import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tp_class/main.dart';
import 'package:tp_class/pages/accueil.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});
  static String verify = "";

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final countryPicker = const FlCountryCodePicker(favorites: ['BJ']);
  String selectedCountryCode = '+229';
  TextEditingController phoneNumber = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bool isloading = false;

  @override
  void initState() {
    /* if (user != null)
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    else */
    selectedCountryCode = '+229';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser !=null)
          return Accueil();
        else
         return Scaffold(
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
                    "ESGIS Network",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Pour commencer, veuillez enregistrer votre numéro de téléphone!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 70,
                          child: GestureDetector(
                            onTap: () async {
                              final code = await countryPicker.showPicker(
                                  context: context);
                              if (code != null) {
                                setState(() {
                                  selectedCountryCode = code.dialCode;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Text(selectedCountryCode,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          controller: phoneNumber,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Entrez votre téléphone",
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: isloading? Center(child: CircularProgressIndicator(color: Colors.green.shade600,),): ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          try {
                            setState(() {
                                  isloading = true;
                                });
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber:
                                                                                selectedCountryCode + phoneNumber.text,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                setState(() {
                                  isloading = true;
                                });
                                CherryToast.error(
                                title: Text("Erreur"),
                                displayTitle: false,
                                description: Text(
                                    "Le numéro de téléphone est invalide",
                                    style: TextStyle(color: Colors.black)),
                                animationType: AnimationType.fromRight,
                                animationDuration: Duration(milliseconds: 1000),
                                autoDismiss: true)
                            .show(context);
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                PhoneAuth.verify = verificationId;
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.pushNamed(context, 'verify');
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {
                                     setState(() {
                                  isloading = false;
                                });
                                     CherryToast.error(
                                title: Text("Erreur"),
                                displayTitle: false,
                                description: Text(
                                    "Le délai d'attente est dépassé",
                                    style: TextStyle(color: Colors.black)),
                                animationType: AnimationType.fromRight,
                                animationDuration: Duration(milliseconds: 1000),
                                autoDismiss: true)
                            .show(context);
                       
                                  },
                            );
                          } catch (e) {

                            setState(() {
                                  isloading = false;
                                });
                                CherryToast.error(
                                title: Text("Erreur"),
                                displayTitle: false,
                                description: Text(
                                    "Une erreur s'est produite",
                                    style: TextStyle(color: Colors.black)),
                                animationType: AnimationType.fromRight,
                                animationDuration: Duration(milliseconds: 1000),
                                autoDismiss: true)
                            .show(context);
                        print("Une erreur s'est produite - ${e}");
                          }
                        },
                        child: Text("Envoyez le code")),
                  )
                ],
              ),
            ),
          ),
        );
        
      
    
  }
}
