import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/login.dart';
import 'package:social_media_app/screens/util.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

bool obscureText = true;
  String email = '';
  String password = '';
  String username = '';
  String confirmpass = '';
Future <void> register() async{
  if (formKey.currentState!.validate() && password==confirmpass){
      try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email' : email,
      }
      );

      // Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => HomeScreen()));
    }on FirebaseAuthException catch(e){
      showErrorMessage(e.code);
    }
  }
}

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Color.fromARGB(255, 245, 240, 255),
            title: Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK',
                    style: TextStyle(color: Colors.black)),
              )
            ]
          );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Image.asset('assets/images/splash.png',height: 120,),
                SizedBox(height: 24),
                CustomText(
                  text: "Welcome Slidee 👋",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                
                ), 
                SizedBox(height: 8),
                CustomText(
                  text: "Sign Up and enjoy our community",
                  fontSize: 16,
                  fontWeight: null,
                  color: Colors.grey,
                
                ), 
                SizedBox(height: 32),
                TextField(
                    onChanged: (value) => username = value,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'Username',
                        fillColor: const Color(0xFFEFF0F2),
                        filled: true,
                        hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                        prefixIcon: const Icon(Icons.person_outline,color: Color(0xFF4979FF),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                      ),
                  ),
                SizedBox(height: 16),
                TextFormField(
                    controller: emailController,
                    onChanged: (value) => email = value,
                    validator: (value) => !EmailValidator.validate(value!, true)
                    ? 'Not a valid email.'
                    : null,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'Your Email',
                        fillColor: const Color(0xFFEFF0F2),
                        filled: true,
                        hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                        prefixIcon: const Icon(Icons.email_outlined,color: Color(0xFF4979FF),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                      ),
                  ),
                SizedBox(height: 16),
                TextField(
                    onChanged: (value) => password = value,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'Password',
                        fillColor: const Color(0xFFEFF0F2),
                        filled: true,
                        hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                        prefixIcon: const Icon(Icons.lock_outline_rounded,color: Color(0xFF4979FF),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                      ),
                  ),
                SizedBox(height: 16),
                TextField(
                    onChanged: (value) => confirmpass = value,
                    obscureText: obscureText,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        fillColor: const Color(0xFFEFF0F2),
                        filled: true,
                        hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                        prefixIcon: const Icon(Icons.lock_outline_rounded,color: Color(0xFF4979FF),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFCFB9B9),
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                  ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: "Create Account",
                    fontFamily: 'Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    onPressed: register, 
                    backgroundColor: const Color(0xFF4979FF),
                    borderRadius: 50)
                 ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.8,
                  alignment: Alignment.center,
                  child:Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'By continuing you agree to our ',
                          style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'Terms of Service ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'and ',
                          style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have an Account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Login()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),]
      ),
    );
  }
}