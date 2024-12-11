import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text("W E L C O M E", style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold, fontSize: 28),),
        centerTitle: true,
      ),
      body: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(colors: [Colors.blue,Colors.pinkAccent,Colors.red,Colors.green]),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          const Text("this is the body",textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(

                height: 150,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:[
                    BoxShadow(
                    offset: const Offset(-5, -5),
                    color: Colors.grey.shade500,
                    blurRadius: 12,
                  ),
                    BoxShadow(
                      offset: const Offset(5, 5),
                      color: Colors.grey.shade900,
                      blurRadius: 12,
                    )],
                ),
                child: const Center(child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text("H  E  L  L  O, "),
                      Text("MadaFaka")
                    ],
                  ),
                )),
              ),
            )
        ],),
      ),
    );
  }
}

