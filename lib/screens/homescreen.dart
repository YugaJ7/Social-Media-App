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
    _fetchImage();
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

  Future<void> _fetchImage() async {
    if(userId!= null) {
      try {
        final fetchedFields = await AppwriteService.getUploadedImages(userId!);
        setState(() {
          imageFileIds = fetchedFields;
        });
        for (var fileId in imageFileIds) {
          final imageFile = await AppwriteService.getImageFile(fileId);
          setState(() {
            uploadedImages.add(imageFile);
          });
        }
      } catch (e) {
        print("Error getting current user: $e");
      }
    }
  }


  // Future<void> deleteImage(String fileId) async {
  //   try{
  //     await AppwriteService.deletionImage(fileId);
  //     setState(() {
  //       imageFileIds.remove(fileId); // Remove from the list after deletion
  //     });
  //   } catch (e) {
  //     print('Failed to delete image: $e');
  //   }
  // }


  void _onItemTapped(int index) {
    setState(() {
    });
  }


  // Future<void> _pickAndUploadImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       imagePath = image.path;
  //     });
  //     File file = File(imagePath);
  //     if (userId != null) {
  //       try {
  //         await AppwriteService.uploadImage(file, userId!);
  //       } catch (e) {
  //         print("Error uploading image: $e");
  //       }
  //     } else {
  //       print("User ID is null, cannot upload image.");
  //     }
  //   }
  // }



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
            FeedScreen(mediaId: '', userId: '',),
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

class FeedScreen extends StatefulWidget {
  final String mediaId;
  final String userId;
  const FeedScreen({
    Key? key,
    required this.mediaId,
    required this.userId,}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isLike = false;

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    bool liked = await AppwriteService.isMediaLiked(widget.mediaId, widget.userId);
    setState(() {
      isLike = liked;
    });
  }

  Future<void> _toggleLike() async {
    if (isLike) {
      await AppwriteService.unlikeMedia(widget.mediaId, widget.userId);
    } else {
      await AppwriteService.likeMedia(widget.mediaId, widget.userId);
    }
    setState(() {
      isLike = !isLike;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/joshan.jpg'),
                ),
                title: Row(
                  children: const [
                    Text(
                      "Jashon Thiago",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "@jashon.thiago",
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 56, right: 16),
                child: Text("Me:", style: TextStyle(fontSize: 17)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 56, right: 16),
                child: Text("I only use auto layout when I'm designing components for reusability", style: TextStyle(fontSize: 17)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 56, right: 16),
                child: Text("Also me:", style: TextStyle(fontSize: 17)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 56, right: 16),
                child: Text("I hate reusing components with auto layout", style: TextStyle(fontSize: 17)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed:  _toggleLike,
                      icon: Icon(
                          isLike? FontAwesomeIcons.solidHeart: FontAwesomeIcons.heart,
                          color: isLike? Colors.red : Colors.grey),
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
                      onPressed:  _toggleLike,
                      icon: Icon(
                          isLike? FontAwesomeIcons.solidHeart: FontAwesomeIcons.heart,
                          color: isLike? Colors.red : Colors.grey),
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
        // Add more content cards here if needed.
      ],
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
                  // Leading CircleAvatar and Text Information
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
                  // Join Button
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
                  // Leading CircleAvatar and Text Information
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
                  // Join Button
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

        // Add more cards as needed
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
