import 'package:flutter/material.dart';

class GenderedActionChip extends StatefulWidget {
  const GenderedActionChip({super.key});

  @override
  State<GenderedActionChip> createState() => _GenderedActionChipState();
}

class _GenderedActionChipState extends State<GenderedActionChip> {
  bool _gendered = false;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(
        _gendered ? Icons.wc : Icons.man_4_outlined,
        color: const Color.fromARGB(255, 117, 239, 227),
      ),
      label: const Text('Gendered?', style: TextStyle()),
      padding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      onPressed: () {
        setState(() {
          _gendered = !_gendered;
        });
      },
    );
  }
}
