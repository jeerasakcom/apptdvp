import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/style.dart';

class LogisticPage extends StatefulWidget {
  //final String debouncer;
  const LogisticPage({super.key});

  @override
  State<LogisticPage> createState() => _LogisticPageState();
}

class _LogisticPageState extends State<LogisticPage> {
  bool load = true;
  bool? haveOrders;
  var orderModels = <OrderModel>[];
  var docIdOrders = <String>[];
  String? ordernumber;
  //final debouncer = Debouncer(millisecond: 100);
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // readAllOrders();
    delayTime();
    //readerOrders();
  }

  Future<Null> delayTime() async {
    Duration duration = Duration(seconds: 1);
    await Timer(duration, () => readAllOrders());
  }

  Future<Null> readAllOrders() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('ordernumber', descending: true)
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          OrderModel model = OrderModel.fromMap(item.data());
          setState(() {
            orderModels.add(model);
          });
        }
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: StyleProjects().primaryColor,
        ),
        body: orderModels.isEmpty ? const ConfigProgress() : newContent());
  }

  Container blockOrdernumber() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white70,
      ),
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            orderModels = orderModels
                .where((element) => (element.ordernumber!
                    .toLowerCase()
                    .contains(value.toLowerCase())))
                .toList();
          });
        },
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white),
          hintText: "รหัสการสั่งซื้อ/สั่งพิมพ์ ",
          prefixIcon: const Icon(
            Icons.document_scanner_outlined,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 14, 98),
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget newContent() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyleProjects().boxTop2,
            StyleProjects().header2(),
            // StyleProjects().boxTop2,
            // Text(
            //   "ค้นหาจากรหัสคำสั่งซื้อ",
            //   style: StyleProjects().topicstyle2,
            // ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 1,
                //color: Colors.black54,
                color: StyleProjects().backgroundState,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StyleProjects().boxTop2,
                    Center(
                      child: Text(
                        "ตรวจสอบสถานะการจัดส่ง",
                        style: StyleProjects().topicstyle7,
                      ),
                    ),
                    //StyleProjects().boxTop2,
                    blockOrdernumber(),
                    StyleProjects().boxTop2,
                  ],
                ),
              ),
            ),

            Text(
              "ค้นหาจากรหัสคำสั่งซื้อ",
              style: StyleProjects().topicstyle2,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: orderModels.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                      //color: StyleProjects().cardStream2,
                      color: const Color(0xFF9ACD32),

                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "รหัสคำสั่งซื้อ : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index]
                                                  .ordernumber
                                                  .toString(),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "วันที่สั่งพิมพ์ : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index]
                                                  .ordertimes
                                                  .toDate()
                                                  .toString()
                                                  .substring(0, 16),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "การจัดส่ง : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index].logistics,
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       flex: 1,
                                      //       child: Text(
                                      //         "การชำระเงิน : ",
                                      //         style:
                                      //             StyleProjects().topicstyle8,
                                      //       ),
                                      //     ),
                                      //     Expanded(
                                      //       flex: 2,
                                      //       child: Text(
                                      //         orderModels[index].payments,
                                      //         softWrap: true,
                                      //         maxLines: 1,
                                      //         overflow: TextOverflow.ellipsis,
                                      //         style:
                                      //             StyleProjects().topicstyle8,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),

                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       flex: 1,
                                      //       child: Text(
                                      //         "จำนวนเงิน : ",
                                      //         style:
                                      //             StyleProjects().topicstyle8,
                                      //       ),
                                      //     ),
                                      //     Expanded(
                                      //       flex: 2,
                                      //       child: Text(
                                      //         orderModels[index].ordertotal,
                                      //         softWrap: true,
                                      //         maxLines: 1,
                                      //         overflow: TextOverflow.ellipsis,
                                      //         style:
                                      //             StyleProjects().topicstyle8,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "สถานะ : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index].status,
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                        ],
                                      ),

                                      //
                                      //

                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "รหัสคำสั่งซื้อ : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index]
                                      //           .ordernumber
                                      //           .toString(),
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "วันที่สั่งพิมพ์ : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index]
                                      //           .ordertimes
                                      //           .toDate()
                                      //           .toString()
                                      //           .substring(0, 16),
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),

                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "การรับสินค้า : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index].logistics,
                                      //       softWrap: true,
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "การชำระเงิน : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index].payments,
                                      //       softWrap: true,
                                      //       maxLines: 1,
                                      //       overflow: TextOverflow.ellipsis,
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "จำนวนเงิน : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index].ordertotal,
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     StyleProjects().boxwidth1,
                                      //     Text(
                                      //       "บาท",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),

                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "สถานะ : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index].status,
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),

                                      //
                                    ],
                                  ),
                                ),

//
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  //
}
