import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/screens/util.dart';
import 'dart:io';
import 'package:social_media_app/services/appwrite_service.dart';

class EditProfilePage extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? displayName;
  final String? bio;
  final String? interest;
  final String? location;
  final String? profileImageId;

  const EditProfilePage({
    Key? key,
    required this.userId,
    this.username,
    this.displayName,
    this.bio,
    this.interest,
    this.location,
    this.profileImageId,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AppwriteService appwriteService = AppwriteService();
  final form = GlobalKey<FormState>();

  late TextEditingController user;
  late TextEditingController displayName;
  late TextEditingController bio;
  late TextEditingController interest;
  late TextEditingController location;
  File? image;

  @override
  void initState() {
    super.initState();
    user = TextEditingController(text: widget.username);
    displayName = TextEditingController(text: widget.displayName);
    bio = TextEditingController(text: widget.bio);
    interest = TextEditingController(text: widget.interest);
    location = TextEditingController(text: widget.location);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (form.currentState!.validate()) {
      String? profileImageId = widget.profileImageId;
      if (image != null) {
        profileImageId = await appwriteService.uploadProfileImage(widget.userId!, image!);
      }

      try {
        await appwriteService.updateUserProfile(
          userId: widget.userId!,
          username: user.text,
          displayName: displayName.text,
          bio: bio.text,
          interest: interest.text,
          location: location.text,
          profileImageId: profileImageId,
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xFFEFF0F2),
                        backgroundImage: image != null
                            ? FileImage(image!)
                            : (widget.profileImageId != null
                                ? NetworkImage(
                                    appwriteService.getImageUrl(widget.profileImageId!),
                                  )
                                : null ) ,
                        child: image == null ? Icon(Icons.camera_alt,size: 70,color: const Color.fromARGB(255, 123, 123, 123)) : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Username*',
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                    controller: user,
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
                      controller: displayName,
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
                      controller: bio,
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
                      maxLines: 3,
                    ),
                  Text(
                    'Interest*',
                    style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 150, 149, 149)),
                  ),
                  TextFormField(
                      controller: interest,
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
                      onPressed: _updateProfile,
                      child: CustomText(text: 'Save', color: Colors.white,fontSize: 19,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.blue,
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
