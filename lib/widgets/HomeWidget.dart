import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab4_mis/widgets/LoginWidget.dart';
import 'package:lab4_mis/widgets/calendarapp.dart';
import 'package:lab4_mis/model/list_item.dart';
import 'nov_element.dart';
import 'package:firebase_core/firebase_core.dart';
class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}
class _HomeWidgetState extends State<HomeWidget>{


  List<ListItem> _userItems = [
    ListItem(id: "T1", naslov: "Algoritmi i podatocni strukturi", datum: "2022-12-25", vreme: "14:15"),
    ListItem(id: "T2", naslov: "Verojatnost i statistika", datum: "2022-12-27", vreme: "16:00"),
    ListItem(id: "T3", naslov: "Kalkulus 1", datum: "2022-12-27", vreme: "15:30")
  ];


  void _openCalendarFunction(BuildContext ct){
    showModalBottomSheet(
        context: ct,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(onTap: () {},
              child: CalendarApp(),
              behavior: HitTestBehavior.opaque);
        });
  }
  void _addItemFunction(BuildContext ct) {

    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(onTap: () {},
              child: NovElement(_addNewItemToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userItems.removeWhere((elem) => elem.id == id);
    });
  }
  Widget _createBody() {
    return Center(
      child: _userItems.isEmpty
          ? Text("Nema elementi")
          : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: ListTile(
              title: Text(_userItems[index].naslov),
              subtitle: Text(_userItems[index].datum + " " + _userItems[index].vreme),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteItem(_userItems[index].id),
              ),
            ),
          );
        },
        itemCount: _userItems.length,
      ),
    );
  }

  Widget _createAppBar() {
    return AppBar(
      // The title text which will be shown on the action bar

        title: Text("Datumi za kolokviumi i ispiti"),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addItemFunction(context),
          ),
          IconButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_rounded),
          )
        ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _createAppBar()
        ),
        body: _createBody(),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          onPressed: () {
            _openCalendarFunction(context);
          },
          icon: Icon(Icons.calendar_month),
          label: Text('CALENDAR'),
        )
    );
  }

}