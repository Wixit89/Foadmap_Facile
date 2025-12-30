#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
build_s2i_substitutes.py

Objectif:
- Lire produits_sii_compatibles.csv (export OpenFoodFacts)
- Classer les produits selon des "axes" sensibles S2I (gluten, lactose, sucre, polyols, caféine, etc.)
- Construire un set de 200 "produits substituts" diversifiés (par groupes + par catégories)
- Exporter s2i_substituts_200.csv

Usage:
  python build_s2i_substitutes.py \
    --input produits_sii_compatibles.csv \
    --output s2i_substituts_200.csv \
    --n 200 \
    --seed 42
"""

from __future__ import annotations
import argparse
import re
from typing import Dict, List, Optional, Tuple
import pandas as pd


# ----------------------------
# Parsing champs multi-valeurs
# ----------------------------

def split_tags(v: str) -> List[str]:
    v = "" if pd.isna(v) else str(v)
    v = v.strip()
    if not v:
        return []
    # OFF utilise souvent des listes séparées par virgule
    return [t.strip().lower() for t in v.split(",") if t.strip()]


def norm(s: str) -> str:
    s = "" if pd.isna(s) else str(s)
    s = s.lower()
    # normalisation légère accents
    for a, b in [("é", "e"), ("è", "e"), ("ê", "e"), ("à", "a"), ("ç", "c"), ("ù", "u"), ("ô", "o"), ("î", "i")]:
        s = s.replace(a, b)
    return s


def pick_col(df: pd.DataFrame, candidates: List[str]) -> Optional[str]:
    cols = {c.lower(): c for c in df.columns}
    for cand in candidates:
        if cand.lower() in cols:
            return cols[cand.lower()]
    # fallback contient
    for cand in candidates:
        for lc, orig in cols.items():
            if cand.lower() in lc:
                return orig
    return None


def to_float(v) -> Optional[float]:
    if pd.isna(v):
        return None
    try:
        return float(v)
    except Exception:
        return None


# ----------------------------
# Axes / règles S2I (heuristiques)
# ----------------------------

# Ces règles ne "diagnostiquent" rien médicalement.
# Elles servent à construire une base de substitution "compatible S2I" à partir de ton dataset déjà filtré.

AXES = [
    "gluten",
    "lactose",
    "sucre",
    "polyols",
    "cafeine",
    "oignon_ail",
    "epices_piment",
    "legumineuses",
    "boissons_gazeuses",
    "ultra_transforme",
    "general",
]


# mots-clés pour détecter les familles "problématiques" (pour matcher un scan)
KW = {
    "gluten": [r"\bgluten\b", r"\bble\b", r"\bwheat\b", r"\borge\b", r"\bseigle\b", r"\brye\b", r"\bavoine\b", r"\boat\b", r"\bfarine\b", r"\bpain\b", r"\bpates\b", r"\bpasta\b", r"\bbiscuit\b"],
    "lactose": [r"\blait\b", r"\bmilk\b", r"\blactose\b", r"\bcreme\b", r"\bfromage\b", r"\byaourt\b", r"\byogurt\b", r"\bcasein(e)?\b", r"\bwhey\b"],
    "sucre": [r"\bsucre\b", r"\bsugar\b", r"\bsirop\b", r"\bsyrup\b", r"\bglucose\b", r"\bfructose\b", r"\bmiel\b", r"\bhoney\b", r"\bchocolat\b", r"\bbonbon\b", r"\bconfiture\b"],
    "polyols": [r"\bsorbitol\b", r"\bxylitol\b", r"\bmaltitol\b", r"\bisomalt\b", r"\berythritol\b", r"\bpolyol(s)?\b"],
    "cafeine": [r"\bcafe\b", r"\bcoffee\b", r"\bthe\b", r"\btea\b", r"\bcola\b", r"\bcafeine\b", r"\benergy drink\b", r"\bboisson energisante\b"],
    "oignon_ail": [r"\boignon\b", r"\bonion\b", r"\bail\b", r"\bgarlic\b", r"\bechalote\b", r"\bshallot\b"],
    "epices_piment": [r"\bpiment\b", r"\bchili\b", r"\bpiquant\b", r"\bspicy\b", r"\bcurry\b", r"\bpaprika\b", r"\bpoivre\b"],
    "legumineuses": [r"\bsoja\b", r"\bsoy\b", r"\blentille\b", r"\blentil\b", r"\bpois chiche\b", r"\bchickpea\b", r"\bharicot\b", r"\bbean\b", r"\bpois\b", r"\bpea\b"],
    "boissons_gazeuses": [r"\bsoda\b", r"\bboisson gazeuse\b", r"\bcarbonated\b", r"\bsparkling\b"],
    "ultra_transforme": [r"\barome(s)?\b", r"\badditif(s)?\b", r"\bemulsifiant(s)?\b", r"\bconservateur(s)?\b"],
}

# "signaux positifs" via labels_tags
POS_LABELS = {
    "gluten": {"en:no-gluten", "en:gluten-free", "en:products-without-gluten"},
    "lactose": {"en:no-lactose", "en:lactose-free"},
    "sucre": {"en:no-added-sugar", "en:sugar-free", "en:no-sugar"},
    "cafeine": {"en:caffeine-free"},
}

# "groupes de substitution" cibles (quotas) -> pour couvrir un max de scans OFF
# Ajustable facilement.
GROUP_QUOTAS = [
    ("gluten_free_breads_pasta", 35),
    ("lactose_free_dairy_or_alt", 35),
    ("low_sugar_snacks_breakfast", 30),
    ("simple_drinks_non_gazeux", 25),
    ("basic_cooking_sauces_no_onion_garlic", 25),
    ("mild_meals_no_spicy", 20),
    ("general_safe_items", 30),
]  # total = 200


def classify_axes(row: pd.Series, colmap: Dict[str, Optional[str]]) -> List[str]:
    labels = set(split_tags(row.get(colmap["labels_tags"], ""))) if colmap["labels_tags"] else set()
    allergens = norm(row.get(colmap["allergens"], "")) if colmap["allergens"] else ""
    ing = norm(row.get(colmap["ingredients_text"], "")) if colmap["ingredients_text"] else ""
    cats = norm(row.get(colmap["categories"], "")) if colmap["categories"] else ""
    main_cat = norm(row.get(colmap["main_category"], "")) if colmap["main_category"] else ""

    blob = " | ".join([allergens, ing, cats, main_cat, ",".join(labels)])

    axes = set()

    # labels "positifs"
    for ax, labset in POS_LABELS.items():
        if labels.intersection(labset):
            axes.add(ax)

    # mots-clés
    for ax, patterns in KW.items():
        for p in patterns:
            if re.search(p, blob):
                axes.add(ax)
                break

    # nutriments si dispo
    sugars = to_float(row.get(colmap["sugars_100g"])) if colmap["sugars_100g"] else None
    lactose = to_float(row.get(colmap["lactose_100g"])) if colmap["lactose_100g"] else None
    polyols = to_float(row.get(colmap["polyols_100g"])) if colmap["polyols_100g"] else None
    caffeine = to_float(row.get(colmap["caffeine_100g"])) if colmap["caffeine_100g"] else None

    if sugars is not None and sugars >= 10:
        axes.add("sucre")
    if lactose is not None and lactose > 0:
        axes.add("lactose")
    if polyols is not None and polyols > 0:
        axes.add("polyols")
    if caffeine is not None and caffeine > 0:
        axes.add("cafeine")

    if not axes:
        axes.add("general")

    # garder un ordre stable
    ordered = [a for a in AXES if a in axes]
    return ordered


def assign_group(row: pd.Series, axes: List[str], colmap: Dict[str, Optional[str]]) -> Tuple[str, str]:
    """Retourne (group, reason)"""
    labels = set(split_tags(row.get(colmap["labels_tags"], ""))) if colmap["labels_tags"] else set()
    cats_tags = set(split_tags(row.get(colmap["categories_tags"], ""))) if colmap["categories_tags"] else set()
    main_cat = norm(row.get(colmap["main_category"], "")) if colmap["main_category"] else ""
    name = norm(row.get(colmap["product_name"], "")) if colmap["product_name"] else ""

    blob = " | ".join([",".join(labels), ",".join(cats_tags), main_cat, name])

    # 1) gluten-free: pains / pates / cereales
    if ("gluten" in axes) and (labels.intersection(POS_LABELS["gluten"]) or any(t in cats_tags for t in ["en:gluten-free-breads", "en:products-without-gluten"])):
        return ("gluten_free_breads_pasta", "labels_tags indique sans gluten / catégorie sans gluten")

    # 2) lactose-free: laits & substituts, yaourts, fromages
    if ("lactose" in axes) and (labels.intersection(POS_LABELS["lactose"]) or "en:dairy-substitutes" in cats_tags or "en:plant-based-milk-substitutes" in cats_tags):
        return ("lactose_free_dairy_or_alt", "labels_tags indique sans lactose ou catégorie substitut laitier")

    # 3) sucre bas / sans ajout: snacks, petit dej
    if ("sucre" in axes) and (labels.intersection(POS_LABELS["sucre"]) or any(t in cats_tags for t in ["en:breakfasts", "en:cereals"])):
        return ("low_sugar_snacks_breakfast", "signal sucre (labels ou nutriments) + catégorie snack/petit-dej")

    # 4) boissons non gazeuses simples
    if any(t in cats_tags for t in ["en:beverages", "en:fruit-juices", "en:unsweetened-beverages"]) and ("boissons_gazeuses" not in axes):
        return ("simple_drinks_non_gazeux", "catégorie boisson + pas de signal gazeux")

    # 5) sauces / cuisine sans oignon/ail
    if any(t in cats_tags for t in ["en:sauces", "en:condiments"]) or "oignon_ail" in axes:
        # ici, on veut plutôt le "sans oignon/ail" => heuristique: on exclut ceux qui contiennent oignon/ail dans ingredients
        ing = norm(row.get(colmap["ingredients_text"], "")) if colmap["ingredients_text"] else ""
        if not re.search(r"\boignon\b|\bonion\b|\bail\b|\bgarlic\b", ing):
            return ("basic_cooking_sauces_no_onion_garlic", "condiment/sauce avec ingrédients sans oignon/ail détectés")

    # 6) repas doux / pas épicé
    if any(t in cats_tags for t in ["en:prepared-meals", "en:ready-meals", "en:meals"]) or "epices_piment" in axes:
        ing = norm(row.get(colmap["ingredients_text"], "")) if colmap["ingredients_text"] else ""
        if not re.search(r"\bpiment\b|\bchili\b|\bspicy\b|\bcurry\b|\bpaprika\b", ing):
            return ("mild_meals_no_spicy", "repas/plat préparé sans signal épicé")

    # 7) fallback général "safe items"
    return ("general_safe_items", "fallback: produit générique compatible S2I (selon ton filtrage amont)")


# ----------------------------
# Echantillonnage stratifié
# ----------------------------

def diversify_pick(df: pd.DataFrame, n: int, cat_col: str, seed: int) -> pd.DataFrame:
    """
    Prend n lignes en maximisant la diversité des catégories:
    - 1er passage: 1 par catégorie
    - puis boucle jusqu'à remplir n
    """
    rng = df.sample(frac=1, random_state=seed)  # shuffle stable
    if cat_col not in rng.columns:
        return rng.head(n)

    out = []
    used_idx = set()

    # 1 par cat
    for cat, sub in rng.groupby(cat_col, dropna=False):
        row = sub.head(1)
        idx = row.index[0]
        out.append(row)
        used_idx.add(idx)
        if len(out) >= n:
            return pd.concat(out).head(n)

    # compléter
    for idx, row in rng.iterrows():
        if idx in used_idx:
            continue
        out.append(row.to_frame().T)
        used_idx.add(idx)
        if len(out) >= n:
            break

    return pd.concat(out).head(n)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", default="produits_sii_compatibles.csv")
    ap.add_argument("--output", default="s2i_substituts_200.csv")
    ap.add_argument("--n", type=int, default=200)
    ap.add_argument("--seed", type=int, default=42)
    args = ap.parse_args()

    df = pd.read_csv(args.input, dtype=str, low_memory=False)

    # colonnes principales d'après ton exemple
    colmap = {
        "code": pick_col(df, ["code"]),
        "url": pick_col(df, ["url"]),
        "product_name": pick_col(df, ["product_name"]),
        "brands": pick_col(df, ["brands"]),
        "categories": pick_col(df, ["categories"]),
        "categories_tags": pick_col(df, ["categories_tags"]),
        "main_category": pick_col(df, ["main_category"]),
        "labels_tags": pick_col(df, ["labels_tags"]),
        "ingredients_text": pick_col(df, ["ingredients_text"]),
        "allergens": pick_col(df, ["allergens"]),
        "sugars_100g": pick_col(df, ["sugars_100g"]),
        "lactose_100g": pick_col(df, ["lactose_100g"]),
        "polyols_100g": pick_col(df, ["polyols_100g"]),
        "caffeine_100g": pick_col(df, ["caffeine_100g"]),
        "nutriscore_grade": pick_col(df, ["nutriscore_grade"]),
        "nova_group": pick_col(df, ["nova_group"]),
        "image_url": pick_col(df, ["image_url"]),
    }

    # nettoyage minimal: retirer produits sans nom ou sans code
    if colmap["code"]:
        df = df[df[colmap["code"]].notna() & (df[colmap["code"]].astype(str).str.len() > 0)]
    if colmap["product_name"]:
        df = df[df[colmap["product_name"]].notna() & (df[colmap["product_name"]].astype(str).str.len() > 0)]

    # dédoublonnage par code
    if colmap["code"]:
        df = df.drop_duplicates(subset=[colmap["code"]])

    # classification
    axes_list = []
    groups = []
    reasons = []

    for _, row in df.iterrows():
        axes = classify_axes(row, colmap)
        g, r = assign_group(row, axes, colmap)
        axes_list.append("|".join(axes))
        groups.append(g)
        reasons.append(r)

    df["axes_sensibles"] = axes_list
    df["substitution_group"] = groups
    df["reason"] = reasons

    # colonnes de sortie "utiles"
    out_cols = []
    for k in ["code", "product_name", "brands", "main_category", "categories", "labels_tags", "allergens", "ingredients_text",
              "sugars_100g", "lactose_100g", "polyols_100g", "caffeine_100g", "nutriscore_grade", "nova_group", "url", "image_url"]:
        if colmap.get(k) and colmap[k] in df.columns:
            out_cols.append(colmap[k])
    # rajouter nos champs calculés
    out_cols += ["axes_sensibles", "substitution_group", "reason"]

    # sampling par quotas
    target_n = args.n
    picked_frames = []
    remaining = df.copy()

    # colonne catégorie pour diversité
    cat_for_diversity = colmap["main_category"] or colmap["categories"] or "substitution_group"

    for grp, quota in GROUP_QUOTAS:
        if target_n <= 0:
            break
        q = min(quota, target_n)

        pool = remaining[remaining["substitution_group"] == grp]
        if len(pool) == 0:
            continue

        chosen = diversify_pick(pool, q, cat_for_diversity if cat_for_diversity in remaining.columns else "substitution_group", args.seed)
        picked_frames.append(chosen)
        # retirer les choisis du remaining
        remaining = remaining.drop(index=chosen.index, errors="ignore")
        target_n -= len(chosen)

    # compléter si pas assez
    if target_n > 0 and len(remaining) > 0:
        filler = diversify_pick(remaining, target_n, cat_for_diversity if cat_for_diversity in remaining.columns else "substitution_group", args.seed + 1)
        picked_frames.append(filler)

    picked = pd.concat(picked_frames) if picked_frames else df.head(args.n)
    picked = picked.drop_duplicates(subset=[colmap["code"]] if colmap["code"] else None).head(args.n)

    # exporter
    picked[out_cols].to_csv(args.output, index=False, encoding="utf-8")

    # petit résumé console
    print(f"[OK] Export: {args.output} ({len(picked)}/{args.n})")
    print(picked["substitution_group"].value_counts(dropna=False).to_string())


if __name__ == "__main__":
    main()
