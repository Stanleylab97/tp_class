import 'package:flutter/material.dart';
import 'package:tp_class/article.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

 

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Mon profil"),
          centerTitle: true,
          //leading: MenuWidget(),
         
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage('assets/images/user.jpeg'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Icon(Icons.email),
                                Text("valdoazanmassou@gmail.com",
                                    style: TextStyle(fontSize: 8))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Icon(Icons.phone), Text("97569701")],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Icon(Icons.home), Text("Calavi")],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 300.0, // Change as you wish
                        width: 240.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Text("2020-2022 :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "Pratique de quelque chose, de quelqu'un, épreuve de quelque chose"),
                            ),
                            ListTile(
                              leading: Text("2018-2020 :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "Pratique de quelque chose, de quelqu'un, épreuve de quelque chose"),
                            ),
                            ListTile(
                              leading: Text("2016-2013 :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  "Pratique de quelque chose,  de quelqu'un, épreuve de quelque chose"),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: size.height * 0.08,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green,
                ),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Article()));
                  },
                  child: Text(
                    "Consulter mes articles",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
            backgroundColor: Colors.green,
            child: ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: const [
                      SizedBox(height: 10),
                      Center(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/images/user.jpeg'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Flutter Developer",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Text("valdo@gmail.com",
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ],
                  ),
                ),
                const Divider(
                    thickness: .06, color: Color.fromARGB(255, 30, 29, 29)),
                ListTile(
                  iconColor: Colors.white,
                  leading: const Icon(Icons.person),
                  title: const Text('Mon Profil',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  iconColor: Colors.white,
                  leading: const Icon(Icons.book),
                  title: const Text('Mes articles',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Article()));
                  },
                ),
                ListTile(
                  iconColor: Colors.white,
                  leading: const Icon(Icons.subscriptions),
                  title: const Text('Go Premium',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Add Navigation logic here
                  },
                ),
              ],
            )));
  }
}
