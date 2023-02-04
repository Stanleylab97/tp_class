import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:tp_class/models/article.dart';
import 'package:intl/intl.dart';
import 'package:tp_class/pages/articleDetails.dart';
import 'package:tp_class/services/database.dart';

class ArticleCard extends StatelessWidget {
  ArticleM article;
  ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    var date = article.date!.toDate();
    TextEditingController messageController = TextEditingController();
    final currentUser = Hive.box('settings').get("currentUser") as Map;

    var output1 = DateFormat('dd/MM').format(date); // 12/31, 1
    return Column(
      children: [
        Card(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(.3)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: article.image == ""
                        ? SizedBox()
                        : CachedNetworkImage(imageUrl: article.image!),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 24, bottom: 13),
                    child: Text(
                      this.article.title!,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.8)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      article.content!,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context, MaterialPageRoute(builder: (context)=>ArticleDetails(idPost: article.idPost,)));
                                },
                                child: Icon(
                                  FontAwesomeIcons.comment,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${article.Nbcomments}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                FontAwesomeIcons.heart,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${article.Nblikes}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_month,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "${output1}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            
                                            contentPadding: EdgeInsets.only(
                                                left: 16.0, bottom: 6.0),
                                            hintText: "Tapez un commentaire",
                                            border:  OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                      const Radius.circular(10),
                                    )),
                                          ),
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          controller: messageController,
                                        ),
                                      ),
                                      Container(
                                          height: 30.0,
                                          width: 30.0,
                                          margin: EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.send,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              await ServiceBDD()
                                                  .ajoutCommentaire(
                                                      article.idPost,
                                                      currentUser['username'],
                                                      currentUser['photo'],
                                                      article.idPost,
                                                      messageController.text);
                                              await FirebaseFirestore.instance
                                                  .collection("articles")
                                                  .doc(article.idPost)
                                                  .update({
                                                "Nbcomments":
                                                    FieldValue.increment(1)
                                              });
                                              messageController.clear();
                                            },
                                          )),
                                    ],
                                  ),
                              

          ],
        )),
      ],
    );
  }
}
