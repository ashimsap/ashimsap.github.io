import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/testCode.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Variable to keep track of whether the drawer is expanded or collapsed
  bool isDrawerExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold transparent to show the image

    /*  appBar: AppBar(
        leading: Icon(Icons.home,color: Colors.black,),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Welcome"),
        centerTitle: true,
        actions: [
          // Button to toggle the drawer collapse/expand
          IconButton(
            icon: Icon(
              isDrawerExpanded ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                // Toggle drawer expansion/collapse
                isDrawerExpanded = !isDrawerExpanded;
              });
            },
          )
        ],
      ),*/
      body: Stack(
        children: [
          // Background Image that fills the screen
          Positioned.fill(
            child: Image.asset(
              "assets/images/img1.jpg", // Your image path
              fit: BoxFit.cover, // Fill the screen
            ),
          ),
          // Main content area
          Row(
            children: [
              // The Drawer
              CollapsibleSidebar(
                backgroundColor: Colors.black.withOpacity(0.2),
                  sidebarBoxShadow: [],
                  avatarImg: AssetImage("assets/images/ashim.jpg"),

                  
                  items: [
                CollapsibleItem(text: "Home",icon: Icons.home, onPressed: (){}),
                CollapsibleItem(text: "Search", icon: Icons.search, onPressed: (){}),

              ],
                  body: Text("")),
              // Main content area next to the drawer
              Expanded(
                child: Center(
                  child: Row(
                    children: [
                      MyContainer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





