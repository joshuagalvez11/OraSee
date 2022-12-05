import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orasee/home.dart';
import 'package:orasee/login_phone/phone_verify_page.dart';
import 'package:orasee/model/user_model.dart';

class PhoneLoginPage extends StatefulWidget {
  final String option;
  PhoneLoginPage({super.key, required this.option});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xff381BE9),
                        ),
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                          color: Color(0xff381BE9),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    "Continue with Phone",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter your Phone Number");
                      }
                      // reg experssion
                      if (!RegExp(r'^.{12,}$').hasMatch(value)) {
                        return ("Please follow the format to input");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneController.text = value!;
                    },
                    decoration: InputDecoration(
                      hintText: "+1 234 567 8900",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  SizedBox(
                    width: width * 0.6,
                    height: height * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF381BE9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () {
                        SignUp();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
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

  void SignUp() async {
    if (_formKey.currentState!.validate()) {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: "Something Went Wrong" + e.toString());
        },
        codeSent: (String verificationId, int? token) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PhoneVerifyPage(
                    verificationId: verificationId,
                    token: token,
                    options: widget.option,
                    phone: phoneController.text,
                  )),
            ),
          );
        },
        codeAutoRetrievalTimeout: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong" + e.toString());
        },
      );
    }
  }
}
