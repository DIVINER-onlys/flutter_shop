import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/httpHeaders.dart';

class CateGoryPage extends StatefulWidget {
  @override
  _CateGoryPageState createState() => _CateGoryPageState();
}

class _CateGoryPageState extends State<CateGoryPage> {
  String showText = '还没有数据';
  void _jike(){
    print('开始向极客时间请求数据....');
    getHttp().then((val) {
      setState(() {
        showText = val['data'].toString();
      });
    });
  }
  Future getHttp () async {
    try {
      Response response;
      Dio dio = new Dio();
      dio.options.headers = httpHeaders;
      response = await dio.get('https://time.geekbang.org/serv/v1/column/topList');
      print(response);
      return response.data;
    } catch(e) {
      return print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('请求远程数据'),),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: _jike,
                child: Text('请求数据'),
              ),
              Text(showText)
            ],
          ),
        ),
      ),
    );
  }
}