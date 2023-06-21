import 'dart:convert';
import 'package:first_flutter/Screens/add_loo.dart';
import 'package:first_flutter/Screens/details_page.dart';
import 'package:first_flutter/Screens/login_page.dart';
import 'package:first_flutter/Widgets/display_modes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatefulWidget {
  const HomeScreen();
  // factory HomeScreen.fromBase64(String jwt) => HomeScreen(
  //     jwt,
  //     json.decode(
  //         ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  // final String jwt;
  // final Map<String, dynamic> payload;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController; // Nullable type
  bool _isDarkMapStyle = false;
  String _darkStyle = '';
  bool _isDarkMode = false;
  final bool _markerIconLoaded = false;
  String? jwt;
  Map<String, dynamic>? payload;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();
    _getMarkers();
    loadDarkMapStyle().then((darkStyle) {
      setState(() {
        _darkStyle = darkStyle;
        print('Dark map style loaded successfully');
      });
    }).catchError((e) {
      print('Error loading dark map style: $e');
    });
    getTokenFromSharedPreferences();
  }

  void getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');
    if (storedToken != null) {
      print('TOKEN');
      print(storedToken);
      try {
        setState(() {
          jwt = storedToken;
          payload = json.decode(
            ascii.decode(base64.decode(base64.normalize(jwt!.split(".")[1]))),
          );

          print(jwt);
          print(payload);
          print('token and payload^^^');
        });
      } catch (e) {
        // Handle decoding errors
        print('Error decoding JWT token: $e');
      }
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void updateLooId(String looId) {
    final looIdProvider = Provider.of<LooIdProvider>(context, listen: false);
    looIdProvider.setLooId(looId);
  }

  List<Marker> markers = [];
  Future<void> _getMarkers() async {
    try {
      BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 20)),
        'assets/icon.png',
      );
      String url = 'http://10.0.2.2:3000/api/v1/loos'; // API endpoint
      var response = await http.get(Uri.parse(url));
      print('string of some sort');
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (!_markerIconLoaded) {
          await Future.delayed(Duration(milliseconds: 500));
        }
        setState(() {
          markers = List<Marker>.from(data.map((markerData) {
            return Marker(
              markerId: MarkerId(markerData['id']),
              position: LatLng(
                double.parse(markerData['latitude']),
                double.parse(markerData['longitude']),
              ),
              icon: markerIcon,
              infoWindow: InfoWindow(
                title: markerData['description'],
                snippet: 'Rating: ${markerData['rating']}/5.0',
                onTap: () {
                  updateLooId(markerData['id']);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DetailsScreen()));
                },
              ),
            );
          }));
        });
      } else {
        throw Exception('Failed to fetch loos');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  void toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  Future<String> loadDarkMapStyle() async {
    try {
      String darkStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/map_styles/dark.json');
      return darkStyle;
    } catch (e) {
      print('Error loading dark map style: $e');
      return '';
    }
  }

  void toggleMapStyle() {
    setState(() {
      _isDarkMapStyle = !_isDarkMapStyle;
      if (_isDarkMapStyle) {
        print('Setting dark map style');
        _mapController?.setMapStyle(_darkStyle);
      } else {
        print('Setting default map style');
        _mapController?.setMapStyle(null);
      }
    });
  }

//     @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadDarkMapStyle,
          ),
          IconButton(
            onPressed: () {
              toggleMapStyle();
              themeProvider.toggleTheme();
            },
            icon: themeProvider.isDarkMode
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          ),
          ElevatedButton(
            child: const Text('Add a loo'),
            onPressed: () {
              _handleLocationPermission();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddLooScreen()));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
              child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller; // Initialize the _mapController
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(markers),
          )),
          Positioned(
            top: 70,
            right: 10,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              tooltip: 'Get Current Location',
              child: Icon(Icons.location_searching),
            ),
          ),
        ],
      ),
    );
  }
}
