import 'package:flutter/material.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class EditProfilePage extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? displayName;
  final String? bio;
  final String? interest;
  final String? location;

  const EditProfilePage({
    Key? key,
    required this.userId,
    this.username,
    this.displayName,
    this.bio,
    this.interest,
    this.location,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AppwriteService appwriteService = AppwriteService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _displayNameController;
  late TextEditingController _bioController;
  late TextEditingController _interestController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _displayNameController = TextEditingController(text: widget.displayName);
    _bioController = TextEditingController(text: widget.bio);
    _interestController = TextEditingController(text: widget.interest);
    _locationController = TextEditingController(text: widget.location);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await appwriteService.updateUserProfile(
          userId: widget.userId.toString(),
          username: _usernameController.text,
          displayName: _displayNameController.text,
          bio: _bioController.text,
          interest: _interestController.text,
          location: _locationController.text,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Display Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a display name' : null,
              ),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _interestController,
                decoration: InputDecoration(labelText: 'Interest'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
