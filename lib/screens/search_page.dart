import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/screens/guests_profile.dart';
import 'package:social_media_app/services/appwrite_service.dart';
import 'package:social_media_app/services/search_history_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchHistoryService _history = SearchHistoryService();
  final TextEditingController search = TextEditingController();
  List<String> result = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    loadRecentSearches();
  }

  void performSearch(String query) async {
    if (query.isNotEmpty) {
      try {
        final results = await AppwriteService().searchProfiles(query);
        setState(() {
          result= results;
        });
        await _history.addSearchTerm(query);
        loadRecentSearches();
      } catch (e) {
        print('Error during search: $e');
      }
    } else {
      setState(() {
        result= [];
      });
    }
  }

  Future<void> loadRecentSearches() async {
    final history = await _history.getSearchHistory();
    setState(() {
      recentSearches = history;
    });
  }
  void clearSearchHistory() async {
    await _history.clearSearchHistory();
    loadRecentSearches();
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
                onSubmitted: (value) {
                  performSearch(value);
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: result.isEmpty
                    ? recentSearches.isEmpty
                        ? const Center(child: Text(""))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Recent Searches",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    TextButton(
                                      child: const Text(
                                        "Clear",
                                        style: TextStyle(color: Colors.blueAccent),),
                                      onPressed: clearSearchHistory,
                                    ),
                                  ],
                                )
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: recentSearches.length,
                                  itemBuilder: (context, index) {
                                    final searchTerm = recentSearches[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              searchTerm,
                                              style: const TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis, 
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () async {
                                              await _history.removeSearchTerm(searchTerm);
                                              loadRecentSearches(); 
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                    : ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          final id = result[index];

                          return FutureBuilder<Map<String, dynamic>?>(
                            future: AppwriteService().fetchUserProfileById(id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const ListTile(
                                  leading: CircularProgressIndicator(color: Colors.grey,),
                                  title: Text("Searching..."),
                                );
                              }
                              final profile = snapshot.data!;
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
                          );
                        },
                      ),
                )
              ],
          ),
        ),
      ),
    );
  }
}