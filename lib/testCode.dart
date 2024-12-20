import 'package:flutter/material.dart';

class  MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("I am  ashim", style: TextStyle(color: Colors.white, fontSize: 32),),
    ),
    decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.2),
    borderRadius: BorderRadius.circular(12),
  /*  boxShadow:[
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
    ),*/
    ));
  }
}





