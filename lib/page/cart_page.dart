import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart' as CartItem;
import './cart_page/cart_bottom.dart' as CartBottom;

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
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, childCategory) {
                    cartList = Provide.value<CartProvide>(context).cartList;
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (BuildContext context, index) {
                        return CartItem.CartItem(cartList[index]);
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom.CartBottom(),
                )
              ],
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