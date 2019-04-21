import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int value = 99;
  increment(){
    value++;
    notifyListeners();
  }
}
