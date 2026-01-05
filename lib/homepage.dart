import 'package:blurbox/blurbox.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Stack(
        children: [
          // Background content
          Container(
            color: Colors.black, // Placeholder color since image is missing
            /*
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/img1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            */
          ),
          Row(
            children: [
              SidebarX(
                controller: _controller,
                extendedTheme: SidebarXTheme(
                  width: 200,
                  hoverColor: Colors.blueGrey,
                  iconTheme: const IconThemeData(color: Colors.white),
                  textStyle: const TextStyle(color: Colors.white),
                  selectedTextStyle: const TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
                  hoverTextStyle: const TextStyle(color: Colors.blueGrey, fontSize: 18),
                  hoverIconTheme: const IconThemeData(color: Colors.blueGrey, size: 30),
                  selectedIconTheme: const IconThemeData(color: Colors.lightBlueAccent, size: 30),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(12))),
                ),
                theme: SidebarXTheme(
                  hoverColor: Colors.blueGrey,
                  iconTheme: const IconThemeData(color: Colors.white),
                  textStyle: const TextStyle(color: Colors.white),
                  selectedTextStyle: const TextStyle(color: Colors.lightBlueAccent, fontSize: 18),
                  hoverTextStyle: const TextStyle(color: Colors.blueGrey),
                  hoverIconTheme: const IconThemeData(color: Colors.blueGrey, size: 30),
                  selectedIconTheme: const IconThemeData(color: Colors.lightBlueAccent, size: 30),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(12))),
                ),
                items: const [
                  SidebarXItem(icon: Icons.home, label: "H O M E"),
                  SidebarXItem(icon: Icons.search, label: "S E A R C H"),
                  SidebarXItem(icon: Icons.person, label: "P R O F I L E")
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return _Screens(controller: _controller);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Screens extends StatelessWidget {
  const _Screens({
    required this.controller,
  });

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    switch (controller.selectedIndex) {
      case 0:
        return const _HomeContent();
      case 1:
        return const Center(child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 30)));
      case 2:
        return const Center(child: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 30)));
      default:
        return const Center(child: Text("Not found", style: TextStyle(color: Colors.white, fontSize: 30)));
    }
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BlurBox(
          height: 150,
          width: 150,
          borderRadius: BorderRadius.circular(12),
          blur: 2,
          color: Colors.black.withValues(alpha: 0.2),
          child: const Center(
            child: Text(
              "This is Blur Box",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
