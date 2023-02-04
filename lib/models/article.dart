import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleM {
  String? idPost,image, title, content;
  int? Nbcomments, Nblikes;
  Timestamp? date;
  ArticleM(
      {required this.title,
      required this.content,
      required this.image,
      required this.date,
      required this.idPost,
      required this.Nbcomments,
      required this.Nblikes});
}
