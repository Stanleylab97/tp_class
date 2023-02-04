import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:tp_class/models/article.dart';
import 'package:tp_class/widgets/listDilemmes.dart';
import 'package:tp_class/widgets/listUtilisateurs.dart';

import '../widgets/articleCard.dart';

class PageAccueil extends StatefulWidget {
  @override
  _PageAccueilState createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Hive.box('settings').get("currentUser") as Map;
    Stream<QuerySnapshot> _articlesStream =
        FirebaseFirestore.instance.collection('articles').snapshots();

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (context, _, __) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/user.png'),
                    ),
                    imageUrl: currentUser['photo'],
                    placeholder: (context, url) => Image(
                      fit: BoxFit.cover,
                      image: const AssetImage(
                        'assets/images/user.png',
                      ),
                    ),
                  )),
            ),
          ),
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'ESGIS',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: ' NETWORK',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w900,
                ),
              )
            ]),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 25,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                size: 25,
                color: Colors.black,
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _articlesStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }

            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return ArticleCard(
                    article: ArticleM(
                      idPost: snapshot.data?.docs[index].id,
                        title: snapshot.data?.docs[index]['title'],
                        content:
                            snapshot.data?.docs[index]['content'],
                        image: snapshot.data?.docs[index]['image'], 
                        Nbcomments:snapshot.data?.docs[index]['Nbcomments'],
                        Nblikes: snapshot.data?.docs[index]['Nblikes'],
                        date: snapshot.data?.docs[index]['createdAt']),
                  );

                 
                });
          },
        ));
  }
}
