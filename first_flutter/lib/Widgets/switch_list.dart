import 'package:flutter/material.dart';

class SwitchList extends StatefulWidget {
  const SwitchList({Key? key}) : super(key: key);

  @override
  State<SwitchList> createState() => _SwitchListState();
}

class _SwitchListState extends State<SwitchList> {
  bool _sanitizer = false;
  bool _locked = false;
  bool _gendered = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SwitchListTile(
        value: _sanitizer,
        title: const Text('Sanitizer'),
        onChanged: (bool? value) {
          if (value != null) {
            setState(() {
              _sanitizer = value;
            });
          }
        },
      ),
      SwitchListTile(
        value: _locked,
        title: const Text('Locked'),
        onChanged: (bool? value) {
          setState(() {
            _locked = value!;
          });
        },
      ),
      SwitchListTile(
        value: _gendered,
        title: const Text('Gendered'),
        onChanged: (bool? value) {
          setState(() {
            _gendered = !_gendered;
          });
        },
      ),
    ]);
  }
}
