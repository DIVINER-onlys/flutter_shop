import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart' as CartItem;

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('购物车'),),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List cartList = Provide.value<CartProvide>(context).cartList;
            return ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (BuildContext context, index) {
                return CartItem.CartItem(cartList[index]);
              },
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async{
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}