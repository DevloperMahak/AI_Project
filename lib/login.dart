import 'dart:convert';
import 'package:ask_my_tutor/home.dart';
import 'package:ask_my_tutor/main_screen.dart';
import 'package:ask_my_tutor/signUp.dart';
import 'package:ask_my_tutor/uihelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<LoginPage>createState()=>LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController EmailText=TextEditingController();
  TextEditingController PasswordNum=TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref()async{
    prefs = await SharedPreferences.getInstance();
  }

  bool _ObscureText = true;





  @override
  Widget build(BuildContext context) {
    final screenwidth=MediaQuery.of(context).size.width;
    final screenheight=MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
            children: [
        // Background Gradient
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff5F2C82),
                        Color(0xffA83279),
                      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
                  ),
    ),

              // Login Card positioned in the center
              // Login Card
              Center(
                child: Container(
                  height: 650,
                  width: 350,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),

                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                            child: Image.asset(
                                'assets/images/Tutor.png')),
                        const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                        child :Text(
                          "WELCOME BACK !",
                          style: TextStyle(fontSize: 22, color: Colors.white,fontWeight: FontWeight.w700),
                        )),

                        const SizedBox(height: 15),

                        const SizedBox(height: 5),
                        UiHelper.CustomTextField1(
                          EmailText, "Email", Icons.email, false,
                        ),

                        const SizedBox(height: 15),

                        const SizedBox(height: 5),
                        TextField(
                          controller: PasswordNum,
                          obscureText: _ObscureText,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: const Icon(Icons.lock, color: Color(0xffD9D9D9)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _ObscureText ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _ObscureText = !_ObscureText;
                                });
                              },
                            ),
                            enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffD9D9D9)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffD9D9D9)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {},
                            onDoubleTap: () {
                              print("tapped");
                            },
                            child: const Text(
                              "Forgot Password ?",
                              style: TextStyle(fontSize: 12, color:Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        UiHelper.CustomButton(() {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()),);
                          // Add login logic
                        }, "Login"),

                        const SizedBox(height: 10),
                        const Text(
                          "Don’t have an account ? Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          height: 5,
                          thickness: 2,
                          color: Color(0xffB2B2B2),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 48,
                          width: 300,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              foregroundColor:  Colors.white ,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                            child: const Text("Sign up "),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
        ),
    );
  }
}
