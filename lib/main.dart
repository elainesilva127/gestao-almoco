import 'package:flutter/material.dart';
import 'package:plug_apps/cadastroUsuario.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:plug_apps/listUsers.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



void main()  {

   runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Gestão de Almoços",
    home: HomePage() ,
  )
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    prefsData();
  }

  prefsData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
      decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }
  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            textColor: Colors.green,
            onPressed: () {},
            child: Text("R\$1500.00"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        centerTitle: true,
        title: Text ("Gestão de Almoços"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.twoWeeks,
              calendarStyle: CalendarStyle(
                  todayColor: Colors.black,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
               startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events,holidays) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(

                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            ),
          ..._selectedEvents.map((event) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
            height: MediaQuery.of(context).size.height/20,
            width: MediaQuery.of(context).size.width/2,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border.all(color: Colors.grey)
            ),
            child: Center(
            child: Text(event,
            style: TextStyle(color: Colors.blue,
            fontWeight: FontWeight.bold,fontSize: 16),)
            ),
            ),
            )),
          ],
        ),
      ),

        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget> [
            FloatingActionButton(
              heroTag: null,
              elevation: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.list_alt_outlined),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => listaUsuarios()
                  )
                );
              },
            ),
            FloatingActionButton(
              heroTag: null,
              elevation: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.person_add_alt_1_sharp),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CadastroUsuario()
                    )
                );
              },
            ),
            FloatingActionButton(
            heroTag: null,
            elevation: 50,
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
            onPressed: _showAddDialog,
            ),
          ],
        )
    );
  }
  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white70,
          title: Text("Check Almoço"),
          content: TextField(
            decoration: InputDecoration(
              hintText: "Digite o nome do usuário",
            ),
            controller: _eventController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Salvar",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                setState(() {
                  if (_events[_controller.selectedDay] != null) {
                    _events[_controller.selectedDay]
                        .add(_eventController.text);
                  } else {
                    _events[_controller.selectedDay] = [
                      _eventController.text
                    ];
                  }
                  prefs.setString("events", json.encode(encodeMap(_events)));
                  _eventController.clear();
                  Navigator.pop(context);
                });

              },
            )
          ],
        ));
  }
}

