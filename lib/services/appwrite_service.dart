import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';

class AppwriteService {
  late Client client;
  late Account account;
  late Databases database;
  late Storage storage;

  AppwriteService() {
    client = Client();
    client.setProject('672cc1fd002f9dce00dd');
    account = Account(client);
    database = Databases(client); 
    storage = Storage(client);
  }

  //Register a new user
  Future<models.User?> registerUser(String email, String password) async {
    try {
      print('Done');
      return await account.create(
        userId: ID.unique(), 
        email: email,
        password: password,
      );
      
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }
  //Saving User Login Credential in database
  Future<void> addUserToDatabase(String userId, String username, String email,String password) async {
    try {
      await database.createDocument(
        databaseId: '672e094b003b610078c0',  
        collectionId: '672e095b000150bfacb0', 
        documentId: userId, 
        data: {
          'username': username,
          'email': email,
          'password': password
        },
      );
    } catch (e) {
      print('Database error: $e');
    }
  }

  // Log in an existing user
  Future<models.Session?> loginUser(String email, String password) async {
    try {
      return await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Log out the current user
  Future<void> logoutUser() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      print("Logout error: $e");
    }
  }
  Future<void> deleteAccount(String userId) async {
    // Implement delete account functionality with a confirmation dialog
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Delete Account'),
    //     content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text('Cancel'),
    //       ),
    //       TextButton(
    //         onPressed: () async {
              await account.deleteIdentity(identityId: userId);
    //           Navigator.of(context).pushReplacementNamed('/login');
    //         },
    //         child: Text('Delete', style: TextStyle(color: Colors.red)),
    //       ),
    //     ],
    //   ),
    // );
  }


  // Check if there’s an active user session
  Future<models.Session?> getCurrentSession() async {
    try {
      return await account.getSession(sessionId: 'current');
    } catch (e) {
      print("Error retrieving session: $e");
      return null;
    }
  }

  // Upload profile image
  Future<String?> uploadProfileImage(String userId,File imageFile) async {
    try {
      final result = await storage.createFile(
        bucketId: '672f4201001100487dad',  
        fileId: userId,  
        file: InputFile.fromPath(path: imageFile.path),
      );
      return result.$id;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Add profile data to the database
  Future<void> createProfile(String userId, String username, String displayName, String bio, String interest, String location, String? imageId) async {
    try {
      await database.createDocument(
        databaseId: '672e094b003b610078c0',
        collectionId: '672e09f40035b32645dc', 
        documentId: userId,  
        data: {
          'username': username,
          'displayName': displayName,
          'bio': bio,
          'interest': interest,
          'location': location,
          'profileImageId': imageId,
        },
      );
      print("Profile data added to database!");
    } catch (e) {
      print('Database error: $e');
    }
  }

// Fetch username from database
Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
  try {
    final document = await database.getDocument(
      databaseId: '672e094b003b610078c0',  // Your database ID
      collectionId: '672e09f40035b32645dc', // Your collection ID for user profiles
      documentId: userId,
    );

    return document.data;
  } catch (e) {
    print('Error fetching user profile: $e');
    return null;
  }
}

Future<String?> getCurrentUserId() async {
    try {
      final user = await account.get();
      return user.$id; // Returns the user's ID
    } catch (e) {
      print('Error retrieving current user ID: $e');
      return null;
    }
  }

Future<List<String>> fetchUserMedia(String userId) async {
  try {
    final files = await storage.listFiles(
      bucketId: '672f4201001100487dad',
      queries: [Query.equal('userId', userId)],
    );
    return files.files.map((file) => file.$id).toList();
  } catch (e) {
    print('Error fetching media files: $e');
    return [];
  }
}

// Update user profile data in the database
Future<void> updateUserProfile({
  required String userId,
  required String username,
  required String displayName,
  required String bio,
  required String interest,
  required String location,
  String? profileImageId,
}) async {
  try {
    await database.updateDocument(
      databaseId: '672e094b003b610078c0',  // Your database ID
      collectionId: '672e09f40035b32645dc', // Collection ID for user profiles
      documentId: userId,  // Same user ID to locate the document
      data: {
        'username': username,
        'displayName': displayName,
        'bio': bio,
        'interest': interest,
        'location': location,
        'profileImageId': profileImageId,
      },
    );
    print("Profile updated successfully!");
  } catch (e) {
    print('Error updating profile: $e');
  }
}

Future<bool> sendPasswordResetEmail(String email) async {
  try {
    await account.createRecovery(
      email: email,
      url: 'https://localhost:3000/recovery', // Replace with your app’s reset password URL
    );
    return true;
  } catch (e) {
    //throw 'Error sending reset email: $e';
    return false;
  }
}


}
