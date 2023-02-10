import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tdvp/components/frontend/customer/service/customer_service.dart';
import 'package:tdvp/models/order_model.dart';
import 'package:tdvp/models/products_model.dart';
import 'package:tdvp/models/sqlite_helper.dart';
import 'package:tdvp/models/sqlite_model.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/style.dart';

class DisplayCart extends StatefulWidget {
  const DisplayCart({
    Key? key,
  }) : super(key: key);

  @override
  State<DisplayCart> createState() => _DisplayCartState();
}

class _DisplayCartState extends State<DisplayCart> {
  var user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool load = true;
  bool? haveData;
  var sqliteModels = <SQLiteModel>[];
  int total = 0;
  late String ordernumber;

  bool displayConfirmOrder = false;
  File? file;
  String? uidcustomers;
  String typeTransfer = 'onShop';
  String typePayment = 'promptPay';

  String urlSlip = '';

  @override
  void initState() {
    super.initState();
    readSQLite();
    findUidCustomer();
  }

  Future<void> findUidCustomer() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      uidcustomers = event!.uid;
    });
  }

  Future<void> readSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
      total = 0;
    }
    await SQLiteHelper().readAllData().then((value) async {
      print('value readSQLite ==> $value');

      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;

        for (var item in value) {
          SQLiteModel sqLiteModel = item;
          sqliteModels.add(sqLiteModel);
          total = total + int.parse(sqLiteModel.sum);
        }
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
        title: const Text('ตะกร้า'),
      ),
      body: load
          ? const ConfigProgress()
          : haveData!
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StyleProjects().header2(),
                        Center(
                          child: ConfigText(
                            lable: 'รายการแบบพิมพ์',
                            textStyle: StyleProjects().topicstyle4,
                          ),
                        ),
                        showHead(),
                        listCart(),
                        const Divider(
                          color: Colors.blue,
                        ),
                        newTotal(),
                        newControlButton(),
                        displayConfirmOrder
                            ? newTypeTransfer()
                            : const SizedBox(),
                        displayConfirmOrder
                            ? newTypePayment()
                            : const SizedBox(),
                        // (displayConfirmOrder && (typePayment == 'Payment'))
                        //     ? showPromptPay()
                        //     : displayConfirmOrder
                        //         ? ElevatedButton(
                        //             onPressed: () => processSaveOrder(),
                        //             child: const Text('ยืนยันการสั่งซื้อ'),
                        //           )
                        //         : const SizedBox(),
                        (displayConfirmOrder && (typePayment == 'Payment'))
                            ? showPromptPay()
                            : displayConfirmOrder
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () => processSaveOrder(),
                                    child: Text(
                                      'ยืนยันการสั่งซื้อ',
                                      style: StyleProjects().contentstyle1,
                                    ),
                                  )
                                : const SizedBox(),
                        file == null
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 32),
                                        width: 200,
                                        height: 200,
                                        child: Image.file(file!),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 48, 32, 223),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () async {
                                            String nameSlip =
                                                '$uidcustomers${Random().nextInt(1000)}.jpg';
                                            FirebaseStorage firebaseStorage =
                                                FirebaseStorage.instance;
                                            Reference reference =
                                                firebaseStorage
                                                    .ref()
                                                    .child('slip/$nameSlip');
                                            UploadTask uploadTask =
                                                reference.putFile(file!);
                                            await uploadTask
                                                .whenComplete(() async {
                                              await reference
                                                  .getDownloadURL()
                                                  .then((value) async {
                                                urlSlip = value.toString();
                                                print('==> $urlSlip');
                                                processSaveOrder();
                                              });
                                            });
                                          },
                                          child: Text(
                                            'อัพโหลด สลิปการจ่ายเงิน ยืนยันการสั่งซื้อ',
                                            style:
                                                StyleProjects().contentstyle1,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: ConfigText(
                    lable: 'ไม่มีสินค้าในตะกร้า',
                    textStyle: StyleProjects().topicstyle4,
                  ),
                ),
    );
  }

  Column newTypeTransfer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfigText(
          lable: 'การจัดส่ง',
          textStyle: StyleProjects().topicstyle4,
        ),
        RadioListTile(
          title: ConfigText(
            lable: 'รับที่โรงพิมพ์อาสารักษาดินแดน',
            textStyle: StyleProjects().contentstyle5,
          ),
          value: 'รับที่โรงพิมพ์อาสารักษาดินแดน',
          groupValue: typeTransfer,
          onChanged: (value) {
            setState(() {
              typeTransfer = value.toString();
            });
          },
        ),
        RadioListTile(
          title: ConfigText(
            lable: 'จัดส่งพัสดุโดยโรงพิมพ์อาสารักษาดินแดน',
            textStyle: StyleProjects().contentstyle5,
          ),
          value: 'จัดส่งพัสดุโดยโรงพิมพ์อาสารักษาดินแดน',
          groupValue: typeTransfer,
          onChanged: (value) {
            setState(() {
              typeTransfer = value.toString();
            });
          },
        ),
      ],
    );
  }

  Column newTypePayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfigText(
          lable: 'การชำระเงิน',
          textStyle: StyleProjects().topicstyle4,
        ),
        RadioListTile(
          title: ConfigText(
            lable: 'ชำระผ่านPayment',
            textStyle: StyleProjects().contentstyle5,
          ),
          value: 'Payment',
          groupValue: typePayment,
          onChanged: (value) {
            setState(() {
              typePayment = value.toString();
            });
          },
        ),
        // Container(
        //   //padding: EdgeInsets.only(left: 70),
        //   padding: const EdgeInsets.all(10),
        //   child: Card(
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //     elevation: 5,
        //     color: StyleProjects().cardStream9,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.all(5),
        //           child: Column(
        //             children: [
        //               Row(
        //                 children: [
        //                   Container(
        //                     height: 40,
        //                     // ignore: prefer_const_constructors
        //                     child: Image(
        //                       image: const AssetImage('assets/images/gsb.png'),
        //                     ),
        //                   ),
        //                   StyleProjects().boxwidth1,
        //                   ConfigText(
        //                     lable: 'บัญชี : ',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                   ConfigText(
        //                     lable: 'ธนาคารออมสิน สาขาพหลโยธิน',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                 ],
        //               ),
        //               StyleProjects().boxheight1,
        //               Row(
        //                 children: [
        //                   ConfigText(
        //                     lable: 'ชื่อบัญชี : ',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                   ConfigText(
        //                     lable: 'โรงพิมพ์อาสารักษาดินแดน กรมการปกครอง',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                 ],
        //               ),
        //               Row(
        //                 children: [
        //                   ConfigText(
        //                     lable: 'เลขบัญชี : ',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                   ConfigText(
        //                     lable: '7 - 900 - 10000 - 210',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                 ],
        //               ),
        //               Row(
        //                 children: [
        //                   ConfigText(
        //                     lable: 'ประเภท : ',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                   ConfigText(
        //                     lable: 'Payment',
        //                     textStyle: StyleProjects().topicstyle8,
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Row showPromptPay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              //padding: EdgeInsets.only(left: 70),
              padding: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                color: StyleProjects().cardStream9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                // ignore: prefer_const_constructors
                                child: Image(
                                  image:
                                      const AssetImage('assets/images/gsb.png'),
                                ),
                              ),
                              StyleProjects().boxwidth1,
                              ConfigText(
                                lable: 'บัญชี : ',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                              ConfigText(
                                lable: 'ธนาคารออมสิน สาขาพหลโยธิน',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                            ],
                          ),
                          StyleProjects().boxheight1,
                          Row(
                            children: [
                              ConfigText(
                                lable: 'ชื่อบัญชี : ',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                              ConfigText(
                                lable: 'โรงพิมพ์อาสารักษาดินแดน กรมการปกครอง',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ConfigText(
                                lable: 'เลขบัญชี : ',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                              ConfigText(
                                lable: '7 - 900 - 10000 - 210',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ConfigText(
                                lable: 'ประเภท : ',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                              ConfigText(
                                lable: 'Payment',
                                textStyle: StyleProjects().topicstyle8,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 26, 180, 28),
                    //backgroundColor: const Color.fromARGB(255, 255, 23, 23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    var result = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 800,
                        maxHeight: 800);
                    setState(() {
                      file = File(result!.path);
                    });
                  },
                  child: Text(
                    'เลือกสลิปการจ่ายเงิน',
                    style: StyleProjects().contentstyle1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row newControlButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 94, 175, 76),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () async {
            await SQLiteHelper().deleteAllData().then((value) => readSQLite());
          },
          child: Text(
            'ลบ',
            style: StyleProjects().topicstyle3,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 94, 175, 76),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              displayConfirmOrder = true;
              setState(() {});
            },
            child: Text(
              'สั่งซื้อ',
              style: StyleProjects().topicstyle3,
            )),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }

  Row newTotal() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConfigText(
                lable: 'รวมทั้งสิ้น : ',
                textStyle: StyleProjects().contentstyle5,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ConfigText(
            lable: '$total บาท',
            textStyle: StyleProjects().contentstyle5,
          ),
        ),
      ],
    );
  }

  Container showHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ConfigText(
              lable: 'ชื่อแบบพิมพ์',
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
            child: Center(
              child: ConfigText(
                lable: 'รวม',
                textStyle: StyleProjects().contentstyle5,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  ListView listCart() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 3,
            child: ConfigText(
              lable: sqliteModels[index].productname,
              textStyle: StyleProjects().contentstyle5,
            ),
          ),
          Expanded(
            flex: 1,
            child: ConfigText(
              lable: sqliteModels[index].price,
              textStyle: StyleProjects().contentstyle5,
            ),
          ),
          Expanded(
            flex: 1,
            child: ConfigText(
              lable: sqliteModels[index].quantity,
              textStyle: StyleProjects().contentstyle5,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ConfigText(
                lable: sqliteModels[index].sum,
                textStyle: StyleProjects().contentstyle5,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                await SQLiteHelper()
                    .deleteValueFromId(sqliteModels[index].id!)
                    .then((value) => readSQLite());
              },
              icon: const Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processSaveOrder() async {
    var mapOrders = <Map<String, dynamic>>[];
    for (var item in sqliteModels) {
      mapOrders.add(item.toMap());
    }

    Timestamp dateOrder = Timestamp.fromDate(DateTime.now());
    ordernumber = 'tdvp${Random().nextInt(1000000)}';

    OrderModel orderModel = OrderModel(
        ordertimes: dateOrder,
        ordernumber: ordernumber,
        productslists: mapOrders,
        status: 'รอดำเนินการ',
        ordertotal: total.toString(),
        payments: typePayment,
        logistics: typeTransfer,
        bankstatement: urlSlip,
        uidcustomer: uidcustomers.toString());

    DocumentReference reference =
        FirebaseFirestore.instance.collection('orders').doc();

    await reference.set(orderModel.toMap()).then((value) async {
      String docId = reference.id;
      print('## Save Order Success $docId');

      // ระบบตัด Stock และ Clear ตระกล้า

      for (var item in sqliteModels) {
        //await
        FirebaseFirestore.instance
            .collection('stock')
            .doc(item.docStock)
            .collection('products')
            .doc(item.docProduct)
            .get()
            .then((value) async {
          ProductModel productModel = ProductModel.fromMap(value.data()!);
          int newAmountProduct =
              productModel.quantity - int.parse(item.quantity);

          Map<String, dynamic> data = {};
          data['quantity'] = newAmountProduct;

          await FirebaseFirestore.instance
              .collection('stock')
              .doc(item.docStock)
              .collection('products')
              .doc(item.docProduct)
              .update(data)
              .then((value) {
            print('Success Update ${item.productname}');
          });
        });
      }

      await SQLiteHelper().deleteAllData().then((value) async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomerService(),
            ));
      });
    });
  }
}
