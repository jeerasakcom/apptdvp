import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tdvp/components/backend/admin/lists_admin.dart';

/*
class DashboardAdminPages extends StatelessWidget {
  DashboardAdminPages({super.key, required this.uid});
  final String uid;

  List<String> nameIcons = [
    '001.png',
    '002.png',
    '003.png',
    '004.png',
    '005.png',
  ];

  List<String> titles = [
    'หมวดหมู่/แบบพิมพ์',
    'การสั่งซื้อ',
    'สถานะการพิมพ์',
    'การจัดส่ง',
    'รายงานสถิติ',
  ];

  List<Widget> widgets = [];

  List<Widget> routToWidgdets = [
    ListsAdminPages(),
    ListsAdminPages(),
    ListsAdminPages(),
    ListsAdminPages(),
    ListsAdminPages(),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      /*
      body: Stack(
        children: <Widget>[
          dashBg,
          content,
        ],
      ),
      */
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Column(
            children: [
              //dashBg,
              //content,

            ],
          ),
        ),
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            child: Container(color: Color.fromARGB(255, 30, 30, 179)),
            flex: 2,
          ),
          Expanded(
            child: Container(color: Colors.transparent),
            flex: 5,
          ),
        ],
      );

  get content => Container(
        child: Column(
          children: <Widget>[
            header,
            grid,
          ],
        ),
      );

  // ignore: prefer_const_constructors
  get header => ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        title: Text(
          'Dashboard',
          style: StyleProjects().topicstyle3,
        ),
        subtitle: Text(
          'Admin',
          style: StyleProjects().topicstyle3,
        ),
        trailing: const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(
            "assets/images/logo.png",
          ),
          // NetworkImage("${snapshot.data.hitsList[index].previewUrl}"),
          backgroundColor: Colors.transparent,
        ),
      );

  get grid => Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: GridView.count(
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            crossAxisCount: 2,
            childAspectRatio: 1,
            children: List.generate(8, (_) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlutterLogo(),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );

  Widget createECard(String title, String nameIcon, int index) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xff003a9f),
        //color: const Color(0xffb3e5fc),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/images/icons/$nameIcon',
                  width: 50,
                  height: 50,
                ),
              ),
              Text(
                title,
                style: StyleProjects().topicstyle6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


*/

class DashboardAdminPages extends StatefulWidget {
  const DashboardAdminPages({super.key, required this.uid});
  final String uid;

  @override
  State<DashboardAdminPages> createState() => _DashboardAdminPagesState();
}

class _DashboardAdminPagesState extends State<DashboardAdminPages> {
  Widget currentWidget = DashboardAdminPages(
    uid: '',
  );
  List<String> titles = [
    'หมวดหมู่/แบบพิมพ์',
    'การสั่งซื้อ',
    'สถานะการพิมพ์',
    'การจัดส่ง',
    'รายงานสถิติ',
  ];

  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 30, 30, 179),
                height: 150,
              ),
              StyleProjects().header2(),
              Container(
                height: 150,
                width: 100,
                child: Card(
                  color: Color.fromARGB(240, 228, 74, 13),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlutterLogo(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(10.0),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  primary: false,
                  crossAxisCount: 3,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/001.png',
                              height: 60,
                            ),
                            Text(
                              'ข้อมูลองค์กร',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/002.png',
                              height: 60,
                            ),
                            Text(
                              'แบบสิ่งพิมพ์',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/003.png',
                              height: 60,
                            ),
                            Text(
                              'ประเมินราคา',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/004.png',
                              height: 60,
                            ),
                            Text(
                              'ปฏิทิน',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/005.png',
                              height: 60,
                            ),
                            Text(
                              'สถานะการพิมพ์',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/006.png',
                              height: 60,
                            ),
                            Text(
                              'การจัดส่ง',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/007.png',
                              height: 60,
                            ),
                            Text(
                              'ติดต่อ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/008.png',
                              height: 60,
                            ),
                            Text(
                              'ข่าวสาร',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListsAdminPages()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 4,
                        color: const Color(0xffb3e5fc),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Image.asset(
                              'assets/images/009.png',
                              height: 60,
                            ),
                            Text(
                              'แชทบอท',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'THSarabunNew',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff04066b),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  
  
  

  */
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        /*
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/p21.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        */
      ),
    );
  }
}
