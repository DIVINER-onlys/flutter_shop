import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 子类高亮索引
  String categoryId = '4'; // 大类ID
  String subId = ''; // 小类Id
  int page = 1; // 列表页数
  String noMoreText = '';  //显示没有数据的文字

  // 改变大类索引
  getChildCategory(List<BxMallSubDto> list, String id) {
    noMoreText = '';
    page = 1;
    childIndex = 0;
    categoryId = id;

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex (index, String id) {
    noMoreText = '';
    page = 1;
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  // 增加Page的方法
  addPage () {
    page++;
  }

  // 改变noMoreText
  changeNoMore (String text) {
    noMoreText = text;
    notifyListeners();
  }
}