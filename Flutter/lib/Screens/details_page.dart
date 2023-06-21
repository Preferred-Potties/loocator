import 'dart:convert';
import 'package:first_flutter/Screens/add_loo.dart';
import 'package:first_flutter/Screens/add_review.dart';
import 'package:first_flutter/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      print('LOOID ${looId}');
      print('string of some sort in REVIEWS');
      print('RESPONSE.BODY in details page ${response.body}');
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _reviews = List<Widget>.from(data.map((reviewData) {
            return Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black, width: 3.0),
                    color: Color.fromARGB(255, 180, 224, 245),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
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
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.soap,
                            color: Color.fromARGB(255, 1, 130, 117),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
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
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.lock_outline,
                            color: Color.fromARGB(255, 1, 130, 117),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
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
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.accessible,
                            color: Color.fromARGB(255, 1, 130, 117),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color.fromARGB(255, 255, 191, 105),
        ),
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Loo Reviews'),
                elevation: 2,
                actions: [
                  IconButton(
                    onPressed: _getReviews,
                    icon: Icon(Icons.refresh),
                  ),
                  ElevatedButton(
                    child: const Text('Go home'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                  ), // ElevatedButton
                  ElevatedButton(
                    child: const Text('Add a review'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ReviewScreen()));
                      print('you clicked');
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
