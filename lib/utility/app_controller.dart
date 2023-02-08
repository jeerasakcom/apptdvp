import 'package:get/get.dart';
import 'package:tdvp/models/binding_book_model.dart';
import 'package:tdvp/models/format_paper_model.dart';
import 'package:tdvp/models/quantity_book_model.dart';
import 'package:tdvp/models/quantity_page_model.dart';
import 'package:tdvp/models/size_paper_model.dart';
import 'package:tdvp/models/type_print_model.dart';

class AppController extends GetxController {
  RxList sizePaperModels = <SizePaperModel>[].obs;
  RxList chooseSizePaperModels = <SizePaperModel?>[null].obs;

  RxList formatPaperModels = <FormatPaperModel>[].obs;
  RxList chooseFormatPaperModels = <FormatPaperModel?>[null].obs;

  RxList bindingBookModels = <BindingBookModel>[].obs;
  RxList chooseBindingBookModels = <BindingBookModel?>[null].obs;

  RxList typePrintModels = <TypePrintModel>[].obs;
  RxList chooseTypePrintModels = <TypePrintModel?>[null].obs;

  RxList quantityPageModels = <QuantityPageModel>[].obs;
  RxList chooseQuantityPageModels = <QuantityPageModel?>[null].obs;

  RxList quantityBookModels = <QuantityBookModel>[].obs;
  RxList chooseQuantityBookModels = <QuantityBookModel?>[null].obs;

  RxDouble price = 0.0.obs;
}
