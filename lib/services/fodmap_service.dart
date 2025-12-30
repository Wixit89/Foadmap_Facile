import '../models/product.dart';

class FodmapService {
  static final List<Product> fodmapDatabase = [
    
    // ==================== FODMAP ÉLEVÉ ====================
    Product(id: '1', name: 'Ail', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧄', fodmapType: 'Fructanes', substitutes: <String>['Huile infusée à l\'ail']),
    Product(id: '2', name: 'Oignons', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧅', fodmapType: 'Fructanes', substitutes: <String>['Ciboulette']),
    Product(id: '3', name: 'Poudre d\'ail', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧄', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '4', name: 'Poudre d\'oignon', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧅', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '5', name: 'Échalotes', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧅', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '6', name: 'Artichauts', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌿', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '7', name: 'Asperges', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌱', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '8', name: 'Champignons', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍄', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '9', name: 'Chou-fleur', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 75g', imageUrl: '🥦', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '10', name: 'Betterave fraîche', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥬', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '11', name: 'Bulbe de poireau', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌱', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '12', name: 'Pommes', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍎', fodmapType: 'Fructose, Polyols', substitutes: <String>[]),
    Product(id: '13', name: 'Poires', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍐', fodmapType: 'Fructose, Polyols', substitutes: <String>[]),
    Product(id: '14', name: 'Mangue', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥭', fodmapType: 'Fructose', substitutes: <String>[]),
    Product(id: '15', name: 'Pastèque', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍉', fodmapType: 'Fructose, Polyols', substitutes: <String>[]),
    Product(id: '16', name: 'Cerises', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍒', fodmapType: 'Fructose, Polyols', substitutes: <String>[]),
    Product(id: '17', name: 'Pêches', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '18', name: 'Prunes', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '19', name: 'Abricots', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '20', name: 'Figues', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫐', fodmapType: 'Fructose', substitutes: <String>[]),
    Product(id: '21', name: 'Mûres', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫐', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '22', name: 'Lactose', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥛', fodmapType: 'Lactose', substitutes: <String>['Sans lactose']),
    Product(id: '23', name: 'Lait de vache', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥛', fodmapType: 'Lactose', substitutes: <String>['Lait sans lactose']),
    Product(id: '24', name: 'Lait de chèvre', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥛', fodmapType: 'Lactose', substitutes: <String>[]),
    Product(id: '25', name: 'Yaourt', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥛', fodmapType: 'Lactose', substitutes: <String>['Yaourt sans lactose']),
    Product(id: '25', name: 'Crème fraîche', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥛', fodmapType: 'Lactose', substitutes: <String>[]),
    Product(id: '26', name: 'Glace', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍦', fodmapType: 'Lactose', substitutes: <String>[]),
    Product(id: '27', name: 'Blé', fodmapLevel: 'Élevé', allowedPortion: 'Plus d\'1 tranche', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Riz', 'Quinoa']),
    Product(id: '28', name: 'Seigle', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '29', name: 'Orge', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '30', name: 'Noix de cajou', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌰', fodmapType: 'GOS', substitutes: <String>[]),
    Product(id: '31', name: 'Pistaches', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌰', fodmapType: 'GOS', substitutes: <String>[]),
    Product(id: '32', name: 'Miel', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍯', fodmapType: 'Fructose', substitutes: <String>['Sirop d\'érable']),
    Product(id: '33', name: 'Sirop d\'agave', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍯', fodmapType: 'Fructose', substitutes: <String>[]),
    Product(id: '34', name: 'Fructose', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍯', fodmapType: 'Fructose', substitutes: <String>[]),
    Product(id: '35', name: 'Sorbitol', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧪', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '36', name: 'Mannitol', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧪', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '37', name: 'Xylitol', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧪', fodmapType: 'Polyols', substitutes: <String>[]),

    Product(id: '423', name: 'Artichaut', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌿', fodmapType: 'Fructanes', substitutes: <String>['Aubergines']),
    Product(id: '424', name: 'Topinambour', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥔', fodmapType: 'Fructanes', substitutes: <String>['Pommes de terre']),
    Product(id: '425', name: 'Asperges', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌱', fodmapType: 'Fructanes', substitutes: <String>['Haricots verts']),
    Product(id: '426', name: 'Haricots blancs', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Tofu ferme']),
    Product(id: '427', name: 'Betterave fraîche', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥬', fodmapType: 'Fructanes', substitutes: <String>['Betterave en conserve']),
    Product(id: '428', name: 'Doliques à œil noir', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Tofu']),
    Product(id: '429', name: 'Fèves', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Haricots verts']),
    Product(id: '430', name: 'Haricots beurre', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Courgettes']),
    Product(id: '431', name: 'Manioc', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥔', fodmapType: 'Fructanes', substitutes: <String>['Pommes de terre']),
    Product(id: '432', name: 'Chou-fleur', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 75g', imageUrl: '🥦', fodmapType: 'Polyols', substitutes: <String>['Brocoli', 'Carottes']),
    Product(id: '433', name: 'Céleri', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 5cm de tige', imageUrl: '🌱', fodmapType: 'Polyols', substitutes: <String>['Concombre']),
    Product(id: '434', name: 'Choko', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥒', fodmapType: 'Polyols', substitutes: <String>['Courgettes']),
    Product(id: '435', name: 'Falafel', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥙', fodmapType: 'GOS', substitutes: <String>['Galettes de pommes de terre']),
    Product(id: '436', name: 'Haricots secs', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Lentilles en conserve rincées']),
    Product(id: '437', name: 'Haricots rouges', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 85g', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Tofu ferme']),
    Product(id: '438', name: 'Algue Kelp', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌊', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '439', name: 'Haricots de Lima', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Haricots verts']),
    Product(id: '440', name: 'Bulbe de poireau', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌱', fodmapType: 'Fructanes', substitutes: <String>['Partie verte du poireau']),
    Product(id: '441', name: 'Mange-tout', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫛', fodmapType: 'Polyols', substitutes: <String>['Haricots verts']),
    Product(id: '442', name: 'Légumes mélangés', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥗', fodmapType: 'Mixte', substitutes: <String>[]),
    Product(id: '443', name: 'Haricots mungo', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Lentilles']),
    Product(id: '444', name: 'Champignons', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍄', fodmapType: 'Polyols', substitutes: <String>['Courgettes']),
    Product(id: '445', name: 'Pois gourmands', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫛', fodmapType: 'Polyols', substitutes: <String>['Haricots verts']),
    Product(id: '446', name: 'Légumes marinés', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥒', fodmapType: 'Mixte', substitutes: <String>[]),
    Product(id: '447', name: 'Chou de Savoie', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 1/2 tasse', imageUrl: '🥬', fodmapType: 'Fructanes', substitutes: <String>['Chou blanc']),
    Product(id: '448', name: 'Graines de soja', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Tofu ferme']),
    Product(id: '449', name: 'Pois cassés', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>['Lentilles en conserve']),
    Product(id: '450', name: 'Oignons nouveaux (partie blanche)', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧅', fodmapType: 'Fructanes', substitutes: <String>['Partie verte']),
    Product(id: '451', name: 'Échalotes', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧅', fodmapType: 'Fructanes', substitutes: <String>['Ciboulette']),
    Product(id: '452', name: 'Taro', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥔', fodmapType: 'Fructanes', substitutes: <String>['Pommes de terre']),
    Product(id: '453', name: 'Pommes', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍎', fodmapType: 'Fructose, Polyols', substitutes: <String>['Bananes fermes', 'Oranges']),
    Product(id: '454', name: 'Pomme Pink Lady', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍎', fodmapType: 'Fructose, Polyols', substitutes: <String>['Oranges']),
    Product(id: '455', name: 'Pomme Granny Smith', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍎', fodmapType: 'Fructose, Polyols', substitutes: <String>['Oranges']),
    Product(id: '456', name: 'Abricots', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>['Oranges']),
    Product(id: '457', name: 'Avocat', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 1/2 tasse', imageUrl: '🥑', fodmapType: 'Polyols', substitutes: <String>['Huile d\'olive']),
    Product(id: '458', name: 'Bananes mûres', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍌', fodmapType: 'Fructanes', substitutes: <String>['Bananes fermes']),
    Product(id: '459', name: 'Mûres', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫐', fodmapType: 'Polyols', substitutes: <String>['Fraises']),
    Product(id: '460', name: 'Cassis', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫐', fodmapType: 'Fructanes', substitutes: <String>['Myrtilles']),
    Product(id: '461', name: 'Boysenberry', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫐', fodmapType: 'Fructanes', substitutes: <String>['Myrtilles']),
    Product(id: '462', name: 'Cerises', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍒', fodmapType: 'Fructose, Polyols', substitutes: <String>['Myrtilles']),
    Product(id: '463', name: 'Groseilles', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍒', fodmapType: 'Fructanes', substitutes: <String>['Myrtilles']),
    Product(id: '464', name: 'Corossol', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍈', fodmapType: 'Fructose', substitutes: <String>['Ananas']),
    Product(id: '465', name: 'Feijoa', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥝', fodmapType: 'Polyols', substitutes: <String>['Kiwi']),
    Product(id: '466', name: 'Figues', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🫐', fodmapType: 'Fructose', substitutes: <String>['Raisins']),
    Product(id: '467', name: 'Baies de Goji', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍒', fodmapType: 'Fructanes', substitutes: <String>['Myrtilles']),
    Product(id: '468', name: 'Pamplemousse', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 80g', imageUrl: '🍊', fodmapType: 'Fructanes', substitutes: <String>['Orange']),
    Product(id: '469', name: 'Goyave non mûre', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥭', fodmapType: 'Fructose', substitutes: <String>['Goyave mûre']),
    Product(id: '470', name: 'Baie de genièvre séchée', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌿', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '471', name: 'Litchi', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥭', fodmapType: 'Fructose', substitutes: <String>['Ananas']),
    Product(id: '472', name: 'Mangue', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥭', fodmapType: 'Fructose', substitutes: <String>['Ananas', 'Papaye']),
    Product(id: '473', name: 'Nectarines', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 1/2 fruit', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>['Oranges']),
    Product(id: '474', name: 'Papaye séchée', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥭', fodmapType: 'Fructose', substitutes: <String>['Papaye fraîche']),
    Product(id: '475', name: 'Pêches', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>['Oranges']),
    Product(id: '476', name: 'Poires', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍐', fodmapType: 'Fructose, Polyols', substitutes: <String>['Kiwi']),
    Product(id: '477', name: 'Kaki', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍊', fodmapType: 'Fructanes', substitutes: <String>['Orange']),
    Product(id: '478', name: 'Ananas séché', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍍', fodmapType: 'Fructose', substitutes: <String>['Ananas frais']),
    Product(id: '479', name: 'Prunes', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>['Raisins']),
    Product(id: '480', name: 'Grenade', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍎', fodmapType: 'Fructanes', substitutes: <String>['Baies']),
    Product(id: '481', name: 'Pruneaux', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>['Raisins secs (petite portion)']),
    Product(id: '482', name: 'Raisins secs', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 1 c. à soupe', imageUrl: '🍇', fodmapType: 'Fructanes', substitutes: <String>['Raisins frais']),
    Product(id: '483', name: 'Argousier', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍊', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '484', name: 'Sultanines', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍇', fodmapType: 'Fructanes', substitutes: <String>['Raisins frais']),
    Product(id: '485', name: 'Tamarillo', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍅', fodmapType: 'Fructose', substitutes: <String>['Tomate']),
    Product(id: '486', name: 'Fruits en conserve (jus de pomme/poire)', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥫', fodmapType: 'Fructose', substitutes: <String>['Fruits dans l\'eau']),
    Product(id: '487', name: 'Pastèque', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍉', fodmapType: 'Fructose, Polyols', substitutes: <String>['Melon cantaloup']),
    Product(id: '488', name: 'Chorizo à l\'ail', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌭', fodmapType: 'Ail', substitutes: <String>['Chorizo nature']),
    Product(id: '489', name: 'Saucisses', fodmapLevel: 'Élevé', allowedPortion: 'Vérifier ingrédients', imageUrl: '🌭', fodmapType: 'Ail, Oignon', substitutes: <String>['Viande nature']),
    Product(id: '490', name: 'Biscuits aux pépites de chocolat', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍪', fodmapType: 'Fructanes', substitutes: <String>['Biscuits sans gluten']),
    Product(id: '491', name: 'Pain de blé', fodmapLevel: 'Élevé', allowedPortion: 'Plus d\'1 tranche', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '492', name: 'Chapelure', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Chapelure sans gluten']),
    Product(id: '493', name: 'Gâteaux', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍰', fodmapType: 'Fructanes', substitutes: <String>['Gâteaux sans gluten']),
    Product(id: '494', name: 'Barre de céréales au blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍫', fodmapType: 'Fructanes', substitutes: <String>['Barres sans gluten']),
    Product(id: '495', name: 'Croissants', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥐', fodmapType: 'Fructanes', substitutes: <String>['Croissants sans gluten']),
    Product(id: '496', name: 'Crumpets', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '497', name: 'Nouilles aux œufs', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍜', fodmapType: 'Fructanes', substitutes: <String>['Nouilles de riz']),
    Product(id: '498', name: 'Muffins', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🧁', fodmapType: 'Fructanes', substitutes: <String>['Muffins sans gluten']),
    Product(id: '499', name: 'Pâtes de blé', fodmapLevel: 'Élevé', allowedPortion: 'Plus de 1/2 tasse cuite', imageUrl: '🍝', fodmapType: 'Fructanes', substitutes: <String>['Pâtes sans gluten']),
    Product(id: '500', name: 'Nouilles Udon', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍜', fodmapType: 'Fructanes', substitutes: <String>['Nouilles de riz']),
    Product(id: '501', name: 'Son de blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Son d\'avoine']),
    Product(id: '502', name: 'Céréales de blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥣', fodmapType: 'Fructanes', substitutes: <String>['Céréales sans gluten']),
    Product(id: '503', name: 'Farine de blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Farine de riz']),
    Product(id: '504', name: 'Germe de blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Graines de chia']),
    Product(id: '505', name: 'Nouilles de blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍜', fodmapType: 'Fructanes', substitutes: <String>['Nouilles de riz']),
    Product(id: '506', name: 'Petits pains de blé', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Petits pains sans gluten']),
    Product(id: '507', name: 'Farine d\'amande', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌰', fodmapType: 'GOS', substitutes: <String>['Farine de riz']),
    Product(id: '508', name: 'Farine d\'amarante', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'GOS', substitutes: <String>['Farine de riz']),
    Product(id: '509', name: 'Orge', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Riz', 'Quinoa']),
    Product(id: '510', name: 'Farine d\'orge', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Farine de riz']),
    Product(id: '511', name: 'Céréales de son', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥣', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '512', name: 'Pain Granary', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '513', name: 'Pain multigrains', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '514', name: 'Naan', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '515', name: 'Pain à l\'avoine', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '516', name: 'Pain Pumpernickel', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '517', name: 'Roti', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Pain sans gluten']),
    Product(id: '518', name: 'Levain au Kamut', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍞', fodmapType: 'Fructanes', substitutes: <String>['Levain d\'épeautre']),
    Product(id: '519', name: 'Noix de cajou', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌰', fodmapType: 'GOS', substitutes: <String>['Noix de macadamia']),
    Product(id: '520', name: 'Farine de châtaigne', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌰', fodmapType: 'GOS', substitutes: <String>['Farine de riz']),
    Product(id: '521', name: 'Couscous', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍚', fodmapType: 'Fructanes', substitutes: <String>['Quinoa']),
    Product(id: '522', name: 'Farine d\'épeautre', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Farine de riz']),
    Product(id: '523', name: 'Freekeh', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Quinoa']),
    Product(id: '524', name: 'Gnocchis', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍝', fodmapType: 'Fructanes', substitutes: <String>['Gnocchis sans gluten']),
    Product(id: '525', name: 'Barre de granola', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍫', fodmapType: 'Fructanes', substitutes: <String>['Barre sans gluten']),
    Product(id: '526', name: 'Céréales muesli', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🥣', fodmapType: 'Fructanes', substitutes: <String>['Céréales sans gluten']),
    Product(id: '527', name: 'Barre muesli', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍫', fodmapType: 'Fructanes', substitutes: <String>['Barre sans gluten']),
    Product(id: '528', name: 'Pistaches', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌰', fodmapType: 'GOS', substitutes: <String>['Noix de macadamia']),
    Product(id: '529', name: 'Seigle', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Riz']),
    Product(id: '530', name: 'Craquelins de seigle', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍘', fodmapType: 'Fructanes', substitutes: <String>['Crackers sans gluten']),
    Product(id: '531', name: 'Semoule', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🍚', fodmapType: 'Fructanes', substitutes: <String>['Polenta']),
    Product(id: '532', name: 'Farine d\'épeautre', fodmapLevel: 'Élevé', allowedPortion: 'Éviter', imageUrl: '🌾', fodmapType: 'Fructanes', substitutes: <String>['Farine de riz']),

    // ==================== FODMAP MODÉRÉ ====================
    Product(id: '38', name: 'Brocoli (têtes)', fodmapLevel: 'Modéré', allowedPortion: '3/4 tasse', imageUrl: '🥦', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '39', name: 'Brocoli (tiges)', fodmapLevel: 'Modéré', allowedPortion: '1/3 tasse', imageUrl: '🥦', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '40', name: 'Choux de Bruxelles', fodmapLevel: 'Modéré', allowedPortion: '2 choux', imageUrl: '🥬', fodmapType: 'Fructanes', substitutes: <String>[]),
    Product(id: '41', name: 'Butternut squash', fodmapLevel: 'Modéré', allowedPortion: '1/4 tasse', imageUrl: '🎃', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '42', name: 'Maïs doux', fodmapLevel: 'Modéré', allowedPortion: '1/2 épi', imageUrl: '🌽', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '43', name: 'Patate douce', fodmapLevel: 'Modéré', allowedPortion: '1/2 tasse', imageUrl: '🍠', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '44', name: 'Pois chiches', fodmapLevel: 'Modéré', allowedPortion: '1/4 tasse', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>[]),
    Product(id: '45', name: 'Lentilles', fodmapLevel: 'Modéré', allowedPortion: 'Petite quantité', imageUrl: '🫘', fodmapType: 'GOS', substitutes: <String>[]),
    Product(id: '46', name: 'Chocolat au lait', fodmapLevel: 'Modéré', allowedPortion: '4 carrés', imageUrl: '🍫', fodmapType: 'Lactose', substitutes: <String>[]),
    Product(id: '47', name: 'Chocolat blanc', fodmapLevel: 'Modéré', allowedPortion: '3 carrés', imageUrl: '🍫', fodmapType: 'Lactose', substitutes: <String>[]),
    Product(id: '48', name: 'Avocat', fodmapLevel: 'Modéré', allowedPortion: 'Plus de 1/2 tasse', imageUrl: '🥑', fodmapType: 'Polyols', substitutes: <String>[]),
    Product(id: '49', name: 'Nectarines', fodmapLevel: 'Modéré', allowedPortion: 'Plus de 1/2', imageUrl: '🍑', fodmapType: 'Polyols', substitutes: <String>[]),

    // ==================== FODMAP FAIBLE - AUTORISÉS ====================

    // LÉGUMES
    Product(id: '50', name: 'Luzerne', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '51', name: 'Pousses de bambou', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🎋', fodmapType: '', substitutes: <String>[]),
    Product(id: '52', name: 'Germes de soja', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '53', name: 'Betterave en conserve', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '54', name: 'Betterave marinée', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '55', name: 'Haricots noirs', fodmapLevel: 'Faible', allowedPortion: '1/4 tasse', imageUrl: '🫘', fodmapType: '', substitutes: <String>[]),
    Product(id: '56', name: 'Bok choy', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '57', name: 'Pak choi', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '58', name: 'Chou commun', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 3/4 tasse', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '59', name: 'Chou rouge', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 3/4 tasse', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '60', name: 'Callaloo', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '61', name: 'Carottes', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥕', fodmapType: '', substitutes: <String>[]),
    Product(id: '62', name: 'Céleri-rave', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '63', name: 'Céleri', fodmapLevel: 'Faible', allowedPortion: 'Moins de 5cm', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '64', name: 'Feuilles de chicorée', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '65', name: 'Piment', fodmapLevel: 'Faible', allowedPortion: 'Si toléré', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '66', name: 'Chou chinois', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '67', name: 'Ciboulette', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '68', name: 'Cho cho', fodmapLevel: 'Faible', allowedPortion: '1/2 tasse en dés', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),
    Product(id: '69', name: 'Choy sum', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '70', name: 'Chou vert', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '71', name: 'Maïs doux', fodmapLevel: 'Faible', allowedPortion: '1/2 épi si toléré', imageUrl: '🌽', fodmapType: '', substitutes: <String>[]),
    Product(id: '72', name: 'Courgette', fodmapLevel: 'Faible', allowedPortion: '65g', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),
    Product(id: '73', name: 'Concombre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),
    Product(id: '74', name: 'Aubergine', fodmapLevel: 'Faible', allowedPortion: '1 tasse', imageUrl: '🍆', fodmapType: '', substitutes: <String>[]),
    Product(id: '75', name: 'Fenouil (bulbe)', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 75g', imageUrl: '🧅', fodmapType: '', substitutes: <String>[]),
    Product(id: '76', name: 'Fenouil (feuilles)', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 15g', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '77', name: 'Chou fermenté', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 1/2 tasse', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '78', name: 'Haricots verts', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫛', fodmapType: '', substitutes: <String>[]),
    Product(id: '79', name: 'Poivron vert', fodmapLevel: 'Faible', allowedPortion: '1/2 tasse', imageUrl: '🫑', fodmapType: '', substitutes: <String>[]),
    Product(id: '80', name: 'Gingembre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫚', fodmapType: '', substitutes: <String>[]),
    Product(id: '81', name: 'Chou frisé', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '82', name: 'Karela', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),
    Product(id: '83', name: 'Kumara', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 75g', imageUrl: '🍠', fodmapType: '', substitutes: <String>[]),
    Product(id: '84', name: 'Feuilles de poireau', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '85', name: 'Laitue (toutes)', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '86', name: 'Roquette', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '87', name: 'Courge musquée', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🎃', fodmapType: '', substitutes: <String>[]),
    Product(id: '88', name: 'Okra', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),
    Product(id: '89', name: 'Olives', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '90', name: 'Panais', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥕', fodmapType: '', substitutes: <String>[]),
    Product(id: '91', name: 'Pois mange-neige', fodmapLevel: 'Faible', allowedPortion: '5 cosses', imageUrl: '🫛', fodmapType: '', substitutes: <String>[]),
    Product(id: '92', name: 'Cornichons', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),
    Product(id: '93', name: 'Gros oignons marinés', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧅', fodmapType: '', substitutes: <String>[]),
    Product(id: '94', name: 'Pommes de terre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '95', name: 'Potiron', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 63g', imageUrl: '🎃', fodmapType: '', substitutes: <String>[]),
    Product(id: '96', name: 'Citrouille', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 63g', imageUrl: '🎃', fodmapType: '', substitutes: <String>[]),
    Product(id: '97', name: 'Citrouille en conserve', fodmapLevel: 'Faible', allowedPortion: '1/4 tasse', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '98', name: 'Radis', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '99', name: 'Poivron rouge', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫑', fodmapType: '', substitutes: <String>[]),
    Product(id: '100', name: 'Oignons verts (partie verte)', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧅', fodmapType: '', substitutes: <String>[]),
    Product(id: '101', name: 'Algue Nori', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌊', fodmapType: '', substitutes: <String>[]),
    Product(id: '102', name: 'Bette à carde', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '103', name: 'Courge spaghetti', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🎃', fodmapType: '', substitutes: <String>[]),
    Product(id: '104', name: 'Épinards', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '105', name: 'Courge', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 63g', imageUrl: '🎃', fodmapType: '', substitutes: <String>[]),
    Product(id: '106', name: 'Tomates séchées', fodmapLevel: 'Faible', allowedPortion: '4 morceaux', imageUrl: '🍅', fodmapType: '', substitutes: <String>[]),
    Product(id: '107', name: 'Rutabaga', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '108', name: 'Tomates', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍅', fodmapType: '', substitutes: <String>[]),
    Product(id: '109', name: 'Tomates en conserve', fodmapLevel: 'Faible', allowedPortion: '3/5 tasse', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '110', name: 'Tomates cerises', fodmapLevel: 'Faible', allowedPortion: '5 tomates', imageUrl: '🍅', fodmapType: '', substitutes: <String>[]),
    Product(id: '111', name: 'Jus de tomate', fodmapLevel: 'Faible', allowedPortion: '1/2 verre', imageUrl: '🧃', fodmapType: '', substitutes: <String>[]),
    Product(id: '112', name: 'Concentré de tomate', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '113', name: 'Navet', fodmapLevel: 'Faible', allowedPortion: '1/2 navet', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '114', name: 'Châtaignes d\'eau', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '115', name: 'Igname', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍠', fodmapType: '', substitutes: <String>[]),
    Product(id: '116', name: 'Zucchini', fodmapLevel: 'Faible', allowedPortion: '65g', imageUrl: '🥒', fodmapType: '', substitutes: <String>[]),

    // FRUITS
    Product(id: '117', name: 'Ackee', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍎', fodmapType: '', substitutes: <String>[]),
    Product(id: '118', name: 'Compote de pommes', fodmapLevel: 'Faible', allowedPortion: '3/4 c. à café', imageUrl: '🍎', fodmapType: '', substitutes: <String>[]),
    Product(id: '119', name: 'Bananes fermes', fodmapLevel: 'Faible', allowedPortion: '1 moyenne', imageUrl: '🍌', fodmapType: '', substitutes: <String>[]),
    Product(id: '120', name: 'Myrtilles', fodmapLevel: 'Faible', allowedPortion: '1 tasse', imageUrl: '🫐', fodmapType: '', substitutes: <String>[]),
    Product(id: '121', name: 'Fruit à pain', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍈', fodmapType: '', substitutes: <String>[]),
    Product(id: '122', name: 'Carambole', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '⭐', fodmapType: '', substitutes: <String>[]),
    Product(id: '123', name: 'Melon cantaloup', fodmapLevel: 'Faible', allowedPortion: '3/4 tasse', imageUrl: '🍈', fodmapType: '', substitutes: <String>[]),
    Product(id: '124', name: 'Canneberges', fodmapLevel: 'Faible', allowedPortion: '1 c. à soupe', imageUrl: '🫐', fodmapType: '', substitutes: <String>[]),
    Product(id: '125', name: 'Clémentine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍊', fodmapType: '', substitutes: <String>[]),
    Product(id: '126', name: 'Crème de coco', fodmapLevel: 'Faible', allowedPortion: '1/4 tasse', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '127', name: 'Chair de coco', fodmapLevel: 'Faible', allowedPortion: '2/3 tasse', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '128', name: 'Sucre de coco', fodmapLevel: 'Faible', allowedPortion: '1 c. à café', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '129', name: 'Jus de canneberge', fodmapLevel: 'Faible', allowedPortion: '3/4 verre', imageUrl: '🧃', fodmapType: '', substitutes: <String>[]),
    Product(id: '130', name: 'Dattes', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 5', imageUrl: '🫐', fodmapType: '', substitutes: <String>[]),
    Product(id: '131', name: 'Fruit du dragon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐉', fodmapType: '', substitutes: <String>[]),
    Product(id: '132', name: 'Raisins', fodmapLevel: 'Faible', allowedPortion: '10g', imageUrl: '🍇', fodmapType: '', substitutes: <String>[]),
    Product(id: '133', name: 'Goyave mûre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥭', fodmapType: '', substitutes: <String>[]),
    Product(id: '134', name: 'Melon Honeydew', fodmapLevel: 'Faible', allowedPortion: '1/2 tasse', imageUrl: '🍈', fodmapType: '', substitutes: <String>[]),
    Product(id: '135', name: 'Melon Galia', fodmapLevel: 'Faible', allowedPortion: '1/2 tasse', imageUrl: '🍈', fodmapType: '', substitutes: <String>[]),
    Product(id: '136', name: 'Jacquier', fodmapLevel: 'Faible', allowedPortion: '1/3 tasse', imageUrl: '🥭', fodmapType: '', substitutes: <String>[]),
    Product(id: '137', name: 'Kiwi', fodmapLevel: 'Faible', allowedPortion: '2 petits', imageUrl: '🥝', fodmapType: '', substitutes: <String>[]),
    Product(id: '138', name: 'Citron', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍋', fodmapType: '', substitutes: <String>[]),
    Product(id: '139', name: 'Jus de citron', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍋', fodmapType: '', substitutes: <String>[]),
    Product(id: '140', name: 'Citron vert', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍋', fodmapType: '', substitutes: <String>[]),
    Product(id: '141', name: 'Jus de citron vert', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍋', fodmapType: '', substitutes: <String>[]),
    Product(id: '142', name: 'Mandarine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍊', fodmapType: '', substitutes: <String>[]),
    Product(id: '143', name: 'Orange', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍊', fodmapType: '', substitutes: <String>[]),
    Product(id: '144', name: 'Fruit de la passion', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥭', fodmapType: '', substitutes: <String>[]),
    Product(id: '145', name: 'Papaye', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥭', fodmapType: '', substitutes: <String>[]),
    Product(id: '146', name: 'Ananas', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍍', fodmapType: '', substitutes: <String>[]),
    Product(id: '147', name: 'Plantain', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍌', fodmapType: '', substitutes: <String>[]),
    Product(id: '148', name: 'Figue de Barbarie', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌵', fodmapType: '', substitutes: <String>[]),
    Product(id: '149', name: 'Framboises', fodmapLevel: 'Faible', allowedPortion: '1/3 tasse', imageUrl: '🍓', fodmapType: '', substitutes: <String>[]),
    Product(id: '150', name: 'Rhubarbe', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥬', fodmapType: '', substitutes: <String>[]),
    Product(id: '151', name: 'Fraises', fodmapLevel: 'Faible', allowedPortion: '65g', imageUrl: '🍓', fodmapType: '', substitutes: <String>[]),
    Product(id: '152', name: 'Tamarin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫘', fodmapType: '', substitutes: <String>[]),
    Product(id: '153', name: 'Tangelo', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍊', fodmapType: '', substitutes: <String>[]),

    // VIANDES, VOLAILLES, POISSONS
    Product(id: '154', name: 'Boeuf', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥩', fodmapType: '', substitutes: <String>[]),
    Product(id: '155', name: 'Poulet', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍗', fodmapType: '', substitutes: <String>[]),
    Product(id: '156', name: 'Chorizo', fodmapLevel: 'Faible', allowedPortion: 'Vérifier ingrédients', imageUrl: '🌭', fodmapType: '', substitutes: <String>[]),
    Product(id: '157', name: 'Foie gras', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥩', fodmapType: '', substitutes: <String>[]),
    Product(id: '158', name: 'Kangourou', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥩', fodmapType: '', substitutes: <String>[]),
    Product(id: '159', name: 'Agneau', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥩', fodmapType: '', substitutes: <String>[]),
    Product(id: '160', name: 'Porc', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥩', fodmapType: '', substitutes: <String>[]),
    Product(id: '161', name: 'Prosciutto', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥓', fodmapType: '', substitutes: <String>[]),
    Product(id: '162', name: 'Quorn haché', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍖', fodmapType: '', substitutes: <String>[]),
    Product(id: '163', name: 'Dinde', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍗', fodmapType: '', substitutes: <String>[]),
    Product(id: '164', name: 'Charcuterie', fodmapLevel: 'Faible', allowedPortion: 'Vérifier', imageUrl: '🥓', fodmapType: '', substitutes: <String>[]),
    Product(id: '165', name: 'Jambon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥓', fodmapType: '', substitutes: <String>[]),
    Product(id: '166', name: 'Thon en conserve', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '167', name: 'Morue', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '168', name: 'Aiglefin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '169', name: 'Plie', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '170', name: 'Saumon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '171', name: 'Truite', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '172', name: 'Thon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🐟', fodmapType: '', substitutes: <String>[]),
    Product(id: '173', name: 'Crabe', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦀', fodmapType: '', substitutes: <String>[]),
    Product(id: '174', name: 'Homard', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦞', fodmapType: '', substitutes: <String>[]),
    Product(id: '175', name: 'Moules', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦪', fodmapType: '', substitutes: <String>[]),
    Product(id: '176', name: 'Huîtres', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦪', fodmapType: '', substitutes: <String>[]),
    Product(id: '177', name: 'Crevettes', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦐', fodmapType: '', substitutes: <String>[]),

    // CÉRÉALES, PAINS, NOIX, GRAINES
    Product(id: '178', name: 'Pain sans gluten', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '179', name: 'Pain sans blé', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '180', name: 'Pain de maïs', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '181', name: 'Pain de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '182', name: 'Pain au levain d\'épeautre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '183', name: 'Pain de farine de pomme de terre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '184', name: 'Pâtes sans gluten', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍝', fodmapType: '', substitutes: <String>[]),
    Product(id: '185', name: 'Pâtes sans blé', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍝', fodmapType: '', substitutes: <String>[]),
    Product(id: '186', name: 'Pain de blé', fodmapLevel: 'Faible', allowedPortion: '1 tranche', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '187', name: 'Amandes', fodmapLevel: 'Faible', allowedPortion: '10 amandes', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '188', name: 'Biscuits crackers', fodmapLevel: 'Faible', allowedPortion: '4 crackers', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '189', name: 'Biscuits à l\'avoine', fodmapLevel: 'Faible', allowedPortion: '4 biscuits', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '190', name: 'Biscuits salés', fodmapLevel: 'Faible', allowedPortion: '2 biscuits', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '191', name: 'Biscuits sablés', fodmapLevel: 'Faible', allowedPortion: '1 biscuit', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '192', name: 'Biscuits sucrés simples', fodmapLevel: 'Faible', allowedPortion: '2 biscuits', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '193', name: 'Biscuits avoine complète', fodmapLevel: 'Faible', allowedPortion: '2 biscuits', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '194', name: 'Noix du Brésil', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 10', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '195', name: 'Boulgour', fodmapLevel: 'Faible', allowedPortion: '1/4 tasse cuite', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '196', name: 'Sarrasin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '197', name: 'Farine de sarrasin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '198', name: 'Nouilles de sarrasin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍜', fodmapType: '', substitutes: <String>[]),
    Product(id: '199', name: 'Riz brun', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '200', name: 'Farine de manioc', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '201', name: 'Châtaignes', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '202', name: 'Chips nature', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '203', name: 'Farine de maïs', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '204', name: 'Pain croustillant', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍞', fodmapType: '', substitutes: <String>[]),
    Product(id: '205', name: 'Galettes de maïs', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌽', fodmapType: '', substitutes: <String>[]),
    Product(id: '206', name: 'Cornflakes', fodmapLevel: 'Faible', allowedPortion: '1/2 tasse', imageUrl: '🥣', fodmapType: '', substitutes: <String>[]),
    Product(id: '207', name: 'Cornflakes sans gluten', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥣', fodmapType: '', substitutes: <String>[]),
    Product(id: '208', name: 'Maïs en crème en conserve', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 1/3 tasse', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '209', name: 'Tortillas de maïs', fodmapLevel: 'Faible', allowedPortion: '3 tortillas', imageUrl: '🌮', fodmapType: '', substitutes: <String>[]),
    Product(id: '210', name: 'Crackers nature', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍘', fodmapType: '', substitutes: <String>[]),
    Product(id: '211', name: 'Graines de lin', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 1 c. à soupe', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '212', name: 'Huile de lin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '213', name: 'Noisettes', fodmapLevel: 'Faible', allowedPortion: '24 noisettes', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '214', name: 'Noix de macadamia', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 15', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '215', name: 'Millet', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '216', name: 'Noix mélangées', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '217', name: 'Flocons d\'avoine', fodmapLevel: 'Faible', allowedPortion: '1/2 tasse', imageUrl: '🥣', fodmapType: '', substitutes: <String>[]),
    Product(id: '218', name: 'Avoine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '219', name: 'Biscuits d\'avoine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍪', fodmapType: '', substitutes: <String>[]),
    Product(id: '220', name: 'Pâte filo', fodmapLevel: 'Faible', allowedPortion: '1 feuille', imageUrl: '🥐', fodmapType: '', substitutes: <String>[]),
    Product(id: '221', name: 'Pâte feuilletée', fodmapLevel: 'Faible', allowedPortion: '1/4 feuille', imageUrl: '🥐', fodmapType: '', substitutes: <String>[]),
    Product(id: '222', name: 'Cacahuètes', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥜', fodmapType: '', substitutes: <String>[]),
    Product(id: '223', name: 'Noix de pécan', fodmapLevel: 'Faible', allowedPortion: '15 moitiés', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '224', name: 'Pignons de pin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),
    Product(id: '225', name: 'Polenta', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌽', fodmapType: '', substitutes: <String>[]),
    Product(id: '226', name: 'Pop-corn', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍿', fodmapType: '', substitutes: <String>[]),
    Product(id: '227', name: 'Porridge', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥣', fodmapType: '', substitutes: <String>[]),
    Product(id: '228', name: 'Farine de pomme de terre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥔', fodmapType: '', substitutes: <String>[]),
    Product(id: '229', name: 'Bretzels', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥨', fodmapType: '', substitutes: <String>[]),
    Product(id: '230', name: 'Quinoa', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '231', name: 'Pâtes de blé', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 1/2 tasse cuite', imageUrl: '🍝', fodmapType: '', substitutes: <String>[]),
    Product(id: '232', name: 'Riz basmati', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '233', name: 'Riz bomba', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '234', name: 'Riz brun', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '235', name: 'Nouilles de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍜', fodmapType: '', substitutes: <String>[]),
    Product(id: '236', name: 'Riz blanc', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '237', name: 'Riz sauvage', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 1 tasse', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '238', name: 'Son de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '239', name: 'Galettes de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍘', fodmapType: '', substitutes: <String>[]),
    Product(id: '240', name: 'Crackers de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍘', fodmapType: '', substitutes: <String>[]),
    Product(id: '241', name: 'Flocons de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥣', fodmapType: '', substitutes: <String>[]),
    Product(id: '242', name: 'Farine de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '243', name: 'Graines de chia', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '244', name: 'Graines d\'aneth', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '245', name: 'Graines de chanvre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '246', name: 'Graines de pavot', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '247', name: 'Graines de citrouille', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🎃', fodmapType: '', substitutes: <String>[]),
    Product(id: '248', name: 'Graines de sésame', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '249', name: 'Graines de tournesol', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌻', fodmapType: '', substitutes: <String>[]),
    Product(id: '250', name: 'Amidon (maïs, pomme de terre, tapioca)', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '251', name: 'Sorgho', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '252', name: 'Chips de tortilla', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌮', fodmapType: '', substitutes: <String>[]),
    Product(id: '253', name: 'Noix', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 15 moitiés', imageUrl: '🌰', fodmapType: '', substitutes: <String>[]),

    // CONDIMENTS, SUCRES, ÉPICES
    Product(id: '254', name: 'Aspartame', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧪', fodmapType: '', substitutes: <String>[]),
    Product(id: '255', name: 'Acesulfame K', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧪', fodmapType: '', substitutes: <String>[]),
    Product(id: '256', name: 'Beurre d\'amande', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥜', fodmapType: '', substitutes: <String>[]),
    Product(id: '257', name: 'Sauce barbecue', fodmapLevel: 'Faible', allowedPortion: 'Vérifier étiquette', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '258', name: 'Câpres au vinaigre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '259', name: 'Câpres salés', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '260', name: 'Chocolat noir', fodmapLevel: 'Faible', allowedPortion: '5 carrés', imageUrl: '🍫', fodmapType: '', substitutes: <String>[]),
    Product(id: '261', name: 'Chutney', fodmapLevel: 'Faible', allowedPortion: '1 c. à soupe', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '262', name: 'Moutarde de Dijon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '263', name: 'Erythritol', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧪', fodmapType: '', substitutes: <String>[]),
    Product(id: '264', name: 'Sauce poisson', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),
    Product(id: '265', name: 'Sirop doré', fodmapLevel: 'Faible', allowedPortion: '1 c. à café', imageUrl: '🍯', fodmapType: '', substitutes: <String>[]),
    Product(id: '266', name: 'Glucose', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍬', fodmapType: '', substitutes: <String>[]),
    Product(id: '267', name: 'Glycérol', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧪', fodmapType: '', substitutes: <String>[]),
    Product(id: '268', name: 'Confiture de fraises', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍓', fodmapType: '', substitutes: <String>[]),
    Product(id: '269', name: 'Confiture de framboises', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🍓', fodmapType: '', substitutes: <String>[]),
    Product(id: '270', name: 'Ketchup', fodmapLevel: 'Faible', allowedPortion: '1 sachet', imageUrl: '🍅', fodmapType: '', substitutes: <String>[]),
    Product(id: '271', name: 'Sirop d\'érable', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍯', fodmapType: '', substitutes: <String>[]),
    Product(id: '272', name: 'Marmelade', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍊', fodmapType: '', substitutes: <String>[]),
    Product(id: '273', name: 'Marmite', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '274', name: 'Mayonnaise', fodmapLevel: 'Faible', allowedPortion: 'Sans ail/oignon', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '275', name: 'Pâte de miso', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '276', name: 'Moutarde', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '277', name: 'Sauce aux huîtres', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦪', fodmapType: '', substitutes: <String>[]),
    Product(id: '278', name: 'Sauce pesto', fodmapLevel: 'Faible', allowedPortion: 'Moins de 1 c. à soupe', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '279', name: 'Beurre de cacahuète', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥜', fodmapType: '', substitutes: <String>[]),
    Product(id: '280', name: 'Sirop de malt de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍯', fodmapType: '', substitutes: <String>[]),
    Product(id: '281', name: 'Saccharine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧪', fodmapType: '', substitutes: <String>[]),
    Product(id: '282', name: 'Pâte de crevettes', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🦐', fodmapType: '', substitutes: <String>[]),
    Product(id: '283', name: 'Sauce soja', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),
    Product(id: '284', name: 'Sauce Sriracha', fodmapLevel: 'Faible', allowedPortion: '1 c. à café', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '285', name: 'Stevia', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '286', name: 'Sauce aigre-douce', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '287', name: 'Sucralose', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧪', fodmapType: '', substitutes: <String>[]),
    Product(id: '288', name: 'Sucre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍬', fodmapType: '', substitutes: <String>[]),
    Product(id: '289', name: 'Pâte de tahini', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '290', name: 'Sauce tamari', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),
    Product(id: '291', name: 'Pâte de tamarin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫘', fodmapType: '', substitutes: <String>[]),
    Product(id: '292', name: 'Sauce tomate', fodmapLevel: 'Faible', allowedPortion: '2 sachets', imageUrl: '🍅', fodmapType: '', substitutes: <String>[]),
    Product(id: '293', name: 'Vegemite', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),
    Product(id: '294', name: 'Vinaigre de cidre de pomme', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),
    Product(id: '295', name: 'Vinaigre balsamique', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),
    Product(id: '296', name: 'Vinaigre de vin de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),
    Product(id: '297', name: 'Sauce Worcestershire', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍶', fodmapType: '', substitutes: <String>[]),

    // BOISSONS
    Product(id: '298', name: 'Bière', fodmapLevel: 'Faible', allowedPortion: '1 verre', imageUrl: '🍺', fodmapType: '', substitutes: <String>[]),
    Product(id: '299', name: 'Vodka', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍸', fodmapType: '', substitutes: <String>[]),
    Product(id: '300', name: 'Gin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍸', fodmapType: '', substitutes: <String>[]),
    Product(id: '301', name: 'Whisky', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥃', fodmapType: '', substitutes: <String>[]),
    Product(id: '302', name: 'Vin', fodmapLevel: 'Faible', allowedPortion: '1 verre', imageUrl: '🍷', fodmapType: '', substitutes: <String>[]),
    Product(id: '303', name: 'Café espresso noir', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '☕', fodmapType: '', substitutes: <String>[]),
    Product(id: '304', name: 'Café espresso avec lait sans lactose', fodmapLevel: 'Faible', allowedPortion: '250ml', imageUrl: '☕', fodmapType: '', substitutes: <String>[]),
    Product(id: '305', name: 'Café instantané noir', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '☕', fodmapType: '', substitutes: <String>[]),
    Product(id: '306', name: 'Café instantané avec lait sans lactose', fodmapLevel: 'Faible', allowedPortion: '250ml', imageUrl: '☕', fodmapType: '', substitutes: <String>[]),
    Product(id: '307', name: 'Lait de coco', fodmapLevel: 'Faible', allowedPortion: '125ml', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '308', name: 'Eau de coco', fodmapLevel: 'Faible', allowedPortion: '100ml', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '309', name: 'Poudre de chocolat chaud', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '☕', fodmapType: '', substitutes: <String>[]),
    Product(id: '310', name: 'Jus de fruits', fodmapLevel: 'Faible', allowedPortion: '125ml fruits sûrs', imageUrl: '🧃', fodmapType: '', substitutes: <String>[]),
    Product(id: '311', name: 'Kvass', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍺', fodmapType: '', substitutes: <String>[]),
    Product(id: '312', name: 'Limonade', fodmapLevel: 'Faible', allowedPortion: 'Petite quantité', imageUrl: '🥤', fodmapType: '', substitutes: <String>[]),
    Product(id: '313', name: 'Protéine d\'œuf', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥚', fodmapType: '', substitutes: <String>[]),
    Product(id: '314', name: 'Protéine de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍚', fodmapType: '', substitutes: <String>[]),
    Product(id: '315', name: 'Protéine Sacha Inchi', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '316', name: 'Protéine whey isolate', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥤', fodmapType: '', substitutes: <String>[]),
    Product(id: '317', name: 'Lait de soja (protéine)', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '318', name: 'Sodas sans sucre', fodmapLevel: 'Faible', allowedPortion: 'Petite quantité', imageUrl: '🥤', fodmapType: '', substitutes: <String>[]),
    Product(id: '319', name: 'Sodas sucrés sans HFCS', fodmapLevel: 'Faible', allowedPortion: 'Limité', imageUrl: '🥤', fodmapType: '', substitutes: <String>[]),
    Product(id: '320', name: 'Thé noir faible', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '321', name: 'Thé chai faible', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '322', name: 'Thé fruité faible', fodmapLevel: 'Faible', allowedPortion: 'Sans pomme', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '323', name: 'Thé vert', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '324', name: 'Thé à la menthe', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '325', name: 'Thé blanc', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '326', name: 'Eau', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '💧', fodmapType: '', substitutes: <String>[]),

    // PRODUITS LAITIERS, ŒUFS
    Product(id: '327', name: 'Beurre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧈', fodmapType: '', substitutes: <String>[]),
    Product(id: '328', name: 'Fromage américain', fodmapLevel: 'Faible', allowedPortion: '16g', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '329', name: 'Fromage Brie', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '330', name: 'Fromage Camembert', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '331', name: 'Fromage Cheddar', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '332', name: 'Fromage cottage', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '333', name: 'Fromage à la crème', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '334', name: 'Fromage Feta', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '335', name: 'Fromage de chèvre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '336', name: 'Haloumi', fodmapLevel: 'Faible', allowedPortion: '40g', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '337', name: 'Fromage Monterey Jack', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '338', name: 'Mozzarella', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '339', name: 'Paneer', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '340', name: 'Parmesan', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '341', name: 'Ricotta', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '342', name: 'Fromage suisse', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧀', fodmapType: '', substitutes: <String>[]),
    Product(id: '343', name: 'Pudding au chocolat sans lactose', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍮', fodmapType: '', substitutes: <String>[]),
    Product(id: '344', name: 'Œufs', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥚', fodmapType: '', substitutes: <String>[]),
    Product(id: '345', name: 'Margarine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧈', fodmapType: '', substitutes: <String>[]),
    Product(id: '346', name: 'Lait d\'amande', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '347', name: 'Lait de chanvre', fodmapLevel: 'Faible', allowedPortion: '125ml', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '348', name: 'Lait sans lactose', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '349', name: 'Lait de macadamia', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '350', name: 'Lait d\'avoine', fodmapLevel: 'Faible', allowedPortion: '30ml', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '351', name: 'Lait de riz', fodmapLevel: 'Faible', allowedPortion: 'Jusqu\'à 200ml', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '352', name: 'Sorbet', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍦', fodmapType: '', substitutes: <String>[]),
    Product(id: '353', name: 'Protéine de soja', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '354', name: 'Tempeh', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '⬜', fodmapType: '', substitutes: <String>[]),
    Product(id: '355', name: 'Tofu ferme', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '⬜', fodmapType: '', substitutes: <String>[]),
    Product(id: '356', name: 'Crème fouettée', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '357', name: 'Yaourt de coco', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '358', name: 'Yaourt grec', fodmapLevel: 'Faible', allowedPortion: '23g', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '359', name: 'Yaourt sans lactose', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '360', name: 'Yaourt de chèvre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '361', name: 'Yaourt de soja', fodmapLevel: 'Faible', allowedPortion: '38g', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),

    // HERBES, ÉPICES, HUILES
    Product(id: '362', name: 'Basilic', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '363', name: 'Feuilles de laurier', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '364', name: 'Coriandre', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '365', name: 'Feuilles de curry', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '366', name: 'Fenugrec', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '367', name: 'Citronnelle', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '368', name: 'Menthe', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '369', name: 'Origan', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '370', name: 'Persil', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '371', name: 'Romarin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '372', name: 'Sauge', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '373', name: 'Estragon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '374', name: 'Thym', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '375', name: 'Quatre-épices', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '376', name: 'Poivre noir', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '377', name: 'Cardamome', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '378', name: 'Poudre de piment', fodmapLevel: 'Faible', allowedPortion: 'Vérifier', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '379', name: 'Poudre de piment chipotle', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '380', name: 'Cannelle', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '381', name: 'Clous de girofle', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '382', name: 'Cumin', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '383', name: 'Poudre de curry', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '384', name: 'Graines de fenouil', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '385', name: 'Cinq-épices', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '386', name: 'Graines de moutarde', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '387', name: 'Noix de muscade', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '388', name: 'Paprika', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '389', name: 'Safran', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '390', name: 'Anis étoilé', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '⭐', fodmapType: '', substitutes: <String>[]),
    Product(id: '391', name: 'Curcuma', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌶️', fodmapType: '', substitutes: <String>[]),
    Product(id: '392', name: 'Huile d\'avocat', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥑', fodmapType: '', substitutes: <String>[]),
    Product(id: '393', name: 'Huile de colza', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '394', name: 'Huile de coco', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥥', fodmapType: '', substitutes: <String>[]),
    Product(id: '395', name: 'Huile d\'olive', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '396', name: 'Huile de cacahuète', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥜', fodmapType: '', substitutes: <String>[]),
    Product(id: '397', name: 'Huile de son de riz', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌾', fodmapType: '', substitutes: <String>[]),
    Product(id: '398', name: 'Huile de sésame', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌱', fodmapType: '', substitutes: <String>[]),
    Product(id: '399', name: 'Huile de soja', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫘', fodmapType: '', substitutes: <String>[]),
    Product(id: '400', name: 'Huile de tournesol', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🌻', fodmapType: '', substitutes: <String>[]),
    Product(id: '401', name: 'Huile végétale', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫒', fodmapType: '', substitutes: <String>[]),
    Product(id: '402', name: 'Huile infusée à l\'ail', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧄', fodmapType: '', substitutes: <String>[]),
    Product(id: '403', name: 'Huile infusée à l\'oignon', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧅', fodmapType: '', substitutes: <String>[]),
    Product(id: '404', name: 'Poudre d\'açaï', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫐', fodmapType: '', substitutes: <String>[]),
    Product(id: '405', name: 'Poudre d\'asafoetida', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '406', name: 'Levure chimique', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '407', name: 'Bicarbonate de soude', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '408', name: 'Poudre de cacao', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍫', fodmapType: '', substitutes: <String>[]),
    Product(id: '409', name: 'Poudre de cacao', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍫', fodmapType: '', substitutes: <String>[]),
    Product(id: '410', name: 'Crème', fodmapLevel: 'Faible', allowedPortion: '2 c. à soupe', imageUrl: '🥛', fodmapType: '', substitutes: <String>[]),
    Product(id: '411', name: 'Gélatine', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '412', name: 'Ghee', fodmapLevel: 'Faible', allowedPortion: '1 c. à soupe', imageUrl: '🧈', fodmapType: '', substitutes: <String>[]),
    Product(id: '413', name: 'Sucre glace', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🍬', fodmapType: '', substitutes: <String>[]),
    Product(id: '414', name: 'Saindoux', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🥓', fodmapType: '', substitutes: <String>[]),
    Product(id: '415', name: 'Poudre de maca', fodmapLevel: 'Faible', allowedPortion: '1 c. à café', imageUrl: '🌿', fodmapType: '', substitutes: <String>[]),
    Product(id: '416', name: 'Poudre de mangue', fodmapLevel: 'Faible', allowedPortion: '1 c. à café', imageUrl: '🥭', fodmapType: '', substitutes: <String>[]),
    Product(id: '417', name: 'Poudre de matcha', fodmapLevel: 'Faible', allowedPortion: '1 c. à café', imageUrl: '🍵', fodmapType: '', substitutes: <String>[]),
    Product(id: '418', name: 'Levure nutritionnelle', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '419', name: 'Sel', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🧂', fodmapType: '', substitutes: <String>[]),
    Product(id: '420', name: 'Huile de soja', fodmapLevel: 'Faible', allowedPortion: 'Libre', imageUrl: '🫘', fodmapType: '', substitutes: <String>[]),
    Product(id: '421', name: 'Tahini décortiqué', fodmapLevel: 'Faible', allowedPortion: '30g', imageUrl: '🥫', fodmapType: '', substitutes: <String>[]),

  ];

  static Map<String, dynamic> analyzeIngredients(String ingredientsText) {
    if (ingredientsText.isEmpty || ingredientsText == 'Ingrédients non disponibles') {
      return {
        'analyzed': false,
        'ingredients': [],
        'highFodmapCount': 0,
        'moderateFodmapCount': 0,
        'lowFodmapCount': 0,
        'overallScore': 'unknown',
        'fodmapTypes': <String>[],
      };
    }

    String normalizedText = ingredientsText.toLowerCase();
    List<String> ingredientsList = normalizedText
        .split(RegExp(r'[,;.]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    List<Map<String, dynamic>> analyzedIngredients = [];
    int highCount = 0;
    int moderateCount = 0;
    int lowCount = 0;
    Set<String> detectedFodmapTypes = {};

    for (String ingredient in ingredientsList) {
      Product? matchedFodmap = _findFodmapMatch(ingredient);
      
      if (matchedFodmap != null) {
        analyzedIngredients.add({
          'text': ingredient,
          'fodmapLevel': matchedFodmap.fodmapLevel,
          'fodmapName': matchedFodmap.name,
          'allowedPortion': matchedFodmap.allowedPortion,
          'fodmapType': matchedFodmap.fodmapType,
          'substitutes': matchedFodmap.substitutes,
          'isFodmap': true,
        });
        
        if (matchedFodmap.fodmapLevel == 'Élevé') {
          highCount++;
        } else if (matchedFodmap.fodmapLevel == 'Modéré') {
          moderateCount++;
        } else {
          lowCount++;
        }

        if (matchedFodmap.fodmapType.isNotEmpty) {
          detectedFodmapTypes.add(matchedFodmap.fodmapType);
        }
      } else {
        analyzedIngredients.add({
          'text': ingredient,
          'isFodmap': false,
        });
      }
    }

    String overallScore = _calculateOverallScore(highCount, moderateCount, lowCount);

    return {
      'analyzed': true,
      'ingredients': analyzedIngredients,
      'highFodmapCount': highCount,
      'moderateFodmapCount': moderateCount,
      'lowFodmapCount': lowCount,
      'overallScore': overallScore,
      'fodmapTypes': detectedFodmapTypes.toList(),
    };
  }

  static Product? _findFodmapMatch(String ingredient) {
    String normalizedIngredient = ingredient.toLowerCase().trim();
    
    // Nettoyer l'ingrédient (enlever les parenthèses, crochets, pourcentages, etc.)
    normalizedIngredient = normalizedIngredient
        .replaceAll(RegExp(r'\[.*?\]'), '') // Enlever [soja], [lait], etc.
        .replaceAll(RegExp(r'\(.*?\)'), '') // Enlever (contient...)
        .replaceAll(RegExp(r'\d+%'), '')    // Enlever les pourcentages
        .replaceAll(RegExp(r':'), ' ')      // Remplacer : par espace
        .trim();
    
    // LISTE D'EXCLUSION : Termes qui indiquent un produit végétal/sans lactose/sans gluten
    // Si détectés, on ne doit PAS matcher avec les produits laitiers/gluten classiques
    List<String> exclusionTerms = [
      'végétal',
      'vegetal',
      'végane',
      'vegan',
      'vegane',
      'sans lactose',
      'sans gluten',
      'délactosé',
      'delactose',
      'lactose free',
      'gluten free',
      'riz',        // lait de riz, farine de riz
      'amande',     // lait d'amande
      'soja',       // lait de soja (mais attention, le soja lui-même est FODMAP)
      'avoine',     // lait d'avoine
      'coco',       // lait de coco
      'noisette',   // lait de noisette (mais attention, noisettes sont FODMAP)
      'châtaigne',  // lait de châtaigne
      'quinoa',     // lait de quinoa
    ];
    
    // Vérifier si l'ingrédient contient un terme d'exclusion
    for (String exclusionTerm in exclusionTerms) {
      if (normalizedIngredient.contains(exclusionTerm)) {
        // Exception : si c'est "lait de soja", on doit quand même détecter le soja
        if (exclusionTerm == 'soja' && normalizedIngredient.contains('lait de soja')) {
          continue; // On ne retourne pas null, on laisse le soja être détecté plus bas
        }
        // Exception : si c'est "lait de noisette", on doit quand même détecter la noisette
        if (exclusionTerm == 'noisette' && normalizedIngredient.contains('lait de noisette')) {
          continue; // On ne retourne pas null
        }
        // Pour tous les autres cas végétaux/sans lactose, on ignore
        return null;
      }
    }
    
    // Mapping des variantes/synonymes vers les ingrédients de la base
    // Format: pattern à détecter -> ID du produit dans la base FODMAP
    Map<String, int> synonymMapping = {
      // Produits laitiers (Lactose - FODMAP Élevé)
      'lait': 23,              // -> Lait de vache
      'lactoserum': 22,        // -> Lactose  
      'lactosérum': 22,        // -> Lactose
      'whey': 22,              // -> Lactose
      'petit-lait': 22,        // -> Lactose
      'poudre de lait': 23,    // -> Lait de vache
      'lait en poudre': 23,    // -> Lait de vache
      'lait écrémé': 23,       // -> Lait de vache
      'crème': 32,             // -> Crème fraîche
      'beurre': 507,           // -> Beurre (dans la base)
      'fromage frais': 25,     // -> Yaourt (similaire en lactose)
      'yaourt': 25,            // -> Yaourt
      'yogourt': 25,           // -> Yaourt
      
      // Soja (GOS - FODMAP Élevé)
      'soja': 448,             // -> Graines de soja
      'lécithine': 448,        // -> Graines de soja (lécithine vient du soja généralement)
      'lecithine': 448,        // -> Graines de soja
      'protéine de soja': 448, // -> Graines de soja
      
      // Autres ingrédients problématiques
      'oignon': 2,             // -> Oignons
      'ail': 1,                // -> Ail
      'blé': 27,               // -> Blé
      'froment': 27,           // -> Blé
      'noisette': 146,         // -> Noisettes (dans la base)
      'cacao': -1,             // Non FODMAP (pour éviter faux positifs)
      'vanille': -1,           // Non FODMAP
      'sel': -1,               // Non FODMAP
      'sucre': 420,            // -> Sucre (Faible FODMAP)
    };
    
    // D'abord vérifier les synonymes/variantes
    for (var entry in synonymMapping.entries) {
      if (normalizedIngredient.contains(entry.key)) {
        // Si c'est marqué -1, c'est explicitement non-FODMAP
        if (entry.value == -1) {
          return null;
        }
        // Trouver le produit correspondant par son ID
        try {
          return fodmapDatabase.firstWhere(
            (p) => p.id == entry.value.toString(),
          );
        } catch (e) {
          // Si l'ID n'est pas trouvé, continuer avec la logique normale
        }
      }
    }
    
    // D'abord, chercher une correspondance exacte
    for (Product fodmapItem in fodmapDatabase) {
      String normalizedFodmapName = fodmapItem.name.toLowerCase();
      if (normalizedIngredient == normalizedFodmapName) {
        return fodmapItem;
      }
    }
    
    // Ensuite, trier les FODMAPs par longueur décroissante pour matcher les plus spécifiques d'abord
    List<Product> sortedFodmaps = List.from(fodmapDatabase);
    sortedFodmaps.sort((a, b) => b.name.length.compareTo(a.name.length));
    
    // Chercher une correspondance partielle en priorisant les noms les plus longs
    for (Product fodmapItem in sortedFodmaps) {
      String normalizedFodmapName = fodmapItem.name.toLowerCase();
      
      // Vérifier si l'ingrédient contient le nom FODMAP comme mot complet ou début de mot
      if (normalizedIngredient.contains(normalizedFodmapName)) {
        // Vérifier que c'est un mot complet (pas juste une sous-chaîne)
        RegExp wordBoundary = RegExp(r'\b' + RegExp.escape(normalizedFodmapName) + r'\b');
        if (wordBoundary.hasMatch(normalizedIngredient)) {
          return fodmapItem;
        }
      }
    }
    
    return null;
  }

  static String _calculateOverallScore(int high, int moderate, int low) {
    if (high > 0) {
      return 'high';
    } else if (moderate > 2) {
      return 'moderate';
    } else if (moderate > 0 || low > 0) {
      return 'caution';
    } else {
      return 'safe';
    }
  }

  static String getFodmapColorHex(String level) {
    switch (level) {
      case 'Élevé':
        return '#F44336';
      case 'Modéré':
        return '#FF9800';
      case 'Faible':
        return '#4CAF50';
      default:
        return '#9E9E9E';
    }
  }
}
