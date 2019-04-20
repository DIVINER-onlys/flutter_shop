import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader()
        ],
      ),
    );
  }

  Widget _topHeader(){
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            width: ScreenUtil().setWidth(120),
            // height: ScreenUtil().setHeight(100),
            child: ClipOval(
              child: Image.network('http://www.gx8899.com/uploads/allimg/2018021008/mcjasrwyb13.jpg'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Sam',
              style: TextStyle(fontSize: ScreenUtil().setSp(36), color: Colors.black54)
            ),
          )
        ],
      ),
    );
  }
}
