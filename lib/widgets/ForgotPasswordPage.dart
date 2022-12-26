import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lab4_mis/widgets/LoginWidget.dart';

import '../model/utils.dart';

class ForgotPasswordPage extends StatefulWidget{
    @override
    _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}
class _ForgotPasswordPageState extends State<ForgotPasswordPage>{
   final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();

    super.dispose();
  }
  
  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
            child: CircularProgressIndicator()
        )
    );

    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
    } on FirebaseAuthException catch(e){
      print(e);

      Utils.showSnackBar(e.message);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 120, left: 15, right: 15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please enter your email and click on the button:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Calibri',
                        color: Color(0xFF2eb5e9)
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: Color(0xFF2eb5e9)
                    ),
                    icon: Icon(Icons.email_outlined, size: 32),
                    label: Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: resetPassword,
                  ),
                ],
              ),
            )

        ),
      )
    );

  }
  

}
