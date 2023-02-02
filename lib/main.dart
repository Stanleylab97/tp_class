import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tp_class/article.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tp_class/auth/login.dart';
import 'package:tp_class/auth/verify.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tp_class/setting_account.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Paint.enableDithering = true;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || kIsWeb) {
    await Hive.initFlutter('tp_class');
  } else {
    await Hive.initFlutter();
  }

  Future<void> openHiveBox(String boxName, {bool limit = false}) async {
    final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      File dbFile = File('$dirPath/$boxName.hive');
      File lockFile = File('$dirPath/$boxName.lock');
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        dbFile = File('$dirPath/tp_class/$boxName.hive');
        lockFile = File('$dirPath/tp_class/$boxName.lock');
      }
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
    // clear box if it grows large
    if (limit && box.length > 500) {
      box.clear();
    }
  }

  await openHiveBox('settings');

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      initialRoute: 'phone',
      routes: {
        'phone': (context) => PhoneAuth(),
        'verify': (context) => Verify(),
        'home': (context) => MyHomePage(),
        'fill_profile': (context) => SettingUser()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

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
    String? username , nom, photo, phone;
  @override
  void initState() {
    final currentUser = Hive.box('settings').get("currentUser") as Map;
    nom = currentUser['nom'] + ' ' + currentUser['prenom'];
    username     = currentUser['username'];
        photo     = currentUser['photo'];
        phone= currentUser['phoneNumber'];


    // TODO: implement initState
    super.initState();
  }

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
                            if (photo == "")
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                              )
                            else
                              SizedBox(
                                height: 130,width: 130
                                ,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      errorWidget: (context, _, __) =>
                                          const Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/user.png'),
                                      ),
                                      imageUrl: photo!,
                                      placeholder: (context, url) => Image(
                                        fit: BoxFit.cover,
                                        image: const AssetImage(
                                          'assets/images/user.png',
                                        ),
                                      ),
                                    )),
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
                              children: [
                                Icon(Icons.phone),
                                Text(phone.toString() ??"")
                              ],
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
                      Text("",
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
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Déconnexion',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Hive.box('settings').delete('currentUser');

                      Navigator.pushNamedAndRemoveUntil(
                          context, 'phone', (route) => false);
                    } catch (e) {
                      CherryToast.error(
                              title: Text("Erreur"),
                              displayTitle: false,
                              description: Text("Erreur de déconnexion",
                                  style: TextStyle(color: Colors.black)),
                              animationType: AnimationType.fromRight,
                              animationDuration: Duration(milliseconds: 1000),
                              autoDismiss: true)
                          .show(context);
                      print("Une erreur s'est produite - ${e}");
                    }
                  },
                ),
              ],
            )));
  }
}
