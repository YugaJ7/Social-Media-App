import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/postcreation.dart';
import 'package:social_media_app/services/appwrite_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:social_media_app/screens/postcreation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> imageFileIds = [];
  String imagePath = "";
  String? userId;
  List<File> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    //_fetchImage();
  }


  Future<void> _getCurrentUser() async {
    try {
      final account = Account(AppwriteService.client); // Use your Appwrite client
      final user = await account.get(); // Get current logged-in user
      setState(() {
        userId = user.$id; // Store user ID
      });
    } catch (e) {
      print("Error getting current user: $e");
    }
  }
void _onItemTapped(int index) {
    setState(() {
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    indicator: const BoxDecoration(),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                    tabs: const [
                      Tab(text: 'Feeds'),
                      Tab(text: 'Community'),
                      Tab(text: 'Explore'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.bell),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //FeedScreen(mediaId: '', userId: '',),
            FeedScreen(),
            CommunityScreen(),
            ExploreScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostCreation()));
          },
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

// class FeedScreen extends StatefulWidget {
//   final String mediaId;
//   final String userId;
//   const FeedScreen({
//     Key? key,
//     required this.mediaId,
//     required this.userId,}) : super(key: key);

//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   bool isLike = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkLikeStatus();
//   }

//   Future<void> _checkLikeStatus() async {
//     bool liked = await AppwriteService.isMediaLiked(widget.mediaId, widget.userId);
//     setState(() {
//       isLike = liked;
//     });
//   }

//   Future<void> _toggleLike() async {
//     if (isLike) {
//       await AppwriteService.unlikeMedia(widget.mediaId, widget.userId);
//     } else {
//       await AppwriteService.likeMedia(widget.mediaId, widget.userId);
//     }
//     setState(() {
//       isLike = !isLike;
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(8.0),
//       children: [
//         Card(
//           color: Colors.white,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 leading: const CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/joshan.jpg'),
//                 ),
//                 title: Row(
//                   children: const [
//                     Text(
//                       "Jashon Thiago",
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       "@jashon.thiago",
//                       style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 8, left: 56, right: 16),
//                 child: Text("Me:", style: TextStyle(fontSize: 17)),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 56, right: 16),
//                 child: Text("I only use auto layout when I'm designing components for reusability", style: TextStyle(fontSize: 17)),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 56, right: 16),
//                 child: Text("Also me:", style: TextStyle(fontSize: 17)),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 56, right: 16),
//                 child: Text("I hate reusing components with auto layout", style: TextStyle(fontSize: 17)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed:  _toggleLike,
//                       icon: Icon(
//                           isLike? FontAwesomeIcons.solidHeart: FontAwesomeIcons.heart,
//                           color: isLike? Colors.red : Colors.grey),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(FontAwesomeIcons.commentDots, color: Colors.grey),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(FontAwesomeIcons.paperPlane, color: Colors.grey),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Card(
//           color: Colors.white,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 leading: const CircleAvatar(
//                   backgroundImage: AssetImage('assets/images/NetflixIcon2016.webp'),
//                 ),
//                 title: Row(
//                   children: const [
//                     Text(
//                       "Netflix ID",
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       "@netflix.id",
//                       style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 8, left: 56, right: 16),
//                 child: Text("it's all about the looks. LUPIN part 3, October 5 on Netflix", style: TextStyle(fontSize: 17)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.asset(
//                     'assets/images/lupin.jpeg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed:  _toggleLike,
//                       icon: Icon(
//                           isLike? FontAwesomeIcons.solidHeart: FontAwesomeIcons.heart,
//                           color: isLike? Colors.red : Colors.grey),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(FontAwesomeIcons.commentDots, color: Colors.grey),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(FontAwesomeIcons.paperPlane, color: Colors.grey),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AppwriteService appwriteService = AppwriteService();
  List<Map<String, dynamic>> postsWithUserData = []; 
  bool isLoading = true; 
  bool isLike = false; 

  @override
  void initState() {
    super.initState();
    _fetchPostsWithUserData();
  }
  Future<void> _fetchPostsWithUserData() async {
  try {
    List<dynamic> posts = await appwriteService.getPosts();

    List<Map<String, dynamic>> fetchedPosts = [];
    for (var post in posts) {
      String userId = post.data['userId'] ?? ''; 
      print('User ID: $userId');
      Map<String, dynamic>? userProfile = await appwriteService.fetchUserProfileById(userId);
      print('User Profile: $userProfile');
      fetchedPosts.add({
        'username': userProfile?['username'] ?? 'Unknown', // Fallback for null
        'displayName': userProfile?['displayName'] ?? 'Unknown',
        'profileImage': userProfile?['profileImageId'] ?? '', // Use empty string as default
        'title': post.data['title'] ?? '', // Fallback to empty string
        'image': post.data['postImageId'] ?? '', // Fallback to empty string
      });
    }

    setState(() {
      postsWithUserData = fetchedPosts;
      isLoading = false;
    });
  } catch (e) {
    print('Error fetching data: $e');
    setState(() {
      isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: postsWithUserData.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final post = postsWithUserData[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 8),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(appwriteService.getImageUrl(post['profileImage'])),
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
                              post['displayName'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "@${post['username']}",
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
    );
  }
}
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        // First community card
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Join Community', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  TextButton(onPressed: (){}, child: Text('See All', style: TextStyle(color: Colors.blue),))
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/joshan.jpg'),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "UI UX Designer Indonesia",
                            style: TextStyle(fontWeight: FontWeight.bold,),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "155 People Joined community",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black,),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(FontAwesomeIcons.plus, size: 14, color: Colors.blue,),
                        SizedBox(width: 4),
                        Text('Join', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/ui.jpg'),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "User Interface Designer",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "155 People Joined community",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.black,),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(FontAwesomeIcons.plus, size: 14,color: Colors.blue,),
                        SizedBox(width: 4),
                        Text('Join', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),


        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/NetflixIcon2016.webp'),
                ),
                title: Row(
                  children: const [
                    Text(
                      "Netflix ID",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "@netflix.id",
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 56, right: 16),
                child: Text("it's all about the looks. LUPIN part 3, October 5 on Netflix", style: TextStyle(fontSize: 17)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/lupin.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.heart, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.commentDots, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.paperPlane, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trending on Slidee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  TextButton(onPressed: (){}, child: Text('See All', style: TextStyle(color: Colors.blue),))
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.solidCompass,color: Colors.blue, size: 30),
                  ),
                  Expanded(
                    child: const Text(
                      "User Interface Design",
                      style: TextStyle( fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.angleUp, color: Colors.blue,),
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.solidCompass,color: Colors.blue, size: 30),
                  ),
                  Expanded(
                    child: const Text(
                      "Indonesia",
                      style: TextStyle( fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.angleUp, color: Colors.blue,),
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.solidCompass,color: Colors.blue, size: 30),
                  ),
                  Expanded(
                    child: const Text(
                      "Mental Health",
                      style: TextStyle( fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.angleUp, color: Colors.blue,),
                  ),
                ],
              ),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/NetflixIcon2016.webp'),
                ),
                title: Row(
                  children: const [
                    Text(
                      "Netflix ID",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "@netflix.id",
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 56, right: 16),
                child: Text("it's all about the looks. LUPIN part 3, October 5 on Netflix", style: TextStyle(fontSize: 17)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/lupin.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.heart, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.commentDots, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.paperPlane, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
