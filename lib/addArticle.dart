import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tp_class/main.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final TextEditingController titre = TextEditingController();
  final TextEditingController contenu = TextEditingController();
  ImagePicker picker = ImagePicker();
  late String errorText = "";
  bool isloading = false;
  bool circular = false;
  var selectedPhoto;
  bool isSeldectedPhoto = false;

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
          //savePhoto(selectedPhoto.path);
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
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Ajout d'article",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: (() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          }),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              children: [
                SizedBox(
                    width: size.width,
                    height: size.height * .3,
                    child: GestureDetector(
                      child: !isSeldectedPhoto
                          ? Container(
                              color: Colors.grey,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    Text("Veuillez choisir une image"),
                                  ],
                                ),
                              ),
                            )
                          : Image.file(
                              selectedPhoto,
                              width: size.width,
                              height: size.height * .3,
                            ),
                      onTap: () {
                        _getFromGallery();
                      },
                    )),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Form(
              child: Column(children: [
                TextFormField(
                  controller: titre,
                  decoration: InputDecoration(
                      label:
                          Text("Titre", style: TextStyle(color: Colors.black)),
                      prefixIcon: Icon(Icons.person)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                TextFormField(
                  maxLines: 10,
                  controller: contenu,
                  decoration: InputDecoration(
                    label:
                        Text("Contenu", style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .028,
                ),
                circular
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.green))
                    : Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.green,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () async {
                            setState(() {
                              circular = true;
                               
                            });
                            await FirebaseFirestore.instance
                                .collection("articles")
                                .add({
                              "title": titre.text,
                              "contenu": contenu.text,
                              "imageUrl":
                                  "https://i0.wp.com/africaglobalnews.com/wp-content/uploads/2019/07/image010.png",
                            }).whenComplete(() {
                              setState(() {
                                circular = false;
                                titre.clear();
                                contenu.clear();
                                isSeldectedPhoto = false;
                              });
                              CherryToast.success(
                                      title: Text(errorText,
                                          style:
                                              TextStyle(color: Colors.black)),
                                      displayTitle: false,
                                      description: Text("Article ajouté",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      animationType: AnimationType.fromRight,
                                      animationDuration:
                                          Duration(milliseconds: 2000),
                                      autoDismiss: true)
                                  .show(context);
                            });
                          },
                          child: Text(
                            "Enregistrer",
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
      ),
    );
  }
}
