// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:first_flutter/Screens/add_loo.dart';
import 'package:first_flutter/Screens/add_review.dart';
import 'package:first_flutter/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    _getReviews();
  }

  List<Widget> _reviews = [];

  Future<void> _getReviews() async {
    final looIdProvider = Provider.of<LooIdProvider>(context, listen: false);
    final looId = looIdProvider.looId;
    try {
      final url =
          'http://10.0.2.2:3000/api/v1/reviews/byLooId/$looId'; // API endpoint
      var response = await http.get(Uri.parse(url));
      log('LOOID $looId');
      log('string of some sort in REVIEWS');
      log('RESPONSE.BODY in details page ${response.body}');
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _reviews = List<Widget>.from(data.map((reviewData) {
            return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    //     border: Border.all(color: Colors.black, width: 3.0),
                    color: Color.fromARGB(255, 180, 224, 245),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Cleanliness',
                                style: TextStyle(fontSize: 18)))),
                    Align(
                        alignment: Alignment.center,
                        child: RatingBar.builder(
                          initialRating:
                              double.parse('${reviewData['cleanliness']}'),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          ignoreGestures: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.soap,
                            color: Color.fromARGB(255, 1, 130, 117),
                          ),
                          onRatingUpdate: (rating) {
                            log(rating.toString());
                          },
                        )),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Safety',
                                style: TextStyle(fontSize: 18)))),
                    Align(
                        alignment: Alignment.center,
                        child: RatingBar.builder(
                          initialRating:
                              double.parse('${reviewData['safety']}'),
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.lock_outline,
                            color: Color.fromARGB(255, 1, 130, 117),
                          ),
                          onRatingUpdate: (rating) {
                            log(rating.toString());
                          },
                        )),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Accessibility',
                                style: TextStyle(fontSize: 18)))),
                    Align(
                        alignment: Alignment.center,
                        child: RatingBar.builder(
                          initialRating:
                              double.parse('${reviewData['accessibility']}'),
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.accessible,
                            color: Color.fromARGB(255, 1, 130, 117),
                          ),
                          onRatingUpdate: (rating) {
                            log(rating.toString());
                          },
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                            child: Text(
                                'Gendered: ${reviewData['gendered'] ? 'Yes' : 'No'}')),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                                'Locked: ${reviewData['locks'] ? 'Yes' : 'No'}')),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 25, 0),
                            child: Text(
                                'Sanitizer: ${reviewData['sanitizer'] ? 'Yes' : 'No'}')),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(50, 25, 50, 0),
                        child: Text('Amenities: ${reviewData['amenities']}')),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(50, 25, 50, 15),
                        child: Text('Comments: ${reviewData['comments']}')),
                  ],
                ));
          }));
        });
      } else {
        throw Exception('Failed to fetch reviews');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(255, 255, 191, 105),
        ),
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Loo Reviews'),
                elevation: 2,
                actions: [
                  IconButton(
                    onPressed: _getReviews,
                    icon: const Icon(Icons.refresh),
                  ),
                  ElevatedButton(
                    child: const Text('Go home'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()));
                    },
                  ), // ElevatedButton
                  ElevatedButton(
                    child: const Text('Add a review'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ReviewScreen()));
                      log('you clicked');
                    },
                  ),
                ]),
            body: Stack(
              children: [
                ListView.builder(
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) => _reviews[index],
                )
              ],
            )));
  }
}
