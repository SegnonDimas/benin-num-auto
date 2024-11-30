import 'package:flutter/material.dart';

class GuideUtilisationPage extends StatelessWidget {
  const GuideUtilisationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guide d’utilisateur – Bénin Num Auto',
          style: TextStyle(fontSize: 13),
        ),
        backgroundColor: Colors.blue.shade50,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: CircleAvatar(
                        radius: 65,
                        backgroundImage:
                            AssetImage('assets/icon/app_icon.png')),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(flex: 3, child: Divider()),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Bénin Num Auto",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.orange),
                  ),
                ),
              ),
              Flexible(flex: 3, child: Divider()),
            ],
          ),
          const Text(
              textAlign: TextAlign.justify,
              "Bienvenue dans 'Bénin Num Auto', votre application conçue pour mettre à jour rapidement et efficacement vos contacts téléphoniques Béninois tout en préservant leur intégrité et votre tranquillité d'esprit. Ce guide vous accompagne dans l'utilisation des fonctionnalités de l'application."),
          space,
          space,
          space,
          const Row(
            children: [
              Text(
                "Guide d’utilisation",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.orange),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(color: Colors.orange),
              ))
            ],
          ),
          const Text(
              "Découvrez comment utiliser notre application afin de faire des choses extraordinaires en seulement quelques clics"),
          space,
          Row(
            children: [
              Text(
                "Étape 1 : Lancer l’application",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.blue.shade600),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.blue.shade600),
              ))
            ],
          ),
          const Text('''
\n-> Ouvrez l’application depuis votre écran d’accueil. \n 
-> Autorisez l’accès à vos contacts lorsque l’application vous le demande. Cela permettra de scanner et de mettre à jour vos numéros Béninois.   
            '''),
          Text(
            textAlign: TextAlign.center,
            'Note : Vos données sont entièrement sécurisées. Aucune information n’est collectée ni utilisée à d’autres fins.',
            style: TextStyle(color: Colors.red.shade400),
          ),
          space,
          SizedBox(
            height: 400,
            child: ClipRRect(
              child: Image.asset('assets/images/autorisation.png'),
            ),
          ),
          space,
          space,
          Row(
            children: [
              Text(
                "Étape 2 : Conversion des numéros",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.blue.shade600),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.blue.shade600),
              ))
            ],
          ),
          const Text('''
\n-> Cliquez sur le bouton "Mettre à jour tous les numéros béninois".  
\n-> L’application ajoutera automatiquement "01" devant tous les numéros concernés.  
\n-> Confirmez l’opération et patientez quelques instants pendant que l’application effectue les mises à jour.  
   
            '''),
          space,
          SizedBox(
            height: 400,
            child: ClipRRect(
              child: Image.asset('assets/images/miseAJour.png'),
            ),
          ),
          space,
          space,
          Row(
            children: [
              Text(
                "Étape 3 : Gestion des anciens\n"
                "numéros",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.blue.shade600),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.blue.shade600),
              ))
            ],
          ),
          const Text('''
\n-> Après la mise à jour, vos anciens numéros sont conservés temporairement.  
\n-> Cela garantit que vous pouvez continuer à utiliser vos contacts sur WhatsApp ou d'autres services qui n'ont pas encore adopté le nouveau format à 10 chiffres.  
\n-> Une fois que le nouveau format sera pleinement reconnu, vous pourrez supprimer automatiquement les anciens numéros en procédant comme suit :\n  
  -> Accédez au *Menu*.  
  -> Sélectionnez *Nettoyer vos contacts*.  
            '''),
          space,
          SizedBox(
            height: 400,
            child: ClipRRect(
              child: Image.asset('assets/images/nettoyage.png'),
            ),
          ),
          space,
          space,
          Row(
            children: [
              Text(
                "Étape 4 : Restauration des\n"
                "numéros (si nécessaire)",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.blue.shade600),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(color: Colors.blue.shade600),
              ))
            ],
          ),
          const Text('''
\n-> Si vous souhaitez annuler les modifications et revenir au format d'origine, l’application propose une option simple :\n  
    -> Allez dans le *Menu*.  
    -> Sélectionnez *Restaurer les contacts modifiés*.  
    -> Vos contacts seront restaurés à leur état initial en quelques secondes.  
            '''),
          space,
          SizedBox(
            height: 400,
            child: ClipRRect(
              child: Image.asset('assets/images/restoration.png'),
            ),
          ),
          space,
          space,
          space,
          const Row(
            children: [
              Text(
                'Changement du Numéro',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.orange),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(color: Colors.orange),
              ))
            ],
          ),
          Text(
            'Le changement de numéro se fait de manière automatique :\n'
            '1. Vous pouvez soit rechercher un contact ou un numéro. \n'
            '2. L\'application transformera le numéro ou les numéros béninois du contact en un format normalisé (+22901XXXXXXXX). \n'
            '3. Si le contact choisi à plusieurs numéros de téléphones, seuls ceux du bénin lui seront mis à jour\n'
            '4. Vous n\'avez rien à faire, juste à sélectionner le contact et l\'application se charge du reste.',
            style: TextStyle(fontSize: 13),
          ),
          space,
          space,
          const Divider(),
          const Text('''

Ce guide vous garantit une utilisation facile et optimale de votre application Bénin Num Auto pour garder vos contacts à jour et conformes à la réglementation en vigueur.
Merci d’avoir choisi Bénin Num Auto. Simplifiez vos mises à jour et gérez vos contacts avec facilité et confiance !
          '''),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
            /*gradient: LinearGradient(colors: [
          Colors.green.shade800,
          Colors.yellow.shade800,
          Colors.red.shade800
        ])*/
            color: Colors.grey.shade700),
        child: const Text(
          'Tout droit réservé © 2024 - Smart Solutions Innova',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
