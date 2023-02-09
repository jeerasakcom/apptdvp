import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/config_text_button.dart';
import 'package:tdvp/utility/style.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MisDetailOrderPage extends StatefulWidget {
  final OrderModel orderModel;
  final String docIdOrder;
  const MisDetailOrderPage({
    Key? key,
    required this.orderModel,
    required this.docIdOrder,
  }) : super(key: key);

  @override
  State<MisDetailOrderPage> createState() => _MisDetailOrderPageState();
}

class _MisDetailOrderPageState extends State<MisDetailOrderPage> {
  OrderModel? orderModel;

  bool load = true;
  bool? haveOrders;
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];
  var orderModels = <OrderModel>[];
  var docIdOrders = <String>[];

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
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
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
        title: const Text('รายละเอียดการสั่งซื่อสินค้า'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Container(
            child: Column(
              children: [
                StyleProjects().boxheight1,
                StyleProjects().header2(),
                StyleProjects().boxheight1,
                Row(
                  children: [
                    Text(
                      "รหัสการสั่งซื้อ/สั่งพิมพ์ : ",
                      style: StyleProjects().topicstyle8,
                    ),
                    Text(
                      orderModel!.ordernumber,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleProjects().topicstyle8,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "วันที่สั่งพิมพ์ : ",
                      style: StyleProjects().topicstyle8,
                    ),
                    Text(
                      changeDateToString(orderModel!.ordertimes),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleProjects().topicstyle8,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "การจัดส่ง : ",
                      style: StyleProjects().topicstyle8,
                    ),
                    Text(
                      orderModel!.logistics,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleProjects().topicstyle8,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "การชำระเงิน : ",
                      style: StyleProjects().topicstyle8,
                    ),
                    Text(
                      orderModel!.payments,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleProjects().topicstyle8,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "จำนวนเงิน : ",
                      style: StyleProjects().topicstyle8,
                    ),
                    Text(
                      orderModel!.ordertotal,
                      style: StyleProjects().topicstyle8,
                    ),
                    StyleProjects().boxwidth1,
                    Text(
                      "บาท",
                      style: StyleProjects().topicstyle8,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "สถานะ : ",
                      style: StyleProjects().topicstyle8,
                    ),
                    Text(
                      orderModel!.status,
                      style: StyleProjects().topicstyle8,
                    ),
                  ],
                ),
                
                Center(
                  child: ConfigText(
                    lable: 'รายการแบบพิมพ์',
                    textStyle: StyleProjects().topicstyle4,
                  ),
                ),
                Divider(
                  color: StyleProjects().darkColor,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ConfigText(
                        lable: 'แบบพิมพ์',
                        textStyle: StyleProjects().contentstyle5,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ConfigText(
                        lable: 'ราคา',
                        textStyle: StyleProjects().contentstyle5,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ConfigText(
                        lable: 'จำนวน',
                        textStyle: StyleProjects().contentstyle5,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ConfigText(
                        lable: 'รวม',
                        textStyle: StyleProjects().contentstyle5,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: StyleProjects().darkColor,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: orderModel!.productslists.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  orderModel!.productslists[index]
                                      ['productname'],
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: StyleProjects().contentstyle5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ConfigText(
                          lable: orderModel!.productslists[index]['price'],
                          textStyle: StyleProjects().contentstyle5,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ConfigText(
                          lable: orderModel!.productslists[index]['quantity'],
                          textStyle: StyleProjects().contentstyle5,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ConfigText(
                          lable: orderModel!.productslists[index]['sum'],
                          textStyle: StyleProjects().contentstyle5,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: StyleProjects().darkColor,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConfigText(
                            lable: 'ผลรวมทั้งหมด :   ',
                            textStyle: StyleProjects().contentstyle5,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ConfigText(
                        lable: orderModel!.ordertotal,
                        textStyle: StyleProjects().contentstyle5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processReceiveProduct() async {
    Map<String, dynamic> map = {};
    map['status'] = 'finish';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processCancelOrder() async {
    Map<String, dynamic> map = {};
    map['status'] = 'cancel';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processStep1() async {
    Map<String, dynamic> map = {};
    map['status'] = 'รับคำสั่งจัดซื้อ';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processStep2() async {
    Map<String, dynamic> map = {};
    map['status'] = 'รับคำสั่งจัดซื้อ';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processStep3() async {
    Map<String, dynamic> map = {};
    map['status'] = 'ดำเนินการจัดพิมพ์';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processStep4() async {
    Map<String, dynamic> map = {};
    map['status'] = 'จัดพิมพ์เสร็จและเตรียมจัดส่ง';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processStep5() async {
    Map<String, dynamic> map = {};
    map['status'] = 'ดำเนินการจัดส่ง';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> processStep6() async {
    Map<String, dynamic> map = {};
    map['status'] = 'เสร็จสิ้น';
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
  }

  Row newLabel({required String title, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConfigText(
          lable: title,
        ),
        ConfigText(
          lable: subTitle,
        ),
      ],
    );
  }

  String changeDateToString(Timestamp timestamp) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    DateTime dateTime = timestamp.toDate();
    String string = dateFormat.format(dateTime);
    return string;
  }

  //
  Future<void> processUpdate({required String docIdOrders}) async {
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
                /*
              Text(
                "ระดับ",
                style: StyleProjects().topicstyle4,
              ),
              StyleProjects().boxwidth1,

              Text(
                userModel.level.toString(),
                style: StyleProjects().topicstyle4,
              ),
              */
                Text(
                  orderModel.ordernumber.toString(),
                  style: StyleProjects().topicstyle4,
                ),
              ],
            ),
          ),
          // content: SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       ConfigForm2(
          //           controller: statusController,
          //           label: 'สถานะ',
          //           iconData: Icons.safety_check_outlined,
          //           changeFunc: (String string) {}),
          //     ],
          //   ),
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TimelineTile(
                afterLineStyle: const LineStyle(color: Colors.yellow),
                indicatorStyle: const IndicatorStyle(
                  color: Colors.yellow,
                ),
                isFirst: true,
                endChild: Container(
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  height: 100,
                  child: const Text('Order'),
                ),
              ),
              TimelineTile(
                beforeLineStyle: const LineStyle(color: Colors.yellow),
                afterLineStyle: const LineStyle(color: Colors.grey),
                indicatorStyle: const IndicatorStyle(color: Colors.yellow),
                endChild: Container(
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  height: 100,
                  child: const Text('จัดพิมพ์'),
                ),
              ),
              TimelineTile(
                indicatorStyle: const IndicatorStyle(color: Colors.grey),
                isLast: true,
                endChild: Container(
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  height: 100,
                  child: Text('จัดส่ง'),
                ),
              )
            ],
          ),
          actions: [
            ConfigTextButton(
              label: 'แก้ไข',
              pressFunc: () async {
                Navigator.pop(context);

                String newstatus = 'printing';

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
              },
            ),
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

  Future<void> processTakeOrder({required String newstatus}) async {
    Map<String, dynamic> map = {};
    map['status'] = newstatus;
    FirebaseFirestore.instance
        .collection('orders')
        .doc()
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
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

      String newstatus = 'cancel';

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

  Container blockFastOrder() => Container(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFF459522),
            ),
          ),
          child: Text(
            'รับคำสั่งซื้อ',
            style: StyleProjects().topicstyle3,
          ),
          onPressed: () {},
          //  onPressed: () {
          //                                   StyleDialog(context: context)
          //                                       .actionDialog(
          //                                           title: 'ยกเลิกคำสั่งซื้อ',
          //                                           message:
          //                                               'คุณต้องการยกเลิกคำสั่งซื้อนี้ ?',
          //                                           label1: 'ยกเลิก',
          //                                           label2: 'ออก',
          //                                           presFunc1: () {
          //                                             print(
          //                                                 '==>> ${docIdOrders[index]}');
          //                                             processUpdateCancel(
          //                                                 docIdOrders:
          //                                                     docIdOrders[index]);

          //                                             Navigator.pop(context);
          //                                           },
          //                                           presFunc2: () {
          //                                             Navigator.pop(context);
          //                                           });
          //                                 },
        ),
      );

//
}
