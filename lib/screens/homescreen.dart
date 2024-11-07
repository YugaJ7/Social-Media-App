import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  // final int index;
  // const HomeScreen({required this.index});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(
       backgroundColor: Colors.white,
       actions: [
         IconButton(onPressed: (){}, icon: Icon(Icons.notifications_outlined)),
       ],
     ),
     body: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Card(
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
                   Text("Netflix ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),),
                   SizedBox(width: 4,),
                   Text("@netflix.id", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),)
                 ],
               ),
             ),
             Text("it's all about the looks. LUPIN part 3, October 5 on Netflix"),
             Image.asset('assets/images/lupin.jpeg'),
           ],
         ),
       ),
     ),
   );
  }

}