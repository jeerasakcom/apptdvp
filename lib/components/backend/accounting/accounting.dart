// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/style.dart';

class AccountingPage extends StatefulWidget {
  final String uid;
  const AccountingPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  String? sumtotal;
  Widget currentWidget = AccountingPage(
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
      // body: Center(
      //   child: Column(
      //     children: [
      //       // FutureBuilder<String>(
      //       //   // กำหนดชนิดข้อมูล
      //       //   //future: _calculation, // ข้อมูล Future
      //       //   //builder: (BuildContext context, AsyncSnapshot snapshot) {
      //       //   builder: (context, snapshot) {
      //       //     // สร้าง widget เมื่อได้ค่า snapshot ข้อมูลสุดท้าย
      //       //     if (snapshot.hasData) {
      //       //       // ถ้าได้ค่าข้อมูลสุดท้าย
      //       //       return Text('Completed');
      //       //     } else if (snapshot.hasError) {
      //       //       // ถ้ามี error
      //       //       return Text('${snapshot.error}');
      //       //     }
      //       //     // ค่าเริ่มต้น, แสดงตัว Loading.สถานะ ConnectionState.waiting
      //       //     return const CircularProgressIndicator();
      //       //   },
      //       // ),

      //       FutureBuilder(
      //         future: FirebaseFirestore.instance
      //             .collection('orders')
      //             //.orderBy('ordertimes', descending: false)
      //             //.where("uidcustomer", isEqualTo: 'uidcustomer')
      //             .orderBy('ordertimes', descending: true)
      //             .get(),
      //         builder: (BuildContext context,
      //             AsyncSnapshot<QuerySnapshot> querySnapshot) {
      //           if (querySnapshot.connectionState == ConnectionState.done) {
      //             querySnapshot.data!.docs.forEach((doc) {
      //               sumtotal = doc["ordernumber"] + "oc " + doc["ordertotal"];
      //             });
      //             return Text("Sum of all sells: ${sumtotal}");
      //           }

      //           return Text("loading");
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            StyleProjects().boxTop2,
            StyleProjects().header2(),
            StyleProjects().boxTop2,
            Text(
              "รายงานสรุป รายรับ-รายจ่าย",
              style: StyleProjects().topicstyle2,
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('orders')
                  //.orderBy('ordertimes', descending: false)
                  //.where("uidcustomer", isEqualTo: 'uidcustomer')
                  .orderBy('ordertimes', descending: true)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.connectionState == ConnectionState.done) {
                  querySnapshot.data!.docs.forEach((doc) {
                    sumtotal = doc["ordernumber"] + "รวม " + doc["ordertotal"];
                  });
                  return Text("รายการ: ${sumtotal}");
                }

                return Text("loading");
              },
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     physics: const ScrollPhysics(),
            //     itemCount: orderModels.length,
            //     itemBuilder: (context, index) => Container(
            //       padding: const EdgeInsets.all(10),
            //       child: InkWell(
            //         onTap: () {},
            //         child: Card(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           elevation: 5,
            //           //color: StyleProjects().cardStream2,
            //           color: const Color(0xFF9ACD32),

            //           child: Column(
            //             children: [
            //               Row(
            //                 children: [
            //                   Expanded(
            //                     flex: 3,
            //                     child: Container(
            //                       padding: const EdgeInsets.all(20),
            //                       width: 100,
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 flex: 1,
            //                                 child: Text(
            //                                   "รหัสคำสั่งซื้อ : ",
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                               Expanded(
            //                                 flex: 2,
            //                                 child: Text(
            //                                   orderModels[index]
            //                                       .ordernumber
            //                                       .toString(),
            //                                   softWrap: true,
            //                                   maxLines: 2,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 flex: 1,
            //                                 child: Text(
            //                                   "วันที่สั่งพิมพ์ : ",
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                               Expanded(
            //                                 flex: 2,
            //                                 child: Text(
            //                                   orderModels[index]
            //                                       .ordertimes
            //                                       .toDate()
            //                                       .toString()
            //                                       .substring(0, 16),
            //                                   softWrap: true,
            //                                   maxLines: 2,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 flex: 1,
            //                                 child: Text(
            //                                   "การจัดส่ง : ",
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                               Expanded(
            //                                 flex: 2,
            //                                 child: Text(
            //                                   orderModels[index].logistics,
            //                                   softWrap: true,
            //                                   maxLines: 1,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 flex: 1,
            //                                 child: Text(
            //                                   "การชำระเงิน : ",
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                               Expanded(
            //                                 flex: 2,
            //                                 child: Text(
            //                                   orderModels[index].payments,
            //                                   softWrap: true,
            //                                   maxLines: 1,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 flex: 1,
            //                                 child: Text(
            //                                   "จำนวนเงิน : ",
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                               Expanded(
            //                                 flex: 2,
            //                                 child: Text(
            //                                   orderModels[index].ordertotal,
            //                                   softWrap: true,
            //                                   maxLines: 1,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Row(
            //                             children: [
            //                               Expanded(
            //                                 flex: 1,
            //                                 child: Text(
            //                                   "สถานะ : ",
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                               Expanded(
            //                                 flex: 2,
            //                                 child: Text(
            //                                   orderModels[index].status,
            //                                   softWrap: true,
            //                                   maxLines: 1,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style:
            //                                       StyleProjects().topicstyle8,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}



// FutureBuilder(
//     future: FirebaseFirestore.instance
        // .collection('orders')
//         .get(),
//     builder:
//       (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {

//     if (snapshot.hasError) {
//       return Text("Something went wrong");
//     }

//     if (snapshot.hasData && !snapshot.data!.exists) {
//       return Text("Document does not exist");
//     }

//     if (snapshot.connectionState == ConnectionState.done) {
//       querySnapshot.data!.docs.forEach((doc) {
//         sumTotal = sumTotal + doc["ordertotal"]; // make sure you create the variable sumTotal somewhere
//       });
//       return Text("Sum of all sells: ${sumTotal}")
//     }

//     return Text("loading");
//   },
// ),