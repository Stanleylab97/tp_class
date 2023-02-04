import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:tp_class/services/database.dart';

class ServiceAuth {
  BuildContext? context;
  ServiceAuth({this.context});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Utilisateur _utilFromFirebaseUser(User utilisateur) {
    return Utilisateur(idUtil: utilisateur.uid);
  }

  /* Stream<Utilisateur> get utilisateur {
    return _auth.authStateChanges().map((_utilFromFirebaseUser)=>) ; //_auth.onAuthStateChanged.map(_utilFromFirebaseUser);
  } */

 /*  //se connecter avec Google
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      var authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = await _auth.currentUser!();
      assert(user.uid == currentUser.uid);

      await ServiceBDD(idUtil: user.uid)
          .saveUserData(user.displayName, user.email, user.photoUrl);

      return _utilFromFirebaseUser(user);
    } catch (error) {
      print(error);
    }
  }
 */
  //Deconnexion
  Future signOut() async {
    try {
      await googleSignIn.signOut();
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
