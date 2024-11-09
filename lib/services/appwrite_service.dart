import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

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

}
