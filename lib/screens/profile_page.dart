import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/edit_profile.dart';
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
  List<String> mediaFiles = []; 

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
      final session = await appwriteService.getCurrentSession();
      final userId = session!.userId;

      final userMedia = await appwriteService.fetchUserMedia(userId);
      setState(() {
        mediaFiles = userMedia;
      });
    } catch (e) {
      print('Error loading media: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text(username ?? 'Profile'),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    ),
    endDrawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: appwriteService.logoutUser,
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
            onTap: () async {
              final userId = await appwriteService.getCurrentUserId();
              if (userId != null) {
                await appwriteService.deleteAccount(userId);
              } else {
                print("Error: userId is null.");
              }
            },
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    body: ListView(
      padding: EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: NetworkImage(
                    'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/$profileImageId/view?project=672cc1fd002f9dce00dd',
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      displayName ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
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
                    SizedBox(height: 8),
                    Text(
                      location ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(bio ?? '', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
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
          child: Text('Edit Profile', style: TextStyle(color: Colors.black)),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        // TabBar for Feeds, Community, Media
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Feeds'),
                  Tab(text: 'Community'),
                  Tab(text: 'Media'),
                ],
              ),
              SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    Center(child: Text('Feeds Content')),
                    Center(child: Text('Community Content')),
                    // Media tab to display user images
                    GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: mediaFiles.length,
                      itemBuilder: (context, index) {
                        final mediaFileId = mediaFiles[index];
                        return Image.network(
                          'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/672f55262be8cc41c16d/view?project=672cc1fd002f9dce00dd',
                          fit: BoxFit.cover,
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
  );
}}