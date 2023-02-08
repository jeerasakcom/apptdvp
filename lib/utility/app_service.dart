import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tdvp/models/binding_book_model.dart';
import 'package:tdvp/models/format_paper_model.dart';
import 'package:tdvp/models/quantity_book_model.dart';
import 'package:tdvp/models/quantity_page_model.dart';
import 'package:tdvp/models/size_paper_model.dart';
import 'package:tdvp/models/type_print_model.dart';
import 'package:tdvp/utility/app_controller.dart';

class AppService {
  Future<void> readSizePapter() async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('sizePaper')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          SizePaperModel model = SizePaperModel.fromMap(element.data());
          appController.sizePaperModels.add(model);
        }
      }
    });
  }

  Future<void> readFormatPapter() async {
    AppController appController = Get.put(AppController());
    await FirebaseFirestore.instance
        .collection('formatPaper')
        .get()
        .then((value) {
      print('## value at readRormatPaper --> ${value.docs.length}');
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          FormatPaperModel model = FormatPaperModel.fromMap(element.data());
          print('## model at readFormatPaper --> ${model.toMap()}');
          appController.formatPaperModels.add(model);
        }
        print(
            '## appController.formatPaperModels ---> ${appController.formatPaperModels.length}');
      }
    });
  }

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
