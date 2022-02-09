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

  void dropDownChangeFunction(String? newKey){
    setState(() {
      dropdownValue = newKey!;
    });
  }

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
            KeySelectWidget(function: dropDownChangeFunction,),
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
                            changeChord: myController.text, changeKey: dropdownValue,
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
  Function function;
  KeySelectWidget({Key? key, required this.function}) : super(key: key);

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
      onChanged: (String? newValue){
        widget.function(newValue);
        dropdownValue = newValue!;
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
  String changeKey;

  ChordChangePage({Key? key, required this.changeChord, required this.changeKey}) : super(key: key);

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
        changeChord: widget.changeChord, changeKey: widget.changeKey,
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

class SecondPage extends StatefulWidget {
  String changeChord;
  String changeKey;

  SecondPage({Key? key, required this.changeChord, required this.changeKey}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var changeKeyDown = 0;

  int downTuning(String newValue){
      var parsedChangeChord = int.parse(newValue);
      changeKeyDown = 12 - parsedChangeChord;
      return changeKeyDown;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${widget.changeChord} 키만큼 ${widget.changeKey} 한 경우 :'),
          (widget.changeKey == '올림')
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('카포를 ${widget.changeChord}번째 프렛에 끼우고 연주'),
                ],
              )
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('카포를'),
                      KeyDownWidget(function: downTuning, changeChord: widget.changeChord,),
                      Text('번째 프렛에 끼우고 연주'),
                    ],
                  ),
                  Text('또는'),
                  Text('카포를 ${widget.changeChord}번째 프렛에 끼우고 정튜닝 후 카포 제거하고 연주'),
                ],
              ),
        ],
      ),
    );
  }
}

class KeyDownWidget extends StatefulWidget {
  Function function;
  String changeChord;
  KeyDownWidget({Key? key, required this.function, required this.changeChord}) : super(key: key);

  @override
  _KeyDownWidgetState createState() => _KeyDownWidgetState();
}

class _KeyDownWidgetState extends State<KeyDownWidget> {
  var changeKeyDown = 0;

  @override
  Widget build(BuildContext context) {
    return Text(
      ' ${widget.function(widget.changeChord)}'
    );
  }
}
