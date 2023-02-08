import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayPriceSave extends StatefulWidget {
  const DisplayPriceSave({super.key});

  @override
  State<DisplayPriceSave> createState() => _DisplayPriceSaveState();
}

class _DisplayPriceSaveState extends State<DisplayPriceSave> {
  var datas = <String>[];
  bool load = true;

  @override
  void initState() {
    super.initState();
    findPriceSave();
  }

  Future<void> findPriceSave() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = preferences.getStringList('price');
    if (result != null) {
      datas.addAll(result);
    }
    load = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: load
          ? const Center(child: CircularProgressIndicator())
          : datas.isEmpty
              ? const Center(child: Text('No Price Save'))
              : Text(datas.toString()),
    );
  }
}
