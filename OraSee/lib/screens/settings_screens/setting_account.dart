import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swip_change/login.dart';
import 'package:swip_change/model/user_model.dart';

class SettingAccount extends StatefulWidget {
  const SettingAccount({super.key});

  @override
  State<SettingAccount> createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loginUser = UserModel();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then(
          (value) => {
            this.loginUser = UserModel.fromJson(value.data()),
            setState(() {}),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final AccountContainer = Container(
      width: width,
      height: height * 0.35,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: width,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: fnameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "${loginUser.firstName}",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: width,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: lnameController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "${loginUser.lastName}",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              readOnly: true,
              // validator: (){},
              decoration: InputDecoration(
                hintText: "${loginUser.email}",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                    width: 2,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              readOnly: true,
              // validator: (){},
              decoration: InputDecoration(
                hintText: "${loginUser.options}",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                    width: 2,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xff381BE9),
        ),
        title: Text(
          "Account Info",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final docUser =
                  FirebaseFirestore.instance.collection("users").doc(user!.uid);

              setState(() {
                //update
                docUser.update({
                  "firstName": fnameController.text,
                  "lastName": lnameController.text,
                }).then((value) => {
                      Fluttertoast.showToast(msg: "Update successful"),
                    });
              });
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Color(0xff381BE9),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                AccountContainer,
                SizedBox(
                  height: height * 0.1,
                ),
                SizedBox(
                  width: width,
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      final docUser = FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid);

                      // update specific field
                      docUser.delete().then((value) => {
                            Fluttertoast.showToast(msg: "Delete Successful"),
                          });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginPage(
                                option: "",
                              )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    child: Text(
                      "Delete User",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
