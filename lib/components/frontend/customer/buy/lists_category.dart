import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/buy/list_product_where_category.dart';
import 'package:tdvp/components/frontend/customer/buy/process_cart.dart';
import 'package:tdvp/models/stock_model.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/style.dart';

class ListCategoryPage extends StatefulWidget {
  const ListCategoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ListCategoryPage> createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  String? idDocUser;
  bool load = true;
  bool? haveProduct;
  var stockModels = <StockModel>[];
  var idStocks = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProduct();
  }

  Future<void> readProduct() async {
    await FirebaseFirestore.instance
        .collection('stock')
        .orderBy('id', descending: false)
        .get()
        .then((value) {
      print('value ==>> ${value.docs}');

      if (value.docs.isEmpty) {
        haveProduct = false;
      } else {
        haveProduct = true;
        for (var item in value.docs) {
          StockModel stockModel = StockModel.fromMap(item.data());
          stockModels.add(stockModel);

          idStocks.add(item.id);
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
        actions: [ProcessCart()],
        backgroundColor: StyleProjects().primaryColor,
        title: Text(
          'หมวดหมู่',
          style: StyleProjects().topicstyle3,
        ),
      ),
      body: load
          ? const ConfigProgress()
          : haveProduct!
              // ? ListView.builder(
              //     itemCount: stockModels.length,
              //     itemBuilder: (context, index) => InkWell(
              //       onTap: () => Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => ShowListProductWhereCat(
              //               idStock: idStocks[index],
              //             ),
              //           )),
              //       child: Card(
              //         child: Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: ConfigText(lable: stockModels[index].category),
              //         ),
              //       ),
              //     ),
              //   )
              ? newContent()
              : Center(
                  child: ConfigText(
                    lable: 'ไม่มีหมวดหมู่แบบพิมพ์',
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
            //StyleProjects().boxTop2,
            StyleProjects().boxheight1,
            Text(
              "หมวดหมู่แบบพิมพ์",
              style: StyleProjects().topicstyle2,
            ),
            StyleProjects().boxheight1,

            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: stockModels.length,
              itemBuilder: (context, index) => Container(
                //padding: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Container(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListProductsWhereCategory(
                          idStock: idStocks[index],
                        ),
                      ),
                    ),
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
                            // Image.network(
                            //   stockModels[index].images!,
                            //   //width: 80,
                            //   height: 50,
                            // ),
                            // Expanded(
                            //   flex: 1,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: SizedBox(
                            //       width: 80,
                            //       height: 100,
                            //       child: Image.network(
                            //         stockModels[index].images!,
                            //         fit: BoxFit.cover,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
                                    // Text(
                                    //   stockModels[index].id.toString(),
                                    //   style: StyleProjects().topicstyle9,
                                    //   softWrap: true,
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   textAlign: TextAlign.start,
                                    // ),
                                    // StyleProjects().boxwidth2,
                                    // ignore: avoid_unnecessary_containers
                                    Container(
                                      width: 175,
                                      child: Text(
                                        stockModels[index].category,
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
                            // Text(
                            //   stockModels[index].category,
                            //   style: StyleProjects().topicstyle9,
                            // ),
                          ],
                        ),
                      ),

                      //child: ConfigText(lable: stockModels[index].category),

                      // child: Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: ConfigText(lable: stockModels[index].category),
                      // ),

                      //
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
