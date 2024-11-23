import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/appwrite_service.dart';

class PostCreation extends StatefulWidget {
  @override
  _PostCreationState createState() => _PostCreationState();
}

class _PostCreationState extends State<PostCreation> {
  final AppwriteService appwriteService = AppwriteService();
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _postFeed() async {
    if (_titleController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a title and select an image')),
      );
      return;
    }

    try {
      final userId = await appwriteService.getCurrentUserId();
      final imageId = await AppwriteService.uploadImage(_selectedImage!,userId!);

      await appwriteService.createpost(
        userId, 
        _titleController.text, 
        imageId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );
      Navigator.pop(context); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.grey,
        shape: const CircleBorder(),
        child: const Icon(
          FontAwesomeIcons.camera,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: _postFeed,
                      child: Text(
                        'Post Feed',
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(height: .1, color: Color.fromARGB(255, 230, 230, 230),),
                TextField(
                  controller: _titleController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Share your post and idea",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey)
                  ),
                ),
                if (_selectedImage != null)
                  Stack(
                    children: [
                      Image.file(_selectedImage!),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(.2),
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.red,size: 24,),
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}