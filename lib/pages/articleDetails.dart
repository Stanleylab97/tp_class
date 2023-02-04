import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tp_class/services/database.dart';

class ArticleDetails extends StatefulWidget {
  String? idPost;
  ArticleDetails({super.key, this.idPost});

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  int n=0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // here the desired height
            child: AppBar(
              leading: Icon(Icons.arrow_back_ios, color: Colors.black,),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "$n commentaires",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            )),
        body: StreamBuilder<QuerySnapshot>(
            stream: ServiceBDD()
                .collectionPosts
                .doc(widget.idPost)
                .collection("commentaires")
                .snapshots(),
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
                    n++;
                    return ListTile(
                      leading: SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              errorWidget: (context, _, __) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/user.png'),
                              ),
                              imageUrl: snapshot.data?.docs[index]['imgUrl'],
                              placeholder: (context, url) => Image(
                                fit: BoxFit.cover,
                                image: const AssetImage(
                                  'assets/images/user.png',
                                ),
                              ),
                            )),
                      ),
                      title: Text(snapshot.data?.docs[index]['nomUser']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(snapshot.data?.docs[index]['msgCmtr']),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Il y a 2 jours"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.heart,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "7",
                                  style: TextStyle(fontSize: 10),
                                )
                              ],
                            )
                          ],
                        )
                      ]),
                    );
                  });
            }));
  }
}
