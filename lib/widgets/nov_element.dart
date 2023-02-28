import 'package:flutter/material.dart';
import 'package:lab4_mis/widgets/local_notification_service.dart';
import 'package:nanoid/nanoid.dart';
import '../model/list_item.dart';
import 'adaptive_flat_button.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NovElement extends StatefulWidget {
  final Function addItem;

  NovElement(this.addItem);
  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final _naslovController = TextEditingController();
  
  late String naslov;
  late String datum;
  late String vreme;

  void _submitData(){
    if (_naslovController.text.isEmpty) {
      return;
    }
    final vnesenNaslov = _naslovController.text;
    final vnesenDatum = dateTime.toString().substring(0, 10);
    final vnesenoVreme = dateTime.toString().substring(10, 16);

    if (vnesenNaslov.isEmpty || vnesenDatum .isEmpty || vnesenoVreme.isEmpty) {
      return;
    }

    final newItem = ListItem(id: nanoid(5), naslov: vnesenNaslov, datum: vnesenDatum, vreme: vnesenoVreme);
    widget.addItem(newItem);
    Navigator.of(context).pop();
  }
  DateTime dateTime = DateTime(2022, 12, 24, 5, 30);

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Container(

        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _naslovController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Vnesete go imeto na predmetot ovde: "
              ),
              onSubmitted: (_) => _submitData(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(
                      const Size(120, 40)
                  ),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.lightBlue
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 18),
                    ),


                  ),
                    onPressed: () async {
                      final date = await pickDate();
                      if(date == null) return;

                      setState(() {
                        dateTime = date;
                      });
                    },
                    child: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}')
                ),
                ElevatedButton(
                    style: ButtonStyle(minimumSize: MaterialStateProperty.all(
                        const Size(120, 40)
                    ),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.lightBlue
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 18),
                      ),

                    ),
                    onPressed: () async {
                      final time = await pickTime();
                      if(time == null) return;

                      final newDateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          time.hour,
                          time.minute
                      );
                      setState(() {
                        dateTime = newDateTime;
                      });
                    },
                    child: Text('$hours:$minutes')

                ),
              ],
            ),

            AdaptiveFlatButton("Dodaj", _submitData)

          ],
        ),
    );
  }
  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100)
  );
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );


}
