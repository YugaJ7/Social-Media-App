import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override

  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
       systemNavigationBarColor: Colors.white,
       statusBarColor: Colors.white,
       statusBarIconBrightness: Brightness.dark,
       systemNavigationBarIconBrightness: Brightness.dark,
      )
    );
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
                      indicator: BoxDecoration(),
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
                      tabs: [
                        Tab(text: 'Feeds',),
                        Tab(text: 'Community',),
                        Tab(text: 'Explore',),
                      ]
                  ),
                ),
                Positioned(left: 4,child: IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.bell)))
              ]
            ),
          ),
          ),
          
          // actions: [
          //   IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.bell)),
          // ],
          // bottom: TabBar(
          //     indicator: BoxDecoration(),
          //     labelColor: Colors.black,
          //     unselectedLabelColor: Colors.grey,
          //     labelStyle: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold
          //     ),
          //     unselectedLabelStyle: TextStyle(
          //       fontWeight: FontWeight.normal,
          //       fontSize: 16,
          //     ),
          //     tabs: [
          //       Tab(text: 'Feeds',),
          //       Tab(text: 'Community',),
          //       Tab(text: 'Explore',),
          //     ]),
        //   actions: [
        //     IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.bell)),
        //   ],
        // ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            // First Card
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/joshan.jpg'),
                    ),
                    title: Row(
                      children: [
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 56, right: 16),
                    child: Text("Me:", style: TextStyle(fontSize: 17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56, right: 16),
                    child: Text("I only use auto layout when I'm designing components for reusability", style: TextStyle(fontSize: 17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56, right: 16),
                    child: Text("Also me:", style: TextStyle(fontSize: 17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( left: 56, right: 16),
                    child: Text("I hate reusing components with auto layout", style: TextStyle(fontSize: 17)),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(16),
                  //     child: Image.asset(
                  //       'assets/images/lupin.jpeg',
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56, right: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.heart, color: Colors.grey)),
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.commentDots, color: Colors.grey)),
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.grey)),
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Second Card (same as the first one)
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/NetflixIcon2016.webp'),
                    ),
                    title: Row(
                      children: [
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 56, right: 16),
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
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.heart, color: Colors.grey)),
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.commentDots, color: Colors.grey)),
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.grey)),
                        IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.white,
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        //   selectedItemColor: Colors.black,  // Color for selected item (black)
        //   unselectedItemColor: Colors.grey,
        //   items: const[
        //     BottomNavigationBarItem(
        //         icon: Icon(FontAwesomeIcons.house),
        //       label: '',
        //     ),
        //     BottomNavigationBarItem(
        //         icon: Icon(FontAwesomeIcons.magnifyingGlass),
        //       label: '',
        //     ),
        //   BottomNavigationBarItem(
        //       icon: Icon(FontAwesomeIcons.envelope),
        //     label: '',
        //   ),
        //   BottomNavigationBarItem(
        //       icon: Icon(FontAwesomeIcons.user),
        //     label: '',
        //   ),
        // ],
        // ),
        floatingActionButton: FloatingActionButton(
            onPressed: (){},
          backgroundColor: Colors.black,
          shape: CircleBorder(),
          child: Icon(FontAwesomeIcons.plus, color: Colors.white,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
