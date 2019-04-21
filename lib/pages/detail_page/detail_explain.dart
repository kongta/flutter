import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailExplain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top:10.0,bottom: 10.0),
      padding: EdgeInsets.fromLTRB(10.0,13.0,10.0,13.0),
      child: Text(
        '说明：>急速送达>正品保证',
        style: TextStyle(
          color: Colors.orange,
          fontSize: ScreenUtil().setSp(30)
        ),
      )
    );
  }
}