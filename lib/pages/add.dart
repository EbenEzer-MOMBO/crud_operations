import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget{
  const AddPage({super.key});

  //ajout dans la collection
  Future<void> ajouter(String nom, String prenom, int age, String password) async{
    try{

      //ref à la collection utilisateurs
      final utilisateurs = FirebaseFirestore.instance.collection('utilisateurs');

      //data to insert
      await utilisateurs.add({
        'nom': nom,
        'prenom' : prenom,
        'age' : age,
        'mot_de_passe' : password,
      });
    } catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    //init variables
    String nom = '';
    String prenom = '';
    int age = 0;
    String password = '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text("Ajouter un utilisateur"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("nom"),
            TextField(
              onChanged: (value){
                nom = value;
              },
            ),

            const Text("prénom"),
            TextField(
              onChanged: (value){
                prenom = value;
              },
            ),

            const Text("âge"),
            TextField(
              onChanged: (value){
                age = int.parse(value);
              },
            ),

            const Text("mot de passe"),
            TextField(
              onChanged: (value){
                password = value;
              },
            ),

            Row(
              children: [
                ElevatedButton(onPressed: (){
                  ajouter(nom, prenom, age, password);
                  Navigator.pop(context);
                }, child: const Text("Valider"))
              ],
            ),
          ],
        ),
      ),
    );
  }

}