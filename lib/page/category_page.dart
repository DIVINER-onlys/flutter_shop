import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


class CateGoryPage extends StatefulWidget {
  @override
  _CateGoryPageState createState() => _CateGoryPageState();
}

class _CateGoryPageState extends State<CateGoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('商品分类'),),
        body: Container(
          child: Row(
            children: <Widget>[
              LeftCategoryNav(),
              Column(
                children: <Widget>[
                  _RightCatetoryNav(),
                  CategoryGoodsList()
                ],
              )
            ],
          ),
        )
      ),
    );
  }

}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      this._getCategory();
      this._getGoodList();
    }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick=(index==listIndex)?true:false;
    return InkWell(
      onTap: (){
        this.setState((){
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList, categoryId);
        _getGoodList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top: 20),
        decoration: BoxDecoration(
          color: isClick?Color.fromRGBO(236, 236, 236, 1.0):Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName, style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());
      // print('大水电费水电费第三方第三方对方$data');
      CategoryModel category = CategoryModel.fromJson(data);
      this.setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      // list.forEach((item) => print(item.mallCategoryName));
    });
  }


  void _getGoodList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };

    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategroyGoodsListModel goodsList = CategroyGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

// 右侧大类导航
class _RightCatetoryNav extends StatefulWidget {
  @override
  __RightCatetoryNavState createState() => __RightCatetoryNavState();
}

class __RightCatetoryNavState extends State<_RightCatetoryNav> {
  // List list = ['名酒', '宝丰', '北京二锅头', '大明', '茅台', '五粮液', '散白'];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (child, context, childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black12,width: 1.0)
            )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(index, childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _rightInkWell (int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index==Provide.value<ChildCategory>(context).childIndex)?true: false;
    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index, item.mallSubId);
        _getGoodList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick?Colors.pink:Colors.black
          ),
        ),
      ),
    );
  }

  void _getGoodList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };

    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategroyGoodsListModel goodsList = CategroyGoodsListModel.fromJson(data);
      if(goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }
}

// 商品列表，可以上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerkey = new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
        try{
          if(Provide.value<ChildCategory>(context).page == 1) {
            // 列表位置放到最上边
            scrollController.jumpTo(0.0);
          }
        }catch(e){
          print('进入页面第一次初始化${e}');
        }
        if (data.goodsList.length>0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              // height: ScreenUtil().setHeight(970),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerkey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo: '加载中',
                  loadReadyText: '上拉加载...',
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listWiget(data.goodsList, index);
                  },
                ),
                loadMore: () async {
                  print('上拉加载更多');
                  _getMoreList();
                },
              )
            ),
          );
        } else {
          return Text(
            '暂无数据'
          );
        }
      },
    );
  }
  void _getMoreList({String categoryId}) async {
    Provide.value<ChildCategory>(context).addPage();

    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategroyGoodsListModel goodsList = CategroyGoodsListModel.fromJson(data);
      if(goodsList.data == null) {
        Provide.value<ChildCategory>(context).changeNoMore('没有更多数据了');
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(goodsList.data);
      }
    });
  }


  Widget _goodImage (List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }
  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28)
        ),
      ),
    );
  }

  Widget _goodsPrice (List newList, index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格，￥${newList[index].presentPrice}',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              color: Colors.pink
            ),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(
              color: Colors.black26,
              decoration: TextDecoration.lineThrough
            ),
          )
        ],
      ),
    );
  }

  Widget _listWiget(List newList, int index) {
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }
}