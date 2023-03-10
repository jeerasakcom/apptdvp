import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tdvp/components/backend/admin/lists_admin.dart';
import 'package:tdvp/components/backend/order/mis_detail_orders.dart';
import 'package:tdvp/models/orders_model.dart';
//import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/config_text_button.dart';
import 'package:tdvp/utility/dailog.dart';
import 'package:tdvp/utility/style.dart';

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
  bool load = true;
  bool? haveOrders;
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];
  var orderModels = <OrderModel>[];
  var docIdOrders = <String>[];

  @override
  void initState() {
    super.initState();
    readerOrders();
  }

  Future<void> readerOrders() async {
    if (orderModels.isNotEmpty) {
      orderModels.clear();
      docIdOrders.clear();

      load = true;
      setState(() {});
    }
    //await
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('ordertimes', descending: true)
        .limit(10)
        .get()
        .then((value) {
      print('value ==> ${value.docs}');
      load = false;

      if (value.docs.isEmpty) {
        haveOrders = false;
      } else {
        haveOrders = true;
        for (var item in value.docs) {
          UserModel userModel = UserModel.fromMap(item.data());
          userModels.add(userModel);
          docIdUsers.add(item.id);
          OrderModel orderModel = OrderModel.fromMap(item.data());
          orderModels.add(orderModel);
          docIdOrders.add(item.id);
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ConfigProgress()
          : haveOrders!
              ? newContent()
              : Center(
                  child: ConfigText(
                    lable: '?????????????????????????????????',
                    textStyle: StyleProjects().topicstyle4,
                  ),
                ),
    );
  }

  Widget newContent() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyleProjects().boxTop2,
            StyleProjects().header2(),
            StyleProjects().boxTop2,
            Text(
              "???????????????????????????????????????????????????????????????",
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MisDetailOrderPage(
                              docIdOrder: '',
                              orderModel: orderModels[index],
                            ),
                          )).then((value) => readerOrders());
                    },
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
                                              "?????????????????????????????????????????? : ",
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
                                              "????????????????????????????????????????????? : ",
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
                                              "??????????????????????????? : ",
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

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "????????????????????????????????? : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index].payments,
                                              softWrap: true,
                                              maxLines: 1,
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
                                              "??????????????????????????? : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index].ordertotal,
                                              softWrap: true,
                                              maxLines: 1,
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
                                              "??????????????? : ",
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
                                      //       "?????????????????????????????????????????? : ",
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
                                      //       "????????????????????????????????????????????? : ",
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
                                      //       "???????????????????????????????????? : ",
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
                                      //       "????????????????????????????????? : ",
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
                                      //       "??????????????????????????? : ",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     Text(
                                      //       orderModels[index].ordertotal,
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //     StyleProjects().boxwidth1,
                                      //     Text(
                                      //       "?????????",
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),

                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "??????????????? : ",
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
                              // Expanded(
                              //   flex: 1,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       IconButton(
                              //         icon: const Icon(
                              //             Icons.edit_calendar_outlined,
                              //             color: Color.fromARGB(
                              //                 255, 000, 000, 000)),
                              //         //onPressed: () {},
                              //         onPressed: () {
                              //           StyleDialog(context: context)
                              //               .actionDialog(
                              //                   title: '??????????????????????????????????????????????????????',
                              //                   message:
                              //                       '???????????????????????????????????????????????????????????????????????????????????????????????????????????? ?',
                              //                   label1: '???????????????',
                              //                   label2: '??????????????????',
                              //                   presFunc1: () {
                              //                     print(
                              //                         '==>> ${docIdOrders[index]}');
                              //                     // processUpdate(
                              //                     //     docIdOrders:
                              //                     //         docIdOrders[index]);
                              //                     processEditStatus(
                              //                         docIdOrders:
                              //                             docIdOrders[index]);

                              //                     Navigator.pop(context);
                              //                   },
                              //                   presFunc2: () {
                              //                     Navigator.pop(context);
                              //                   });
                              //         },
                              //       ),

                              //       IconButton(
                              //           onPressed: () {
                              //             StyleDialog(context: context)
                              //                 .actionDialog(
                              //                     title: '????????????????????????????????????????????????',
                              //                     message:
                              //                         '??????????????????????????????????????????????????????????????????????????????????????? ?',
                              //                     label1: '??????????????????',
                              //                     label2: '?????????',
                              //                     presFunc1: () {
                              //                       print(
                              //                           '==>> ${docIdOrders[index]}');
                              //                       processUpdateCancel(
                              //                           docIdOrders:
                              //                               docIdOrders[index]);

                              //                       Navigator.pop(context);
                              //                     },
                              //                     presFunc2: () {
                              //                       Navigator.pop(context);
                              //                     });
                              //           },
                              //           icon: const Icon(
                              //             Icons.delete_forever_outlined,
                              //             color:
                              //                 Color.fromARGB(255, 219, 49, 49),
                              //           )),

                              //       //
                              //     ],
                              //   ),
                              // ),
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

  Future<void> processUpdateCancel({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      String newstatus = '?????????????????????????????????????????????????????????????????????????????????';

      Map<String, dynamic> map = orderModel.toMap();

      map['status'] = newstatus;
      print('##3feb map --> $map');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docIdOrders)
          .update(map)
          .then((value) {
        readerOrders();
      });
    });
  }

  Future<void> processUpdatePrinting1({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      String newstatus = "????????????????????????????????????????????????????????????????????????";

      Map<String, dynamic> map = orderModel.toMap();

      map['status'] = newstatus;
      print('##3feb map --> $map');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docIdOrders)
          .update(map)
          .then((value) {
        readerOrders();
      });
    });
  }

  Future<void> processUpdatePrinting2({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      String newstatus = "???????????????????????????????????????????????????";

      Map<String, dynamic> map = orderModel.toMap();

      map['status'] = newstatus;
      print('##3feb map --> $map');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docIdOrders)
          .update(map)
          .then((value) {
        readerOrders();
      });
    });
  }

  Future<void> processUpdatePrinting3({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      String newstatus = "????????????????????????????????????????????????????????????????????????????????????????????????";

      Map<String, dynamic> map = orderModel.toMap();

      map['status'] = newstatus;
      print('##3feb map --> $map');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docIdOrders)
          .update(map)
          .then((value) {
        readerOrders();
      });
    });
  }

  Future<void> processUpdatePrinting4({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      String newstatus = "?????????????????????????????????????????????";

      Map<String, dynamic> map = orderModel.toMap();

      map['status'] = newstatus;
      print('##3feb map --> $map');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docIdOrders)
          .update(map)
          .then((value) {
        readerOrders();
      });
    });
  }

  Future<void> processUpdatePrinting5({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      String newstatus = "????????????????????????????????????";

      Map<String, dynamic> map = orderModel.toMap();

      map['status'] = newstatus;
      print('##3feb map --> $map');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(docIdOrders)
          .update(map)
          .then((value) {
        readerOrders();
      });
    });
  }

//
//
  Future<void> processEditStatus({required String docIdOrders}) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docIdOrders)
        .get()
        .then((value) async {
      OrderModel orderModel = OrderModel.fromMap(value.data()!);

      print('##3feb orderModel ---> ${orderModel.toMap()}');

      TextEditingController statusController = TextEditingController();
      statusController.text = orderModel.status.toString();

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: ListTile(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: prefer_const_constructors
              Text(
                "??????????????????????????????",
                style: StyleProjects().topicstyle4,
              ),
              StyleProjects().boxwidth1,

              Text(
                orderModel.ordernumber.toString(),
                style: StyleProjects().topicstyle4,
              ),
            ],
          )),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // ConfigForm2(
                //     textInputType: TextInputType.text,
                //     controller: titleController,
                //     label: '??????????????????????????????',
                //     iconData: Icons.list_outlined,
                //     changeFunc: (String string) {}),
                // StyleProjects().boxheight1,
                // ConfigForm2(
                //     textInputType: TextInputType.text,
                //     controller: detailController,
                //     label: '??????????????????????????????',
                //     iconData: Icons.list_outlined,
                //     changeFunc: (String string) {}),

                Text(
                  "??????????????????????????????????????????????????????????????????????????????",
                  style: StyleProjects().topicstyle8,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "????????????????????????????????????????????????",
                        style: StyleProjects().topicstyle8,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            processUpdatePrinting1(docIdOrders: docIdOrders);
                          },
                          child: Text(
                            "??????????????????",
                            style: StyleProjects().topicstyle8,
                          ),
                        ),
                      ),
                      // ConfigIconButton(
                      //     iconData: Icons.edit_outlined,
                      //     pressFunc: () {
                      //       Navigator.pop(context);
                      //       processUpdateInOrder(docIdOrders: docIdOrders);
                      //     }),
                    ),
                  ],
                ),

                StyleProjects().boxheight1,
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "?????????????????????????????????",
                        style: StyleProjects().topicstyle8,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            processUpdatePrinting2(docIdOrders: docIdOrders);
                          },
                          child: Text(
                            "??????????????????",
                            style: StyleProjects().topicstyle8,
                          ),
                        ),
                      ),
                      // ConfigIconButton(
                    ),
                  ],
                ),

                //StyleProjects().boxheight1,
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "????????????????????????????????????????????????",
                        style: StyleProjects().topicstyle8,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            processUpdatePrinting3(docIdOrders: docIdOrders);
                          },
                          child: Text(
                            "??????????????????",
                            style: StyleProjects().topicstyle8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "???????????????????????????",
                        style: StyleProjects().topicstyle8,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            processUpdatePrinting4(docIdOrders: docIdOrders);
                          },
                          child: Text(
                            "??????????????????",
                            style: StyleProjects().topicstyle8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "???????????????????????????",
                        style: StyleProjects().topicstyle8,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            processUpdatePrinting5(docIdOrders: docIdOrders);
                          },
                          child: Text(
                            "??????????????????",
                            style: StyleProjects().topicstyle8,
                          ),
                        ),
                      ),
                      // ConfigIconButton(
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            // ConfigTextButton(
            //   label: '???????????????',
            //   pressFunc: () async {
            //     String newstatus = 'printing';

            //     Map<String, dynamic> map = orderModel.toMap();

            //     map['status'] = newstatus;
            //     print('##map --> $map');

            //     await FirebaseFirestore.instance
            //         .collection('orders')
            //         .doc(docIdOrders)
            //         .update(map)
            //         .then((value) {
            //       readerOrders();
            //     });
            //   },
            // ),

            ConfigTextButton(
              label: '??????????????????',
              pressFunc: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
