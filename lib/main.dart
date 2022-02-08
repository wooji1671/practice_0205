import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    Text(
      'Index 1: Saved change',
    ),
    Text(
      'Index 2: Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guitar Chords Changer'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.save_outlined), label: 'saved change'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final myController = TextEditingController();
  String dropdownValue = '올림';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: Text('원키에서'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    width: 100,
                    //margin: EdgeInsets.only(left:400, bottom:10),
                    child: TextFormField(
                      controller: myController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      decoration: InputDecoration(
                        helperText: '숫자를 입력하세요.',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Text('키만큼'),
                ),
              ],
            ),
            DropdownButton(
              value: dropdownValue,
              // value는 리스트로 저장되어야 함
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              //선택창 그림자
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['올림', '내림']
                  .map<DropdownMenuItem<String>>((String value) {
                // map() :문자열 2개를 DropdownMenuItem의 인스턴스로 변환
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(), // toList() :인스턴스 2개를 리스트로 변환
            ),
            Container(
              margin: const EdgeInsets.all(40),
            ),
            IconButton(
              alignment: Alignment.center,
              icon: Icon(Icons.tune),
              iconSize: 40,
              tooltip: ('Chord Change'),
              onPressed: () {
                //print(myController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChordChangePage(
                            changeChord: myController.text, changeDropdown: dropdownValue,
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class KeySelectWidget extends StatefulWidget {
  const KeySelectWidget({Key? key}) : super(key: key);

  @override
  _KeySelectWidgetState createState() => _KeySelectWidgetState();
}

class _KeySelectWidgetState extends State<KeySelectWidget> {
  String dropdownValue = '올림';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      // value는 리스트로 저장되어야 함
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      //선택창 그림자
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['올림', '내림'].map<DropdownMenuItem<String>>((String value) {
        // map() :문자열 2개를 DropdownMenuItem의 인스턴스로 변환
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(), // toList() :인스턴스 2개를 리스트로 변환
    );
  }
}

class ChordChangePage extends StatefulWidget {
  String changeChord;
  String changeDropdown;

  ChordChangePage({Key? key, required this.changeChord, required this.changeDropdown}) : super(key: key);

  @override
  _ChordChangePageState createState() => _ChordChangePageState();
}

class _ChordChangePageState extends State<ChordChangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guitar Chords Changer'),
      ),
      body: SecondPage(
        changeChord: widget.changeChord, changeDropdown: widget.changeDropdown
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.home),
              Icon(Icons.save_outlined),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  String changeChord;
  String changeDropdown;

  SecondPage({Key? key, required this.changeChord, required this.changeDropdown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(changeChord),
          Text(changeDropdown),
        ],
      ),
    );
  }
}
