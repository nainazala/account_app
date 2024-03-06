import 'package:account_app/ModelClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {


  TextEditingController txttitle = TextEditingController();
  TextEditingController txtamount = TextEditingController();
  TextEditingController txtdate = TextEditingController();
  DateTime? selectDate ;
  var trascationList = <ModelClass>[].obs;
  final formkey = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}