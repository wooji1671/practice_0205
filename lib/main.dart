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

  static List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    SavedPage(
      changeChord: '0', changeKey: '올림', savedMusic: '',
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

  void dropDownChangeFunction(String? newKey) {
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
            KeySelectWidget(
              function: dropDownChangeFunction,
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
                            changeChord: myController.text,
                            changeKey: dropdownValue,
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
      onChanged: (String? newValue) {
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

  ChordChangePage(
      {Key? key, required this.changeChord, required this.changeKey})
      : super(key: key);

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
        changeChord: widget.changeChord,
        changeKey: widget.changeKey,
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  String changeChord;
  String changeKey;

  SecondPage({Key? key, required this.changeChord, required this.changeKey})
      : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final myController = TextEditingController();
  int changeKeyDown = 0;
  List musics = <String>[];
  String input = "";

  int downTuning(String newValue) {
    int parsedChangeChord = int.parse(newValue);
    changeKeyDown = 12 - parsedChangeChord;
    return changeKeyDown;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('${widget.changeChord} 키만큼 ${widget.changeKey} 한 경우 :',
                style: TextStyle(fontSize: 25)),
            (widget.changeKey == '올림')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '카포를 ${widget.changeChord}번째 프렛에 끼우고 연주',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '카포를 ${downTuning(widget.changeChord)}번째 프렛에 끼우고 연주',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '또는',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '카포를 ${widget.changeChord}번째 프렛에 끼우고 정튜닝 후 카포 제거하고 연주',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 60),
          child: Text(
            '* Save Chords Change *',
            style: TextStyle(
                backgroundColor: Colors.blueGrey,
                color: Colors.white,
                fontSize: 25),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.save_outlined),
              iconSize: 40,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text("코드 설정 저장하기"),
                          content: TextField(
                            decoration: InputDecoration(
                              helperText: '저장될 이름을 입력하세요.',
                              hintText: 'ex) Oasis - Live Forever',
                            ),
                            onChanged: (String value) {
                              input = value;
                            },
                          ),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    musics.add(input);
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SavedPage(
                                          changeChord: widget.changeChord,
                                          changeKey: widget.changeKey,
                                          savedMusic: input,
                                        )),
                                  );
                                  final snackBar = SnackBar(
                                    content: const Text('저장되었습니다.'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: Text("Add"))
                          ]);
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class SavedPage extends StatefulWidget {
  String changeChord;
  String changeKey;
  String savedMusic;

  SavedPage({Key? key, required this.changeChord, required this.changeKey, required this.savedMusic}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List musics = <String>[];
  List chords = <int>[];
  List keys = <String>[];
  String? musicinput;
  int? chordinput;
  String? keyinput;

  @override
  void initState() {
    super.initState();
    setState(() {
      musicinput = widget.savedMusic;
      chordinput = int.parse(widget.changeChord);
      keyinput = widget.changeKey;
      musics.add(musicinput);
      chords.add(chordinput);
      keys.add(keyinput);
    });
    //musics.add("Oasis- Live Forever");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyStatefulWidget()),
          );
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
          itemCount: musics.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(musics[index]),
              // subtitle: Text(keys[index]),
              // trailing: Text(chords[index]),
              subtitle: Text(
                  (keys[index] == '올림')
                      ? '카포를 ${chords[index]}번째 프렛에 끼우고 연주'
                      : '카포를 ${12 - chords[index]}번째 프렛에 끼우고 연주 또는 '
                      '카포를 ${chords[index]}번째 프렛에 끼우고 정튜닝 후 카포 제거하고 연주'
              ),
            );
          }),
    );
  }
}
