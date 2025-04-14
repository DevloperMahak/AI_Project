import 'package:ask_my_tutor/login.dart';
import 'package:ask_my_tutor/main_screen.dart';
import 'package:ask_my_tutor/uihelper.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Add your sign-up logic here (e.g. API call)
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      print('Name: $name');
      print('Email: $email');
      print('Password: $password');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed up successfully!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>LoginPage()));
    }
  }
  InputDecoration customInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Color(0xffD9D9D9)),
      suffixIcon: suffixIcon,
      errorStyle: const TextStyle(color: Color(0xFFF3E8FF)),
      // Normal state
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffD9D9D9)),
        borderRadius: BorderRadius.circular(30),
      ),
      // Focused state
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
      ),
      // Error state
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFF3E8FF)),
        borderRadius: BorderRadius.circular(30),
      ),
      // Focused + Error state
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFF3E8FF), width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Sign Up")),
      body:      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff5F2C82),
              Color(0xffA83279),
            ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
   child:Center(
    child: Container(
    width: 350,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(30),
    ),
        child: Column(
    children: [
      Center(
          child: Image.asset(
              'assets/images/Tutor.png')),
      const SizedBox(height: 10),
      Align(
          alignment: Alignment.center,
          child :Text(
            "CREATE YOUR ACCOUNT",
            style: TextStyle(fontSize: 22, color: Colors.white,fontWeight: FontWeight.w700),
          )),

      const SizedBox(height: 15),

       Form(
           key: _formKey,
           child: SingleChildScrollView(
             child: Column(
             children: [
              // Name
              TextFormField(
                controller: _nameController,
               style: const TextStyle(color: Colors.white),
                decoration: customInputDecoration(
                  label: 'Name',
                  icon: Icons.person_rounded,
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your name' : null,
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: customInputDecoration(
                  label: 'Email',
                  icon: Icons.email,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: !_isPasswordVisible,
                decoration: customInputDecoration(
                  label: 'Password',
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    color: Colors.white,
                  ),
                ),
                validator: (value) =>
                value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 24),

              // Sign Up Button
               UiHelper.CustomButton(() {
                 _signUp();
                 // Add login logic
               }, "Sign Up"),
             const SizedBox(height: 10),
             const Text(
               "Already have an account ? Log In",
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
                 child: const Text("Sign up with Google "),
               ),
             )
            ],
          ),
        ),
       )
    ])
      ),
    ),
      )
    );
  }
}


