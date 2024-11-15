import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/guests_profile.dart';
import 'package:social_media_app/services/appwrite_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController search = TextEditingController();
  List<Map<String, dynamic>> result= [];

  void performSearch(String query) async {
    if (query.isNotEmpty) {
      try {
        final results = await AppwriteService().searchProfiles(query);
        setState(() {
          result= results;
        });
      } catch (e) {
        print('Error during search: $e');
      }
    } else {
      setState(() {
        result= [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 10,),
              TextField(
                controller: search,
                style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Search by username or display name',
                      fillColor: const Color(0xFFEFF0F2),
                      filled: true,
                      prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.blue,),
                      hintStyle: const TextStyle(color: Color(0xFFBEBEBE)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                onChanged: (value) {
                  performSearch(value);
                },
              ),
              SizedBox(height: 20),
             Expanded(
                child: result.isEmpty
                    ? Center(child: Text("No results found"))
                    : ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          final profile = result[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => GuestsProfile(profile: profile),),);
                            },
                            child: ListTile(
                              title: Text(profile['displayName'] ?? 'No Display Name'),
                              subtitle: Text(profile['username'] ?? 'No Username'),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: profile['profileImageId'] != null
                                  ? NetworkImage(
                                      AppwriteService().getImageUrl(profile['profileImageId']),
                                    )
                                  : null,
                                backgroundColor: Colors.grey,
                              )
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}