import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DetailEntryLoading extends StatelessWidget {
  const DetailEntryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: Theme.of(context).colorScheme.onBackground,
      child: const Card(
        child: ListTile(
          title: Text('Loading'),
        ),
      ),
    );
  }
}
