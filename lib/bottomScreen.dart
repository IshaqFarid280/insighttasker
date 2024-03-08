import 'package:flutter/material.dart';
import 'package:insighttasker/notes_screen.dart';
import 'package:insighttasker/timer_screen.dart';
import 'package:insighttasker/unit_conversion.dart';


class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});



  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  int indexx = 0;
  List<Widget> screens= [
    TimerScreen(),
    ConverterScreen(),
    NotesScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[indexx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: indexx,
        type:BottomNavigationBarType.fixed,
        selectedFontSize: 12.0,
        unselectedFontSize: 10.0,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedIconTheme: IconThemeData(color: Colors.blueAccent),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white24,
        onTap: (index){
          indexx=index;
          setState(() {
          });
        },
        items: const [
          BottomNavigationBarItem(icon:Icon(Icons.pending_actions_outlined),label:'Timer'),
          BottomNavigationBarItem(icon:Icon(Icons.precision_manufacturing_outlined),label:'Conversion'),
          BottomNavigationBarItem(icon:Icon(Icons.newspaper_outlined),label:'Notes'),
        ],
      ),
    );
  }
}