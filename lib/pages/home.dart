import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/pages/add.dart';
import 'package:crud_operations/pages/edit.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void affiche() async {
    //ref à la collection
    //CollectionReference utilisateurs = FirebaseFirestore.instance.collection('utilisateurs');

    //obtenir les documents de la collection
    //QuerySnapshot querySnapshot = await utilisateurs.get();

    //affichage avec boucle sur console
    // for (var element in querySnapshot.docs) {
    //   print(element.data());
    // }
  }

  @override
  Widget build(BuildContext context) {
    //ref à la collection
    CollectionReference utilisateurs =
        FirebaseFirestore.instance.collection('utilisateurs');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore test"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //affichage
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const AddPage()));
                },
                child: const Text("Ajouter")),

            //builder données
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('utilisateurs')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Chargement...');
                }

                if (snapshot.data!.size == 0) {
                  return const Text('Aucun utilisateur trouvé');
                }

                //obtenir les documents de la collection
                final List<QueryDocumentSnapshot> documents =
                    snapshot.data!.docs;

                //construire le widget pour chaque élément
                final List<Widget> widgets = documents.map((doc) {
                  return ListTile(
                    title: Text(doc['nom']),
                    subtitle: Text(doc['prenom']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EditPage(docId: doc.id)));
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                await utilisateurs.doc(doc.id).delete();
                              },
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.redAccent,
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList();

                //renvoie la liste avec les widget
                return Expanded(
                  child: ListView(
                    children: widgets,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
