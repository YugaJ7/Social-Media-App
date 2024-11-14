import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/util.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class Settings_page extends StatefulWidget {
  const Settings_page({super.key});

  @override
  State<Settings_page> createState() => _Settings_pageState();
}

class _Settings_pageState extends State<Settings_page> {
  final AppwriteService appwriteService = AppwriteService();
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                      }, 
                    icon: const Icon(FontAwesomeIcons.chevronLeft, color: Colors.black54,)),
                  SizedBox(width: MediaQuery.of(context).size.width*0.25,),
                  Text('Settings', style: TextStyle(fontSize: 24, fontFamily: 'Medium'),),
                ],
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent, 
                ),
                child: ExpansionTile(
                  leading: Icon(FontAwesomeIcons.user, color: isExpanded ? Colors.black54 : Colors.black),
                  trailing: Icon(
                  isExpanded ? FontAwesomeIcons.chevronUp : FontAwesomeIcons.chevronDown,
                  color: Colors.black,
                ),
                  title: Text('Account'),
                  onExpansionChanged: (expanded) {
                  setState(() {
                     isExpanded = expanded;
                  });
                },
                  children: [
                    ListTile(
                      title: Text('Delete Account'),
                      leading: Icon(Icons.delete, color: Colors.red),
                      
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Account'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),),
                            backgroundColor: Colors.white,
                            content: Text('Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel',style: TextStyle(color: Colors.black),),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Privacy'),
                trailing: Icon(FontAwesomeIcons.chevronRight),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('Archive Post'),
                trailing: Icon(FontAwesomeIcons.chevronRight),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                trailing: Icon(FontAwesomeIcons.chevronRight),
                onTap: () {},
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Button(
                    text: 'Logout', 
                    fontFamily: 'Regular', 
                    fontSize: 18, 
                    fontWeight: FontWeight.normal, 
                    onPressed: appwriteService.logoutUser, 
                    backgroundColor: Colors.black, 
                    borderRadius: 30),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
