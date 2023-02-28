import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab4_mis/widgets/AuthPage.dart';
import 'package:lab4_mis/widgets/HomeWidget.dart';
import 'package:lab4_mis/widgets/LoginWidget.dart';
import 'package:lab4_mis/widgets/calendarapp.dart';
import 'model/list_item.dart';
import 'model/utils.dart';
import 'widgets/nov_element.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab4_mis/widgets/local_notification_service.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Laboratory Exercise 4 - 192015',
      theme: ThemeData(
        primarySwatch: Colors.blue,
          textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(fontSize:26)
          )
      ),

      home:  MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final LocalNotificationService localNotificationService;

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await LocalNotificationService().initialize(); // <----
    runApp(MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return HomeWidget();
            }
            else{
              return AuthPage();
            }
          }
      )
    );
  }

}

