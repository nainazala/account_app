import 'dart:convert';

import 'package:account_app/ModelClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'HomeController.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text("Personal Expenses"), actions: [
          IconButton(
            onPressed: () {
              buttomSheet(context);
            },
            icon: Icon(Icons.add),
          )
        ]),
        body: controller.trascationList.length==0?Center(child: Text("No Trascation added yet!"),): ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: controller.trascationList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 25,
                  child: FittedBox(
                      child:
                          Text("₹" + controller.trascationList[index].amount)),
                ),
                title: Text(controller.trascationList[index].title),
                subtitle: Text(DateFormat("MMM dd, yyyy")
                    .format(controller.trascationList[index].date!)),
                trailing: IconButton(
                  onPressed: () {
                    showAlertDialog(context,index);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
          onPressed: () {
            buttomSheet(context);
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, int index) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure you want to delete!"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                controller.trascationList.removeAt(index);
                controller.trascationList.refresh();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  buttomSheet(BuildContext context) {
    controller.txttitle.text = "";
    controller.txtamount.text = "";
    controller.txtdate.text = "";
    controller.selectDate = null;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: controller.formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.txttitle,
                        decoration: InputDecoration(hintText: "Enter Title"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: controller.txtamount,
                        decoration: InputDecoration(hintText: "Enter Amount"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(controller.selectDate == null
                              ? "No Date Chosen!"
                              : controller.txtdate.text),
                          TextButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                    2019,
                                  ),
                                  lastDate: DateTime(2025),
                                ).then((selectedDate) {
                                  //TODO: handle selected date
                                  if (selectedDate != null) {
                                    controller.selectDate = selectedDate;
                                    controller.txtdate.text =
                                        DateFormat("MMM dd, yyyy")
                                            .format(selectedDate);
                                    setState(() {});
                                  }
                                });
                              },
                              child: Text(
                                "Chose Date",
                                style: TextStyle(color: Colors.purple),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: () {
                              if (!controller.formkey.currentState!
                                      .validate() ||
                                  controller.selectDate == null) {
                                if (controller.selectDate == null) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: "Please selete Date",
                                  ));
                                }
                                return;
                              }
                              controller.formkey.currentState!.save();
                              ModelClass model = ModelClass(
                                  controller.txttitle.text,
                                  controller.txtamount.text,
                                  controller.selectDate);
                              controller.trascationList.add(model);
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add Transcation"),
                            )),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
