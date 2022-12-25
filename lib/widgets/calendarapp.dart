import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';


class CalendarApp extends StatefulWidget {
  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {

  DateTime? selectedDay;
  List <CleanCalendarEvent>? selectedEvent;

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
    );
  }
}