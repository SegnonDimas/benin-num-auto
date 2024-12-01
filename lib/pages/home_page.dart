import 'package:benin_num_auto/pages/guide_utilisation_page.dart';
import 'package:benin_num_auto/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUpdaterPage extends StatefulWidget {
  const ContactUpdaterPage({Key? key}) : super(key: key);

  @override
  State<ContactUpdaterPage> createState() => _ContactUpdaterPageState();
}

class _ContactUpdaterPageState extends State<ContactUpdaterPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> filteredContactsByLetter = [];
  List<Contact> selectedContacts = [];
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  /// DEBUT : recharge des contacts du téléphone
  Future<void> fetchContacts({bool incremental = false}) async {
    if (!await FlutterContacts.requestPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission refusée. Accès aux contacts requis.'),
        ),
      );
      return;
    }

    setState(() => isLoading = true); // Démarre le loader

    try {
      List<Contact> newContacts;

      if (incremental) {
        // Charge uniquement les contacts modifiés
        newContacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          withAccounts: true,
        );
      } else {
        // Charge tous les contacts
        newContacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          withAccounts: true,
        );
      }

      setState(() {
        if (incremental) {
          // Met à jour uniquement les contacts modifiés
          for (var contact in newContacts) {
            contacts.removeWhere((c) => c.id == contact.id);
            contacts.add(contact);
          }
        } else {
          // Recharge complètement les contacts
          contacts = newContacts;
        }

        filteredContacts = contacts; // Mise à jour de la liste affichée
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la récupération des contacts: $e'),
        ),
      );
      print('Erreur lors de la récupération des contacts: $e');
    } finally {
      setState(() => isLoading = false); // Arrête le loader
    }
/*    final box = await Hive.openBox('contactsBox');
    box.put('contacts', contacts);*/
  }

  /// FIN : recharge des contacts du téléphone

  /// DEBUT : convertion des contacts au format +22901XXXXXXXX
  /* String transformBeninNumber(String number) {
    // Nettoyage du numéro pour enlever les espaces, tirets, parenthèses
    var cleanedNumber = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Si le numéro est local (8 chiffres), on ajoute '01' au début et on retourne sous le format souhaité
    if (cleanedNumber.length == 8) {
      return '+22901$cleanedNumber'; // Ajouter "01" pour les numéros locaux
    }

    // Liste des patterns pour détecter un numéro avec indicatif béninois (+229, 00229, 229)
    final patterns = [r'^\+229', r'^00229', r'^229'];

    // Vérification de chaque pattern pour les numéros internationaux
    for (var pattern in patterns) {
      if (RegExp(pattern).hasMatch(cleanedNumber)) {
        var localNumber = cleanedNumber.replaceFirst(RegExp(pattern), '');
        if (localNumber.length == 8) {
          return '+22901$localNumber'; // Ajouter "01" pour les numéros internationaux
        }
      }
    }

    // Retourner le numéro original s'il ne correspond à aucune condition (par exemple, un mauvais format)
    return number;
  }

  Future<void> updateContact(Contact contact) async {
    bool updated = false;

    for (var phone in contact.phones) {
      final oldNumber = phone.number;
      final newNumber = transformBeninNumber(oldNumber);

      if (newNumber != oldNumber) {
        phone.number = newNumber;
        updated = true;
      }
    }

    if (updated) {
      try {
        await contact.update();
        print('Contact mis à jour : ${contact.displayName}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Contact mis à jour : ${contact.displayName}')),
        );
      } catch (e) {
        print('Erreur lors de la mise à jour : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour.')),
        );
      }
    }
  }

  Future<void> updateContacts({bool updateAll = false}) async {
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission refusée.')),
      );
      return;
    }

    final contactsToUpdate = updateAll ? contacts : selectedContacts;

    for (var contact in contactsToUpdate) {
      await updateContact(contact);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${contactsToUpdate.length} contacts mis à jour !')),
    );
    await refreshContacts();
  }

  Future<void> refreshContacts() async {
    try {
      const platform = MethodChannel('com.example.benin_num_auto');
      await platform.invokeMethod('refreshContacts');
      print("Contacts refreshed successfully!");
    } on PlatformException catch (e) {
      print("Failed to refresh contacts: ${e.message}");
    }
  }*/

  /// Fonction pour transformer un numéro béninois au nouveau format +22901XXXXXXXX
  /*String transformBeninNumber(String number) {
    // Nettoyage du numéro pour enlever les espaces, tirets, parenthèses
    var cleanedNumber = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Si le numéro est local (8 chiffres), on ajoute '01' au début
    if (cleanedNumber.length == 8) {
      return '+22901$cleanedNumber'; // Nouveau format
    }

    // Liste des patterns pour détecter un numéro avec indicatif béninois
    final patterns = [r'^\+229', r'^00229', r'^229'];

    // Vérification de chaque pattern pour les numéros internationaux
    for (var pattern in patterns) {
      if (RegExp(pattern).hasMatch(cleanedNumber)) {
        var localNumber = cleanedNumber.replaceFirst(RegExp(pattern), '');
        if (localNumber.length == 8) {
          return '+22901$localNumber'; // Nouveau format
        }
      }
    }

    // Retourner le numéro original si aucune condition n'est remplie
    return number;
  }*/

  String transformBeninNumber(String number) {
    // Nettoyage du numéro pour enlever les espaces, tirets, parenthèses
    final cleanedNumber = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Si le numéro est local (8 chiffres), ajouter '01' au début
    if (cleanedNumber.length == 8) {
      return '+22901$cleanedNumber';
    }

    // Détecter les indicatifs béninois et vérifier si le numéro est local
    final patterns = [r'^\+229', r'^00229', r'^229'];
    for (var pattern in patterns) {
      if (RegExp(pattern).hasMatch(cleanedNumber)) {
        final localNumber = cleanedNumber.replaceFirst(RegExp(pattern), '');
        if (localNumber.length == 8) {
          return '+22901$localNumber';
        }
      }
    }

    // Si aucune transformation nécessaire, retourner le numéro original
    return number;
  }

  /// Met à jour un contact en ajoutant le nouveau format tout en conservant l'ancien

  /*Future<void> updateContact(Contact contact) async {
    bool updated = false;

    // Créer une copie de la liste pour éviter les modifications pendant l'itération
    final phonesToCheck = List.of(contact.phones);

    for (var phone in phonesToCheck) {
      final oldNumber = phone.number;
      final newNumber = transformBeninNumber(oldNumber);

      // Vérifie si le nouveau numéro est valide et unique
      if (newNumber != oldNumber &&
          !contact.phones.any((p) => p.number == newNumber)) {
        contact.phones.add(Phone(newNumber)); // Ajouter le nouveau numéro
        updated = true;
      }
    }

    if (updated) {
      try {
        await contact.update(); // Enregistrer les modifications
        print('Contact mis à jour : ${contact.displayName}');

      } catch (e) {
        print('Erreur lors de la mise à jour : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour.')),
        );
      }
    }
  }*/

  Future<void> updateContact(Contact contact) async {
    bool updated = false;
    final phonesToCheck = List.of(contact.phones);

    for (var phone in phonesToCheck) {
      final oldNumber = phone.number;
      final newNumber = transformBeninNumber(oldNumber);

      // Vérifie si le nouveau numéro est différent et unique
      if (newNumber != oldNumber &&
          !contact.phones.any((p) => p.number == newNumber)) {
        contact.phones.add(Phone(newNumber)); // Ajouter le nouveau numéro
        updated = true;
      }
    }

    if (updated) {
      try {
        await contact.update();
        print('Contact mis à jour : ${contact.displayName}');
      } catch (e) {
        print('Erreur lors de la mise à jour : $e');
        // Vous pouvez ajouter une gestion d'erreur ici
      }
    }
  }

  /// Met à jour tous les contacts ou une sélection de contacts
  Future<void> updateContacts({bool updateAll = false}) async {
    // Vérifier les permissions
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission refusée.')),
      );
      return;
    }

    // Obtenir la liste des contacts à mettre à jour
    final contactsToUpdate = updateAll ? contacts : selectedContacts;

    for (var contact in contactsToUpdate) {
      await updateContact(contact);
      await organizeContactNumbers(
          contact); // Organiser et nettoyer les contacts
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${contactsToUpdate.length} contacts mis à jour !')),
    );

    // Rafraîchir les contacts après mise à jour
    await refreshContacts();
  }

  Future<void> organizeContactNumbers(Contact contact) async {
    // Listes pour stocker les numéros sous le nouveau et l'ancien format
    final Set<String> newFormatPhones = {}; // Set pour éviter les doublons
    final Set<String> oldFormatPhones = {}; // Set pour éviter les doublons

    // Créer une copie des numéros existants pour itération
    final List<Phone> phonesToCheck = List.from(contact.phones);

    for (var phone in phonesToCheck) {
      final oldNumber = phone.number;
      final transformedNumber = transformBeninNumber(oldNumber);

      if (transformedNumber != oldNumber) {
        // Ajouter au groupe des nouveaux formats si transformation
        newFormatPhones.add(transformedNumber);
      }

      // Ajouter le numéro original (il peut ne pas nécessiter de transformation)
      oldFormatPhones.add(oldNumber);
    }

    // Organiser les numéros : nouveaux formats en premier
    final List<Phone> organizedPhones = [
      ...newFormatPhones.map((number) => Phone(number)),
      ...oldFormatPhones.map((number) => Phone(number)),
    ];

    // Appliquer la nouvelle organisation au contact
    contact.phones
      ..clear()
      ..addAll(organizedPhones);

    // Sauvegarder les modifications
    try {
      await contact.update();
      print('Contact organisé : ${contact.displayName}');
    } catch (e) {
      print('Erreur lors de la mise à jour : $e');
    }
  }

  /// Rafraîchir les contacts dans l'application
  Future<void> refreshContacts() async {
    try {
      const platform = MethodChannel('com.example.benin_num_auto');
      await platform.invokeMethod('refreshContacts');
      print("Contacts refreshed successfully!");
    } on PlatformException catch (e) {
      print("Failed to refresh contacts: ${e.message}");
    }
  }

  /// FIN : convertion des contacts au format +22901XXXXXXXX

  /// DEBUT : Réorganisation des numéros des contacts
  /*Future<void> organizeContactNumbers(Contact contact) async {
    // Listes pour stocker les numéros sous l'ancien et le nouveau format
    final List<Phone> newFormatPhones = [];
    final List<Phone> oldFormatPhones = [];

    // Parcourir tous les numéros du contact
    for (var phone in contact.phones) {
      final oldNumber = phone.number; // Numéro actuel
      final transformedNumber =
          transformBeninNumber(oldNumber); // Transformation

      if (transformedNumber != oldNumber) {
        // Si le numéro a été transformé, ajouter au groupe des nouveaux numéros
        newFormatPhones.add(Phone(transformedNumber));
      } else {
        // Sinon, conserver dans le groupe des anciens numéros
        oldFormatPhones.add(phone);
      }
    }

    // Réorganiser les numéros : nouveaux formats en premier
    final List<Phone> organizedPhones = [
      ...newFormatPhones, // Nouveaux numéros
      ...oldFormatPhones, // Anciens numéros
    ];

    // Appliquer cette organisation au contact
    contact.phones
      ..clear() // Effacer l'existant
      ..addAll(organizedPhones); // Ajouter la nouvelle organisation

    // Tenter de sauvegarder les changements
    try {
      await contact.update(); // Mise à jour du carnet
      print('Contact organisé : ${contact.displayName}');

      // Notification à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact mis à jour : ${contact.displayName}')),
      );
    } catch (e) {
      // En cas d'erreur, afficher une notification
      print('Erreur lors de la mise à jour : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour.')),
      );
    }
  }*/

  /// FIN :  Réorganisation des numéros des contacts

  /// DEBUT : filtrage des contacts
  void filterContacts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      if (letterIndex == 0 && searchQuery != '') {
        filteredContacts = contacts.where((contact) {
          final name = contact.displayName.toLowerCase();
          final phoneNumbers =
              contact.phones.map((phone) => phone.number).join(' ');
          return name.contains(searchQuery) ||
              phoneNumbers.contains(searchQuery);
        }).toList();
      } else if (letterIndex != 0 && searchQuery != '') {
        filteredContacts = filteredContactsByLetter.where((contact) {
          final name = contact.displayName.toLowerCase();
          final phoneNumbers =
              contact.phones.map((phone) => phone.number).join(' ');
          return name.contains(searchQuery) ||
              phoneNumbers.contains(searchQuery);
        }).toList();
      } else {
        letterIndex = 0;
        filteredContacts = contacts;
      }
    });
  }

  void filterContactsByLetter(String letter) {
    setState(() {
      if (letter == 'Tous') {
        filteredContactsByLetter =
            filteredContacts; // Affiche tous les contacts
      } else {
        filteredContactsByLetter = filteredContacts.where((contact) {
          final name = contact.displayName.toUpperCase();
          return name.startsWith(letter.toUpperCase());
        }).toList();
      }
    });
  }

  /// FIN : filtrage des contacts

  /// DEBUT : reconversion des contacts au format XXXXXXXX
  String revertBeninNumber(String number) {
    // Nettoyer le numéro pour enlever les espaces, tirets, parenthèses
    var cleanedNumber = number.replaceAll(RegExp(r'[\s\-()]'), '');

    // Vérifier si le numéro est au format +22901XXXXXXXX
    if (RegExp(r'^\+22901\d{8}$').hasMatch(cleanedNumber)) {
      // Supprimer le préfixe +22901
      return cleanedNumber.replaceFirst(RegExp(r'^\+22901'), '');
    }

    // Retourner le numéro original si ce n'est pas un format reconnu
    return number;
  }

  Future<void> updateContactToLocal(Contact contact) async {
    bool updated = false;

    for (var phone in contact.phones) {
      final oldNumber = phone.number;
      final newNumber = revertBeninNumber(oldNumber);

      if (newNumber != oldNumber) {
        phone.number = newNumber;
        updated = true;
      }
    }

    if (updated) {
      try {
        await contact.update();
        print('Contact mis à jour : ${contact.displayName}');
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Contact mis à jour : ${contact.displayName}')),
        );*/
      } catch (e) {
        print('Erreur lors de la mise à jour : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour.')),
        );
      }
    }
  }

  Future<void> updateContactsToLocal({bool updateAll = true}) async {
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission refusée.')),
      );
      return;
    }

    final contactsToUpdate = updateAll ? contacts : selectedContacts;

    for (var contact in contactsToUpdate) {
      await updateContactToLocal(contact);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          //backgroundColor: Colors.green.shade700,
          content: Text('Opération réussie')),
    );
    await refreshContacts();
  }

  /// FIN : reconversion des contacts au format XXXXXXXX

  /// DEBUT : nettoyage des contacts / Pour la suppression des anciens numéros

  Future<void> removeOldBeninNumbers(
      List<Contact> contactsToProcess, // Liste des contacts à traiter

      {bool deleteAll = false}) async {
    /*selectedContacts.length != 0
        ? contactsToProcess = selectedContacts
        : contactsToProcess = contacts;*/
    for (var contact in contactsToProcess) {
      // Liste temporaire pour conserver uniquement les numéros à ne pas supprimer
      final List<Phone> updatedPhones = [];

      for (var phone in contact.phones) {
        final originalNumber = phone.number;
        final transformedNumber = transformBeninNumber(originalNumber);

        // Identifier les anciens formats béninois uniquement
        if (isBeninNumber(originalNumber) &&
            transformedNumber != originalNumber) {
          // C'est un ancien format béninois -> Ignorer (ne pas ajouter à `updatedPhones`)
          print('Numéro supprimé : $originalNumber');
        } else {
          // Conserver les autres numéros
          updatedPhones.add(phone);
        }
      }

      // Appliquer la liste mise à jour au contact
      contact.phones
        ..clear()
        ..addAll(updatedPhones);

      try {
        // Sauvegarder les modifications
        await contact.update();
        print(
            'Numéros anciens supprimés pour le contact : ${contact.displayName}');
      } catch (e) {
        print(
            'Erreur lors de la mise à jour du contact ${contact.displayName} : $e');
      }
    }

    // Afficher un message global après traitement
    final message = deleteAll
        ? 'Tous les contacts ont été mis à jour.'
        : '${contactsToProcess.length} contacts sélectionnés ont été mis à jour.';
    print(message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool isBeninNumber(String number) {
    // Nettoyer le numéro pour uniformiser le format
    var cleanedNumber = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Vérifier si le numéro correspond à un format béninois
    final patterns = [r'^\+229', r'^00229', r'^229', r'^\d{8}$'];

    for (var pattern in patterns) {
      if (RegExp(pattern).hasMatch(cleanedNumber)) {
        return true;
      }
    }

    return false; // Si aucun pattern ne correspond, ce n'est pas un numéro béninois
  }

  /// FIN : nettoyage des contacts / Pour la suppression des anciens numéros

  /// DEBUT : Facebook, Gmail, Partage
  // facebook
  Future<void> openFacebook() async {
    const url =
        'https://www.facebook.com/profile.php?id=100076965547828'; //  lien Facebook
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Erreur lors d\'ouverture de facebook : $e');
    }
  }

  // gmail
  void openGmail() async {
    const email = 'segnondimas@gmail.com'; // Remplacez par votre email
    const subject = 'Bénin Num App';
    const body = '';

    final url =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    try {
      await launchUrl(Uri.parse(url));
      print('Impossible d\'ouvrir Gmail');
    } catch (e) {
      print('Erreur lors d\'ouverture de Gmail : $e');
    }
  }

  // partage

  void shareApp() {
    const message =
        'Découvrez cette application géniale pour la mise à jour facile de vos contacts béninois au format +22901XXXXXXXX : https://bit.ly/ObtenirApp';
    try {
      Share.share(message);
    } catch (e) {
      print("Erreur lors du partage : $e");
    }
  }

  /// FIN : Facebook, Gmail, Partage

  /// politique de confidentialité
  Future<void> onpenConfidentialPolicy() async {
    const url = 'https://tally.so/r/wz0Rz0'; //  lien Facebook
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Erreur lors d\'ouverture de la politique de confidentialité : $e');
    }
  }

  int letterIndex = 0;
  int letterIndexTemp = 0;
  bool selectAll = false;
  double loadingDelay = 0;
  bool isOperating = false;

  final List<String> _rechercheLettre = [
    'Tous',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 650,
              child: Column(
                children: [
                  //icon
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(flex: 4, child: Divider()),
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: CircleAvatar(
                                radius: 75,
                                backgroundImage:
                                    AssetImage('assets/icon/app_icon.png')),
                          ),
                        ),
                        Flexible(flex: 4, child: Divider()),
                      ],
                    ),
                  ),
                  //facebook
                  ListTile(
                      leading: Icon(
                        Icons.facebook,
                        size: 30,
                        color: Colors.blue.shade800,
                      ),
                      title: const Text(
                        "Nous suivre sur notre page",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                      onTap: () async {
                        await openFacebook();
                      }),
                  // gmail
                  ListTile(
                    leading: const Icon(
                      Icons.mail_outline,
                      size: 25,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Nous écrire",
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    onTap: () => openGmail(),
                  ),
                  // partage
                  ListTile(
                    leading: const Icon(
                      Icons.share,
                      size: 25,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Partager l'application",
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    onTap: () => shareApp(),
                  ),
                  // infos
                  Shimmer.fromColors(
                    baseColor: Colors.blue.shade800,
                    highlightColor: Colors.orange,
                    child: ListTile(
                      leading: const Icon(
                        Icons.info,
                        size: 25,
                        //color: Colors.blue,
                      ),
                      title: const Text(
                        "Guide utilisateur",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GuideUtilisationPage()));
                      },
                    ),
                  ),

                  const Divider(),

                  //restauration
                  AppButton(
                    backgroundColor: Colors.grey.shade300,
                    height: 50,
                    width: 300,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restart_alt,
                          size: 25,
                        ),
                        //color: Colors.blue,),

                        Tooltip(
                          message: 'Reconvertir vos numéros',
                          showDuration: const Duration(seconds: 3),
                          verticalOffset: 49,
                          child: AppButton(
                            // backgroundColor: Colors.grey.shade600,
                            height: 50,
                            width: 200,
                            borderRadius: 30,
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.white,
                                        child: SizedBox(
                                          height: 340,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 22.0),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    'RAMENER TOUS LES CONTACTS MODIFIÉS À L\'ANCIEN FORMAT',
                                                    style: TextStyle(
                                                        //color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: !isOperating
                                                      ? const Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .emoji_emotions_outlined,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              title: Text(
                                                                'Nous ramenerons au format XXXXXXXX tous les numéros béninois des contacts',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons qu\'aux numéros modifiés sur notre applications',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons à aucun numéro non béninois',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          height: 180,
                                                          child: Expanded(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 100,
                                                                  child: Lottie
                                                                      .asset(
                                                                          'assets/lotties/loading4.json'),
                                                                ),
                                                                const Text(
                                                                    "Opération en cours ..."),
                                                                const Text(
                                                                    "Veuillez patienter ...")
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppButton(
                                                        alignment:
                                                            Alignment.center,
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            isOperating = true;
                                                          });
                                                          await updateContactsToLocal(); // Appelle la fonction de reconversion
                                                          setState(() {
                                                            selectedContacts =
                                                                [];
                                                            isOperating = false;
                                                          });
                                                          //Navigator.pop(context);
                                                        },
                                                        height: 50,
                                                        width: 110,
                                                        backgroundColor: Colors
                                                            .green.shade700,
                                                        child: !isOperating
                                                            ? const Text(
                                                                'CONFIRMER',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        12.5),
                                                              )
                                                            : const CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                      ),
                                                      AppButton(
                                                          alignment:
                                                              Alignment.center,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          height: 50,
                                                          width: 110,
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade700,
                                                          child: const Text(
                                                            'ANNULER',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 12.5),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  });

                              setState(() {});
                            },
                            child: const Text(
                              "Restaurer les contacts modifiés",
                              style: TextStyle(fontSize: 11),
                            ),
                            //tooltip: 'Reconvertir les numéros sélectionnés',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // nettoyage de tous les ancians numéros
                  AppButton(
                    backgroundColor: Colors.grey.shade300,
                    height: 50,
                    width: 300,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.cleaning_services_outlined,
                          size: 25,
                        ),
                        //color: Colors.blue,),

                        Tooltip(
                          message:
                              'Supprimez les anciens numéros au format XXXXXXXX et maintenez que les numéros au nouveau format +22901XXXXXXXX',
                          showDuration: const Duration(seconds: 6),
                          verticalOffset: 49,
                          child: AppButton(
                            // backgroundColor: Colors.grey.shade600,
                            height: 50,
                            width: 200,
                            borderRadius: 30,
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.white,
                                        child: SizedBox(
                                          height: 370,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 22.0),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    'SUPPRIMER LES NUMÉROS QUI SONT À L\'ANCIEN FORMAT XXXXXXXX',
                                                    style: TextStyle(
                                                        //color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: !isOperating
                                                      ? const Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .emoji_emotions_outlined,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              title: Text(
                                                                'Nous supprimerons que les doublons de l\'ancien format XXXXXXXX',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons qu\'aux numéros modifiés antérieurement sur notre application',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons à aucun numéro non béninois',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          height: 180,
                                                          child: Expanded(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 100,
                                                                  child: Lottie
                                                                      .asset(
                                                                          'assets/lotties/loading4.json'),
                                                                ),
                                                                const Text(
                                                                    "Opération en cours ..."),
                                                                const Text(
                                                                    "Veuillez patienter ...")
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppButton(
                                                        alignment:
                                                            Alignment.center,
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            isOperating = true;
                                                          });
                                                          //await updateContactsToLocal(); // Appelle la fonction de reconversion
                                                          await removeOldBeninNumbers(
                                                              contacts);
                                                          setState(() {
                                                            selectedContacts =
                                                                [];
                                                            isOperating = false;
                                                          });
                                                          //Navigator.pop(context);
                                                        },
                                                        height: 50,
                                                        width: 110,
                                                        backgroundColor: Colors
                                                            .green.shade700,
                                                        child: !isOperating
                                                            ? const Text(
                                                                'CONFIRMER',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        12.5),
                                                              )
                                                            : const CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                      ),
                                                      AppButton(
                                                          alignment:
                                                              Alignment.center,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          height: 50,
                                                          width: 110,
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade700,
                                                          child: const Text(
                                                            'ANNULER',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 12.5),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  });

                              setState(() {});
                            },
                            child: const Text(
                              "Nettoyer tous vos contacts",
                              style: TextStyle(fontSize: 12),
                            ),
                            //tooltip: 'Reconvertir les numéros sélectionnés',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // nettoyage des anciens numéros des contacts sélectionnés
                  AppButton(
                    backgroundColor: Colors.grey.shade300,
                    height: 50,
                    width: 300,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.cleaning_services_sharp,
                          size: 25,
                        ),
                        //color: Colors.blue,),

                        Tooltip(
                          message:
                              'Supprimez les anciens numéros au format XXXXXXXX et maintenez que les numéros au nouveau format +22901XXXXXXXX',
                          showDuration: const Duration(seconds: 6),
                          verticalOffset: 49,
                          child: AppButton(
                            // backgroundColor: Colors.grey.shade600,
                            height: 50,
                            width: 230,
                            borderRadius: 30,
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.white,
                                        child: SizedBox(
                                          height: 370,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 22.0),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    'SUPPRIMER LES NUMÉROS QUI SONT À L\'ANCIEN FORMAT XXXXXXXX',
                                                    style: TextStyle(
                                                        //color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  child: !isOperating
                                                      ? const Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .emoji_emotions_outlined,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              title: Text(
                                                                'Nous supprimerons que les doublons de l\'ancien format XXXXXXXX',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons qu\'aux numéros modifiés antérieurement sur notre application',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons à aucun numéro non béninois',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          height: 180,
                                                          child: Expanded(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 100,
                                                                  child: Lottie
                                                                      .asset(
                                                                          'assets/lotties/loading4.json'),
                                                                ),
                                                                const Text(
                                                                    "Opération en cours ..."),
                                                                const Text(
                                                                    "Veuillez patienter ...")
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppButton(
                                                        alignment:
                                                            Alignment.center,
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            isOperating = true;
                                                          });
                                                          //await updateContactsToLocal(); // Appelle la fonction de reconversion
                                                          /*await cleanContacts(
                                                              cleanAll: false);*/
                                                          await removeOldBeninNumbers(
                                                              selectedContacts /*.isNotEmpty?selectedContacts:contacts*/);
                                                          setState(() {
                                                            selectedContacts =
                                                                [];
                                                            isOperating = false;
                                                          });
                                                          //Navigator.pop(context);
                                                        },
                                                        height: 50,
                                                        width: 110,
                                                        backgroundColor: Colors
                                                            .green.shade700,
                                                        child: !isOperating
                                                            ? const Text(
                                                                'CONFIRMER',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        12.5),
                                                              )
                                                            : const CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                      ),
                                                      AppButton(
                                                          alignment:
                                                              Alignment.center,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          height: 50,
                                                          width: 110,
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade700,
                                                          child: const Text(
                                                            'ANNULER',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 12.5),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  });

                              setState(() {});
                            },
                            child: const Text(
                              "Nettoyer les contacts sélectionnés",
                              style: TextStyle(fontSize: 12),
                            ),
                            //tooltip: 'Reconvertir les numéros sélectionnés',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 75,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await onpenConfidentialPolicy();
                    },
                    child: Text(
                      textWidthBasis: TextWidthBasis.longestLine,
                      "POLITIQUE DE CONFIDENTIALITÉ",
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Powered by\nSmart Solutions Innova",
                      style: TextStyle(
                          //color: Colors.deepOrange,
                          fontWeight: FontWeight.w900,
                          fontSize: 10),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mise à jour des numéros béninois',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "${contacts.length} contacts",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade300),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const GuideUtilisationPage()));
                  },
                  child: SizedBox(
                      height: 33,
                      child: Lottie.asset('assets/lotties/infos.json')),
                ),
                Text(
                  "${selectedContacts.length} sélectionnés",
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8, left: 8),
            child: isLoading
                ? Container(
                    // width: 200.0,
                    //height: 50.0,
                    alignment: Alignment.center,
                    child: Shimmer.fromColors(
                      baseColor: Colors.orange.shade800,
                      highlightColor: Colors.orange.shade300,
                      child: AppButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GuideUtilisationPage()));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lire le guide d\'utilisation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 25,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w900,
                            ),
                            onChanged: filterContacts,
                            decoration: InputDecoration(
                              label: Text(
                                "Rechercher un contact",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Actualiser la page',
                        showDuration: const Duration(seconds: 3),
                        verticalOffset: 49,
                        child: AppButton(
                            backgroundColor: Colors.orange.shade700,
                            height: 40,
                            width: 40,
                            borderRadius: 30,
                            onTap: isLoading ? () {} : fetchContacts,
                            child: isLoading
                                ? const CupertinoActivityIndicator(
                                    radius: 9.0, // Taille du spinner
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 18,
                                  )),
                      ),
                    ],
                  ),
          ),
          if (isLoading)
            //const Center(child: CircularProgressIndicator())
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                      height: 250,
                      child: Lottie.asset('assets/lotties/loading4.json')),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        textAlign: TextAlign.center,
                        'Veuillez patienter pendant que nous chargeons vos contacts ...',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _rechercheLettre.length,
                          itemBuilder: (context, index) {
                            return AppButton(
                              onTap: () {
                                setState(() {
                                  if (index != letterIndex) {
                                    letterIndexTemp = letterIndex;
                                    letterIndex = index;
                                    selectAll = false;
                                    selectedContacts = [];
                                  } else {
                                    letterIndexTemp = letterIndex;
                                    letterIndex = index;
                                  }

                                  filterContactsByLetter(
                                      _rechercheLettre[index]);
                                });
                              },
                              width: 60,
                              alignment: Alignment.center,
                              backgroundColor: letterIndex == index
                                  ? Colors.blue.withOpacity(0.5)
                                  : Colors.grey.shade200,
                              child: Text(_rechercheLettre[index]),
                            );
                          },
                        ),
                      ),
                      selectedContacts.length != 0 && !isOperating
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sélectionner tout",
                                    style: TextStyle(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13),
                                  ),
                                  AppButton(
                                    onTap: () {
                                      setState(() {
                                        selectAll = !selectAll;
                                        if (selectAll) {
                                          letterIndex != 0
                                              ? selectedContacts =
                                                  filteredContactsByLetter
                                              : selectedContacts = contacts;
                                        } else {
                                          selectedContacts = [];
                                        }
                                      });
                                    },
                                    child: !selectAll
                                        ? const Icon(Icons.check_box_outlined)
                                        : const Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                      selectAll && letterIndex == 0
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: filteredContacts.length,
                                itemBuilder: (context, index) {
                                  selectedContacts = contacts;
                                  final contact = filteredContacts[index];

                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        if (selectedContacts
                                            .contains(contact)) {
                                          selectedContacts.remove(contact);
                                        } else {
                                          selectedContacts.add(contact);
                                        }
                                      });
                                    },
                                    leading: CircleAvatar(
                                      child: Text(contact.displayName?[0] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    title: Text(
                                      contact.displayName ?? 'Sans nom',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      contact.phones.isNotEmpty
                                          ? contact.phones.first.number
                                          : 'Pas de numéro',
                                    ),
                                    trailing: Checkbox(
                                      value: selectedContacts.contains(contact),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedContacts.add(contact);
                                          } else {
                                            selectedContacts.remove(contact);
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : letterIndex == 0
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredContacts.length,
                                    itemBuilder: (context, index) {
                                      final contact = filteredContacts[index];
                                      return ListTile(
                                        onTap: () {
                                          setState(() {
                                            if (selectedContacts
                                                .contains(contact)) {
                                              selectedContacts.remove(contact);
                                            } else {
                                              selectedContacts.add(contact);
                                            }
                                          });
                                        },
                                        leading: CircleAvatar(
                                          child: Text(
                                              contact.displayName?[0] ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        title: Text(
                                          contact.displayName ?? 'Sans nom',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          contact.phones.isNotEmpty
                                              ? contact.phones.first.number
                                              : 'Pas de numéro',
                                        ),
                                        trailing: Checkbox(
                                          value: selectedContacts
                                              .contains(contact),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                selectedContacts.add(contact);
                                              } else {
                                                selectedContacts
                                                    .remove(contact);
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredContactsByLetter.length,
                                    itemBuilder: (context, index) {
                                      final contact =
                                          filteredContactsByLetter[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: Text(
                                              contact.displayName?[0] ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        title: Text(contact.displayName ??
                                            'Nom inconnu'),
                                        subtitle: Text(contact.phones.isNotEmpty
                                            ? contact.phones.first.number
                                            : 'Numéro inconnu'),
                                        trailing: Checkbox(
                                          value: selectedContacts
                                              .contains(contact),
                                          onChanged: (isSelected) {
                                            setState(() {
                                              if (isSelected == true) {
                                                selectedContacts.add(contact);
                                              } else {
                                                selectedContacts
                                                    .remove(contact);
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
                  isOperating
                      ? Center(
                          child: AppButton(
                            alignment: Alignment.topCenter,
                            height: 300,
                            width: 300,
                            backgroundColor: Colors.black87.withOpacity(0.8),
                            borderRadius: 30,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton(
                                      height: 150,
                                      child: Lottie.asset(
                                          'assets/lotties/loading4.json')),
                                  Container(
                                    // width: 200.0,
                                    //height: 50.0,
                                    alignment: Alignment.center,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.black38,
                                      child: AppButton(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const GuideUtilisationPage()));
                                        },
                                        child: const Text(
                                          'Opération en cours ...\nVeuillez patienter ...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: !isLoading
          ? Container(
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selectedContacts.length != 0
                      ? Tooltip(
                          message:
                              'Seuls les contacts sélectionnés seront mis à jour conformément à la norme du Gouvernement',
                          showDuration: const Duration(seconds: 6),
                          verticalOffset: 25,
                          //padding: EdgeInsets.all(8),
                          child: AppButton(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 50,
                            borderRadius: 20,
                            //backgroundColor: Colors.blue.shade800,
                            border: Border.all(color: Colors.white),
                            backgroundColor: Colors.blue.shade800,
                            onTap: () async {
                              selectedContacts.length == 0
                                  ? showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          icon: Icon(
                                            Icons.mood_bad_sharp,
                                            size: 35,
                                            color: Colors.orange,
                                          ),
                                          title: Text(
                                            "Oups désolé",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          content: Text(
                                              textAlign: TextAlign.center,
                                              "Veuillez sélectionner au moins un contact"),
                                        );
                                      })
                                  : showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            backgroundColor: Colors.white,
                                            child: SizedBox(
                                              height: 340,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 22.0),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'METTRE À JOUR LES CONTACTS SÉLECTIONNÉS',
                                                        style: TextStyle(
                                                            //color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    !isOperating
                                                        ? const SizedBox(
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .emoji_emotions_outlined,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  title: Text(
                                                                    'Nous mettrons à jours tous les numéros béninois des contacts sélectionnés',
                                                                    style: TextStyle(
                                                                        //color: Colors.white,
                                                                        //fontWeight: FontWeight.w900,
                                                                        fontSize: 11),
                                                                  ),
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .emoji_emotions_outlined,
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                                  title: Text(
                                                                    'Tous les numéros modifiés passeront au format +22901XXXXXXXX',
                                                                    style: TextStyle(
                                                                        //color: Colors.white,
                                                                        //fontWeight: FontWeight.w900,
                                                                        fontSize: 11),
                                                                  ),
                                                                ),
                                                                ListTile(
                                                                  leading: Icon(
                                                                    Icons
                                                                        .verified_user_sharp,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  title: Text(
                                                                    'Nous ne toucherons à aucun numéro non béninois',
                                                                    style: TextStyle(
                                                                        //color: Colors.white,
                                                                        //fontWeight: FontWeight.w900,
                                                                        fontSize: 11),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox(
                                                            height: 180,
                                                            child: Expanded(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 100,
                                                                    child: Lottie
                                                                        .asset(
                                                                            'assets/lotties/loading4.json'),
                                                                  ),
                                                                  const Text(
                                                                      "Opération en cours ..."),
                                                                  const Text(
                                                                      "Veuillez patienter ...")
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AppButton(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  isOperating =
                                                                      true;
                                                                });
                                                                await updateContacts(
                                                                    updateAll:
                                                                        false);

                                                                setState(() {
                                                                  isOperating =
                                                                      false;
                                                                  selectedContacts =
                                                                      [];
                                                                });
                                                                //Navigator.pop(context);
                                                              },
                                                              height: 50,
                                                              width: 110,
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade700,
                                                              child: isOperating
                                                                  ? const CupertinoActivityIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : const Text(
                                                                      'CONFIRMER',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w900,
                                                                          fontSize:
                                                                              12.5),
                                                                    )),
                                                          AppButton(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              height: 50,
                                                              width: 110,
                                                              backgroundColor:
                                                                  Colors.red
                                                                      .shade700,
                                                              child: const Text(
                                                                'ANNULER',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        12.5),
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                      });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app_outlined,
                                  color: Colors.white,
                                ),
                                Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13),
                                    'Mise à jour des contacts sélectionnés'),
                              ],
                            ),
                          ),
                        )
                      : Tooltip(
                          message:
                              'Tous vos contacts béninois seront mis à jour conformément à la norme du Gouvernement',
                          showDuration: const Duration(seconds: 6),
                          verticalOffset: 25,
                          child: AppButton(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 50,
                            borderRadius: 20,
                            border: Border.all(color: Colors.white),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: Colors.white,
                                        child: SizedBox(
                                          height: 340,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 22.0),
                                                  child: Text(
                                                    'TOUT METTRE À JOUR',
                                                    style: TextStyle(
                                                        //color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                                !isOperating
                                                    ? const SizedBox(
                                                        height: 190,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .emoji_emotions_outlined,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                              title: Text(
                                                                'Nous mettrons à jours tous les numéros béninois',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                Icons
                                                                    .verified_user_sharp,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              title: Text(
                                                                'Nous ne toucherons à aucun numéro non béninois',
                                                                style: TextStyle(
                                                                    //color: Colors.white,
                                                                    //fontWeight: FontWeight.w900,
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 180,
                                                        child: Expanded(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 100,
                                                                child: Lottie.asset(
                                                                    'assets/lotties/loading4.json'),
                                                              ),
                                                              const Text(
                                                                  "Opération en cours ..."),
                                                              const Text(
                                                                  "Veuillez patienter ...")
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppButton(
                                                          alignment:
                                                              Alignment.center,
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {
                                                              isOperating =
                                                                  true;
                                                            });
                                                            await updateContacts(
                                                                updateAll:
                                                                    true);
                                                            setState(() {
                                                              isOperating =
                                                                  false;
                                                              selectedContacts =
                                                                  [];
                                                            });
                                                            //Navigator.pop(context);
                                                          },
                                                          height: 50,
                                                          width: 110,
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade700,
                                                          child: !isOperating
                                                              ? const Text(
                                                                  'CONFIRMER',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          12.5),
                                                                )
                                                              : const CupertinoActivityIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                      AppButton(
                                                          alignment:
                                                              Alignment.center,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          height: 50,
                                                          width: 110,
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade700,
                                                          child: const Text(
                                                            'ANNULER',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 12.5),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  });
                            },
                            //backgroundColor: Colors.green.shade700,
                            backgroundColor: Colors.orange.shade700,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    'Mise à jour de tous les contacts béninois'),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () async {
                await onpenConfidentialPolicy();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.longestLine,
                  "POLITIQUE DE CONFIDENTIALITÉ",
                  style: TextStyle(
                      color: Colors.blueAccent.shade700,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
