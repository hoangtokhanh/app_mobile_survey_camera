import 'package:flutter/material.dart';

class LoadingItem extends StatelessWidget {
  final double size;

  const LoadingItem({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      'assets/gif/loading.gif',
      width: size,
    ));
  }
}
