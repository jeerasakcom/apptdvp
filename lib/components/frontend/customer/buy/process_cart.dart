import 'package:flutter/material.dart';
import 'package:tdvp/components/frontend/customer/buy/display_cart.dart';

class ProcessCart extends StatelessWidget {
  final Function()? callBackFunc;
  const ProcessCart({
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
