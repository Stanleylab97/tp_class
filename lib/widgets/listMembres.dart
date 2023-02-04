import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:tp_class/services/database.dart';
import 'package:tp_class/widgets/inboxMessage.dart';

class ListesDesMembres extends StatefulWidget {
  @override
  _ListesDesMembresState createState() => _ListesDesMembresState();
}

class _ListesDesMembresState extends State<ListesDesMembres> {
  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);

    return StreamBuilder<List<DonnEesUtil>>(
      stream: ServiceBDD().listDesUtils,
      builder: (context, snapshot){

        final listUtil = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: Text(
              'Séléctionnez un membre',
              style: TextStyle(color:Colors.black),
            ),
          ),
          body: ListView.builder(
            itemCount: listUtil.length,
            itemBuilder: (context, index){
              return listUtil[index].idUtil != utilisateur.idUtil ? ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(
                    idExp: utilisateur.idUtil,
                    idDest: listUtil[index].idUtil,
                    nom: listUtil[index].nomUtil,
                    imgUrl: listUtil[index].photoUrl,
                    emailDest:listUtil[index].emailUtil,
                    nbreMsgNonLis: 0,
                  )));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(listUtil[index].photoUrl!),
                ),
                title: Text(
                  listUtil[index].nomUtil!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  listUtil[index].emailUtil!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ): Container();
            },
          ),
        );
      },
    );
  }
}