
import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/processbuy/display_cart.dart';




class ShowAddCart extends StatelessWidget {
  final Function()? callBackFunc;
  const ShowAddCart({
    Key? key,
    this.callBackFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayCart(),
              ),
            ).then((value) => callBackFunc),
        icon: Icon(Icons.shopping_cart));
  }
}
