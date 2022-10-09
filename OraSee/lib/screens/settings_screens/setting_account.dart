import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swip_change/email_login.dart';
import 'package:swip_change/landing.dart';
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
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    bool firstName = false;
    bool lastName = false;
    bool email = false;
    bool phone = false;

    if (loginUser.firstName == null) {
      firstName = true;
    }

    if (loginUser.lastName == null) {
      lastName = true;
    }

    if (loginUser.email == null) {
      email = true;
    }

    if (loginUser.phone == null) {
      phone = true;
    }

    final AccountContainer = Container(
      width: width,
      height: phone ? height * 0.4 : height * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: width,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: fnameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{3,}$');

                  if (value!.isEmpty) {
                    return ("First Name cannot be empty");
                  }

                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Name (Min 3 chars)");
                  }

                  return null;
                },
                onSaved: (value) {
                  fnameController.text = value!;
                },
                decoration: InputDecoration(
                  hintText: firstName ? "FirstName" : "${loginUser.firstName}",
                  // hintText: "FirstName",
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
              child: TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: lnameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Last Name cannot be empty");
                  }

                  return null;
                },
                onSaved: (value) {
                  lnameController.text = value!;
                },
                decoration: InputDecoration(
                  hintText: lastName ? "LastName" : "${loginUser.lastName}",
                  // hintText: "FirstName",
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
            TextFormField(
              autofocus: false,
              readOnly: email ? false : true,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!phone) {
                  if (value!.isEmpty) {
                    return ("Please Enter your Email");
                  }
                  // reg experssion
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return ("Please Enter a Vaild email");
                  }
                }
                return null;
              },
              onSaved: (value) {
                emailController.text = value!;
              },
              decoration: InputDecoration(
                hintText: email ? "Email" : "${loginUser.email}",
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
              height: 15,
            ),
            phone
                ? Container()
                : TextField(
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "${loginUser.phone}",
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
            phone
                ? Container()
                : SizedBox(
                    height: 15,
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
              if (_formKey.currentState!.validate()) {
                final docUser = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid);

                //update
                docUser
                    .update({
                      "firstName": fnameController.text,
                      "lastName": lnameController.text,
                      "email": emailController.text
                    })
                    .then((value) => {
                          Fluttertoast.showToast(msg: "Update successful"),
                          setState(() {})
                        })
                    .catchError((e) {
                      Fluttertoast.showToast(
                          msg: "Update Error" + e.toString());
                    });
              }
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
            child: Form(
              key: _formKey,
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
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Landing()));
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
      ),
    );
  }
}
