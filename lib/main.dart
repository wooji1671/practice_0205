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
  String dropdownValue = '??????';

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
              child: Text('????????????'),
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
                        helperText: '????????? ???????????????.',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Text('?????????'),
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
  String dropdownValue = '??????';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownValue,
      // value??? ???????????? ??????????????? ???
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      //????????? ?????????
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        widget.function(newValue);
        dropdownValue = newValue!;
      },
      items: <String>['??????', '??????'].map<DropdownMenuItem<String>>((String value) {
        // map() :????????? 2?????? DropdownMenuItem??? ??????????????? ??????
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(), // toList() :???????????? 2?????? ???????????? ??????
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
            Text('${widget.changeChord} ????????? ${widget.changeKey} ??? ?????? :',
                style: TextStyle(fontSize: 25)),
            (widget.changeKey == '??????')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '????????? ${widget.changeChord}?????? ????????? ????????? ??????',
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
                            '????????? ${12 - int.parse(widget.changeChord)}?????? ????????? ????????? ??????',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '??????',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            '????????? ${widget.changeChord}?????? ????????? ????????? ????????? ??? ?????? ???????????? ??????',
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
                          title: Text("?????? ?????? ??????"),
                          content: TextField(
                            decoration: InputDecoration(
                              helperText: '????????? ????????? ???????????????.',
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
                                    content: const Text('?????????????????????.'),
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
            //       (widget.keys[index] == '??????')
            //           ? '????????? ${widget.chords[index]}?????? ????????? ????????? ??????'
            //           : '????????? ${12 - widget.chords[index]}?????? ????????? ????????? ?????? ?????? '
            //           '????????? ${widget.chords[index]}?????? ????????? ????????? ????????? ??? ?????? ???????????? ??????'
            //   ),
            // );
            return Dismissible(
              key: Key(widget.musics[index]),
              child: ListTile(
                title: Text(widget.musics[index]),
                subtitle: Text(
                   (widget.keys[index] == '??????')
                       ? '????????? ${widget.chords[index]}?????? ????????? ????????? ??????'
                       : '????????? ${12 - widget.chords[index]}?????? ????????? ????????? ?????? ?????? '
                       '????????? ${widget.chords[index]}?????? ????????? ????????? ????????? ??? ?????? ???????????? ??????'
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
                        title: const Text("?????? ?????? ??????"),
                        content: const Text("????????? ?????????????????????????"),
                        actions: <Widget> [
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("??????")
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("??????"),
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
                      child: Text('????????? ??????????', style: TextStyle(fontSize: 20)),
                    );
                  },
                  body: Column(
                    children: [
                      Image.asset('images/img_2.jpg', height: 200, width: 200,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('????????? ????????? ?????? ?????? ???????????? ?????? ????????? ??????????????? ????????? ?????????????????????.')
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text('???????????? ????????? ????????? ????????? ?????? ???????????????.')
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('????????? ?????? 1????????? ?????????, ???????????? ??????????????? ????????????. 1???????????? ???????????????, ???????????? ??????????????? ????????? ????????? ????????? ?????? ???????????????.')
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
                    child: Text('????????? ??????????', style: TextStyle(fontSize: 20)),
                  );
                },
                body: Column(
                  children: [
                    Image.asset('images/img_3.png', height: 200, width: 200,),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('????????? ?????? ???????????? ?????? ???????????? ???????????? ?????? ????????? ??????????????? ???????????????.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('?????? ?????? ?????? ????????? 1??????, 2??????...????????? ????????????.')
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
                    child: Text('??? ?????? ??????(??????) ????????? ????????? ????????????????', style: TextStyle(fontSize: 20)),
                  );
                },
                body: Column(
                  children: [
                    Image.asset('images/img_4.png', height: 200, width: 200,),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('????????? C????????? B???????????? ???????????? ????????????.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text('????????? ????????? ???????????????(CDEFGABCDEFGAB...).')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text('??? ???????????? ?????? 1?????? ???????????? ?????? 1?????? ????????? ?????? ????????????.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('??? ???????????? ????????? ???????????? ?????? ??? ??????, ?????? ???????????? ?????? ??? ???????????????.')
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('??????: ????????? G????????? A#?????? ?????????! -> 3??? ??????')
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
                    child: Text('???????????? ????????? ?????? ??????????', style: TextStyle(fontSize: 20)),
                  );
                },
                body: Column(
                  children: [
                    HelpVideo(videoId: 'DuwWfAOzfy8',),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('?????? ????????? ???????????????.')
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

