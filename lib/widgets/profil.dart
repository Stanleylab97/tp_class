import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tp_class/models/bellaVote.dart';
import 'package:tp_class/models/dilemmePost.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:tp_class/pages/dilemmePos.dart';
import 'package:tp_class/pages/profil/bellaVotEs.dart';
import 'package:tp_class/services/database.dart';
import 'package:tp_class/widgets/inboxMessage.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilUtilisateur extends StatefulWidget {

  String? idUtil, nomUtil, photoUtil, lastImgUrl, emailUtil;
  int? nbrePost; Timestamp? dateInscription;

  ProfilUtilisateur({this.idUtil, this.nomUtil, this.photoUtil,
    this.lastImgUrl, this.emailUtil, this.nbrePost, this.dateInscription});

  @override
  _ProfilUtilisateurState createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {

  int pagesAffichEe = 0;

  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);
    final dateDeFirestore = widget.dateInscription!.toDate();
    String date = DateFormat.yMMMMd().format(dateDeFirestore);

    _lancerGmail() async {
      String url = 'mailto:${widget.emailUtil}';
      if(await canLaunch(url)){
        await launch(url);
      }else{
        throw 'Impossible d\'envoyer le mail à $url';
      }
    }

    return StreamProvider<List<Dilemme>>.value(
      initialData: [],
      value: ServiceBDD(idUtil: utilisateur.idUtil).listDilemme,
      child: StreamProvider<DonnEesUtil>.value(
        initialData: DonnEesUtil(),
        value: ServiceBDD(idUtil:utilisateur.idUtil).donnEesUtil,
        child: StreamProvider<List<BellaVotEe>>.value(
          initialData: [],
          value: ServiceBDD(idUtil: utilisateur.idUtil).bellasVotEes,
          child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              title: Text(
                'Profil de ${widget.nomUtil}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: <Widget>[
                          Container(
                            height: 265,
                            width: double.infinity,
                            child: Container(
                              decoration:BoxDecoration(
                                  image: DecorationImage(
                                      image: /* widget.lastImgUrl == '' ?  */AssetImage('assets/images/a1.jpeg'),
                                        //  : NetworkImage('${widget.lastImgUrl}'),
                                      fit: BoxFit.cover
                                  )
                              ) ,
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(.9),
                                          Colors.black.withOpacity(.1),
                                        ]
                                    )
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border : Border.all(color: Colors.white, width: 2.0),
                                            image: DecorationImage(
                                                image: NetworkImage('${widget.photoUtil}'),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 10.0,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget.nomUtil!,
                                            style: TextStyle(color: Colors.white, fontSize: 24.0),
                                          ),
                                          Text(
                                            widget.emailUtil!,
                                            maxLines: 1,
                                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                                          ),
                                          Text(
                                            '${widget.nbrePost} posts en dilemme',
                                            maxLines: 1,
                                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                                          ),
                                          Text(
                                            'Membre depuis $date',
                                            maxLines: 1,
                                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            children: <Widget>[
                                              MaterialButton(
                                                child: Text(
                                                  'MESSAGE', style: Theme.of(context)
                                                    .textTheme.button!.copyWith(
                                                    color: Colors.white, letterSpacing: 1.5
                                                ),),
                                                color: Colors.redAccent,
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                                                    idExp: utilisateur.idUtil,
                                                    idDest: widget.idUtil,
                                                    nom: widget.nomUtil,
                                                    imgUrl: widget.photoUtil,
                                                    emailDest: widget.emailUtil,
                                                    nbreMsgNonLis: 0,
                                                  )));
                                                },
                                              ),
                                              SizedBox(width: 10.0,),
                                              MaterialButton(
                                                child: Text(
                                                  'ENVOYER UN EMAIL', style: Theme.of(context)
                                                    .textTheme.button!.copyWith(
                                                    color: Colors.white, letterSpacing: 1.5
                                                ),),
                                                color: Colors.black,
                                                onPressed: _lancerGmail,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DefaultTabController(
                              length: 2,
                              child: TabBar(
                                  labelColor: Colors.red,
                                  onTap: (int tappedIndex){
                                    setState(() {
                                      pagesAffichEe = tappedIndex;
                                    });
                                  },
                                  tabs: <Widget>[
                                    Tab(text: 'Dilemme(s) posté(s)'),
                                    Tab(text: 'Bella(s) votée(s)')
                                  ]
                              )
                          )
                        ],
                      ),
                    ]
                  ),
                ),
                pagesAffichEe==0 ? ListDilemmePostE(idUtil: widget.idUtil)
                    : BellasVotEes(idUtil: widget.idUtil),
              ],
            ),
          ),
        ),
      ),
    );
  }
}