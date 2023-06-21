import 'dart:ffi';

import 'package:first_flutter/Screens/add_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class AddLooScreen extends StatefulWidget {
  const AddLooScreen({Key? key}) : super(key: key);

  @override
  AddLooScreenState createState() {
    return AddLooScreenState();
  }
}

class LooIdProvider with ChangeNotifier {
  int? looId;

  void setLooId(String id) {
    looId = int.parse(id);
    notifyListeners();
  }
}

class AddLooScreenState extends State<AddLooScreen> {
  TextEditingController descriptionController = TextEditingController();
  double rating = 3;
  String? currentLatitude;
  String? currentLongitude;
  Position? position;

  bool isLoading = false;
  addLoo(String description, rating, String latitude, String longitude) async {
    String url = "http://10.0.2.2:3000/api/v1/loos";
    Map body = {
      'description': description,
      "rating": rating,
      "latitude": latitude,
      'longitude': longitude,
    };
    print(body);

    var res = await http.Client().post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      print(res.body);
      print("Response status: ${res.statusCode}");

      var jsonResponse = json.decode(res.body);
      print('Response $jsonResponse');
      if (jsonResponse is Map) {
        var looId = jsonResponse['id'];
        print('LooId is $looId');
        Provider.of<LooIdProvider>(context, listen: false).setLooId(looId);
      }
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
          title: const Text("Add a Loo"),
          backgroundColor: Colors.green,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(5),
            children: [
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText:
                        'How do you get to this loo and what is it like?'),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 117, 239, 227),
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rating = rating;
                  });
                  (rating);
                },
              ),
              // Geo(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high)
                        .then((Position position) {
                      setState(
                          () => currentLatitude = position.latitude.toString());
                      setState(() =>
                          currentLongitude = position.longitude.toString());
                    });

                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );

                      addLoo(
                        descriptionController.text,
                        rating,
                        currentLatitude.toString(),
                        currentLongitude.toString(),
                      ).then((looId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewScreen()),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
