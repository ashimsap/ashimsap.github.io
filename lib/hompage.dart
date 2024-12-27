import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content (e.g., an image)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/img1.jpg"), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent AppBar
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: const Text('W    E    L   C    O   M    E',style: TextStyle(color: Colors.white),),
            centerTitle: true,
          ),
          Row(
            children: [
              SidebarX(controller: SidebarXController(selectedIndex: 0),
              extendedTheme: SidebarXTheme(
                width: 200,
                hoverColor: Colors.red,
                iconTheme: IconThemeData(color: Colors.white),
                textStyle: TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.horizontal( right: Radius.circular(12))
                ),
              ),
              theme: SidebarXTheme(
                  iconTheme: IconThemeData(color: Colors.white),
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.horizontal( right: Radius.circular(12))
                ),
              ),
              items: [
                SidebarXItem(icon: Icons.home, label: "H O M E"),
                SidebarXItem(icon: Icons.search, label: "S E A R C H"),
                SidebarXItem(icon: Icons.person, label: "P R O F I L E")
              ],
              ),
              SizedBox(width: 10,),
              Expanded(child: Container(
               // color: Colors.transparent.withValues(alpha: 0.2),
                child: Center(child: Text("This is the body",style: TextStyle(color: Colors.white),)),))
            ],
          )
        ],
      ),
    );
  }
}
