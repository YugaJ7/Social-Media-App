import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/register.dart';
import 'package:social_media_app/screens/util.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool _isChecked = false;
  String email = '';
  String password = '';
  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    } on FirebaseAuthException catch(e){
    showErrorMessage(e.code);
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
                SizedBox(height: 30),
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
                  text: "Enter your Email & Password to Sign in",
                  fontSize: 16,
                  fontWeight: null,
                  color: Colors.grey,
                
                ), 
                SizedBox(height: 32),
                TextField(
                    onChanged: (value) => email = value,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: 'Enter Your Email Address',
                        fillColor: const Color(0xFFEFF0F2),
                        filled: true,
                        hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                        prefixIcon: const Icon(Icons.mail_outline,color: Color(0xFF4979FF),),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                      ),
                  ),
                SizedBox(height: 16),
                TextField(
                    onChanged: (value) => password = value,
                    obscureText: _obscureText,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFFCFB9B9),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                        activeColor: Color(0xFF4979FF),
                      ),
                        Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: "Sign In",
                    fontFamily: 'Regular',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    onPressed: (){}, 
                    backgroundColor: const Color(0xFF4979FF),
                    borderRadius: 50)
                 ),
                SizedBox(height: 16),
                
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR",style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.google,),
                    label: Text("Sign In with Google",style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Regular',
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.apple,color: Colors.white,),
                    label: Text("Sign In with Apple",style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Regular',
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t Have an Account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Register()));
                      },
                      child: Text(
                        "Sign Up",
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