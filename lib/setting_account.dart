import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

class SettingUser extends StatefulWidget {
  const SettingUser({super.key});

  @override
  State<SettingUser> createState() => _SettingUserState();
}

class _SettingUserState extends State<SettingUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController nom = TextEditingController();
  final TextEditingController prenom = TextEditingController();
  final TextEditingController username = TextEditingController();

  TextEditingController pays = TextEditingController();

  bool validate = false;
  Logger log = Logger();
  late String errorText = "";
  bool isloading = false;
  bool circular = false;
  String? photoUrl;
  //final currentUser = Hive.box('settings').get("currentUser") as Map;
  var selectedPhoto;
  ImagePicker picker = ImagePicker();
  bool isSeldectedPhoto = false;

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  uploadUserDataToFirebase(
      File? file, String username, String nom, String prenom) async {
    var storage = FirebaseStorage.instance.ref();

if(file==null){
 await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      "photoUrl": "",
      "phoneNumber": FirebaseAuth.instance.currentUser?.phoneNumber,
      "username": username,
      "nom": nom,
      "prenom": prenom,
    }).then((value) {
      final x = {
        "username": username,
        "nom": nom,
        "prenom": prenom,
        "photo": "",
         "phoneNumber": FirebaseAuth.instance.currentUser?.phoneNumber,
      };

      Hive.box('settings').put('currentUser', x);
      CherryToast.success(
              title: Text("Succès"),
              displayTitle: false,
              description: Text("Votre profil a été mis à jour",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
            setState(() {
                            circular = false;
                          });
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }).onError((error, stackTrace) {
      CherryToast.error(
              title: Text("Erreur"),
              displayTitle: false,
              description: Text("L'enregistrement n'a pas aboutie ${error}",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    });
}
else{
TaskSnapshot taskSnapshot =
        await storage.child('usersProfiles/${Timestamp.now().millisecondsSinceEpoch}.${p.extension(file.path)}').putFile(file);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
     await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      "photoUrl": downloadUrl,
      "phoneNumber": FirebaseAuth.instance.currentUser?.phoneNumber,
      "username": username,
      "nom": nom,
      "prenom": prenom,
    }).then((value) {
      final x = {
        "username": username,
        "nom": nom,
        "prenom": prenom,
        "photo": downloadUrl,
         "phoneNumber": FirebaseAuth.instance.currentUser?.phoneNumber,
      };

      Hive.box('settings').put('currentUser', x);
      CherryToast.success(
              title: Text("Succès"),
              displayTitle: false,
              description: Text("Votre profil a été mis à jour",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
            setState(() {
                            circular = false;
                          });
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }).onError((error, stackTrace) {
      CherryToast.error(
              title: Text("Erreur"),
              displayTitle: false,
              description: Text("L'enregistrement n'a pas aboutie ${error}",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    });
}

    

   
  }

  _getFromGallery() async {
    try {
      XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: MediaQuery.of(context).size.height * .3,
          maxWidth: MediaQuery.of(context).size.height * .6);

      if (pickedFile != null) {
        // File imageFile = File(pickedFile.path);
        setState(() {
          selectedPhoto = File(pickedFile.path);
          isSeldectedPhoto = true;
          print("Section photo ${selectedPhoto.path}");
        });
      }
    } catch (e) {
      CherryToast.error(
              title: Text("La selection de photo n'a pas aboutie"),
              displayTitle: false,
              description: Text("La selection de photo n'a pas aboutie ${e}",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Profil',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(top: 8, right: 8, left: 8),
        child: Column(children: [
          Stack(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: !isSeldectedPhoto
                      ? Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/user.png',
                          ),
                        )
                      : Image(
                          fit: BoxFit.cover, image: FileImage(selectedPhoto)),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _getFromGallery();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .13,
                      height: MediaQuery.of(context).size.width * .13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green.shade600),
                      child: Icon(
                        FontAwesomeIcons.pencil,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ))
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .1),
          Form(
            child: Column(children: [
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                    label: Text("Nom d'utilisateur",
                        style: TextStyle(color: Colors.black)),
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              TextFormField(
                controller: nom,
                decoration: InputDecoration(
                    label: Text("Nom", style: TextStyle(color: Colors.black)),
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              TextFormField(
                controller: prenom,
                decoration: InputDecoration(
                    label:
                        Text("Prénom", style: TextStyle(color: Colors.black)),
                    prefixIcon: Icon(Icons.person_outline_rounded)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .028,
              ),
              circular
                  ? Center(
                      child: CircularProgressIndicator(
                          color: Colors.green.shade600))
                  : Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black,
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade600)),
                        onPressed: () async {
                          setState(() {
                            circular = true;
                          });
                          try {
                            DataConnectionStatus status = await isConnected();
                            if (status == DataConnectionStatus.connected) {
                              uploadUserDataToFirebase(selectedPhoto,
                                  username.text, nom.text, prenom.text);
                                    setState(() {
                            circular = false;
                          });
                            } else {
                                setState(() {
                            circular = false;
                          });
                              CherryToast.error(
                                      title: Text("Erreur"),
                                      displayTitle: false,
                                      description: Text(
                                          "Vérifies ta connexion internet",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      animationType: AnimationType.fromRight,
                                      animationDuration:
                                          Duration(milliseconds: 1000),
                                      autoDismiss: true)
                                  .show(context);
                            }
                          } catch (e) {
                             setState(() {
                            circular = false;
                          });
                            CherryToast.error(
                                    title: Text("Erreur"),
                                    displayTitle: false,
                                    description: Text(
                                        "Vérifies ta connexion internet",
                                        style: TextStyle(color: Colors.black)),
                                    animationType: AnimationType.fromRight,
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    autoDismiss: true)
                                .show(context);
                            print("An error occured $e");
                          }
                        },
                        child: Text(
                          "Compléter le profil",
                          style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  height: 1.5)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ]),
          )
        ]),
      )),
    );
  }
}
