import 'package:flutter/material.dart';

class OverviewLoading extends StatelessWidget {
  const OverviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }
}
