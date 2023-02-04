import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tp_class/models/bellaVote.dart';
import 'package:tp_class/models/chat.dart';
import 'package:tp_class/models/dilemmePost.dart';
import 'package:tp_class/models/top10.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:tp_class/pages/pageAccueil.dart';
import 'package:tp_class/pages/pageAjoutArticle.dart';
import 'package:tp_class/pages/pageChat.dart';
import 'package:tp_class/pages/pageExplore.dart';
import 'package:tp_class/services/database.dart';

import 'pageCompte.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  /* final PageAccueil _pageAccueil = PageAccueil();
  final PageExplorer _pageExplorer = PageExplorer();
  final PageAjoutDilemme _pageAjoutDilemme = PageAjoutDilemme();
  
   */
  final PageAccueil _pageAccueil = PageAccueil();
  final Scaffold _pageExplorer = Scaffold();
  final PageAjoutDilemme _pageAjoutDilemme = PageAjoutDilemme();
final PageCompte _pageCompte = PageCompte();
  Widget _affichePage = PageAccueil();

  Widget _pageSelectionEe(int page){
    switch (page) {
      case 0 :
        return _pageAccueil;
        break;
      /* case 1 :
        return _pageExplorer; */
        break;
      case 1 :
        return _pageAjoutDilemme;
        break;
     /*  case 3 :
        return _pageSearch; */
        break;
      case 2 :
        return _pageCompte;
        break;
        default:
          return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
                  body: _affichePage,
                  backgroundColor : Colors.grey[200],
                  bottomNavigationBar: CurvedNavigationBar(
                    backgroundColor : Colors.transparent,
                    height: 70.0,
                    items: <Widget>[
                      Icon(Icons.home, size: 30.0),
                      //Icon(Icons.explore, size: 30.0),
                      Icon(Icons.add_circle, size: 30.0, color: Colors.green.shade600,),
                    //  Icon(Icons.sms, size: 30.0),
                      Icon(Icons.person, size: 30.0)
                    ],
                    onTap: (int tappedIndex){
                      setState(() {
                        _affichePage = _pageSelectionEe(tappedIndex);
                      });
                    },
                  ),
               
    );
  }
}

