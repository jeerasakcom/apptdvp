import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tdvp/components/backend/admin/lists_admin.dart';
import 'package:tdvp/components/backend/order/mis_detail_orders.dart';
import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/config_text_button.dart';
import 'package:tdvp/utility/dailog.dart';
import 'package:tdvp/utility/style.dart';

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
  bool load = true;
  bool? haveOrders;
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];
  var orderModels = <OrderModel>[];
  var docIdOrders = <String>[];
  //String? newstatus = 'Cancel';
  String? InOrders = "รับคำสั่งซื้อ";

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
    await FirebaseFirestore.instance
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
                    lable: 'ไม่มีข้อมูล',
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
              "คำสั่งซื้อใหม่",
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

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "การชำระเงิน : ",
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
                                              "จำนวนเงิน : ",
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
                              //                   title: 'ปรับสถานะดำเนินการ',
                              //                   message:
                              //                       'คุณต้องการปรับสถานะดำเนินการจัดพิมพ์ ?',
                              //                   label1: 'แก้ไข',
                              //                   label2: 'ยกเลิก',
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
                              //                     title: 'ยกเลิกคำสั่งซื้อ',
                              //                     message:
                              //                         'คุณต้องการยกเลิกคำสั่งซื้อนี้ ?',
                              //                     label1: 'ยกเลิก',
                              //                     label2: 'ออก',
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

      String newstatus = 'ยกเลิกคำสั่งจัดซื้อจัดพิมพ์';

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

      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => AlertDialog(
      //     title: ListTile(
      //       title: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             orderModel.ordernumber.toString(),
      //             style: StyleProjects().topicstyle4,
      //           ),
      //         ],
      //       ),
      //     ),
      //     actions: [
      //       ConfigTextButton(
      //         label: 'ยกเลิกคำสั่งซื้อ',
      //         pressFunc: () async {
      //           Navigator.pop(context);

      //           String newstatus = 'cancel';

      //           Map<String, dynamic> map = orderModel.toMap();

      //           map['status'] = newstatus;
      //           print('##3feb map --> $map');

      //           await FirebaseFirestore.instance
      //               .collection('orders')
      //               .doc(docIdOrders)
      //               .update(map)
      //               .then((value) {
      //             readerOrders();
      //           });
      //         },
      //       ),
      //       ConfigTextButton(
      //         label: 'ไม่',
      //         pressFunc: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // );
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

      String newstatus = "รับคำสั่งจัดซื้อแบบพิมพ์";

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

      String newstatus = "ดำเนินการจัดพิมพ์";

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

      String newstatus = "จัดพิมพ์สำเร็จและเตรียมการจัดส่ง";

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

      String newstatus = "ดำเนินการจัดส่ง";

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

      String newstatus = "จัดส่งสำเร็จ";

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
                "คำสั่งซื้อ",
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
                //     label: 'หัวข้อข่าว',
                //     iconData: Icons.list_outlined,
                //     changeFunc: (String string) {}),
                // StyleProjects().boxheight1,
                // ConfigForm2(
                //     textInputType: TextInputType.text,
                //     controller: detailController,
                //     label: 'รายละเอียด',
                //     iconData: Icons.list_outlined,
                //     changeFunc: (String string) {}),

                Text(
                  "ปรับสถานะดำเนินการจัดพิมพ์",
                  style: StyleProjects().topicstyle8,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "รับคำสั่งจัดซื้อ",
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
                            "ยืนยัน",
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
                        "การจัดพิมพ์",
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
                            "ยืนยัน",
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
                        "ขั้นตอนดำเนินการ",
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
                            "ยืนยัน",
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
                        "การจัดส่ง",
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
                            "ยืนยัน",
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
                        "เสร็จสิ้น",
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
                            "ยืนยัน",
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
            //   label: 'แก้ไข',
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
              label: 'ยกเลิก',
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
