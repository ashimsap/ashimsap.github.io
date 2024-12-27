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
                hoverColor: Colors.blueGrey,
                iconTheme: IconThemeData(color: Colors.white),
                textStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.lightBlueAccent),
                hoverTextStyle: TextStyle(color: Colors.blueGrey, fontSize: 18),
                hoverIconTheme: IconThemeData(color: Colors.blueGrey, applyTextScaling: true),
                selectedIconTheme: IconThemeData(color: Colors.lightBlueAccent),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.horizontal( right: Radius.circular(12))
                ),
              ),
              theme: SidebarXTheme(
                hoverColor: Colors.blueGrey,
                iconTheme: IconThemeData(color: Colors.white),
                textStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.lightBlueAccent),
                hoverTextStyle: TextStyle(color: Colors.blueGrey),
                hoverIconTheme: IconThemeData(color: Colors.blueGrey, applyTextScaling: true),
                selectedIconTheme: IconThemeData(color: Colors.lightBlueAccent),
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
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                        color: Colors.transparent.withValues(alpha: 0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("This is the body",style: TextStyle(color: Colors.white),),
                        )
                    ),
                    SizedBox(width: 20,),
                    Container(
                        color: Colors.transparent.withValues(alpha: 0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("This is the second body",style: TextStyle(color: Colors.white),),
                        )
                    ),
                  ],
                ),

                  /*child: Container(
               // color: Colors.transparent.withValues(alpha: 0.2),
                child: Center(child: Text("This is the body",style: TextStyle(color: Colors.white),)),)*/
              ),
            ],
          )
        ],
      ),
    );
  }
}
