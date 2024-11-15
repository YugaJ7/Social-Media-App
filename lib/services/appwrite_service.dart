import 'dart:io';
import 'dart:math';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';

class AppwriteService {
  static late Client client;
  late Account account;
  static late Databases database;
  static late Storage storage;

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
  Future<void> deleteAccount(String id) async {
  try {
    await account.deleteIdentity(identityId: id); 
  } catch (e) {
    print('Error in deleting account: $e');
  }
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

  String getImageUrl(String fileId) {
    return 'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/$fileId/view?project=672cc1fd002f9dce00dd';
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

//Getting current user id
Future<String?> getCurrentUserId() async {
    try {
      final user = await account.get();
      return user.$id; 
    } catch (e) {
      print('Error retrieving current user ID: $e');
      return null;
    }
  }

//fetching user media 
Future<List<String>> fetchUserMedia(String userId) async {
  try {
    final files = await storage.listFiles(
      bucketId: '672f4201001100487dad',
      
    );
    //return files.files.map((file) => file.$id).toList();
    final filteredFiles = files.files.where((file) => file.$id.endsWith(userId)).toList();
    return filteredFiles.map((file) => file.$id).toList();
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
      databaseId: '672e094b003b610078c0',  
      collectionId: '672e09f40035b32645dc', 
      documentId: userId,  
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

//sending reset password email
Future<bool> sendPasswordResetEmail(String email) async {
  try {
    await account.createRecovery(
      email: email,
      url: 'https://localhost:3000/recovery', 
    );
    return true;
  } catch (e) {
    //throw 'Error sending reset email: $e';
    return false;
  }
}

  static Future<void> uploadImage(File imageFile, String userId)async{
    try{
      const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final Random random = Random();
      final String shortUniqueId = List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
      final String uniqueFileId = '${shortUniqueId}_$userId';
      await storage.createFile(
        bucketId: '672f4201001100487dad',
        fileId: uniqueFileId,
        file: InputFile.fromPath(path: imageFile.path),
      );
      print('File uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  static Future<void> deletionImage(String fileId) async{
    try{
      await storage.deleteFile(
        bucketId: '672f4201001100487dad',
        fileId: fileId,
      );
      print('File deleted successfully');
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  static Future<void> likeMedia(String mediaId, String userId) async{
    try{
      await database.createDocument(
          databaseId: '672e094b003b610078c0',
          collectionId: '672fbc200005547ac93d',
          documentId: userId,
          data: {
            'mediaId': mediaId,
            'userId': userId,
            'isLiked': true,
          }
      );
      print("Media liked successfully.");
    } catch (e) {
      print("Error liking media: $e");
    }
  }

  static Future<void> unlikeMedia(String mediaId, String userId) async{
    try{
      final result = await database.listDocuments(
        databaseId: '672e094b003b610078c0',
        collectionId: '672fbc200005547ac93d',
        queries: [
          Query.equal('mediaId', mediaId),
          Query.equal('userId', userId),
        ],
      );

      if (result.documents.isNotEmpty) {
        await database.deleteDocument(
          databaseId: '672e094b003b610078c0',
          collectionId: '672fbc200005547ac93d',
          documentId: result.documents.first.$id,
        );
        print("Media unliked successfully.");
      }
    } catch (e) {
      print("Error unliking media: $e");
    }
  }

  static Future<bool> isMediaLiked(String mediaId, String userId) async {
    try {
      final result = await database.listDocuments(
        databaseId: '672e094b003b610078c0',
        collectionId: '672fbc200005547ac93d',
        queries: [
          Query.equal('mediaId', mediaId),
          Query.equal('userId', userId),
        ],
      );

      return result.documents.isNotEmpty;
    } catch (e) {
      print("Error checking like status: $e");
      return false;
    }
  }

// Searching user for search page
Future<List<Map<String, dynamic>>> searchProfiles(String searchQuery) async {
    try {
      final result = await database.listDocuments(
        databaseId: '672e094b003b610078c0',
        collectionId: '672e09f40035b32645dc',
        queries: [
          Query.search('username', searchQuery),
          Query.search('displayName', searchQuery),
        ],
      );
      print("Documents found: ${result.documents.length}");
      return result.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print("Error during search: $e");
      return [];
    }
  }

}
