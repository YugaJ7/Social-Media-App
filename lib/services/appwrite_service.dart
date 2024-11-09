import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AppwriteService {
  static late Client client;
  static late Account account;
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
  Future<void> addUserToDatabase(String userId, String username, String email,String password) async {
    try {
      await database.createDocument(
        databaseId: '672e094b003b610078c0',  // Replace with your database ID
        collectionId: '672e095b000150bfacb0',  // Replace with your collection ID
        documentId: userId,  // Use the user ID from registration
        data: {
          'username': username,
          'email': email,
          'password': password
        },
      );
      print("User data added to database!");
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
      print("Logged out successfully!");
    } catch (e) {
      print("Logout error: $e");
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
        bucketId: '672f4201001100487dad',  // Replace with your Appwrite bucket ID
        fileId: userId,  // Generate a unique ID for the file
        file: InputFile.fromPath(path: imageFile.path),
      );
      return result.$id;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Add profile data to the Appwrite database
  Future<void> createProfile(String userId, String username, String displayName, String bio, String interest, String location, String? imageId) async {
    try {
      await database.createDocument(
        databaseId: '672e094b003b610078c0',  // Replace with your database ID
        collectionId: '672e09f40035b32645dc',  // Replace with your profiles collection ID
        documentId: userId,  // Use the Appwrite user ID
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

  static Future<void> uploadImage(File imageFile, String userId)async{
    try{
      final file = await storage.createFile(
        bucketId: '672f4201001100487dad',
        fileId: ID.unique(),
        file: InputFile.fromPath(path: imageFile.path),
      );
      await storage.updateFile(
          bucketId: '672f4201001100487dad',
          fileId: ID.unique(),
      );
      print('File uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


}