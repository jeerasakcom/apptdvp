import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tdvp/controller/app_controller.dart';
import 'package:tdvp/models/binding_book_model.dart';
import 'package:tdvp/models/format_paper_model.dart';
import 'package:tdvp/models/quantity_book_model.dart';
import 'package:tdvp/models/quantity_page_model.dart';
import 'package:tdvp/models/size_paper_model.dart';
import 'package:tdvp/models/type_print_model.dart';

class AppService {
  Future<void> readQuantityPrint() async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('quantitypage')
        .orderBy('quantity', descending: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          QuantityPageModel model = QuantityPageModel.fromMap(element.data());
          appController.quantityPageModels.add(model);
        }
      }
    });
  }

  Future<void> readQuantityBook() async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('quantitybook')
        .orderBy('quantity', descending: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          QuantityBookModel model = QuantityBookModel.fromMap(element.data());
          appController.quantityBookModels.add(model);
        }
      }
    });
  }

  Future<void> readBindingBook() async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('bindingbook')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          BindingBookModel model = BindingBookModel.fromMap(element.data());
          appController.bindingBookModels.add(model);
        }
      }
    });
  }

  Future<void> readTypePrint() async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('typeprint')
        .orderBy('typeprint', descending: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          TypePrintModel model = TypePrintModel.fromMap(element.data());
          appController.typePrintModels.add(model);
        }
      }
    });
  }

  //
}
