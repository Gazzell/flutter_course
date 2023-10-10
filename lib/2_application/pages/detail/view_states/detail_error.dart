import 'package:flutter/material.dart';

class DetailError extends StatelessWidget {
  const DetailError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Text('Item could not be loaded'),
    );
  }
}
