import 'dart:convert';
import 'package:first_flutter/Screens/add_loo.dart';
import 'package:first_flutter/Screens/home_page.dart';
import 'package:first_flutter/Screens/login_page.dart';
import 'package:first_flutter/Screens/details_page.dart';
import 'package:first_flutter/Screens/add_review.dart';
import 'package:first_flutter/Widgets/display_modes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("jwt");
    if (jwt == null) return "N";
    return jwt.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LooIdProvider>(
            create: (_) => LooIdProvider(),
          ),
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(),
          )
        ],
        child: Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
          return MaterialApp(
            routes: {
              '/AddLoo': (context) => AddLooScreen(),
              '/AddReviews': (context) => ReviewScreen(),
              '/Details': (context) => DetailsScreen(),
              '/Login': (context) => LoginPage(),
            },
            title: 'Loocater Login',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode
                ? AppThemes.darkTheme
                : AppThemes.lightTheme,
            home: FutureBuilder(
                future: jwtOrEmpty,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LoginPage();
                  if (snapshot.data != "N") {
                    dynamic str = snapshot.data;
                    dynamic jwt =
                        str.length > 1 ? str.toString().split(".") : "";
                    if (jwt.length != 3) {
                      return LoginPage();
                    } else {
                      var payload = json.decode(ascii
                          .decode(base64.decode(base64.normalize(jwt[1]))));
                      if (DateTime.fromMillisecondsSinceEpoch(
                              payload["exp"] * 1000)
                          .isAfter(DateTime.now())) {
                        return HomeScreen();
                      } else {
                        return LoginPage();
                      }
                    }
                  } else {
                    return LoginPage();
                  }
                }),
          );
        }));
  }
}
