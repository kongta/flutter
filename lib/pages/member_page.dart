import 'package:flutter/material.dart';
import '../provide/counter.dart';
import 'package:provide/provide.dart';

class MemberPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body:Center(
          child:Provide<Counter>(
            builder: (context,child,counter){
              return Text('${counter.value}');
            },
          )
        )
      )
    );
  }
}