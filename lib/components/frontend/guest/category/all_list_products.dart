import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/processbuy/show_add_cart.dart';
import 'package:tdvp/models/products_model.dart';
import 'package:tdvp/models/sqlite_helper.dart';
import 'package:tdvp/models/sqlite_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/dailog.dart';
import 'package:tdvp/utility/style.dart';

class AllListProducts extends StatefulWidget {
  final String idStock;
  const AllListProducts({
    Key? key,
    required this.idStock,
  }) : super(key: key);

  @override
  State<AllListProducts> createState() => _AllListProductsState();
}

class _AllListProductsState extends State<AllListProducts> {
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
      ),

      //
      body: load
          ? const ConfigProgress()
          /*
          : ListView.builder(
              itemCount: productModels.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: InkWell(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 1,
                      color: StyleProjects().cardStream15,
                      //color: StyleProjects().cardStream14,
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
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'รหัส ${productModels[index].id.toString()}',
                                      style: StyleProjects().topicstyle9,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),

                                    Text(
                                      'แบบ ${productModels[index].name.toString()}',
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

                                    // Text(
                                    //   'คงเหลือ ${productModels[index].quantity.toString()} เล่ม',
                                    //   style: StyleProjects().topicstyle9,
                                    //   softWrap: true,
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   textAlign: TextAlign.start,
                                    // ),
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
            ),

*/

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
                  ],
                );
              }),
            ),

      //
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
            //StyleProjects().boxTop2,
            StyleProjects().boxheight1,
            Text(
              "รายการแบบพิมพ์",
              style: StyleProjects().topicstyle2,
            ),
            StyleProjects().boxheight1,

            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: productModels.length,
              itemBuilder: (context, index) => Container(
                //padding: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Container(
                  child: InkWell(
                    // onTap: () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AllListProducts(
                    //       idStock: idStocks[index],
                    //     ),
                    //   ),
                    // ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 1,
                      //color: StyleProjects().cardStream2,
                      color: StyleProjects().cardStream14,
                      child: Container(
                        //height: 75,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Text(
                                      'หมวดหมู่ :',
                                      style: StyleProjects().topicstyle9,
                                    ),
                                    StyleProjects().boxwidth1,
                                    Container(
                                      width: 175,
                                      child: Text(
                                        productModels[index].name,
                                        style: StyleProjects().topicstyle9,
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget newContentRoll() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: productModels.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 1,
                    //color: Color.fromARGB(255, 136, 223, 161),
                    color: StyleProjects().cardStream2,
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
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: 150,
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'รหัส ${productModels[index].id.toString()}',
                                      style: StyleProjects().topicstyle9,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      'แบบ ${productModels[index].name.toString()}',
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
          ],
        );
      }),
    );
  }
}
