import 'package:flutter/material.dart';

class LockedActionChip extends StatefulWidget {
  const LockedActionChip({super.key});

  @override
  State<LockedActionChip> createState() => _LockedActionChipState();
}

class _LockedActionChipState extends State<LockedActionChip> {
  bool _locks = false;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(
        _locks ? Icons.lock_outline : Icons.lock_open,
        color: const Color.fromARGB(255, 117, 239, 227),
      ),
      label: const Text('Locked?', style: TextStyle()),
      padding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      onPressed: () {
        setState(() {
          _locks = !_locks;
        });
      },
    );
  }
}
