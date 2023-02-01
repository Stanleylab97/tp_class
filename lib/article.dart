import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tp_class/addArticle.dart';
import 'package:tp_class/main.dart';
import 'package:tp_class/models/article.dart';
import 'package:tp_class/widgets/articleCard.dart';

class Article extends StatefulWidget {
  const Article({super.key});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: 
        Colors.green,
        title: Text(
                "Consultez mes articles",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        leading: GestureDetector(child: Icon(Icons.arrow_back_ios), onTap: (() {
         Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
        }),),
         actions: [
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: Icon(Icons.add,color: Colors.green, ),
              onPressed: (){Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddArticle(),
            ));

              })
          ],),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              
              ArticleCard(
                article: ArticleM(
                    title: "La culture de chez nous",
                    content:
                        "Si la grâce ne supprime pas la nature, la mondialisation montre qu’elle ne supprime pas la culture. Après quelques considérations sur les rapports religion/culture dans l’espace négro-africian, le propos voudrait montrer, à partir d’un exemple, comment les croyances aux apparitions des morts dans la culture bantoue posent question au fondement de la logique chrétienne qu’est la résurrection de Jésus, tout en se laissant questionner par l’Écriture. Se trouveront ainsi fondées la mise en question d’un discours chrétien unique et la nécessité de l’inculturation pour dire le message du Christ en Afrique.Seitenanfang",
                    image: "assets/images/a1.jpeg",
                    date: "12/01/2023"),
              ),
              SizedBox(
                height: 8,
              ),
              ArticleCard(
                article: ArticleM(
                    title: "Les griots à l'oeuvre",
                    content:
                        "Musicien, il a longtemps gardé le monopole du jeu des instruments mélodiques, seuls quelques tambours pouvant être battus par des non-griots. Il est le chantre, le héraut de la société mandingue, et par la même son influence sur ladite société apparaît évidente.",
                    image: "assets/images/a3.jpg",
                    date: "08/01/2022"),
              ),
              SizedBox(
                height: 8,
              ),
              ArticleCard(
                article: ArticleM(
                    title: "Moeurs de la femme africaine",
                    content:
                        "Il vaut mieux naître femme en Afrique qu’en Asie. Cette affirmation peut surprendre de prime abord lorsque l’on a présent à l’esprit la formule employée par des générations de géographes, à commencer par le grand tropicaliste Pierre Gourou : la femme est la bête de somme de l’Afrique. Cette affirmation est toujours vraie. Mais aujourd’hui, ce sont les femmes qui, concrètement, tiennent les leviers de commande du continent. C’est tout le paradoxe du statut de la femme en Afrique.",
                    image: "assets/images/a2.jpeg",
                    date: "26/06/2022"),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
