import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';


class CalendarApp extends StatefulWidget {
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {

  DateTime? selectedDay;
  List <CleanCalendarEvent>? selectedEvent;

  late String lat;
  late String long;
  String locationMessage = 'Current location displayed';

  final Map<DateTime,List<CleanCalendarEvent>> events = {
    DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day):
    [
      CleanCalendarEvent('Algoritmi i podatocni strukturi',
          startTime: DateTime(2022,12,25,14,15),
          endTime:  DateTime(2022,12,25,16,30),
          description: 'Kolokvium I',
          color: Colors.blue),
    ],

    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
    [
      CleanCalendarEvent('Verojatnost i statistika',
          startTime: DateTime(2022, 12, 23, 16, 00),
          endTime: DateTime(2022, 12, 23, 19, 00),
          color: Colors.orange),
      CleanCalendarEvent('Kalkulus 1',
          startTime: DateTime(2022, 12, 28, 15, 30),
          endTime: DateTime(2022, 12, 28, 18, 00),
          color: Colors.pink),
    ],
  };

  void _handleData(date){
    setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });
    print(selectedDay);
  }
  @override
  void initState() {
    // TODO: implement initState
    selectedEvent = events[selectedDay] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        centerTitle: true,
      ),
      body:  SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Calendar(
            startOnMonday: true,
            selectedColor: Colors.blue,
            todayColor: Colors.red,
            eventColor: Colors.green,
            eventDoneColor: Colors.amber,
            bottomBarColor: Colors.deepOrange,
            onRangeSelected: (range) {
              print('selected Day ${range.from},${range.to}');
            },
            onDateSelected: (date){
              return _handleData(date);
            },
            events: events,
            isExpanded: true,
            dayOfWeekStyle: TextStyle(
              fontSize: 15,
              color: Colors.black12,
              fontWeight: FontWeight.w100,
            ),
            bottomBarTextStyle: TextStyle(
              color: Colors.white,
            ),
            hideBottomBar: false,
            hideArrows: false,
            weekDays: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          onPressed: () {
              getLocation();
          },
          icon: Icon(Icons.location_city),
          label: Text('Get location'),
        )
    );
  }
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location services are disabled!');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location permissions are denied!');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Locaton permissions are permanently denied!');
    }

    return await Geolocator.getCurrentPosition();
  }
  void _liveLocation(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude $long';
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
    ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  Future getLocation() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: Text('The location of the exam'),
          content: Text(locationMessage, textAlign: TextAlign.center),
          actions: [
            TextButton(
                onPressed: (){
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';

                    setState(() {
                      locationMessage = 'Latitude: $lat, Longitude $long';
                    });

                    _liveLocation();

                  });
                },
                child: Text('Get Location')),
            TextButton(
                onPressed: (){
                  _openMap(lat, long);
                },
                child: Text('Open in Google Maps')),
            TextButton(
                onPressed: (){
                    Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
      ),
  );

}