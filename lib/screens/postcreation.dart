import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appwrite/appwrite.dart';
import 'package:social_media_app/services/appwrite_service.dart';
import 'package:image_picker/image_picker.dart';

class PostCreation extends StatefulWidget{
  const PostCreation({Key? key}) : super(key: key);
  @override
  State<PostCreation> createState() => _PostCreationState();
}

class _PostCreationState extends State<PostCreation> {
  final AppwriteService appwriteService = AppwriteService();
  List<String> imageFileIds = [];
  String imagePath = "";
  String? userId;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    try {
      final user = await appwriteService.getCurrentUserId(); 
      setState(() {
        userId = user; 
      });
    } catch (e) {
      print("Error getting current user: $e");
    }
  }


  Future<void> deleteImage(String fileId) async {
    try{
      await AppwriteService.deletionImage(fileId);
      setState(() {
        imageFileIds.remove(fileId); 
      });
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
      File file = File(imagePath);
      if (userId != null) {
        try {
          await AppwriteService.uploadImage(file, userId!);
        } catch (e) {
          print("Error uploading image: $e");
        }
      } else {
        print("User ID is null, cannot upload image.");
      }
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 16))),
        actions: [
          TextButton(
              onPressed: (){},
              child: Text('Post Feed', style: TextStyle(
                color: Colors.black
              ),)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Share your post and idea',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _pickAndUploadImage,
        backgroundColor: Colors.white,
        child: const Icon(FontAwesomeIcons.camera, color: Colors.grey,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}