import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tp_class/models/article.dart';

class ArticleCard extends StatelessWidget {
  ArticleM article;
   ArticleCard({super.key,  required this.article});

  @override
  Widget build(BuildContext context) {
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
                          padding: const EdgeInsets.only(left:8.0, right: 8.0),
                          child: Image.asset(
                            this.article.image!,
                            fit: BoxFit.cover,
                          ),
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
                          child: Text(article.content!,style: TextStyle(fontWeight: FontWeight.normal),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.calendar_month,),
                                  SizedBox(width: 4,),
                                  Text("Rédigé le ${article.date}",style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                             
                                ],
                              ))
                            ],
                          ),
                        ),
                       
                      ],
                    )),
                    Divider(color: Colors.black,)
      ],
    )
        
    ;
  }
}