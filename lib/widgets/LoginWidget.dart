import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab4_mis/widgets/ForgotPasswordPage.dart';

import '../model/utils.dart';


class LoginWidget extends StatefulWidget{

  final VoidCallback onClickSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickSignUp
}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}
class _LoginWidgetState extends State<LoginWidget>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
            child: CircularProgressIndicator()
        )
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e){
      print(e);
      Utils.showSnackBar(e.message);
    }

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(top: 120, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Calibri',
                    color: Color(0xFF2eb5e9)
                ),
              ),
              Image.asset('assets/images/flag.png', width: 70,
                  height: 100,
                  fit: BoxFit.cover
              ),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 4),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true ,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(0xFF2eb5e9)
                  ),
                  icon: Icon(Icons.lock_open, size: 32),
                  label: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: signIn
              ),
              SizedBox(height: 14),
              TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ForgotPasswordPage(),
                    ));
                  },
                  child: Text('Forgot Password?')
              ),

              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                    text: "No account?  ",
                    style: TextStyle(
                      color: Color(0xFF2eb5e9),
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickSignUp
                          ,
                          text: "Sign up",
                          style: TextStyle(color: Colors.redAccent, fontSize: 18)
                      )
                    ]
                ),
              )

            ],
          ),
        );

  }

}