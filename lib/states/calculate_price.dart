import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdvp/utility/app_controller.dart';
import 'package:tdvp/utility/app_service.dart';
import 'package:tdvp/utility/style.dart';

class CalculatePrice extends StatefulWidget {
  const CalculatePrice({super.key});

  @override
  State<CalculatePrice> createState() => _CalculatePriceState();
}

class _CalculatePriceState extends State<CalculatePrice> {
  @override
  void initState() {
    super.initState();
    AppService().readQuantityPrint();
    AppService().readQuantityBook();
    AppService().readBindingBook();
    AppService().readTypePrint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                // '## aPrintModel ---> ${appController.typePrintModels.length}');
                '## PrintModel ---> ${appController.quantityBookModels.length}');
            return ((appController.typePrintModels.isEmpty) ||
                    (appController.quantityPageModels.isEmpty) ||
                    (appController.bindingBookModels.isEmpty) ||
                    (appController.quantityBookModels.isEmpty))
                ? const SizedBox()
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    children: [
                      // displayItem(
                      //   head: 'ขนาดกระดาษ',
                      //   widget: dropdownSizePaper(appController: appController),
                      // ),
                      // displayItem(
                      //   head: 'รูปแบบกระดาษ',
                      //   widget:
                      //       dropdownFormatPaper(appController: appController),
                      // ),
                      displayItem(
                        head: 'รูปแบบการพิมพ์',
                        widget: dropdownTypePrint(appController: appController),
                      ),
                      displayItem(
                        head: 'จำนวนหน้าทั้งหมด',
                        widget:
                            dropdownQuantityPage(appController: appController),
                      ),
                      displayItem(
                        head: 'วิธีการเข้าเล่ม',
                        widget:
                            dropdownBindingBook(appController: appController),
                      ),
                      displayItem(
                        head: 'จำนวนเล่มที่ต้องการ',
                        widget:
                            dropdownQuantityBook(appController: appController),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (appController
                                        .chooseTypePrintModels.length ==
                                    1) {
                                  Get.snackbar('รูปแบบการพิมพ์ ?',
                                      'กรุณาเลือกรูปแบบการพิมพ์ ด้วยคะ');
                                } else if (appController
                                        .chooseQuantityPageModels.length ==
                                    1) {
                                  Get.snackbar('จำนวนหน้า ?',
                                      'กรุณาเลือกจำนวนหน้า ด้วยคะ');
                                } else if (appController
                                        .chooseBindingBookModels.length ==
                                    1) {
                                  Get.snackbar('วิธีการเข้าเล่ม ?',
                                      'กรุณาเลือกวิธีการเข้าเล่ม ด้วยคะ');
                                } else if (appController
                                        .chooseQuantityBookModels.length ==
                                    1) {
                                  Get.snackbar('จำนวนเล่ม ?',
                                      'กรุณาเลือกจำนวนเล่ม ด้วยคะ');
                                } else {
                                  double factorTypePrintDou = double.parse(
                                      appController
                                          .chooseTypePrintModels.last.factor);
                                  double quantityPageDou = double.parse(
                                      appController.chooseQuantityPageModels
                                          .last.quantity
                                          .toString());
                                  double factorBindingBookDou = double.parse(
                                      appController
                                          .chooseBindingBookModels.last.factor);
                                  double quantityBookDou = double.parse(
                                      appController.chooseQuantityBookModels
                                          .last.quantity
                                          .toString());
                                  double price = factorTypePrintDou *
                                          quantityPageDou +
                                      factorBindingBookDou * quantityBookDou;
                                  print('## price ---> $price');
                                  appController.price.value = price;
                                }
                              },
                              child: Text('Calculate')),
                          Text(appController.price.value.toString())
                        ],
                      ),
                      appController.price.value == 0.0
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () async {
                                var datas = <String>[];

                                datas.add(appController
                                    .chooseTypePrintModels.last.typeprint);

                                datas.add(appController
                                    .chooseQuantityPageModels.last.quantity
                                    .toString());
                                datas.add(appController
                                    .chooseBindingBookModels.last.bindingbook);
                                datas.add(appController
                                    .chooseQuantityBookModels.last.quantity
                                    .toString());
                                datas.add(appController.price.toString());

                                print('datas ---> $datas');

                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences
                                    .setStringList('price', datas)
                                    .then((value) {
                                  Get.snackbar('Save Success', 'Save Success');

                                  appController.chooseTypePrintModels.clear();
                                  appController.chooseTypePrintModels.add(null);

                                  appController.chooseQuantityPageModels
                                      .clear();
                                  appController.chooseQuantityPageModels
                                      .add(null);

                                  appController.chooseBindingBookModels.clear();
                                  appController.chooseBindingBookModels
                                      .add(null);

                                  appController.chooseQuantityBookModels
                                      .clear();
                                  appController.chooseQuantityBookModels
                                      .add(null);

                                  appController.price.value = 0.0;
                                });
                              },
                              child: const Text('Save'),
                            ),
                    ],
                  );
          }),
    );
  }

  Row displayItem({
    required String head,
    required Widget widget,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(head),
        ),
        Expanded(
          flex: 3,
          child: widget,
        ),
      ],
    );
  }

  // DropdownButton<Object> dropdownSizePaper(
  //     {required AppController appController}) {
  //   return DropdownButton(
  //     isExpanded: true,
  //     items: appController.sizePaperModels
  //         .map(
  //           (element) => DropdownMenuItem(
  //             child: Text(element.size),
  //             value: element,
  //           ),
  //         )
  //         .toList(),
  //     onChanged: (value) {
  //       appController.chooseSizePaperModels.add(value);
  //     },
  //     value: appController.chooseSizePaperModels.last,
  //     hint: const Text('โปรดเลือกขนาดกระดาษ'),
  //   );
  // }

  // DropdownButton<Object> dropdownFormatPaper(
  //     {required AppController appController}) {
  //   return DropdownButton(
  //     isExpanded: true,
  //     items: appController.formatPaperModels
  //         .map(
  //           (element) => DropdownMenuItem(
  //             child: Text(element.paper),
  //             value: element,
  //           ),
  //         )
  //         .toList(),
  //     onChanged: (value) {
  //       appController.chooseFormatPaperModels.add(value);
  //     },
  //     value: appController.chooseFormatPaperModels.last,
  //     hint: const Text('เลือกรูปแบบกระดาษ'),
  //   );
  // }

  DropdownButton<Object> dropdownFormatPaper(
      {required AppController appController}) {
    return DropdownButton(
      isExpanded: true,
      items: appController.formatPaperModels
          .map(
            (element) => DropdownMenuItem(
              child: Text(
                element.paper,
                style: StyleProjects().contentstyle5,
              ),
              value: element,
            ),
          )
          .toList(),
      onChanged: (value) {
        appController.chooseFormatPaperModels.add(value);
      },
      value: appController.chooseFormatPaperModels.last,
      hint: const Text('เลือกรูปแบบกระดาษ'),
    );
  }

  DropdownButton<Object> dropdownQuantityPage(
      {required AppController appController}) {
    return DropdownButton(
      isExpanded: true,
      items: appController.quantityPageModels
          .map(
            (element) => DropdownMenuItem(
              child: Text(
                element.quantity.toString(),
                style: StyleProjects().contentstyle5,
              ),
              value: element,
            ),
          )
          .toList(),
      onChanged: (value) {
        appController.chooseQuantityPageModels.add(value);
      },
      value: appController.chooseQuantityPageModels.last,
      hint: Text(
        'เลือกจำนวนหน้า',
        style: StyleProjects().contentstyle8,
      ),
    );
  }

  DropdownButton<Object> dropdownQuantityBook(
      {required AppController appController}) {
    return DropdownButton(
      isExpanded: true,
      items: appController.quantityBookModels
          .map(
            (element) => DropdownMenuItem(
              child: Text(
                element.quantity.toString(),
                style: StyleProjects().contentstyle5,
              ),
              value: element,
            ),
          )
          .toList(),
      onChanged: (value) {
        appController.chooseQuantityBookModels.add(value);
      },
      value: appController.chooseQuantityBookModels.last,
      hint: Text(
        'เลือกจำนวนเล่ม',
        style: StyleProjects().contentstyle8,
      ),
    );
  }

  DropdownButton<Object> dropdownBindingBook(
      {required AppController appController}) {
    return DropdownButton(
      isExpanded: true,
      items: appController.bindingBookModels
          .map(
            (element) => DropdownMenuItem(
              child: Text(
                element.bindingbook,
                style: StyleProjects().contentstyle5,
              ),
              value: element,
            ),
          )
          .toList(),
      onChanged: (value) {
        appController.chooseBindingBookModels.add(value);
      },
      value: appController.chooseBindingBookModels.last,
      hint: Text(
        'เลือกวิธีการเข้าเล่ม',
        style: StyleProjects().contentstyle8,
      ),
    );
  }

  DropdownButton<Object> dropdownTypePrint(
      {required AppController appController}) {
    return DropdownButton(
      isExpanded: true,
      items: appController.typePrintModels
          .map(
            (element) => DropdownMenuItem(
              child: Text(
                element.typeprint,
                style: StyleProjects().contentstyle5,
              ),
              value: element,
            ),
          )
          .toList(),
      onChanged: (value) {
        appController.chooseTypePrintModels.add(value);
      },
      value: appController.chooseTypePrintModels.last,
      hint: Text(
        'เลือกรูปแบบการพิมพ์',
        style: StyleProjects().contentstyle8,
      ),
    );
  }

  //
}
