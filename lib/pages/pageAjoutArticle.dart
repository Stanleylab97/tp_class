import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:tp_class/services/database.dart';
import 'package:path/path.dart' as p;

class PageAjoutDilemme extends StatefulWidget {
  @override
  _PageAjoutDilemmeState createState() => _PageAjoutDilemmeState();
}

class _PageAjoutDilemmeState extends State<PageAjoutDilemme> {
  final currentUser = Hive.box('settings').get("currentUser") as Map;
  late String errorText = "";
  bool isloading = false;
  bool circular = false;
  var selectedPhoto;
  bool isSeldectedPhoto = false;
  final TextEditingController titre = TextEditingController();
  final TextEditingController contenu = TextEditingController();

  FocusNode focusNode = new FocusNode();

  String nomBella1 = '';
  String nomBella2 = '';
  String? urlImgB1, urlImgB2;
  String? nationalitB1, nationalitB2;
  bool _enProcessus = false;
  File? _fichierSelectionEB1;
  File? _fichierSelectionEB2;

  final _formKey = GlobalKey<FormState>();

  Widget imageBella1() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _fichierSelectionEB1 != null
                ? GestureDetector(
                    onTap: () {
                      obtenirImageBella1(ImageSource.gallery);
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                              image: FileImage(
                            _fichierSelectionEB1!,
                          ))),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      obtenirImageBella1(ImageSource.gallery);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.add_photo_alternate,
                              size: 100,
                              color: Colors.grey[700],
                            ),
                            Text('Image à charger',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: OutlinedButton.icon(
                label: Text(
                  'Camera',
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  obtenirImageBella1(ImageSource.camera);
                },
                //  borderSide: BorderSide(color: Colors.white, width: 2),
                icon: Icon(Icons.add_a_photo, color: Colors.grey[700]),
                /* shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ), */
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageBella2() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _fichierSelectionEB2 != null
                ? GestureDetector(
                    onTap: () {
                      // obtenirImageBella2(ImageSource.gallery);
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                              image: FileImage(
                            _fichierSelectionEB2!,
                          ))),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      // obtenirImageBella2(ImageSource.gallery);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.add_photo_alternate,
                              size: 100,
                              color: Colors.grey[700],
                            ),
                            Text('Photo bella 2',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: OutlinedButton.icon(
                label: Text(
                  'Camera',
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //  obtenirImageBella2(ImageSource.camera);
                },
                // borderSide: BorderSide(color: Colors.white, width: 2),
                icon: Icon(Icons.add_a_photo, color: Colors.grey[700]),
                /* shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ), */
              ),
            ),
          ],
        ),
      ),
    );
  }

  obtenirImageBella1(ImageSource source) async {
    setState(() => _enProcessus = true);
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      CroppedFile? croppE = await ImageCropper.platform.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
                toolbarColor: Colors.white,
                toolbarTitle: 'Rognez l\'image',
                statusBarColor: Colors.white,
                backgroundColor: Colors.black)
          ]);
      setState(() {
        File? x = File(croppE!.path);
        _fichierSelectionEB1 = x;
        _enProcessus = false;
      });
    } else {
      this.setState(() => _enProcessus = false);
    }
  }

  /*  obtenirImageBella2(ImageSource source) async {
    setState(() => _enProcessus = true);
    XFile? image = await ImagePicker.pickImage(source: source);
    if(image != null){
      CroppedFile? croppE = await ImageCropper.platform.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [AndroidUiSettings(
              toolbarColor: Colors.white,
              toolbarTitle: 'Rognez l\'image',
              statusBarColor: Colors.white,
              backgroundColor: Colors.black
          )]
      );
      this.setState((){
       // _fichierSelectionEB2 = croppE;
        _enProcessus = false;
      });
    }else{
      this.setState(() => _enProcessus = false);
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> enregistrerDilemme() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SimpleDialog(
                title: Text('Envoi...'),
                shape: CircleBorder(),
                children: <Widget>[
                  Center(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage('assets/logo.jpg'),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        LinearProgressIndicator()
                      ],
                    ),
                  )
                ],
              ));

      //Eregistrer image bella1 sur Cloud Storage
      Reference? reference =
          FirebaseStorage.instance.ref().child('$nomBella1$nationalitB1.png');
      var uploadTask = reference.putFile(_fichierSelectionEB1!);
      //TaskSnapshot taskSnapshot = await uploadTask.onComplete;
      // this.urlImgB1 = await taskSnapshot.ref.getDownloadURL();

      //la mme chose pour bella B2
      Reference? reference2 =
          FirebaseStorage.instance.ref().child('$nomBella2$nationalitB2');
      var uploadTask2 = reference2.putFile(_fichierSelectionEB2!);
      //TaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
      //this.urlImgB2 = await taskSnapshot2.ref.getDownloadURL();

      ServiceBDD serviceBDD =
          ServiceBDD(idUtil: FirebaseAuth.instance.currentUser?.uid);

      dynamic result = serviceBDD.ajoutPost(
          context,
          nomBella1,
          nationalitB1,
          urlImgB1,
          nomBella2,
          nationalitB2,
          urlImgB2,
          currentUser['username'],
          currentUser['photo'],
          currentUser['phoneNumber']);

      if (result == null) {
        setState(() => _enProcessus = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Oups! Quelque chose s\'est mal passé'),
        ));
      } else {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/accueil');
      }
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Nouvel article',
              style: TextStyle(color: Colors.black),
            ),
            floating: true,
            /*  actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  dynamic statusDeConnexion =
                      await Connectivity().checkConnectivity();
                  if (statusDeConnexion == ConnectivityResult.none) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Verifier votre connexion internet'),
                    ));
                  } else {
                    if ((_formKey.currentState!.validate()) &&
                        (_fichierSelectionEB1 != null) &&
                        (_fichierSelectionEB2 != null) &&
                        (nationalitB1 != null) &&
                        (nationalitB2 != null)) {
                      enregistrerDilemme();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Vous venez fournir correctement '
                            'toutes les informations'),
                      ));
                    }
                  }
                },
                child: Text(
                  'Enregistrer',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                color: Colors.green.shade600,
              )
            ], */
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[imageBella1()],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  controller: titre,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez remplir le champ';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      label: Text("Titre",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      prefixIcon: Icon(Icons.person)),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez remplir le champ';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                      const Radius.circular(10),
                                    )),
                                    hintText: 'Écrivez quelque chose',
                                    labelText: 'Contenu:',
                                  ),
                                  autofocus: false,
                                  focusNode: focusNode,
                                  maxLines: null,
                                  controller: contenu,
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .028,
                                ),
                                circular
                                    ? Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.green))
                                    : Container(
                                        height: size.height * 0.08,
                                        width: size.width * 0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.green,
                                        ),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green.shade600)),
                                          onPressed: () async {
                                            setState(() {
                                              circular = true;
                                              _enProcessus = true;
                                            });

                                            if (_formKey.currentState!
                                                    .validate() &&
                                                (_fichierSelectionEB1 !=
                                                    null)) {
                                              var storage = FirebaseStorage
                                                  .instance
                                                  .ref();

                                              TaskSnapshot taskSnapshot =
                                                  await storage
                                                      .child(
                                                          'articles/${Timestamp.now().millisecondsSinceEpoch}.${p.extension(_fichierSelectionEB1!.path)}')
                                                      .putFile(
                                                          _fichierSelectionEB1!);
                                              final String downloadUrl =
                                                  await taskSnapshot.ref
                                                      .getDownloadURL();
                                              await FirebaseFirestore.instance
                                                  .collection("articles")
                                                  .add({
                                                "author":
                                                    currentUser['username'],
                                                "uid": FirebaseAuth.instance
                                                    .currentUser?.phoneNumber,
                                                "title": titre.text,
                                                "content": contenu.text,
                                                "image": downloadUrl,
                                                "createdAt": Timestamp.now(),
                                                "Nbcomments":0,
                                                "Nblikes":0
                                              }).then((value) {
                                                CherryToast.success(
                                                        title: Text("Succès"),
                                                        displayTitle: false,
                                                        description: Text(
                                                            "Article ajouté avec succès",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        animationType:
                                                            AnimationType
                                                                .fromRight,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        autoDismiss: true)
                                                    .show(context);

                                                setState(() {
                                                  circular = false;
                                                  _enProcessus = false;
                                                });
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        'home',
                                                        (route) => false);
                                              }).onError((error, stackTrace) {
                                                CherryToast.error(
                                                        title: Text("Erreur"),
                                                        displayTitle: false,
                                                        description: Text(
                                                            "L'enregistrement n'a pas aboutie ${error}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        animationType:
                                                            AnimationType
                                                                .fromRight,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        autoDismiss: true)
                                                    .show(context);
                                              });
                                            } else {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                await FirebaseFirestore.instance
                                                    .collection("articles")
                                                    .add({
                                                  "author":
                                                      currentUser['username'],
                                                  "uid": FirebaseAuth.instance
                                                      .currentUser?.phoneNumber,
                                                  "title": titre.text,
                                                  "content": contenu.text,
                                                  "image": "",
                                                  "createdAt": Timestamp.now(),
                                                       "Nbcomments":0,
                                                "Nblikes":0
                                                }).then((value) {
                                                  CherryToast.success(
                                                          title: Text("Succès"),
                                                          displayTitle: false,
                                                          description: Text(
                                                              "Article ajouté avec succès",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                          animationType:
                                                              AnimationType
                                                                  .fromRight,
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          autoDismiss: true)
                                                      .show(context);

                                                  setState(() {
                                                    circular = false;
                                                    _enProcessus = false;
                                                  });
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          'home',
                                                          (route) => false);
                                                }).onError((error, stackTrace) {
                                                  _enProcessus = false;
                                                  CherryToast.error(
                                                          title: Text("Erreur"),
                                                          displayTitle: false,
                                                          description: Text(
                                                              "L'enregistrement n'a pas aboutie ${error}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                          animationType:
                                                              AnimationType
                                                                  .fromRight,
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          autoDismiss: true)
                                                      .show(context);
                                                });
                                              } else {
                                                setState(() {
                                                  _enProcessus = false;
                                                  circular = false;
                                                });

                                                CherryToast.error(
                                                        title: Text("Erreur"),
                                                        displayTitle: false,
                                                        description: Text(
                                                            "Veuillez compléter les informations manquantes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        animationType:
                                                            AnimationType
                                                                .fromRight,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        autoDismiss: true)
                                                    .show(context);
                                              }
                                            }
                                          },
                                          child: Text(
                                            "Enregistrer",
                                            style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    height: 1.5)
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                      ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                  (_enProcessus)
                      ? Container(
                          color: Colors.grey[200],
                          height: MediaQuery.of(context).size.height * 0.95,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container()
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
