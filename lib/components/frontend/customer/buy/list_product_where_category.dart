import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/buy/process_cart.dart';

import 'package:tdvp/models/products_model.dart';
import 'package:tdvp/models/sqlite_helper.dart';
import 'package:tdvp/models/sqlite_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/dailog.dart';
import 'package:tdvp/utility/style.dart';

class ListProductsWhereCategory extends StatefulWidget {
  final String idStock;
  const ListProductsWhereCategory({
    Key? key,
    required this.idStock,
  }) : super(key: key);

  @override
  State<ListProductsWhereCategory> createState() =>
      _ListProductsWhereCategoryState();
}

class _ListProductsWhereCategoryState extends State<ListProductsWhereCategory> {
  String? idStock, idDocUser;
  var productModels = <ProductModel>[];
  var docProducts = <String>[];
  bool load = true;
  bool? haveProducts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idStock = widget.idStock;
    print('idStock ==>> $idStock');
    readAllProduct();
  }

  Future<void> readAllProduct() async {
    // await
    FirebaseFirestore.instance
        .collection('stock')
        .doc(idStock)
        .collection('products')
        .orderBy('id', descending: false)
        .get()
        .then((value) {
      for (var item in value.docs) {
        ProductModel productModel = ProductModel.fromMap(item.data());
        productModels.add(productModel);
        docProducts.add(item.id);
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
        title: Text(
          'รายการแบบพิมพ์',
          style: StyleProjects().topicstyle3,
        ),
        actions: [
          ProcessCart(callBackFunc: () {
            print('Call Back Work');
            readAllProduct();
          }),
        ],
      ),
      body: load
          ? const ConfigProgress()
          : SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constarints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StyleProjects().boxTop2,
                    StyleProjects().header2(),
                    StyleProjects().boxheight1,
                    Text(
                      "รายการแบบพิมพ์",
                      style: StyleProjects().topicstyle2,
                    ),
                    StyleProjects().boxheight1,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: productModels.length,
                        itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () => dialogAddCart(
                                productModels[index], docProducts[index]),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 1,
                              //color: Color.fromARGB(255, 136, 223, 161),
                              color: StyleProjects().cardStream12,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: 80,
                                          height: 100,
                                          margin: const EdgeInsets.all(8),
                                          child: Image.network(
                                            productModels[index].images,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          // width: 150,
                                          // height: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รหัสแบบพิมพ์ ${productModels[index].id.toString()}',
                                                style:
                                                    StyleProjects().topicstyle9,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'แบบพิมพ์ ${productModels[index].name.toString()}',
                                                style:
                                                    StyleProjects().topicstyle9,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'ราคา ${productModels[index].price.toString()} บาท',
                                                style:
                                                    StyleProjects().topicstyle9,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                'จำนวนคงเหลือ ${productModels[index].quantity.toString()}',
                                                style:
                                                    StyleProjects().topicstyle9,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
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
            ),
    );
  }

  Future<void> dialogAddCart(
      ProductModel productModel, String docProduct) async {
    int chooseProduct = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: ListTile(
            title: Center(
              child: ConfigText(
                lable: productModel.name,
                textStyle: StyleProjects().topicstyle4,
              ),
            ),
            subtitle: Column(
              children: [
                ConfigText(
                  lable: 'ราคา ${productModel.price.toString()} บาท',
                  textStyle: StyleProjects().topicstyle4,
                ),
                ConfigText(
                  lable:
                      'จำนวนคงเหลือ ${productModel.quantity.toString()} เล่ม',
                  textStyle: StyleProjects().topicstyle4,
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        if (chooseProduct < productModel.quantity) {
                          chooseProduct++;
                          print('chooseProduct ==>> $chooseProduct');
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_circle)),
                  ConfigText(
                    lable: '$chooseProduct',
                    textStyle: StyleProjects().topicstyle4,
                  ),
                  IconButton(
                      onPressed: () {
                        if (chooseProduct > 1) {
                          chooseProduct--;
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.remove_circle)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await SQLiteHelper().readAllData().then((value) {
                  var sqliteModels = <SQLiteModel>[];
                  sqliteModels = value;
                  processAddCart(productModel, chooseProduct, docProduct);
                });
              },
              child: Text(
                'เพิ่มลงตะกร้า',
                style: StyleProjects().topicstyle9,
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: StyleProjects().topicstyle9,
                )),
          ],
        );
      }),
    );
  }

  Future<void> processAddCart(
      ProductModel productModel, int chooseProduct, String docProduct) async {
    print('add ==> ${productModel.name} chooseProduct ==> $chooseProduct');

    SQLiteModel sqLiteModel = SQLiteModel(
      productname: productModel.name,
      price: productModel.price.toString(),
      quantity: chooseProduct.toString(),
      sum: (productModel.price * chooseProduct).toString(),
      docProduct: docProduct,
      docStock: idStock!,
    );

    await SQLiteHelper().insertValueToSQLite(sqLiteModel).then((value) =>
        normalDialogOn(context, 'เพิ่ม ${productModel.name} สำเร็จคะ'));

    //
  }

  ///
  Widget newContent() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyleProjects().boxTop2,
            StyleProjects().header2(),
            //StyleProjects().boxTop2,
            StyleProjects().boxheight1,
            Text(
              "รายการแบบพิมพ์",
              style: StyleProjects().topicstyle2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                itemCount: productModels.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () =>
                      dialogAddCart(productModels[index], docProducts[index]),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 50,
                              height: 100,
                              margin: const EdgeInsets.all(10),
                              child: Image.network(
                                productModels[index].images,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 50,
                          //   height: 100,
                          //   margin: const EdgeInsets.all(10),
                          //   child: Image.network(
                          //     productModels[index].images,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productModels[index].name,
                                    style: StyleProjects().topicstyle9,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'ราคา ${productModels[index].price.toString()} บาท',
                                    style: StyleProjects().topicstyle9,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    'คงเหลือ ${productModels[index].quantity.toString()} เล่ม',
                                    style: StyleProjects().topicstyle9,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          )
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
