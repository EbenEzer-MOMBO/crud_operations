import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String docId;
  const EditPage({Key? key, required this.docId}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Récupère les données de l'utilisateur à éditer
  void _getUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('utilisateurs').doc(widget.docId).get();

    if (doc.exists) {
      setState(() {
        _nameController.text = doc['nom'];
        _lastNameController.text = doc['prenom'];
        _ageController.text = doc['age'].toString();
        _passwordController.text = doc['mot_de_passe'];
      });
    } else {
      // TODO: Gérer le cas où l'utilisateur n'existe pas
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Édite les données de l'utilisateur
  void _editUser() async {
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    int age = int.parse(_ageController.text.trim());
    String password = _passwordController.text.trim();

    await FirebaseFirestore.instance.collection('utilisateurs').doc(widget.docId).update({
      'nom': name,
      'prenom': lastName,
      'age': age,
      'mot_de_passe': password,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Éditer un utilisateur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nom"),
            TextField(
              controller: _nameController,
            ),
            const SizedBox(height: 20.0),
            const Text("Prénom"),
            TextField(
              controller: _lastNameController,
            ),
            const SizedBox(height: 20.0),
            const Text("Âge"),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            const Text("Mot de passe"),
            TextField(
              controller: _passwordController,
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: _editUser,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
