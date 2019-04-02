import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTaps = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会议中心')
    )
  ];
  final List<Widget> tabBodies = [
    HomePage(),
    CateGoryPage(),
    CartPage(),
    MemberPage()
  ];
  int currentIndex = 0;
  var currentPage;
  @override
    void initState() {
      currentPage = tabBodies[currentIndex];
      // TODO: implement initState
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    // 引入屏幕适配
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print('设备像素密度:${ScreenUtil.pixelRatio}');
    print('设备高:${ScreenUtil.screenHeight}');
    print('设备高DP:${ScreenUtil.screenHeightDp}');
    print('设备宽:${ScreenUtil.screenWidth}');
    print('设备宽DP:${ScreenUtil.screenWidthDp}');
    print('设备信息：${MediaQuery.of(context).size}');

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTaps,
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}