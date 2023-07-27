import 'dart:developer';

import 'package:first_flutter/Screens/add_loo.dart';
import 'package:first_flutter/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  ReviewScreenState createState() {
    return ReviewScreenState();
  }
}

class ReviewScreenState extends State<ReviewScreen> {
  int? looId;
  int? _cleanliness = 3;
  int? _safety = 3;
  int? _accessibility = 3;
  bool _sanitizer = false;
  bool _locks = false;
  bool _gendered = false;
  TextEditingController amenitiesController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  bool isLoading = false;

  addReview(
    looId,
    cleanliness,
    safety,
    accessibility,
    gendered,
    locks,
    sanitizer,
    String comments,
    String amenities,
  ) async {
    String url = "http://10.0.2.2:3000/api/v1/reviews";
    Map body = {
      'loo_id': looId,
      'cleanliness': _cleanliness,
      "safety": _safety,
      "accessibility": _accessibility,
      'gendered': _gendered,
      'locks': _locks,
      'sanitizer': _sanitizer,
      'amenities': amenities,
      'comments': comments,
    };
    log('Sanitizer: $_sanitizer');

    var res = await http.Client().post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      log("Response status: ${res.statusCode}");

      var jsonResponse = (res.body);
      log('Response $jsonResponse');
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Review the Loo"),
          backgroundColor: const Color.fromARGB(255, 255, 159, 28)), // AppBar
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Align(
                    alignment: Alignment.center,
                    child:
                        Text('Cleanliness', style: TextStyle(fontSize: 18)))),
            Align(
                alignment: Alignment.center,
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.soap,
                    color: Color.fromARGB(255, 117, 239, 227),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _cleanliness = rating.toInt();
                    });
                    (rating);
                  },
                )),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Align(
                    alignment: Alignment.center,
                    child: Text('Safety', style: TextStyle(fontSize: 18)))),
            Align(
                alignment: Alignment.center,
                child: RatingBar.builder(
                    initialRating: 3,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 117, 239, 227),
                        ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _safety = rating.toInt();
                      });
                      (rating);
                    })),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Align(
                    alignment: Alignment.center,
                    child:
                        Text('Accessibility', style: TextStyle(fontSize: 18)))),
            Align(
                alignment: Alignment.center,
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.accessible,
                    color: Color.fromARGB(255, 117, 239, 227),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _accessibility = rating.toInt();
                    });
                    (rating);
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SwitchListTile(
                value: _sanitizer,
                title: const Text('Sanitizer'),
                onChanged: (bool value) {
                  setState(() {
                    _sanitizer = value;
                  });
                },
              ),
            ),
            SwitchListTile(
              value: _locks,
              title: const Text('locks'),
              onChanged: (bool value) {
                setState(() {
                  _locks = value;
                });
              },
            ),
            SwitchListTile(
              value: _gendered,
              title: const Text('Gendered'),
              onChanged: (bool value) {
                setState(() {
                  _gendered = value;
                });
              },
            ),

            // GenderedActionChip()
            // ])),
            Padding(
                padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
                child: TextFormField(
                  maxLines: null,
                  controller: amenitiesController,
                  decoration: const InputDecoration(
                      hintMaxLines: 2,
                      labelText: 'other amenities',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 117, 239, 227),
                        width: 2.0,
                      )),
                      isDense: true,
                      hintText:
                          'menstrual products, toilet paper, handwashing station, etc.'),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
              child: TextFormField(
                controller: commentsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'comments',
                    hintText: 'anything else'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(100, 25, 100, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    var looId =
                        Provider.of<LooIdProvider>(context, listen: false)
                            .looId;
                    addReview(
                      looId,
                      _cleanliness,
                      _safety,
                      _accessibility,
                      _gendered,
                      _locks,
                      _sanitizer,
                      amenitiesController.text,
                      commentsController.text,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()));
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(elevation: 3),
                  child: const Text('Submit!'),
                ))
          ], // ElevatedButton
        ), // Center
      ),
    ); // Scaffold
  }
}
