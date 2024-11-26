import 'package:benin_num_auto/pages/infos_page.dart';
import 'package:benin_num_auto/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:lottie/lottie.dart';

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

  /*Future<void> fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permission refusée. Accès aux contacts requis.')),
      );
      return;
    }

    setState(() => isLoading = true); // Démarre le loader

    try {
      final allContacts = await FlutterContacts.getContacts(
        withProperties: true, // Assurez-vous de récupérer les propriétés
        withPhoto: true, // Assurez-vous de récupérer les photos
        withAccounts:
            true, // Gardez cette option pour récupérer les informations sur les comptes associés
      );
      setState(() {
        contacts = allContacts;
        filteredContacts =
            allContacts; // Initialement, tous les contacts sont affichés
      });
    } catch (e) {
      // Affiche un message d'erreur détaillé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la récupération des contacts: $e')),
      );
      print('Erreur lors de la récupération des contacts: $e');
    } finally {
      setState(() => isLoading = false); // Arrête le loader
    }
  }*/
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
          //withPhoto: true,
          withAccounts: true,
          //onlyWithChanges: true, // Charge uniquement les changements
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
  String transformBeninNumber(String number) {
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
  }

  /// FIN : convertion des contacts au format +22901XXXXXXXX

  /// DEBUT : filtrage des contacts
  void filterContacts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      if (letterIndex == 0 && searchQuery != '') {
        filteredContacts = contacts.where((contact) {
          final name = contact.displayName?.toLowerCase() ?? '';
          final phoneNumbers =
              contact.phones.map((phone) => phone.number).join(' ');
          return name.contains(searchQuery) ||
              phoneNumbers.contains(searchQuery);
        }).toList();
      } else if (letterIndex != 0 && searchQuery != '') {
        filteredContacts = filteredContactsByLetter.where((contact) {
          final name = contact.displayName?.toLowerCase() ?? '';
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
          final name = contact.displayName?.toUpperCase() ?? '';
          return name.startsWith(letter.toUpperCase());
        }).toList();
      }
    });
  }

  /// FIN : filtrage des contacts

  /// DEBUT : reconversion des contacts au format XXXXXXXX
  String revertBeninNumber(String number) {
    // Nettoyer le numéro pour enlever les espaces, tirets, parenthèses
    var cleanedNumber = number.replaceAll(RegExp(r'[\s\-\(\)]'), '');

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
      SnackBar(
          backgroundColor: Colors.green.shade700,
          content: Text('Opération réussie')),
    );
    await refreshContacts();
  }

  /*Future<void> updateContactToLocal(Contact contact) async {
    bool updated = false;

    // Parcourir tous les numéros du contact
    for (var phone in contact.phones) {
      final oldNumber = phone.number;
      final newNumber = revertBeninNumber(oldNumber);

      // Mettre à jour uniquement si le numéro a changé
      if (newNumber != oldNumber) {
        phone.number = newNumber;
        updated = true;
      }
    }

    // Sauvegarder les changements si des mises à jour ont été faites
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

  Future<void> updateAllContactsToLocal() async {
    // Demander la permission pour lire et écrire dans les contacts
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission refusée.')),
      );
      return;
    }

    // Charger tous les contacts
    final allContacts = await FlutterContacts.getContacts(withProperties: true);

    // Mettre à jour chaque contact
    for (var contact in allContacts) {
      await updateContactToLocal(contact);
    }

    // Indiquer que tous les contacts ont été mis à jour
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${allContacts.length} contacts mis à jour !')),
    );

    // Rafraîchir les contacts
    await refreshContacts();
  }
*/
/*  Future<void> refreshContacts() async {
    try {
      const platform = MethodChannel('com.example.benin_num_auto');
      await platform.invokeMethod('refreshContacts');
      print("Contacts refreshed successfully!");
    } on PlatformException catch (e) {
      print("Failed to refresh contacts: ${e.message}");
    }
  }*/

  /// FIN : reconversion des contacts au format XXXXXXXX

  int letterIndex = 0;
  int letterIndexTemp = 0;
  bool selectAll = false;

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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InfosPage()));
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
          Row(
            children: [
              Tooltip(
                message: 'Reconvertir vos numéros',
                showDuration: const Duration(seconds: 3),
                verticalOffset: 49,
                child: AppButton(
                  backgroundColor: Colors.grey.shade600,
                  height: 50,
                  width: 50,
                  borderRadius: 30,
                  onTap: () async {
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
                                        padding: EdgeInsets.only(top: 22.0),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'RAMENER TOUS LES CONTACTS MODIFIÉS À L\'ANCIEN FORMAT',
                                          style: TextStyle(
                                              //color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 13),
                                        ),
                                      ),
                                      const ListTile(
                                        leading: Icon(
                                          Icons.emoji_emotions_outlined,
                                          color: Colors.orange,
                                        ),
                                        title: Text(
                                          'Nous ramenerons au format XXXXXXXX tous les numéros béninois des contacts',
                                          style: TextStyle(
                                              //color: Colors.white,
                                              //fontWeight: FontWeight.w900,
                                              fontSize: 11),
                                        ),
                                      ),
                                      const ListTile(
                                        leading: Icon(
                                          Icons.verified_user_sharp,
                                          color: Colors.green,
                                        ),
                                        title: Text(
                                          'Nous ne toucherons qu\'aux numéros modifiés sur notre applications',
                                          style: TextStyle(
                                              //color: Colors.white,
                                              //fontWeight: FontWeight.w900,
                                              fontSize: 11),
                                        ),
                                      ),
                                      const ListTile(
                                        leading: Icon(
                                          Icons.verified_user_sharp,
                                          color: Colors.green,
                                        ),
                                        title: Text(
                                          'Nous ne toucherons à aucun numéro non béninois',
                                          style: TextStyle(
                                              //color: Colors.white,
                                              //fontWeight: FontWeight.w900,
                                              fontSize: 11),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppButton(
                                                alignment: Alignment.center,
                                                onTap: () async {
                                                  await updateContactsToLocal(); // Appelle la fonction de reconversion
                                                  setState(() {
                                                    selectedContacts = [];
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                height: 50,
                                                width: 110,
                                                backgroundColor:
                                                    Colors.green.shade700,
                                                child: const Text(
                                                  'CONFIRMER',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12.5),
                                                )),
                                            AppButton(
                                                alignment: Alignment.center,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                height: 50,
                                                width: 110,
                                                backgroundColor:
                                                    Colors.red.shade700,
                                                child: const Text(
                                                  'ANNULER',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
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
                  child: const Icon(
                    Icons.replay,
                    color: Colors.white,
                  ),
                  //tooltip: 'Reconvertir les numéros sélectionnés',
                ),
              ),
              Expanded(
                child: ListTile(
                  trailing: const Icon(Icons.search_rounded),
                  title: TextField(
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
            ],
          ),
          if (isLoading)
            //const Center(child: CircularProgressIndicator())
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Lottie.asset('assets/lotties/loading.json'),
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
              child: Column(
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

                              filterContactsByLetter(_rechercheLettre[index]);
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
                  selectedContacts.length != 0
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    if (selectedContacts.contains(contact)) {
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
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredContactsByLetter.length,
                                itemBuilder: (context, index) {
                                  final contact =
                                      filteredContactsByLetter[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(contact.displayName?[0] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    title: Text(
                                        contact.displayName ?? 'Nom inconnu'),
                                    subtitle: Text(contact.phones.isNotEmpty
                                        ? contact.phones.first.number
                                        : 'Numéro inconnu'),
                                    trailing: Checkbox(
                                      value: selectedContacts.contains(contact),
                                      onChanged: (isSelected) {
                                        setState(() {
                                          if (isSelected == true) {
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
                            ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Tooltip(
              message:
                  'Seuls les contacts sélectionnés seront mis à jour conformément à la norme du Gouvernement',
              showDuration: const Duration(seconds: 6),
              verticalOffset: 25,
              //padding: EdgeInsets.all(8),
              child: AppButton(
                width: MediaQuery.of(context).size.width / 2.2,
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
                                    fontSize: 18, fontWeight: FontWeight.w900),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 22.0),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            'METTRE À JOUR LES CONTACTS SÉLECTIONNÉS',
                                            style: TextStyle(
                                                //color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 13),
                                          ),
                                        ),
                                        const ListTile(
                                          leading: Icon(
                                            Icons.emoji_emotions_outlined,
                                            color: Colors.orange,
                                          ),
                                          title: Text(
                                            'Nous mettrons à jours tous les numéros béninois des contacts sélectionnés',
                                            style: TextStyle(
                                                //color: Colors.white,
                                                //fontWeight: FontWeight.w900,
                                                fontSize: 11),
                                          ),
                                        ),
                                        const ListTile(
                                          leading: Icon(
                                            Icons.emoji_emotions_outlined,
                                            color: Colors.orange,
                                          ),
                                          title: Text(
                                            'Tous les numéros modifiés passeront au format +22901XXXXXXXX',
                                            style: TextStyle(
                                                //color: Colors.white,
                                                //fontWeight: FontWeight.w900,
                                                fontSize: 11),
                                          ),
                                        ),
                                        const ListTile(
                                          leading: Icon(
                                            Icons.verified_user_sharp,
                                            color: Colors.green,
                                          ),
                                          title: Text(
                                            'Nous ne toucherons à aucun numéro non béninois',
                                            style: TextStyle(
                                                //color: Colors.white,
                                                //fontWeight: FontWeight.w900,
                                                fontSize: 11),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppButton(
                                                  alignment: Alignment.center,
                                                  onTap: () async {
                                                    await updateContacts(
                                                        updateAll: false);
                                                    setState(() {
                                                      selectedContacts = [];
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  height: 50,
                                                  width: 110,
                                                  backgroundColor:
                                                      Colors.green.shade700,
                                                  child: const Text(
                                                    'CONFIRMER',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 12.5),
                                                  )),
                                              AppButton(
                                                  alignment: Alignment.center,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  height: 50,
                                                  width: 110,
                                                  backgroundColor:
                                                      Colors.red.shade700,
                                                  child: const Text(
                                                    'ANNULER',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
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
                child: const Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 12),
                    'Mise à jour des contacts sélectionnés'),
              ),
            ),
            Tooltip(
              message:
                  'Tous vos contacts béninois seront mis à jour conformément à la norme du Gouvernement',
              showDuration: const Duration(seconds: 6),
              verticalOffset: 25,
              child: AppButton(
                width: MediaQuery.of(context).size.width / 2.1,
                border: Border.all(color: Colors.white),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            backgroundColor: Colors.white,
                            child: SizedBox(
                              height: 260,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 22.0),
                                      child: Text(
                                        'TOUT METTRE À JOUR',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 17),
                                      ),
                                    ),
                                    const ListTile(
                                      leading: Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: Colors.orange,
                                      ),
                                      title: Text(
                                        'Nous mettrons à jours tous les numéros béninois',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            //fontWeight: FontWeight.w900,
                                            fontSize: 12),
                                      ),
                                    ),
                                    const ListTile(
                                      leading: Icon(
                                        Icons.verified_user_sharp,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        'Nous ne toucherons à aucun numéro non béninois',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            //fontWeight: FontWeight.w900,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppButton(
                                              alignment: Alignment.center,
                                              onTap: () async {
                                                await updateContacts(
                                                    updateAll: true);
                                                setState(() {
                                                  selectedContacts = [];
                                                });
                                                Navigator.pop(context);
                                              },
                                              height: 50,
                                              width: 110,
                                              backgroundColor:
                                                  Colors.green.shade700,
                                              child: const Text(
                                                'CONFIRMER',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12.5),
                                              )),
                                          AppButton(
                                              alignment: Alignment.center,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              height: 50,
                                              width: 110,
                                              backgroundColor:
                                                  Colors.red.shade700,
                                              child: const Text(
                                                'ANNULER',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
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
                backgroundColor: Colors.blue.shade800,
                child: const Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 12),
                    'Mise à jour de tous les contacts béninois'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Tooltip(
              message: 'Reconvertir vos numéros',
              showDuration: const Duration(seconds: 3),
              verticalOffset: 49,
              child: AppButton(
                backgroundColor: Colors.orange.shade700,
                height: 50,
                width: 50,
                borderRadius: 30,
                onTap: () async {
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
                                      padding: EdgeInsets.only(top: 22.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'RAMENER TOUS LES CONTACTS MODIFIÉS À L\'ANCIEN FORMAT',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13),
                                      ),
                                    ),
                                    const ListTile(
                                      leading: Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: Colors.orange,
                                      ),
                                      title: Text(
                                        'Nous ramenerons au format XXXXXXXX tous les numéros béninois des contacts',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            //fontWeight: FontWeight.w900,
                                            fontSize: 11),
                                      ),
                                    ),
                                    const ListTile(
                                      leading: Icon(
                                        Icons.verified_user_sharp,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        'Nous ne toucherons qu\'aux numéros modifiés sur notre applications',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            //fontWeight: FontWeight.w900,
                                            fontSize: 11),
                                      ),
                                    ),
                                    const ListTile(
                                      leading: Icon(
                                        Icons.verified_user_sharp,
                                        color: Colors.green,
                                      ),
                                      title: Text(
                                        'Nous ne toucherons à aucun numéro non béninois',
                                        style: TextStyle(
                                            //color: Colors.white,
                                            //fontWeight: FontWeight.w900,
                                            fontSize: 11),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppButton(
                                              alignment: Alignment.center,
                                              onTap: () async {
                                                await updateContactsToLocal(); // Appelle la fonction de reconversion
                                                setState(() {
                                                  selectedContacts = [];
                                                });
                                                Navigator.pop(context);
                                              },
                                              height: 50,
                                              width: 110,
                                              backgroundColor:
                                                  Colors.green.shade700,
                                              child: const Text(
                                                'CONFIRMER',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12.5),
                                              )),
                                          AppButton(
                                              alignment: Alignment.center,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              height: 50,
                                              width: 110,
                                              backgroundColor:
                                                  Colors.red.shade700,
                                              child: const Text(
                                                'ANNULER',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
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
                child: const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
                //tooltip: 'Reconvertir les numéros sélectionnés',
              ),
            ),*/
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Actualiser la page',
                  showDuration: const Duration(seconds: 3),
                  verticalOffset: 49,
                  child: AppButton(
                      backgroundColor: Colors.orange.shade700,
                      height: 50,
                      width: 50,
                      borderRadius: 30,
                      onTap: isLoading ? () {} : fetchContacts,
                      child: isLoading
                          ? const CupertinoActivityIndicator(
                              radius: 13.0, // Taille du spinner
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            )),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
