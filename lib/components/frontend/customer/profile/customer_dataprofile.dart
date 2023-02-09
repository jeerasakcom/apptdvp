import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/profile/customer_updateprofile.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_avatar.dart';
import 'package:tdvp/utility/config_form.dart';
import 'package:tdvp/utility/config_progress.dart';
import 'package:tdvp/utility/config_text.dart';
import 'package:tdvp/utility/config_text_button.dart';
import 'package:tdvp/utility/config_title.dart';
import 'package:tdvp/utility/dailog.dart';
import 'package:tdvp/utility/style.dart';

class CustomerReaderProfilePage extends StatefulWidget {
  const CustomerReaderProfilePage({Key? key}) : super(key: key);

  @override
  State<CustomerReaderProfilePage> createState() =>
      _CustomerReaderProfilePageState();
}

class _CustomerReaderProfilePageState extends State<CustomerReaderProfilePage> {
  var user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool load = true;
  bool? haveData;
  var userModels = <UserModel>[];
  var docIdUsers = <String>[];

  @override
  void initState() {
    super.initState();
    readProfile();
  }

  Future<void> readProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        load = false;
        userModel = UserModel.fromMap(value.data()!);
        print('userModel ==> ${userModel!.toMap()}');
      });
    });
  }

  Future<void> readDataProfile() async {
    if (userModels.isNotEmpty) {
      userModels.clear();
      docIdUsers.clear();
    }
    await FirebaseFirestore.instance
        .collection('users')
        .where("level", isEqualTo: "admin")
        .get()
        .then((value) {
      print('value ==> ${value.docs}');
      load = false;

      if (value.docs.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
        for (var item in value.docs) {
          UserModel userModel = UserModel.fromMap(item.data());
          userModels.add(userModel);
          docIdUsers.add(item.id);
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const UpdateProfileCustomer(),
      //         )).then((value) {
      //       readProfile();
      //     });
      //   },
      //   backgroundColor: Colors.amber,
      //   //backgroundColor: StyleProjects().baseColor,
      //   child: const Icon(Icons.edit),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

      // backgroundColor: StyleProjects().backgroundState,
      /*
      body: load
          ? const Center(child: ConfigProgress())
    
    
    
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StyleProjects().boxTop2,
                  const Center(
                    child: ConfigTitle(
                      title: 'ข้อมูลส่วนบุคคลลูกค้า',
                    ),
                  ),
                  StyleProjects().boxheight1,
                  AvatarView(
                    radius: 75,
                    borderWidth: 8,
                    // borderColor: Color(0xff033674),
                    borderColor: const Color(0xfff8d800),
                    avatarType: AvatarType.CIRCLE,
                    backgroundColor: Colors.red,
                    imagePath: userModel!.images!,
                    placeHolder: const Icon(
                      Icons.person,
                      size: 50,
                    ),
                    errorWidget: Container(
                      child: const Icon(
                        Icons.error,
                        size: 50,
                      ),
                    ),
                  ),

                  /*
                  ConfigAvatar(
                    urlImage: userModel!.images!,
                    size: 75,
                  ),
                  */

                  StyleProjects().boxTop2,
                  newLabel(head: 'ชื่อ :', value: userModel!.fname!),
                  newLabel(head: 'นามสกุล :', value: userModel!.lname!),
                  newLabel(head: 'ที่อยู่ :', value: userModel!.address!),
                  newLabel(head: 'ตำบล :', value: userModel!.subdistrict!),
                  newLabel(head: 'อำเภอ :', value: userModel!.district!),
                  newLabel(head: 'จังหวัด :', value: userModel!.province!),
                  newLabel(head: 'รหัสไปรษณีย์ :', value: userModel!.zipcode!),
                  newLabel(head: 'เบอร์โทรศัพท์ :', value: userModel!.phone!),
                  newLabel(head: 'Email :', value: userModel!.email!),
                ],
              ),
            ),
   */

      //
      body: SingleChildScrollView(
        child: Column(
          children: [
            StyleProjects().boxTop2,
            StyleProjects().header2(),
            StyleProjects().boxheight1,
            Text(
              "ข้อมูลส่วนบุคคลลูกค้า",
              style: StyleProjects().topicstyle2,
            ),
            StyleProjects().boxheight1,
            load ? const ConfigProgress() : newContent()
          ],
        ),
      ),

      //
    );
  }

  Row newLabel({required String head, required String value}) {
    return Row(
      children: [
        // Expanded(
        //   flex: 2,
        //   child: ConfigText(
        //     lable: head,
        //     //textStyle: StyleProjects().contentstyle2,
        //     textStyle: StyleProjects().topicstyle9,
        //   ),
        // ),
        // Expanded(
        //   flex: 3,
        //   child: ConfigText(
        //     lable: value,
        //     //textStyle: StyleProjects().contentstyle2,
        //     textStyle: StyleProjects().topicstyle9,
        //   ),
        // ),

        Expanded(
          flex: 1,
          child: Text(
            head,
            style: StyleProjects().topicstyle9,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: StyleProjects().topicstyle9,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  //
  Widget newContent() {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constarints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AvatarView(
                    radius: 75,
                    borderWidth: 8,
                    // borderColor: Color(0xff033674),
                    borderColor: const Color(0xfff8d800),
                    avatarType: AvatarType.CIRCLE,
                    backgroundColor: Colors.red,
                    imagePath: userModel!.images!,
                    placeHolder: const Icon(
                      Icons.person,
                      size: 50,
                    ),
                    errorWidget: Container(
                      child: const Icon(
                        Icons.error,
                        size: 50,
                      ),
                    ),
                  ),
                  StyleProjects().boxTop2,
                  newLabel(head: 'ชื่อ :', value: userModel!.fname!),
                  newLabel(head: 'นามสกุล :', value: userModel!.lname!),
                  newLabel(head: 'ที่อยู่ :', value: userModel!.address!),
                  newLabel(head: 'ตำบล :', value: userModel!.subdistrict!),
                  newLabel(head: 'อำเภอ :', value: userModel!.district!),
                  newLabel(head: 'จังหวัด :', value: userModel!.province!),
                  newLabel(head: 'รหัสไปรษณีย์ :', value: userModel!.zipcode!),
                  newLabel(head: 'เบอร์โทรศัพท์ :', value: userModel!.phone!),
                  newLabel(head: 'Email :', value: userModel!.email!),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       ElevatedButton(
            //           onPressed: () {
            //             StyleDialog(context: context).actionDialog(
            //                 title: 'ยืนยันการแก้ไข',
            //                 message: 'คุณต้องการแก้ไข ?',
            //                 label1: 'แก้ไข',
            //                 label2: 'ยกเลิก',
            //                 presFunc1: () {
            //                   print('==>> ${docIdUsers}');
            //                   // processUpdateDataProfile(docIdUsers: '');

            //                   Navigator.pop(context);
            //                 },
            //                 presFunc2: () {
            //                   Navigator.pop(context);
            //                 });
            //           },
            //           child: Text("ปรับปรุงข้อมูล"))
            //     ],
            //   ),
            // ),
          ],
        );
      }),
    );
  }

  //
  Future<void> processUpdateDataProfile({required String docIdUsers}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docIdUsers)
        .get()
        .then((value) async {
      UserModel userModel = UserModel.fromMap(value.data()!);
      TextEditingController phoneController = TextEditingController();
      phoneController.text = userModel.phone.toString();

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: ListTile(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userModel.email.toString(),
                style: StyleProjects().topicstyle4,
              ),
            ],
          )),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ConfigForm2(
                    textInputType: TextInputType.number,
                    controller: phoneController,
                    label: 'เบอร์โทร',
                    iconData: Icons.phone_callback_outlined,
                    changeFunc: (String string) {}),
              ],
            ),
          ),
          actions: [
            ConfigTextButton(
              label: 'แก้ไข',
              pressFunc: () async {
                Navigator.pop(context);

                String newphone = (phoneController.text);

                Map<String, dynamic> map = userModel.toMap();

                map['phone'] = newphone;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(docIdUsers)
                    .update(map)
                    .then((value) {
                  readDataProfile();
                });
              },
            ),
            ConfigTextButton(
              label: 'ยกเลิก',
              pressFunc: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    });
  }
}
