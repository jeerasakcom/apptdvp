import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/profile/customer_dataprofile.dart';
import 'package:tdvp/models/users_model.dart';
import 'package:tdvp/utility/config_edit_form.dart';
import 'package:tdvp/utility/style.dart';

class UpdateProfileCustomer extends StatefulWidget {
  final UserModel userModel;
  const UpdateProfileCustomer({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UpdateProfileCustomer> createState() => _UpdateProfileCustomerState();
}

class _UpdateProfileCustomerState extends State<UpdateProfileCustomer> {
  String? address, phone;
  String? fname, lname;

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  UserModel? userModel;
  Map<String, dynamic> map = {};
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    fnameController.text = userModel!.fname!;
    lnameController.text = userModel!.lname!;
    addressController.text = userModel!.address!;
    phoneController.text = userModel!.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleProjects().primaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ConfigEditForm(
                  textEditingController: fnameController,
                  label: 'ชื่อ :',
                  myValidate: fnameValidate,
                  mySave: fnameSave),
              ConfigEditForm(
                  textEditingController: lnameController,
                  label: 'นามสกุล :',
                  myValidate: lnameValidate,
                  mySave: lnameSave),
              ConfigEditForm(
                  textEditingController: addressController,
                  label: 'ที่อยู่ :',
                  myValidate: addressValidate,
                  mySave: addressSave),
              ConfigEditForm(
                  textEditingController: phoneController,
                  label: 'เบอร์โทร :',
                  myValidate: phoneValidate,
                  mySave: phoneSave),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    print('map ====>>> $map');

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update(map)
                        .then(
                          (value) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustomerReaderProfilePage(),
                            ),
                          ),
                        );
                  }
                },
                child: const Text('แก้ไขข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fnameSave(String? string) {
    fname = string!.trim();
    map['fname'] = fname;
  }

  String? fnameValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกชื่อ';
    } else {
      return null;
    }
  }

  void lnameSave(String? string) {
    lname = string!.trim();
    map['fname'] = lname;
  }

  String? lnameValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกชื่อ';
    } else {
      return null;
    }
  }

  void addressSave(String? string) {
    address = string!.trim();
    map['address'] = address;
  }

  String? addressValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกที่อยู่';
    } else {
      return null;
    }
  }

  void phoneSave(String? string) {
    phone = string!.trim();
    map['phone'] = phone;
  }

  String? phoneValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกเบอร์โทร';
    } else {
      return null;
    }
  }
}
