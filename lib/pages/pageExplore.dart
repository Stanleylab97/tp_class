import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_class/models/bellaVote.dart';
import 'package:tp_class/widgets/bellavoteeList.dart';
import 'package:tp_class/widgets/listTop10.dart';

class PageExplorer extends StatefulWidget {
  @override
  _PageExplorerState createState() => _PageExplorerState();
}

class _PageExplorerState extends State<PageExplorer> {
  @override
  Widget build(BuildContext context) {

    final top10List = Provider.of<List<BellaVotEe>>(context) ?? [];

    return Center(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              title: Text(
                'Les bellas à l\'une ',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.search, color: Colors.black,),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left:16.0, right: 16.0, top: 16.0),
                    child: Text(
                        'Top de 10 bellas les plus votées',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.black
                      ),
                    ),
                  )
                ]
              ),
            ),
            ListTop10(),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(left:16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        'Plus de ${top10List.length} bellas, beauté déjà approuvée',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Colors.black
                        ),
                      ),
                    )
                  ]
              ),
            ),
            ListDeBellasVotEes(),
          ],
        ),
      )
    );
  }
}