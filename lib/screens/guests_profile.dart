import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class GuestsProfile extends StatefulWidget {
  final Map<String, dynamic> profile;
  GuestsProfile({Key? key, required this.profile}) : super(key: key);

  @override
  _GuestsProfileState createState() => _GuestsProfileState();
}

class _GuestsProfileState extends State<GuestsProfile> {
  final AppwriteService appwriteService = AppwriteService();
  bool ispressed = false; 

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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      widget.profile['username'],
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    GestureDetector(
                      onTap: (){show_profile_image(url: appwriteService.getImageUrl(widget.profile['profileImageId']));},
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                          appwriteService.getImageUrl(widget.profile['profileImageId']),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.1),
                    Column(
                      children: [
                        Text(
                          widget.profile['displayName'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500, fontFamily: 'Regular'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.profile['interest'],
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.profile['location'],
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Text(widget.profile['bio'] ?? '', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    ispressed = !ispressed; 
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ispressed ? const Color.fromARGB(255, 110, 190, 255) : Colors.blue, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  ispressed ? 'Invitation Sent' : 'Send Invite', 
                  style: const TextStyle(color: Colors.white,fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 16), 
          ],
        ),
      ),
    );
  }
}
