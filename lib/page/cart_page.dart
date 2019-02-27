import 'package:flutter/material.dart';
import '../service/service_method.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String homePageContent = '正在获取数据';
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getHomePageContent().then((val) {
        print(val);
        setState(() {
          homePageContent = val.toString();
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body: SingleChildScrollView(
        child: Text(homePageContent),
      ),
    );
  }
}