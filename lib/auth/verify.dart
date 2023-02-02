import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:pinput/pinput.dart';
import 'package:tp_class/auth/login.dart';
import 'package:cherry_toast/cherry_toast.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/img1.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Vérification OTP",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Veuillez entrer le code que nous vous avons envoyé pour confirmer votre identité !",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
                onCompleted: ((value) async {
                  setState(() {
                    isloading = true;
                  });
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: PhoneAuth.verify, smsCode: code);
                    
                    await auth.signInWithCredential(credential);
                    setState(() {
                      isloading = false;
                    });
                     print('Login successed');
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        Map<String, dynamic> data =
                            documentSnapshot.data()! as Map<String, dynamic>;

                        final x = {
                          "username": data['username'],
                          "nom": data['nom'],
                          "prenom": data['prenom'],
                          "photo": data['photoUrl'],
                          "phoneNumber":
                              FirebaseAuth.instance.currentUser?.phoneNumber,
                        };

                        Hive.box('settings').put('currentUser', x);
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'home', (route) => false);
                      } else {
                        print('Il va s\'enregistrer');
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'fill_profile', (route) => false);
                      }
                    }).onError((error, stackTrace) {
                       print('Firebase ref unreadable');
                    }); 
                  } catch (e) {
                    CherryToast.error(
                            title: Text("Erreur"),
                            displayTitle: false,
                            description: Text("Code OTP incorrecte",
                                style: TextStyle(color: Colors.black)),
                            animationType: AnimationType.fromRight,
                            animationDuration: Duration(milliseconds: 1000),
                            autoDismiss: true)
                        .show(context);
                    print("Une erreur s'est produite - ${e}");
                    setState(() {
                      isloading = false;
                    });
                  }
                }),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: isloading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.green.shade600,
                      ))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: PhoneAuth.verify,
                                    smsCode: code);
                            // Sign the user in (or link) with the credential
                            await auth.signInWithCredential(credential);
                            setState(() {
                              isloading = false;
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(auth.currentUser!.uid)
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                Map<String, dynamic> data = documentSnapshot
                                    .data()! as Map<String, dynamic>;

                                final x = {
                                  "username": data['username'],
                                  "nom": data['nom'],
                                  "prenom": data['prenom'],
                                  "photo": data['photoUrl'],
                                  "phoneNumber": FirebaseAuth
                                      .instance.currentUser?.phoneNumber,
                                };

                                Hive.box('settings').put('currentUser', x);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'home', (route) => false);
                              } else {
                                print('Il va s\'enregistrer');
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'fill_profile', (route) => false);
                              }
                            });
                          } catch (e) {
                            CherryToast.error(
                                    title: Text("Erreur"),
                                    displayTitle: false,
                                    description: Text("Code OTP incorrecte",
                                        style: TextStyle(color: Colors.black)),
                                    animationType: AnimationType.fromRight,
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    autoDismiss: true)
                                .show(context);
                            print("Une erreur s'est produite - ${e}");
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        child: Text("Confirmation")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Modifier le numéro ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
