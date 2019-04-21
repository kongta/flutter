import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
// 请求封装

Future request(url,{formData}) async{
  try{
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if(formData==null){
      response = await dio.post(url);
      print('地址为${url}');
    }else{
      response = await dio.post(url,data:formData);
      print('地址为${url}');
    }
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('服务器异常');
    }
  }catch(e){
    return print('error====>${e}');
  }
}



// Future getHomePageContent() async{
//   try{
//     print('开始获取数据');
//     Response response;
//     Dio dio = new Dio();
//     dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
//     var formData = {
//       'lon':'115.02932','lat':'35.76189'
//     };
//     response = await dio.post(servicePath['homePageContent'],data: formData);
//     if(response.statusCode == 200){
//       return response.data;
//     }else{
//       throw Exception('服务的错误');
//     }
//   }catch(e){
//     return print('error====>${e}');
//   }
// }
