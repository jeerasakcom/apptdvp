import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/service/customer_service.dart';
import 'package:tdvp/utility/style.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.uid});
  final String uid;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          //bg

          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xff59d3fc),
                Color(0xff124699),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),

          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),
              _backButton(),
              SizedBox(height: 20),
              headertdvp1(),
              SizedBox(height: 20),
              // header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: 1,
                          color: const Color(0xffffda7a),
                          //color: const Color(0xff000f3b),
                          //color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Text(
                      'ข่าวสาร',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'THSarabunNew',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffda7a),
                        //color: const Color(0xff000f3b),
                        //color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: 1,
                          color: const Color(0xffffda7a),
                          //color: const Color(0xff000f3b),
                          //color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("news")
                      .orderBy('newstimes', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'กรุณารอสักครู่นะคะ...',
                        style: StyleProjects().topicstyle7,
                      );
                    }
                    int length = snapshot.data!.docs.length;
                    return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemCount: length,
                        itemBuilder: (_, int index) {
                          final QueryDocumentSnapshot<Object?>? doc =
                              snapshot.data?.docs[index];

                          return ExpandableNotifier(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ExpansionTileCard(
                                title: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        //padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          snapshot.data!.docs
                                              .elementAt(index)['title'],
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: StyleProjects().contentstyle5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                subtitle: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'วันที่ : ',
                                        textAlign: TextAlign.start,
                                        style: StyleProjects().contentstyle5,
                                      ),
                                      Text(
                                        snapshot.data?.docs
                                            .elementAt(index)['newstimes'],
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: StyleProjects().contentstyle5,
                                      ),
                                    ],
                                  ),
                                ),

                                //
                                children: <Widget>[
                                  Divider(
                                    thickness: 1.0,
                                    height: 1.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),

                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              snapshot.data!.docs
                                                  .elementAt(index)['title'],
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.start,
                                              style:
                                                  StyleProjects().contentstyle5,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 10),
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              snapshot.data!.docs
                                                  .elementAt(index)['detail'],
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.start,
                                              style:
                                                  StyleProjects().contentstyle5,
                                            ),
                                          ),
                                          StyleProjects().boxTop2,
                                          Container(
                                            alignment: Alignment.center,
                                            child: Image.network(
                                              snapshot.data?.docs
                                                  .elementAt(index)['images'],
                                              fit: BoxFit.fill,
                                              width: 250,
                                              height: 400,
                                            ),
                                          ),
                                        ],
                                      ),

                                      //
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceAround,
                                    buttonHeight: 52.0,
                                    buttonMinWidth: 90.0,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardPage(
                                                uid: '',
                                              ),
                                            ),
                                          );
                                        },
                                        // onPressed: () {
                                        //   Get.to(() => const NewsDetailPage(),
                                        //       arguments: [
                                        //         {"newstimes": item}
                                        //       ],
                                        //       preventDuplicates: false);
                                        // },
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.arrow_upward),
                                            // ignore: prefer_const_constructors
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                            ),
                                            Text(
                                              'ปิด',
                                              textAlign: TextAlign.start,
                                              style:
                                                  StyleProjects().contentstyle5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                //
                              ),
                            ),

                            //
                          );

                          //
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      // onTap: () {
      //   Get.back();
      //   Get.to(() => const HomePage());
      // },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomerService(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: Color(0xffffc52e),
              ),
            ),
            Text(
              'Back',
              style: TextStyle(
                fontFamily: 'THSarabunNew',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffc52e),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget headertdvp1() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/logo.png'),
          ),
          SizedBox(
            width: 10,
          ),
          Center(
            child: Text(
              'โรงพิมพ์อาสารักษาดินแดน กรมการปกครอง\n'
              'Territorial Defence Volunteers Printing',
              style: TextStyle(
                fontFamily: 'THSarabunNew',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffc52e),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
