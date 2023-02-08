import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/backend/misorders/mis_detail_orders.dart';
import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_form.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/config_text_button.dart';
import 'package:tdvp/utility/dailog.dart';
import 'package:tdvp/utility/style.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrdersListsPages extends StatefulWidget {
  const OrdersListsPages({
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersListsPages> createState() => _OrdersListsPagesState();
}

class _OrdersListsPagesState extends State<OrdersListsPages> {
  bool load = true;
  bool? haveOrders;
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];
  var orderModels = <OrderModel>[];
  var docIdOrders = <String>[];
  String? newstatus = 'Cancel';

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
              "บริหารจัดการคำสั่งซื้อ",
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
                    hoverColor: StyleProjects().cardStream1,
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
                                  padding: const EdgeInsets.all(10),
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
                                              "การรับสินค้า : ",
                                              style:
                                                  StyleProjects().topicstyle8,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              orderModels[index].logistics,
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
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  StyleProjects().topicstyle6,
                                            ),
                                          ),
                                        ],
                                      ),

                                      //
                                    ],
                                  ),
                                ),
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
                Text(
                  orderModel.ordernumber.toString(),
                  style: StyleProjects().topicstyle4,
                ),
              ],
            ),
          ),
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
}
