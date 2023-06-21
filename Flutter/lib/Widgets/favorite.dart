import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(favorite ? Icons.check_circle : Icons.check_circle_outline),
      label: const Text('Save to favorites'),
      backgroundColor: Colors.green,
      onPressed: () {
        setState(() {
          favorite = !favorite;
        });
      },
    );
  }
}
