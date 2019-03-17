import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';

class CateGoryPage extends StatefulWidget {
  @override
  _CateGoryPageState createState() => _CateGoryPageState();
}

class _CateGoryPageState extends State<CateGoryPage> {
  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('请求远程数据'),),
        body: Container(
          child: Center(
            child: Text('data'),
          ),
        )
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());
      print('大水电费水电费第三方第三方对方$data');
    });
  }
}