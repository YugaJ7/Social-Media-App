import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'; // Import the package
import 'package:social_media_app/services/appwrite_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final AppwriteService appwriteService = AppwriteService();
  List<Map<String, dynamic>> postsWithUserData = [];
  bool isLoading = true;
  List<bool> isLikeList = [];

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
        Map<String, dynamic>? userProfile =
            await appwriteService.fetchUserProfileById(userId);
        print('User Profile: $userProfile');
        String postId = post.$id;
        List<String> comments =
            await appwriteService.fetchCommentsForPost(postId);
        print('Post ID: $postId');
        fetchedPosts.add({
          'id': postId,
          'username': userProfile?['username'] ?? 'Unknown',
          'displayName': userProfile?['displayName'] ?? 'Unknown',
          'profileImage': userProfile?['profileImageId'] ?? '',
          'title': post.data['title'] ?? '',
          'image': post.data['postImageId'] ?? '',
          'comments': comments,
        });
      }

      setState(() {
        postsWithUserData = fetchedPosts;
        isLoading = false;
        isLikeList = List.generate(fetchedPosts.length, (index) => false);
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showCommentSection(BuildContext context, int postIndex) {
  final post = postsWithUserData[postIndex];
  final comments = post['comments'] as List<String>;
  print(comments);
  final TextEditingController commentController = TextEditingController(); 

  showCupertinoModalBottomSheet(
    context: context,
    builder: (context) => Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: comments.isEmpty
                  ? const Center(child: Text('No comments yet'))
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text('User ${index + 1}'), 
                        subtitle: Text(comments[index]),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController, 
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () async {
                      String commentText = commentController.text.trim();
                      if (commentText.isNotEmpty) {
                        try {
                          print(post['id']);
                          await appwriteService.addCommentToPost(
                              post['id'], commentText);
                          setState(() {
                            post['comments'].add(commentText); // Update local state
                          });
                          commentController.clear(); // Clear text field after submission
                        } catch (e) {
                          print('Error adding comment: $e');
                        }
                      }
                    },
                  ),
                ],
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Colors.white,
      onRefresh: _fetchPostsWithUserData, 
      child: ListView.builder(
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
                      padding: const EdgeInsets.only(left: 16.0, right: 8),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            appwriteService.getImageUrl(post['profileImage'])),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  height:
                                      MediaQuery.of(context).size.height * .38,
                                ),
                              ),
                          ],
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isLikeList[index] = !isLikeList[index];
                        });
                      },
                      icon: Icon(
                        isLikeList[index]
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: isLikeList[index] ? Colors.red : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showCommentSection(context, index),
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
    );
  }
}
