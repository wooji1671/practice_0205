import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

int selectedindex= 0;
MyStatefulWidget msw = MyStatefulWidget();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: msw,
      debugShowCheckedModeBanner: false,
    );
  }
}

SavedPage sp = SavedPage();

class MyStatefulWidget extends StatefulWidget {

  MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    sp,
    HelpPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Guitar Chords Changer'),
      ),
      body: _widgetOptions.elementAt(selectedindex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.save_outlined), label: 'saved change'),
          BottomNavigationBarItem(
              icon: Icon(Icons.help_outline_outlined), label: 'help'),
        ],
        currentIndex: selectedindex,
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
            Image.asset('images/img_1.jpg', height: 200, width: 400,),
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
                            '카포를 ${12 - int.parse(widget.changeChord)}번째 프렛에 끼우고 연주',
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
                          title: Text("코드 설정 저장"),
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
                                    sp.musics.add(input);
                                    sp.chords.add(int.parse(widget.changeChord));
                                    sp.keys.add(widget.changeKey);
                                    selectedindex = 1;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => msw),
                                  );
                                  final snackBar = SnackBar(
                                    content: const Text('저장되었습니다.'),
                                    duration: Duration(seconds: 1),
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
  List<String> musics = [];
  List<int> chords = [];
  List<String> keys = [];

  SavedPage({Key? key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: widget.musics.length,
          itemBuilder: (BuildContext context, int index) {
            // return ListTile(
            //   title: Text(widget.musics[index]),
            //   subtitle: Text(
            //       (widget.keys[index] == '올림')
            //           ? '카포를 ${widget.chords[index]}번째 프렛에 끼우고 연주'
            //           : '카포를 ${12 - widget.chords[index]}번째 프렛에 끼우고 연주 또는 '
            //           '카포를 ${widget.chords[index]}번째 프렛에 끼우고 정튜닝 후 카포 제거하고 연주'
            //   ),
            // );
            return Dismissible(
              key: Key(widget.musics[index]),
              child: ListTile(
                title: Text(widget.musics[index]),
                subtitle: Text(
                   (widget.keys[index] == '올림')
                       ? '카포를 ${widget.chords[index]}번째 프렛에 끼우고 연주'
                       : '카포를 ${12 - widget.chords[index]}번째 프렛에 끼우고 연주 또는 '
                       '카포를 ${widget.chords[index]}번째 프렛에 끼우고 정튜닝 후 카포 제거하고 연주'
               ),
              ),
              background: Container(color: Colors.red,),
              onDismissed: (direction) {
                setState(() {
                  widget.musics.removeAt(index);
                });
              },
              confirmDismiss: (direction) async {
                return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("코드 설정 삭제"),
                        content: const Text("항목을 삭제하시겠습니까?"),
                        actions: <Widget> [
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("삭제")
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("취소"),
                          ),
                        ],
                      );
                    }
                );
              },
            );
          }),
    );
  }
}

class HelpPage extends StatefulWidget {
  HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<bool> _expanded = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          Text(
            "FAQ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          ExpansionPanelList(
            children: [
              ExpansionPanel(
                isExpanded: _expanded[0],
                  headerBuilder: (context, isExpanded){
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text('카포가 뭔가요?', style: TextStyle(fontSize: 20)),
                    );
                  },
                  body: Column(
                    children: [
                      Image.asset('images/img_2.jpg', height: 200, width: 200,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('카포는 기타의 모든 현을 눌러주어 현의 음정을 조절하도록 해주는 보조기구입니다.')
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text('사진처럼 기타의 프렛에 물리듯 끼워 사용합니다.')
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('카포는 기타 1프렛에 가깝게, 수평으로 장착할수록 좋습니다. 1프렛에서 멀어질수록, 수평에서 어긋날수록 음정이 틀어질 위험이 있기 때문입니다.')
                      ),
                    ],
                  ),
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                isExpanded: _expanded[1],
                headerBuilder: (context, isExpanded){
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Text('프렛이 뭔가요?', style: TextStyle(fontSize: 20)),
                  );
                },
                body: Column(
                  children: [
                    Image.asset('images/img_3.png', height: 200, width: 200,),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('프렛은 기타 지판에서 은색 쇠막대로 구분되어 있는 세로칸 하나하나를 의미합니다.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('사진 기준 왼쪽 칸부터 1프렛, 2프렛...이라고 부릅니다.')
                    ),
                  ],
                ),
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                isExpanded: _expanded[2],
                headerBuilder: (context, isExpanded){
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Text('몇 키를 올림(내림) 했는지 어떻게 계산하나요?', style: TextStyle(fontSize: 20)),
                  );
                },
                body: Column(
                  children: [
                    Image.asset('images/img_4.png', height: 200, width: 200,),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('코드는 C키에서 B키까지로 구성되어 있습니다.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text('코드는 원처럼 반복됩니다(CDEFGABCDEFGAB...).')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text('원 기준으로 코드 1칸이 달라지는 것은 1키가 바뀌는 것과 같습니다.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('원 기준으로 오른쪽 방향으로 돌면 키 올림, 왼쪽 방향으로 돌면 키 내림입니다.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('예시: 코드를 G키에서 A#키로 높이자! -> 3키 올림')
                    ),
                  ],
                ),
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                isExpanded: _expanded[3],
                headerBuilder: (context, isExpanded){
                  return Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Text('정튜닝은 어떻게 하는 건가요?', style: TextStyle(fontSize: 20)),
                  );
                },
                body: Column(
                  children: [
                    HelpVideo(videoId: 'DuwWfAOzfy8',),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('위의 영상을 참고하세요.')
                    ),
                  ],
                ),
                canTapOnHeader: true,
              ),

            ],
            expandedHeaderPadding: EdgeInsets.all(0),
            expansionCallback: (i, isExpanded) =>
                setState(() =>
                    _expanded[i] = !isExpanded
                )
          ),
        ],
      ),
    );
  }
}

class HelpVideo extends StatefulWidget {
  String videoId;

  HelpVideo({Key? key, required this.videoId}) : super(key: key);

  @override
  _HelpVideoState createState() => _HelpVideoState();
}

class _HelpVideoState extends State<HelpVideo> {
  late YoutubePlayerController _controller;

  @override

  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: 'DuwWfAOzfy8',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
        width: 360,
        height:195,
        child: YoutubePlayer(
          controller: _controller,
          width: 360,
          aspectRatio : 16 / 9,
            actionsPadding: const EdgeInsets.only(left: 16.0),
            bottomActions: [
              CurrentPosition(),
              const SizedBox(width: 10.0),
              ProgressBar(isExpanded: true),
              const SizedBox(width: 10.0),
              RemainingDuration(),
              FullScreenButton(),
      ]
        )
    );
  }
}

