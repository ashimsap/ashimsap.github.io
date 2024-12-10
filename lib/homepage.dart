import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text("W E L C O M E", style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text("this is the body",textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:[
                    BoxShadow(
                    offset: Offset(-5, -5),
                    color: Colors.grey.shade500,
                    blurRadius: 12,
                  ),
                    BoxShadow(
                      offset: Offset(5, 5),
                      color: Colors.grey.shade900,
                      blurRadius: 12,
                    )],
                ),
                width: 150,
                height: 150,
              ),
            )
        ],),
      ),
    );
  }
}

