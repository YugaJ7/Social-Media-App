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
  List<Map<String, dynamic>> userPosts = [];
   bool isLoading = true;
   bool isLike = false; 

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    loadUserPosts();
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
          String url = 'https://cloud.appwrite.io/v1/storage/buckets/672f55262be8cc41c16d/files/$profileImageId/view?project=672cc1fd002f9dce00dd';
          print('Image URL: $url');
          print('HELLO');
        }
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }
  Future<void> loadUserPosts() async {
    try {
      final session = await appwriteService.getCurrentSession();
      final currentUserId = session!.userId;

      // Fetch all posts
      final allPosts = await appwriteService.getPosts();

      // Filter posts where document ID ends with the current user ID
      List<Map<String, dynamic>> filteredPosts = [];
      for (var post in allPosts) {
        String docId = post.$id; // Get the document ID
        if (docId.endsWith(currentUserId)) {
          filteredPosts.add({
            'title': post.data['title'] ?? '',
            'image': post.data['postImageId'] ?? '',
          });
        }
      }

      setState(() {
        userPosts = filteredPosts;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user posts: $e');
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

      mediaFileIds = await appwriteService.fetchUserMedia(userId);
      setState(() {
        mediaFileIds = mediaFileIds;
       isLoading = false;
      });
    } catch (e) {
      print('Error loading media: $e');
    }
  }
  void showmedia({required String url, required String fileid}) {
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
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
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
              onPressed: () async => {
                await AppwriteService.deletionImage(fileid),
                Navigator.pop(context)
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void show_profile_image({required String url}) {
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
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
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
          ],
        ),
      ),
    ),
  );
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
                  GestureDetector(
                    onTap: (){
                      show_profile_image(url: appwriteService.getImageUrl(profileImageId!));
                    },
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(
                        'https://cloud.appwrite.io/v1/storage/buckets/672f4201001100487dad/files/$profileImageId/view?project=672cc1fd002f9dce00dd',
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(width: 30),
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
                            '0 Followers',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                          ),
                          Text(' • ', style: TextStyle(color: Colors.grey)),
                          Text(
                            '0 Following',
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
                       isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : userPosts.isEmpty
                                ? const Center(child: Text("No posts"))
                                : ListView.builder(
                                    itemCount: userPosts.length,
                                    itemBuilder: (context, index) {
                                      final post = userPosts[index];
                                      return Card(
                                        color: Colors.white,
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8),
                                                  child: CircleAvatar(
                                                    radius: 35,
                                                    backgroundImage: NetworkImage(appwriteService.getImageUrl(profileImageId!)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            displayName ?? '',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.bold, fontSize: 19),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            "@${username ?? 'Username'}",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        post['title'],
                                                        style: const TextStyle(fontSize: 17),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                    if (post['image'] != null)
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(16),
                                                        child: Image.network(
                                                          appwriteService.getImageUrl(post['image']),
                                                          fit: BoxFit.fitWidth,
                                                          width: MediaQuery.of(context).size.width*0.65,
                                                          height: MediaQuery.of(context).size.height*.38,
                                                        ),
                                                      ),           
                                                    ],
                                                  )
                                                )
                                              ]
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                IconButton(
                                                  onPressed: (){},
                                                  icon: Icon(
                                                    isLike
                                                        ? FontAwesomeIcons.solidHeart
                                                        : FontAwesomeIcons.heart,
                                                    color: isLike ? Colors.red : Colors.grey,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(FontAwesomeIcons.commentDots,
                                                      color: Colors.grey),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(FontAwesomeIcons.paperPlane,
                                                      color: Colors.grey),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(FontAwesomeIcons.ellipsisVertical,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : mediaFileIds.isEmpty
                            ? const Center(child: Text("No media files found"))
                            : GridView.builder(
                                padding: const EdgeInsets.symmetric(vertical :8.0),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, 
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemCount: mediaFileIds.length,
                                itemBuilder: (context, index) {
                                  String x =mediaFileIds[index];
                                  String url = appwriteService.getImageUrl(x);
                                  print('IMAGE : '+ x);
                                  return GestureDetector(
                                    onTap: () {
                                      showmedia(url: url, fileid: x);
                                     },   
                                  child:  Container(
                                    color: Colors.grey[300],
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                    ),
                                  ));
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
}
}