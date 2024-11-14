import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/edit_profile.dart';
import 'package:social_media_app/screens/settings.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AppwriteService appwriteService = AppwriteService();
  String? userId;
  String? username;
  String? displayName;
  String? bio;
  String? interest;
  String? location;
  String? profileImageId;
  List<String> mediaFileIds = []; 
   bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    loadUserMedia();
  }

  Future<void> loadUserProfile() async {
    try {
      final session = await appwriteService.getCurrentSession();
      userId = session!.userId;

      final profileData = await appwriteService.fetchUserProfile(userId!);

      if (profileData != null) {
        setState(() {
          username = profileData['username'];
          displayName = profileData['displayName'];
          bio = profileData['bio'];
          interest = profileData['interest'];
          location = profileData['location'];
          profileImageId = profileData['profileImageId'];
          print(profileImageId);
          print('HELLO');
          if (profileImageId != null) {
          String imageUrl = 'https://cloud.appwrite.io/v1/storage/buckets/672f55262be8cc41c16d/files/$profileImageId/view?project=672cc1fd002f9dce00dd';
          print('Image URL: $imageUrl');
          print('HELLO');
        }
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> loadUserMedia() async {
    try {
      setState(() {
       isLoading = true;
      });
      final session = await appwriteService.getCurrentSession();
      final userId = session!.userId;

      mediaFileIds = await appwriteService.fetchUserMedia(userId);
      setState(() {
        mediaFileIds = mediaFileIds;
       isLoading = false;
      });
    } catch (e) {
      print('Error loading media: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(username ?? 'Username', style: const TextStyle(color: Colors.black, fontSize: 24),),
                  IconButton(
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> Settings_page()));
                      }, 
                    icon: const Icon(FontAwesomeIcons.gear, color: Colors.black54,))
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(
                      'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/$profileImageId/view?project=672cc1fd002f9dce00dd',
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        displayName ?? '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'Regular'),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text(
                            '11 Followers',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                          ),
                          Text(' • ', style: TextStyle(color: Colors.grey)),
                          Text(
                            '2 Following',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        location ?? '',
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(bio ?? '', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    userId: userId,
                    username: username,
                    displayName: displayName,
                    bio: bio,
                    interest: interest,
                    location: location,
                  ),
                ),
              );
            },
            child: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // TabBar for Feeds and  Media
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'Media'),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      const Center(child: Text('Feeds Content')),
                      // Media tab to display user images
                      isLoading
            ? const Center(child: CircularProgressIndicator())
            : mediaFileIds.isEmpty
                ? const Center(child: Text("No media files found"))
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust the number of columns as needed
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: mediaFileIds.length,
                    itemBuilder: (context, index) {
                      // For demonstration, showing the file ID
                      // Replace this with an image widget or another media display widget
                      String x =mediaFileIds[index];
                      print('IMAGE : '+ x);
                      return Container(
                        
                        color: Colors.grey[300],
                        child: Center(
                          child: 
                            Image.network(
                            //'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/672f55262be8cc41c16d/view?project=672cc1fd002f9dce00dd',
                            'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/$x/view?project=672cc1fd002f9dce00dd',
                            //mediaFileIds[index],
                            fit: BoxFit.cover,
                          ),
                            
                            
                        ),
                      );
                    },
                  ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}}