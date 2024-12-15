import 'package:flutter/material.dart';

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

      appBar: AppBar(
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
      ),
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
              Drawer(
                width: isDrawerExpanded ? 250 : 70, // Change width based on expanded/collapsed state
                child: Column(
                  children: [
                    // Avatar at the top of the drawer
                    UserAccountsDrawerHeader(
                      accountName: isDrawerExpanded ? const Text('Username') : const Text(''),
                      accountEmail: isDrawerExpanded ? const Text('email@example.com') : const Text(''),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/avatar.jpg"), // Your avatar image path
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                    ),
                    // Drawer items
                    ListTile(
                      leading: Icon(Icons.home),
                      title: isDrawerExpanded ? const Text('Home') : null,
                      onTap: () {
                        // Handle Home item tap
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: isDrawerExpanded ? const Text('Profile') : null,
                      onTap: () {
                        // Handle Profile item tap
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.search),
                      title: isDrawerExpanded ? const Text('Search') : null,
                      onTap: () {
                        // Handle Search item tap
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: isDrawerExpanded ? const Text('Settings') : null,
                      onTap: () {
                        // Handle Settings item tap
                      },
                    ),
                  ],
                ),
              ),
              // Main content area next to the drawer
              Expanded(
                child: Center(
                  child: Text(
                    'Content goes here!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white, // Make text white for contrast
                    ),
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

