import 'package:flutter/material.dart';

class InfosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informations sur l\'Application',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: const [
            SizedBox(height: 16),
            Text(
              'Bienvenue dans notre Application !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Cette application vous permet de modifier facilement les numéros de téléphone béninois en ajoutant le préfixe 01 comme le gouvernement béninois le veut adopter à partir du 30 novembre 2024. '
              'Elle est simple d\'utilisation et vous garantit une mise à jour rapide et efficace de vos contacts.',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Mode de fonctionnement :',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              '1. Sélectionnez un contact béninois (celui que vous souhaitez mettre à jour). \n'
              '2. Cliquez sur le bouton "Mise à jour des contacts sélectionnés"\n'
              '3. L\'application transformera automatiquement le numéro au format international +22901XXXXXXXX. \n'
              '4. Le numéro sera affiché sous un format propre et uniforme.',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Accès et Autorisations :',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'L\'application nécessite les permissions suivantes : \n\n'
              '1. Accès aux contacts : pour récupérer les numéros dans vos contacts et les mettre à jour si nécessaire. \n'
              '2. Accès à Internet : pour récupérer les informations de mise à jour en temps réel. \n\n'
              'Toutes ces autorisations sont requises uniquement pour améliorer l\'expérience utilisateur et n\'ont aucune intention malveillante.',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text(
              'Changement du Numéro :',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Le changement de numéro se fait de manière automatique :\n'
              '1. Vous pouvez soit rechercher un contact ou un numéro. \n'
              '2. L\'application transformera le numéro ou les numéros béninois du contact en un format normalisé (+22901XXXXXXXX). \n'
              '3. Si le contact choisi à plusieurs numéros de téléphones, seuls ceux du bénin lui seront mis à jour\n'
              '4. Vous n\'avez rien à faire, juste à sélectionner le contact et l\'application se charge du reste.',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Nous vous remercions de votre confiance dans l\'utilisation de cette application.',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.green.shade800,
          Colors.yellow.shade800,
          Colors.red.shade800
        ])),
        child: const Text(
          'Tout droit réservé © 2024 - Smart Solutions Innova',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
