import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tp_class/models/bellaVote.dart';
import 'package:tp_class/models/chat.dart';
import 'package:tp_class/models/commentaire.dart';
import 'package:tp_class/models/dilemmePost.dart';
import 'package:tp_class/models/message.dart';
import 'package:tp_class/models/top10.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:tp_class/models/vote.dart';

class ServiceBDD {
  String? idUtil, idPost, idExp, idDest, idMsg, idCmtr;
  ServiceBDD({ this.idUtil, this.idPost, this.idExp,
    this.idDest, this.idMsg, this.idCmtr });

  //collection de reference Utilisateur
  final CollectionReference collectionUtilisateurs = FirebaseFirestore.instance.collection('utilisateurs');

  //collection de posts
  final CollectionReference collectionPosts = FirebaseFirestore.instance.collection('articles');

  //collection pour le top10
  final CollectionReference collectionTop10 = FirebaseFirestore.instance.collection('top10');

  //query de dilemme
  final Query queryDilemme = FirebaseFirestore.instance.collection('posts')
      .orderBy('timestamp', descending: true);

  //query utilisateurs
  final Query queryUilisateurs = FirebaseFirestore.instance.collection('utilisateurs')
      .orderBy('nbrePost', descending: true);

  //query Top10
  final Query queryTop10 = FirebaseFirestore.instance.collection('top10')
      .orderBy('nbreVoteBella', descending: true).limit(10);

  //query toutes les bellas votées
  final Query queryBellaVotEe = FirebaseFirestore.instance.collection('top10')
      .orderBy('nbreVoteBella', descending: true);

  //collection chat
  final CollectionReference collectionRoom = FirebaseFirestore.instance.collection('rooms');

  //methode pour enregister un nouveau utilisateur
  Future<void> saveUserData(nomUtil, emailUtil, photoUrl) async {
    try {
      DocumentReference docReference = collectionUtilisateurs.doc(
          idUtil);
      docReference.snapshots().listen((doc) async {
        if (doc.exists) {
          return null;
        } else {
          return await collectionUtilisateurs.doc(idUtil).set({
            'idUtil': idUtil,
            'nomUtil': nomUtil,
            'emailUtil': emailUtil,
            'photoUrl': photoUrl,
            'nbrePost': 0,
            'lastImgPost': '',
            'dateInscription': FieldValue.serverTimestamp()
          });
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }
  //methode pour fetching les donées utilisateurs
  DonnEesUtil _donnEesUtilFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return DonnEesUtil(
      idUtil: data['idUtil'],
      nomUtil: data['nomUtil'],
      emailUtil: data['emailUtil'],
      photoUrl: data['photoUrl'],
      nbrePost: data['nbrePost'],
      lastImgPost: data['lastImgPost'],
      dateInscription: data['dateInscription']
    );
  }

  Stream<DonnEesUtil> get donnEesUtil {
    return collectionUtilisateurs.doc(idUtil).snapshots()
    .map(_donnEesUtilFromSnapshot);
  }

  //list de tous les utilisateurs from snapshot
  List<DonnEesUtil> _listUtilFromSnapshot(QuerySnapshot snapshot){

    return snapshot.docs.map((doc){
                            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return DonnEesUtil(
          idUtil: data['idUtil'],
          nomUtil: data['nomUtil'],
          emailUtil: data['emailUtil'],
          photoUrl: data['photoUrl'],
          nbrePost: data['nbrePost'],
          lastImgPost: data['lastImgPost'],
          dateInscription: data['dateInscription']
      );
    }).toList();
  }

  //obtention des utilisateurs en stream
  Stream<List<DonnEesUtil>> get listDesUtils {
    return queryUilisateurs.snapshots()
    .map(_listUtilFromSnapshot);
  }

  //methode pour ajouter un dilemme
  Future<void> ajoutPost(context, nomB1, nationalitB1, imgB1, nomB2, nationalitB2, imgB2,
      nomUtil, imgUtil, emailUtil) async {
    try{

      Random radom = Random();
      int idBella1 = radom.nextInt(1000);
      int idBella2 = radom.nextInt(1000);
      String idPost = collectionPosts.doc().id;

      await collectionUtilisateurs.doc(idUtil).update({
        'nbrePost' : FieldValue.increment(1),
        'lastImgPost' : imgB1,
      });

      return await collectionPosts.doc(idPost).set({
        'bella1' :{
          'idB1' : idBella1,
          'nomB1': nomB1,
          'nationalitB1' : nationalitB1,
          'imgB1':imgB1
        },
        'bella2' :{
          'idB2' : idBella2,
          'nomB2' : nomB2,
          'nationalitB2': nationalitB2,
          'imgB2' : imgB2
        },
        'utilisateur':{
          'idUtil':idUtil,
          'nomUtil':nomUtil,
          'emailUtil':emailUtil,
          'imgUtil' : imgUtil
        },
        'idPost' :idPost,
        'nbreVoteB1': 0,
        'nbreVoteB2' : 0,
        'totalVotePost' : 0,
        'timestamp': FieldValue.serverTimestamp()
      });
    }catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oups! Quelque chose s\'est passé ${error.toString()}'),
        )
      );
    }
  }

  //list des dilemmes from snapshot
  List<Dilemme> _dilemmeListOfSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return Dilemme(
        totalVote: data['totalVotePost'] ?? 0,
        nbreVoteB1: data['nbreVoteB1'] ?? 0,
        nbreVoteB2: data['nbreVoteB2']?? 0,
        timestamp: data['timestamp'] ?? '',
        bella1: data['bella1'] ?? {},
        bella2: data['bella2'] ?? {},
        idPost: data['idPost'] ?? '',
        utilisateur: data['utilisateur'] ?? {},
      );
    }).toList();
  }

  //get dilemme en streaming
  Stream<List<Dilemme>> get listDilemme{
    return queryDilemme.snapshots().map(_dilemmeListOfSnapshot);
  }

  Future onVoteB1(idPost, idUser, nomUser, idBella, nomBella, nationalit, imgBella) async {
    try{
      final DocumentReference docummentReference = collectionTop10.doc(idBella.toString());
      docummentReference.get().then((ds) async {
        if(ds.exists){
          await collectionPosts.doc(idPost).update({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.doc(idPost).collection('votes')
              .doc(idUser).set({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.doc(idBella.toString()).update({
            'nbreVoteBella' : FieldValue.increment(1)
          });
        }else{
          await collectionPosts.doc(idPost).update({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.doc(idPost).collection('votes')
              .doc(idUser).set({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.doc(idBella.toString()).set({
            'idBella' : idBella,
            'nomBella': nomBella,
            'nationalitBella' : nationalit,
            'imgBella' : imgBella,
            'nbreVoteBella' : 1,
            'idUser' : idUser
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

  Future onVoteB2(idPost, idUser, nomUser, idBella, nomBella, nationalit, imgBella) async {
    try{
      final DocumentReference docummentReference = collectionTop10.doc(idBella.toString());
      docummentReference.get().then((ds) async {
        if(ds.exists){
          await collectionPosts.doc(idPost).update({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.doc(idPost).collection('votes')
              .doc(idUser).set({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.doc(idBella.toString()).update({
            'nbreVoteBella' : FieldValue.increment(1)
          });
        }else{
          await collectionPosts.doc(idPost).update({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost' : FieldValue.increment(1),
          });
          await collectionPosts.doc(idPost).collection('votes')
              .doc(idUser).set({
            'idVoteUtil' : idUser,
            'idPost' : idPost,
            'nomBella' : nomBella,
            'nationalite' : nationalit,
            'nomUtil' : nomUser
          });
          return await collectionTop10.doc(idBella.toString()).set({
            'idBella' : idBella,
            'nomBella': nomBella,
            'nationalitBella' : nationalit,
            'imgBella' : imgBella,
            'nbreVoteBella' : 1,
            'idUser' : idUser
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

 

  List<Top10> queryTop10FromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return Top10(
          idBella: data['idBella'] ?? 0,
          nomBella: data['nomBella'] ?? '',
          nationalitBella:data['nationalitBella'] ?? '',
          imgBella: data['imgBella'],
          nbreVoteBela: data['nbreVoteBella'],
          idUser: data['idUser'],
      );
    }).toList();
  }

 //Stream de toutes les bellas votées
  Stream<List<BellaVotEe>> get bellasVotEes{
    return queryBellaVotEe.snapshots().map(queryBellaVotEeFromSnapshot);
  }

  Future<void> suppressionDilemme(idPost, idUser, context) async {
    try{
      await collectionUtilisateurs.doc(idUser).update({
        'nbrePost' : FieldValue.increment(-1),
      });
      return await collectionPosts.doc(idPost).delete();
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oups! quelque chose s\'est mal passé'),
        )
      );
    }
  }
Vote _voteFromSnapShop(DocumentSnapshot doc){
    return Vote(
        idUtilVote: doc['idVoteUtil'] ?? '',
        idPostVote: doc['idPost'] ?? '',
        nomBvotE: doc['nomBella'] ??'',
        natBvtE: doc['nationalite'] ?? '',
        nomUtil: doc['nomUtil'] ?? ''
    );
  }

 Stream<Vote> get voteData  {
    return collectionPosts.doc(idPost)
        .collection('votes').doc(idUtil)
        .snapshots().map(_voteFromSnapShop);
  }
  //strem pour le auery de top10
  Stream<List<Top10>> get top10data{
    return queryTop10.snapshots().map(queryTop10FromSnapshot);
  }

  List<BellaVotEe> queryBellaVotEeFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return BellaVotEe(
        idBella: data['idBella'],
        nomBella: data['nomBella'],
        nationalitBella:data['nationalitBella'],
        imgBella: data['imgBella'],
        nbreVoteBela: data['nbreVoteBella'],
        idUser: data['idUser'],
      );
    }).toList();
  }

  

  //créer une nvlle discussion
  Future<void> envoyezMsg (nomExp, emailExp, imgUrlExp, idExp, idDest, nomDest, emailDest,
      imgUrlDest, msgTxt, msgImage)async {
    try{
      String idMonChat = '$idExp$idDest';
      String idSonChat = '$idDest$idExp';
      String idMessage = collectionRoom.doc().id;

      DocumentReference docChat = collectionRoom.doc(idExp)
          .collection('chats').doc(idMonChat);

      docChat.get().then((doc) async {
        if(doc.exists){

          await collectionRoom.doc(idExp).collection('chats')
              .doc(idMonChat).update({
            'nbreMsgNonLis' : FieldValue.increment(1),
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
          });

          await collectionRoom.doc(idDest).collection('chats')
              .doc(idSonChat).update({
            'nbreMsgNonLis' : FieldValue.increment(1),
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
          });

          await collectionRoom.doc(idDest)
              .collection('chats').doc(idSonChat).collection('messages')
              .doc(idMessage).set({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });

          return await collectionRoom.doc(idExp)
              .collection('chats').doc(idMonChat).collection('messages')
              .doc(idMessage).set({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });

        }else{

          await collectionRoom.doc(idDest).collection('chats').doc(idSonChat).set({
            'nbreMsgNonLis' : 1,
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
            'exp' : {
              'idExp' : idExp,
              'nomExp' : nomExp,
              'emailExp' : emailExp,
              'imgUrlExp' : imgUrlExp,
            },
            'dest' : {
              'idDest':idDest,
              'emailDest' : emailDest,
              'nomDest' : nomDest,
              'imgUrlDest' : imgUrlDest
            }
          });

          await collectionRoom.doc(idExp).collection('chats').doc(idMonChat).set({
            'nbreMsgNonLis' : 1,
            'msgTxt' : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp(),
            'exp' : {
              'idExp' : idExp,
              'nomExp' : nomExp,
              'emailExp' : emailExp,
              'imgUrlExp' : imgUrlExp,
            },
            'dest' : {
              'idDest':idDest,
              'emailDest' : emailDest,
              'nomDest' : nomDest,
              'imgUrlDest' : imgUrlDest
            }
          });

          await collectionRoom.doc(idDest)
              .collection('chats').doc(idSonChat).collection('messages')
              .doc(idMessage).set({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });
          return await collectionRoom.doc(idExp)
              .collection('chats').doc(idMonChat).collection('messages')
              .doc(idMessage).set({
            'idMsg': idMessage,
            'idExp' : idExp,
            'idDest' : idDest,
            'msgTxt'  : msgTxt,
            'msgImage' : msgImage,
            'timestamp' : FieldValue.serverTimestamp()
          });
        }
      });
    }catch (error){
      print(error.toString());
    }
  }

  List<Chat> listChatFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return Chat(
          msg : data['msgTxt'],
          msgImage: data['msgImage'],
          nbreMsgNonLis : data['nbreMsgNonLis'],
          timestamp : data['timestamp'],
          exp : data['exp'],
          dest : data['dest'],
       );
    }).toList();
  }

  Stream<List<Chat>> get chats {
    //query chats
    final Query querychat = collectionRoom.doc(idExp)
        .collection('chats').orderBy('timestamp', descending: true);
    return querychat.snapshots().map(listChatFromSnapShot);
  }

  //liste des messages issus d'un chat specifique
  List<Message> listMessageFromSnapShot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
                      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

      return Message(
        idMsg: data['idMsg'] ?? '',
        idExp: data['idExp'] ?? '',
        idDest: data['idDest'] ?? '',
        msg : data['msgTxt'] ?? '',
        msgImage: data['msgImage'] ?? '',
        timestamp : data['timestamp'] ?? '',
      );
    }).toList();
  }

  Stream<List<Message>> get messages {
    return collectionRoom.doc(idExp).collection('chats')
        .doc('$idExp$idDest').collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots().map(listMessageFromSnapShot);
  }

  Future<void> msgLis() async {
    try{
      return await collectionRoom.doc(idExp).collection('chats')
          .doc('$idExp$idDest').update({'nbreMsgNonLis' : 0});
    }catch (error){
      print(error.toString());
    }
  }

  Future<void> supprimerConversation(idExp, idDest) async => await collectionRoom
      .doc(idExp).collection('chats').doc('$idExp$idDest').delete();


  Future<void> sprmerMsgPourVous(idExp, idDest, idMsg) async => await collectionRoom
      .doc(idExp).collection('chats').doc('$idExp$idDest').collection('messages')
        .doc(idMsg).delete();

  Future<void> sprmerMsgPourTous(idExp, idDest, idMsg) async {

    await collectionRoom.doc(idDest)
        .collection('chats').doc('$idDest$idExp').collection('messages')
        .doc(idMsg).update({'msg' : 'Message supprimé par l\'éxpediteur'});

    return await collectionRoom.doc(idExp)
        .collection('chats').doc('$idExp$idDest').collection('messages')
        .doc(idMsg).delete();
  }
  
  Stream<QuerySnapshot> get mesMessages => collectionRoom.doc(idExp)
        .collection('chats').doc('$idExp$idDest').collection('messages')
        .where('idExp', isEqualTo: idExp).snapshots();

  Stream<QuerySnapshot> get nbreMesMsgImg => collectionRoom.doc(idExp)
        .collection('chats').doc('$idExp$idDest').collection('messages')
        .where('idExp', isEqualTo: idExp).where('msgTxt', isEqualTo:'')
        .snapshots();

  Stream<QuerySnapshot> get nbreSesMsgImg => collectionRoom.doc(idExp)
        .collection('chats').doc('$idExp$idDest').collection('messages')
        .where('idDest', isEqualTo: idExp).where('msgTxt', isEqualTo:'')
        .snapshots();

  Future<void> blockE() async => await collectionUtilisateurs.doc(idDest)
      .collection('bloque').doc('$idDest$idExp').set({'bloque':'bloqué'});

  Future<void> deblockE() async => await collectionUtilisateurs.doc(idDest)
      .collection('bloque').doc('$idDest$idExp').delete();

  UserBlockE userBlockEFromSnapshot(DocumentSnapshot doc)=>

   UserBlockE(isBlockE: doc['bloque'] ?? '');
  
   

  Stream<UserBlockE> get blockdata => collectionUtilisateurs
      .doc(idDest).collection('bloque').doc('$idDest$idExp')
      .snapshots().map(userBlockEFromSnapshot);

  //Ajouter un commentaire
  Future<void> ajoutCommentaire(idUser, nomUser, imgUrl, idPost, msgCmtr) async {
    String idCmtr = collectionPosts.doc().id;

    return await collectionPosts.doc(idPost)
        .collection('commentaires').doc(idCmtr).set({
      'idCmtr' : idCmtr,
      'idUser' : idUser,
      'nomUser' : nomUser,
      'idPost' : idPost,
      'imgUrl' : imgUrl,
      'msgCmtr' : msgCmtr,
      'timestamp' : FieldValue.serverTimestamp()
    });
  }

  List<Commentaire> listCommentaire(QuerySnapshot snapshot)
  => snapshot.docs.map((doc) => Commentaire(
    idCmtr: doc['idCmtr'] ?? '',
    idUser: doc['idUser'] ?? '',
    nomUser: doc['nomUser'] ?? '',
    imgUrl: doc['imgUrl'] ?? '',
    idPost: doc['idPost'] ?? '',
    msgCmtr: doc['msgCmtr'] ?? '',
    timestamp: doc['timestamp'] ?? ''
  )).toList();

  Stream<List<Commentaire>> get commentaires => collectionPosts
      .doc(idPost).collection('commentaires').snapshots().map(listCommentaire);

  Future<void> supprimerCmtr() async => await collectionPosts
      .doc(idPost).collection('commentaires').doc(idCmtr).delete();

}