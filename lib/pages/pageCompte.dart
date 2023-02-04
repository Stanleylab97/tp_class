import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tp_class/models/utilisateur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
//import 'package:profile/profile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PageCompte extends StatefulWidget {
  const PageCompte({super.key});

  @override
  State<PageCompte> createState() => _PageCompteState();
}

class _PageCompteState extends State<PageCompte> {
  late String errorText = "";
  var box = Hive.box('settings');
  final currentUser = Hive.box('settings').get("currentUser") as Map;
  bool _isOpen = false;
  PanelController _panelController = PanelController();

  logout() async {
    Map<String, dynamic> data = {
      "id": currentUser['id'],
    };
    DataConnectionStatus status = await isConnected();
    if (status == DataConnectionStatus.connected) {
      await FirebaseAuth.instance.signOut();
      Hive.box('settings').delete('currentUser');
      CherryToast.success(
              title: Text("", style: TextStyle(color: Colors.black)),
              displayTitle: false,
              description: Text("Déconnexion réuissie",
                  style: TextStyle(color: Colors.black)),
              animationType: AnimationType.fromRight,
              animationDuration: Duration(milliseconds: 1000),
              autoDismiss: true)
          .show(context);
      Navigator.pushNamedAndRemoveUntil(context, 'phone', (route) => false);
    }
  }

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  var _imageList = [
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
    'assets/images/a1.jpeg',
  ];

  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => const Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/user.png'),
                ),
                imageUrl: currentUser['photo'],
                placeholder: (context, url) => Image(
                  fit: BoxFit.cover,
                  image: const AssetImage(
                    'assets/images/user.png',
                  ),
                ),
              ),
            ),
          ),

          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding Panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************
  /// Panel Body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40;

    return SingleChildScrollView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Action Section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.edit,
                size: 20.0,
              ),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, 'phone', (route) => false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              // borderSide: BorderSide(color: Colors.blue),
              label: Text(
                "Modifier",
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: SizedBox(
            width: 16,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: TextButton.icon(
                icon: Icon(
                  Icons.logout,
                  size: 20.0,
                ),
                onPressed: () {
                  logout();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                label: Text(
                  "Déconnexion",
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _infoCell(title: "Username", value: currentUser['username']),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: "Status account", value: "Active "),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: "Location", value: "Cotonou"),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
    return Column(
      children: <Widget>[
        Text(
          currentUser['nom'],
          style: TextStyle(
              fontFamily: 'NimbusSanL',
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          currentUser['prenom'],
          style: TextStyle(
              fontFamily: 'NimbusSanL',
              fontWeight: FontWeight.w700,
              fontSize: 23,
              color: Colors.black),
        ),
      ],
    );
  }
}
