import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes{
  static String detailPage = '/detail';
  static void initRouter(Router router){
    router.define(detailPage,handler: DetailPageHandler);
  }
}