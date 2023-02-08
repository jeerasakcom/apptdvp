import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdvp/utility/style.dart';

class ResultAssessmentPage extends StatefulWidget {
  const ResultAssessmentPage({super.key});

  @override
  State<ResultAssessmentPage> createState() => _ResultAssessmentPageState();
}

class _ResultAssessmentPageState extends State<ResultAssessmentPage> {
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
      appBar: AppBar(
        backgroundColor: StyleProjects().baseColor,
      ),
      body: load
          ? const Center(child: CircularProgressIndicator())
          : datas.isEmpty
              ? const Center(child: Text('No Price Save'))
              // : Text(datas.toString()),

              : Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          color: StyleProjects().cardStream14,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                StyleProjects().boxTop2,
                                StyleProjects().header2(),
                                StyleProjects().boxTop2,
                                Center(
                                  child: Text(
                                    "ราคาประเมิน",
                                    style: StyleProjects().topicstyle4,
                                  ),
                                ),
                                StyleProjects().boxheight1,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "รูปแบบการพิมพ์ : ",
                                            //style: StyleProjects().topicstyle6,
                                            //style: StyleProjects().contentstyle5,
                                            //style: StyleProjects().contentstyle5,
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth2,
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              width: 150,
                                              child: Text(
                                                datas[0].toString(),
                                                style:
                                                    StyleProjects().topicstyle8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       datas[0].toString(),
                                      //       style: StyleProjects().topicstyle8,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "จำนวนหน้าทั้งหมด : ",
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            datas[1].toString(),
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            'หน้า',
                                            style: StyleProjects().topicstyle8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'วิธีการเข้าเล่ม : ',
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            datas[2].toString(),
                                            style: StyleProjects().topicstyle8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'จำนวนเล่มที่ต้องการ : ',
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            datas[3].toString(),
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            'เล่ม',
                                            style: StyleProjects().topicstyle8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'ราคาประเมิน : ',
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            datas[4].toString(),
                                            style: StyleProjects().topicstyle8,
                                          ),
                                          StyleProjects().boxwidth1,
                                          Text(
                                            'บาท',
                                            style: StyleProjects().topicstyle8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                StyleProjects().boxTop2,
                              ],
                            ),
                          ),
                        ),
                      ),
                   
                   
                   
                    ],
                  ),
                ),
    
    
    );
  }
}
