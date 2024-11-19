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
  List<String> mediaFileIds = [];
  bool isLoading = true;
  List<String> imageFileIds = [];
  String imagePath = "";
  String? userId;
  @override
  void initState() {
    super.initState();
    loadUserMedia();
    loadUserPost();

  }
  Future<void> loadUserPost() async {
    try {
      final session = await appwriteService.getCurrentSession();
      userId = session?.userId;

      if (userId != null) {
        final List<String> mediaFileIds = await AppwriteService.fetchPostImages(userId!);

        if (mediaFileIds.isNotEmpty) {
          final String selectedImageId = mediaFileIds.first;
          String selectedImageUrl =
              'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/$selectedImageId/view?project=672cc1fd002f9dce00dd';

          setState(() {
            isLoading = false;
            this.mediaFileIds = mediaFileIds;
            imagePath = selectedImageUrl;
          });

          print('Selected Image URL: $selectedImageUrl');
        } else {
          setState(() {
            isLoading = false;
          });
          print('No images found for the user.');
        }
      } else {
        print('User ID is null. Cannot fetch media.');
      }
    } catch (e) {
      print('Error loading user media: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> loadUserMedia() async {
    try {
      setState(() {
        isLoading = true;
      });
      final session = await appwriteService.getCurrentSession();
      final userId = session!.userId;

      mediaFileIds = await AppwriteService.fetchPostImages(userId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading media: $e');
    }
  }
  void showMedia({required String url, required String fileId}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white.withOpacity(0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 40),
                onPressed: () async {
                  await AppwriteService.deletionImage(fileId);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _getCurrentUser() async {
    try {
      final user = await appwriteService.getCurrentUserId();
      setState(() {
        userId = user; // Store user ID
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