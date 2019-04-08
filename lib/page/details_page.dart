import 'package:flutter/material.dart';

class DetialsPage extends StatelessWidget {
  final String goodsId;
  DetialsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('商品Id：$goodsId'),
      ),
    );
  }
}