import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_app/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? longitude;

  double? latitude;

  getPermission() async {
    await Geolocator.requestPermission();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      print("LONGITUDE:$longitude");
      print("Latitude:$latitude");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        // foregroundColor: Colors.cyan,
        title:  Text("Location",style: GoogleFonts.oswald(fontWeight: FontWeight.w500,fontSize: 27),),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                child: Image.asset('assets/images/pin.png'),
              ),
              Text(
                'Current Location',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700,color: Colors.white),
              ),
              longitude != null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Longitude:',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white),
                      ),
                      Text(
                        '${longitude?.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24,color: Colors.cyan),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Latitude:',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16,color: Colors.white),
                      ),
                      Text(
                        '${latitude?.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24,color: Colors.cyan),
                      ),
                    ],
                  )
                ],
              )
                  : CircularProgressIndicator(color: Colors.cyan,),

              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                WebViewScreen(latitude: latitude!,longitude: longitude!,)));
                  },
                  child: Text('Web View')),

              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                    String googleUrl =
                        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                    try {
                      launch(googleUrl);
                    } catch (e) {
                      print(e);
                      SnackBar(content: Text('Something Went Wrong'));
                    }
                  },
                  child: Text('Google Map')),

            ]),
      ),
    );
  }
}
