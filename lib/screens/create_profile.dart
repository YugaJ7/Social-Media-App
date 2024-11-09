import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/screens/homescreen.dart';
import 'package:social_media_app/screens/util.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final AppwriteService appwriteService = AppwriteService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController interest = TextEditingController();
  final TextEditingController location = TextEditingController();
  File? profileImage;
  bool isFormComplete = false;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
        checkFormCompletion();
      });
    }
  }

  Future<void> saveProfile() async {
    if (formKey.currentState!.validate() && profileImage != null) {
      try {
        final session = await appwriteService.getCurrentSession();
  
        final user = await appwriteService.account.get();
        final userId = user.$id;
        final imageId = await appwriteService.uploadProfileImage(userId,profileImage!);

        await appwriteService.createProfile(
          userId,
          usernameController.text,
          displayNameController.text,
          bioController.text,
          interest.text,
          location.text,
          imageId,
        );

        Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
      } catch (e) {
        print("Error saving profile: $e");
      }
    }
  }

  void checkFormCompletion() {
    setState(() {
      isFormComplete = usernameController.text.isNotEmpty &&
          displayNameController.text.isNotEmpty &&
          bioController.text.isNotEmpty &&
          interest.text.isNotEmpty &&
          location.text.isNotEmpty&&
          profileImage != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Create a Profile',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        color: Colors.black,
                        fontSize: 22,),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xFFEFF0F2),
                        backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null
                            ? Icon(Icons.camera_alt, size: 70,color: Colors.white,)
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Username*',
                    style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                      controller: usernameController,
                      onChanged: (value) => checkFormCompletion(),
                      validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Your Unique @username',
                          fillColor: const Color(0xFFEFF0F2),
                          filled: true,
                          hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                        ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Display Name*',
                    style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                      controller: displayNameController,
                      onChanged: (value) => checkFormCompletion(),
                      validator: (value) => value!.isEmpty ? 'Please enter a display name' : null,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'How your name appears on profile',
                          fillColor: const Color(0xFFEFF0F2),
                          filled: true,
                          hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                        ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Bio on profile*',
                    style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                      controller: bioController,
                      onChanged: (value) => checkFormCompletion(),
                      validator: (value) => value!.isEmpty ? 'Please enter a bio' : null,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'How your Bio appears on profile',
                          fillColor: const Color(0xFFEFF0F2),
                          filled: true,
                          hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                        ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Interest*',
                    style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                      controller: interest,
                      onChanged: (value) => checkFormCompletion(),
                      validator: (value) => value!.isEmpty ? 'Please enter a interest' : null,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Your Unique Interest',
                          fillColor: const Color(0xFFEFF0F2),
                          filled: true,
                          hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                        ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Location*',
                    style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                      controller: location,
                      onChanged: (value) => checkFormCompletion(),
                      validator: (value) => value!.isEmpty ? 'Please enter your location' : null,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Where are you?',
                          fillColor: const Color(0xFFEFF0F2),
                          filled: true,
                          hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                        ),
                    ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/16,
                    child: ElevatedButton(
                      onPressed: isFormComplete ? saveProfile : null,
                      child: CustomText(text: 'Save', color: Colors.white,fontSize: 19,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormComplete ? Colors.blue : const Color.fromARGB(188, 33, 149, 243),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}
