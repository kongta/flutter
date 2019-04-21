import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/categoty_good_list.dart';
import './provide/goods_detail.dart';
import './provide/cart_provide.dart';
import './provide/currentIndex.dart';
import 'package:fluro/fluro.dart';
import './router/routes.dart';
import './router/application.dart';


void main(){
  var childCategory = ChildCategory();
  var counter =Counter();
  var categoryGoodList =CategoryGoodList();
  var detailProvie =DetailProvde();
  var cartProvide =CartProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers  =Providers();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodList>.value(categoryGoodList))
    ..provide(Provider<DetailProvde>.value(detailProvie))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide));
  runApp(ProviderNode(child:MyApp(),providers:providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.initRouter(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title:'百姓生活+', 
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor:Colors.pink
        ),
        home:IndexPage()
      ),
    );
  }
}
