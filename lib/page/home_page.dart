import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_shop/helper/http.dart' show RestApi;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  String showText = '你选择的类型';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Get请求'),),
        body: SingleChildScrollView(
          child: Container(
            height: 1000,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: '类型',
                    helperText: '请输入你的类型'
                  ),
                  autofocus: false,
                ),
                RaisedButton(
                  onPressed: _choiceAction,
                  child: Text('选择完毕'),
                ),
                Text(
                  showText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _choiceAction () {
    print('开始选择你的类型....');
    if(typeController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('类型不能为空'),)
      );
    } else {
      getHttp(typeController.text.toString()).then((res) {
        setState(() {
          print('测试$res');
          showText = res['data']['name'].toString();
        });
      });

      // RestApi.get('https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian', typeController.text.toString()).then(
      //   (res) {
      //   setState(() {
      //       print('测试1$res');
      //       showText = res['data']['name'].toString();
      //     });
      //   }
      // );
    }
  }

  Future getHttp(String TypeText) async {
    try{
      Response response;
      var data = {'name': TypeText};
      // response = await Dio().get(
      //   'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian',
      //   queryParameters: data
      // );
      response = await Dio().post(
        'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/post_dabaojian',
        queryParameters: data
      );
      return response.data;
    } catch(e) {
      return print(e);
    }
  }
}