import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdvp/components/backend/accounting/accounting.dart';
import 'package:tdvp/components/backend/admin/create_admin.dart';
import 'package:tdvp/components/backend/admin/lists_admin.dart';
import 'package:tdvp/components/backend/news/lists_news.dart';
import 'package:tdvp/components/backend/order/mis_orders_page.dart';
import 'package:tdvp/components/backend/products/list_products.dart';
import 'package:tdvp/components/backend/dashboard/dashboard.dart';
import 'package:tdvp/components/backend/stock/lists_stock.dart';
import 'package:tdvp/components/frontend/guest/authentication/authentication.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/style.dart';

class AdminService extends StatefulWidget {
  @override
  _AdminServiceState createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  Widget currentWidget = const DashboardAdminPages(
    uid: '',
  );
  String? fname, email;
  var user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool load = true;
  bool? haveDataProfile;
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findNameAnEmail();
  }

  Future<Null> findToken(String uid) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.getToken().then((value) async {
        print('### uid ที่ login อยู่ ==>> $uid');
        print('### token ==> $value');

        Map<String, dynamic> data = {};
        data['token'] = value;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update(data)
            .then((value) => print('Update Token Success'));
      });
    });
  }

  Future<Null> findNameAnEmail() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        String uid = event!.uid;
        findToken(uid);
        setState(() {
          fname = event.displayName;
          email = event.email;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: ConfigText(
                      lable: 'Exit',
                      textStyle: StyleProjects().alertstyle1,
                    ),
                    content: ConfigText(
                      lable: 'คุณต้องการออกจากระบบ ?',
                      textStyle: StyleProjects().alertstyle2,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthenticationPage()));
                        },
                        child: Text(
                          'ใช่',
                          style: StyleProjects().alertstyle2,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'ไม่',
                          style: StyleProjects().alertstyle2,
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  blockUserAccountsDrawerHeader(),
                  // blockListDataAdmin(),
                  blockListProducts(),
                  blockListOrder(),
                  blockListNews(),
                  blockListAccount(),
                ],
              ),
            ),
            blocklogout(),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile blockListDataAdmin() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(
          Icons.person_2_outlined,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      title: const Text(
        'ผู้ดูแลระบบ',
        style: TextStyle(
          fontFamily: 'THSarabunNew',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          //color: const Color(0xFF000120),
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = const ListsAdminPages();
        });
      },
    );
  }

  ListTile blockListProducts() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(
          Icons.add_chart,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      title: const Text(
        'หมวดสินค้า/รายการสินค้า',
        style: TextStyle(
          fontFamily: 'THSarabunNew',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          //color: const Color(0xFF000120),
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = const ListsCategoryPages(
            docStock: '',
          );
        });
      },
    );
  }

  ListTile blockListOrder() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(
          //Icons.print_rounded,
          Icons.production_quantity_limits,
          color: Colors.black,
        ),
        onPressed: () => const MisOrdersPages(),
        //OrdersListsPages(),
      ),
      title: const Text(
        'การสั่งซื้อ/สั่งพิมพ์',
        style: TextStyle(
          fontFamily: 'THSarabunNew',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          //color: const Color(0xFF000120),
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = const MisOrdersPages();
          //OrdersListsPages();
        });
      },
    );
  }

  ListTile blockListNews() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(
          Icons.new_label_sharp,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      title: const Text(
        'ข่าวสาร',
        style: TextStyle(
          fontFamily: 'THSarabunNew',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          //color: const Color(0xFF000120),
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = const ListsNewsPages();
        });

        //
        // Navigator.pop(context);
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const ListsNewsPages(),
        // ));
      },
    );
  }

  ListTile blockListAccount() {
    return ListTile(
      leading: IconButton(
        icon: new Icon(
          Icons.add_task,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      title: const Text(
        'รายงานสรุปการสั่งซื้อ',
        style: TextStyle(
          fontFamily: 'THSarabunNew',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          //color: const Color(0xFF000120),
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = const DashboardAdminPages(
            uid: '',
          );
          //     AccountingPage(
          //   uid: '',
          // );
        });
      },
    );
  }

  Column blocklogout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: ListTile(
            // onTap: () async {
            //   // await FirebaseAuth.instance.signOut().then((value) {
            //   //   Get.offAll(const AuthenticationPage());
            //   // });
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const AuthenticationPage()));
            // },
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: ConfigText(
                    lable: 'Exit',
                    textStyle: StyleProjects().alertstyle1,
                  ),
                  content: ConfigText(
                    lable: 'คุณต้องการออกจากระบบ ?',
                    textStyle: StyleProjects().alertstyle2,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AuthenticationPage()));
                      },
                      child: Text(
                        'ใช่',
                        style: StyleProjects().alertstyle2,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'ไม่',
                        style: StyleProjects().alertstyle2,
                      ),
                    ),
                  ],
                ),
              );
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 253, 253, 253),
            ),
            title: const Text(
              'ออกจากระบบ',
              style: TextStyle(
                fontFamily: 'THSarabunNew',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> findUserLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event!.uid;
        print('uid ===>> $uid');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {});
        });
      });
    });
  }

  UserAccountsDrawerHeader blockUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('assets/images/tree.jpeg'), fit: BoxFit.cover),
      ),
      // accountName:
      //     StyleProjects().topicaccount2(fname == null ? 'fname' : fname!),
      accountName: Text(""),
      accountEmail: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "อีเมล",
                  style: StyleProjects().topicstyle8,
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  email == null ? 'email' : email!,
                  style: StyleProjects().topicstyle8,
                ),
              ),
            ],
          ),

          // Text(
          //   email == null ? 'email' : email!,
          //   style: StyleProjects().topicstyle8,
          // ),

          // ConfigText(
          //   lable: "อีเมล",
          //   textStyle: StyleProjects().topicstyle8,
          // ),
          // StyleProjects().boxwidth2,
          // ConfigText(
          //   lable: email == null ? 'email' : email!,
          //   textStyle: StyleProjects().topicstyle8,
          // ),
          //  StyleProjects().topicaccount2(email == null ? 'email' : email!),
        ],
      ),
      currentAccountPicture: Image.asset(
        'assets/images/iconpro.png',
      ),
    );
  }
}
