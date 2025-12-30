import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Informations personnelles',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo de profil
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.photoURL != null 
                      ? NetworkImage(user.photoURL!) 
                      : null,
                  child: user.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Nom complet
            _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Nom complet',
              value: user.displayName ?? 'Non défini',
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            // Email
            _buildInfoCard(
              icon: Icons.email_outlined,
              label: 'Adresse email',
              value: user.email ?? 'Non défini',
              color: Colors.green,
            ),

            const SizedBox(height: 16),

            // UID
            _buildInfoCard(
              icon: Icons.fingerprint,
              label: 'Identifiant unique (UID)',
              value: user.uid,
              color: Colors.purple,
              isMonospace: true,
            ),

            const SizedBox(height: 16),

            // Fournisseur d'authentification
            _buildInfoCard(
              icon: Icons.verified_user_outlined,
              label: 'Fournisseur de connexion',
              value: _getProviderName(user),
              color: Colors.orange,
            ),

            const SizedBox(height: 16),

            // Vérification email
            _buildInfoCard(
              icon: user.emailVerified 
                  ? Icons.check_circle_outline 
                  : Icons.cancel_outlined,
              label: 'Email vérifié',
              value: user.emailVerified ? 'Oui ✓' : 'Non',
              color: user.emailVerified ? Colors.green : Colors.orange,
            ),

            const SizedBox(height: 16),

            // Date de création
            if (user.metadata.creationTime != null)
              _buildInfoCard(
                icon: Icons.calendar_today_outlined,
                label: 'Compte créé le',
                value: _formatDate(user.metadata.creationTime!),
                color: Colors.indigo,
              ),

            const SizedBox(height: 16),

            // Dernière connexion
            if (user.metadata.lastSignInTime != null)
              _buildInfoCard(
                icon: Icons.access_time_outlined,
                label: 'Dernière connexion',
                value: _formatDate(user.metadata.lastSignInTime!),
                color: Colors.teal,
              ),

            const SizedBox(height: 30),

            // Note d'information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ces informations proviennent de votre compte Google et ne peuvent pas être modifiées depuis cette application.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[900],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isMonospace = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w600,
                    fontFamily: isMonospace ? 'monospace' : null,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getProviderName(User user) {
    if (user.providerData.isEmpty) {
      return 'Inconnu';
    }
    
    final providerId = user.providerData.first.providerId;
    
    switch (providerId) {
      case 'google.com':
        return 'Google';
      case 'apple.com':
        return 'Apple';
      case 'password':
        return 'Email/Mot de passe';
      case 'facebook.com':
        return 'Facebook';
      default:
        return providerId;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Hier à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays < 7) {
      final days = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
      return "${days[date.weekday % 7]} ${date.day}/${date.month}/${date.year}";
    } else {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
  }
}

