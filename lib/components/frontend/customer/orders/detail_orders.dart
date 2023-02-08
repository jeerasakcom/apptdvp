import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_button.dart';
import 'package:tdvp/utility/config_db.dart';
import 'package:tdvp/utility/config_logo.dart';
import 'package:tdvp/utility/config_process.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/style.dart';

class DetailOrderBuyer extends StatefulWidget {
  final OrderModel orderModel;
  final String docIdOrder;
  const DetailOrderBuyer({
    Key? key,
    required this.orderModel,
    required this.docIdOrder,
  }) : super(key: key);

  @override
  State<DetailOrderBuyer> createState() => _DetailOrderBuyerState();
}

class _DetailOrderBuyerState extends State<DetailOrderBuyer> {
  OrderModel? orderModel;
  String? StartStatus = 'ส่งคำสั่งจัดซื้อ';

  @override
  void initState() {
    super.initState();
    orderModel = widget.orderModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                          child: Row(
                            children: [
                              Container(
                                //width: 130,
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
                //String StartStatus = 'ส่งคำสั่งจัดซื้อ';
                orderModel!.status == 'order'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConfigButton(
                            label: 'ยกเลิกคำสั่งซื้อ',
                            pressFunc: () {
                              processCancelOrder();
                            },
                          ),
                        ],
                      )
                    : const SizedBox()
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

    //     .then((value) async {
    //   UserModel userModel =
    //       await ConfigProcess().findUserModel(uid: orderModel!.uidcustomer);
    //   await ConfigProcess()
    //       .sentNotification(
    //           title: 'ได้รับสินค้าแล้ว',
    //           body: 'ลูกค้าได้รับ สินค้าแล้ว',
    //           token: userModel.token!)
    //       .then((value) {
    //     Navigator.pop(context);
    //   });
    // });
  }

  Future<void> processCancelOrder() async {
    String newstatus = 'ยกเลิกคำสั่งจัดซื้อจัดพิมพ์';
    Map<String, dynamic> map = {};
    //map['status'] = 'cancel';
    map['status'] = newstatus;
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.docIdOrder)
        .update(map)
        .then((value) {
      Navigator.pop(context);
    });
    //     .then((value) async {
    //   UserModel userModel =
    //       await ConfigProcess().findUserModel(uid: orderModel!.uidcustomer);
    //   await ConfigProcess()
    //       .sentNotification(
    //           title: 'Cancel Order',
    //           body: 'ลูกค้าได้ Cancel สินค้าแล้ว',
    //           token: userModel.token!)
    //       .then((value) {
    //     Navigator.pop(context);
    //   });
    // });
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
}
