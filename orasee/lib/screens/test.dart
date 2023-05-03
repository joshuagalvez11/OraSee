import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';

// import 'package:speech_recognition/speech_recognition.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:camera/camera.dart';

void main() {
  runApp(const TestPage());
}


class TestPage extends StatelessWidget {
  const TestPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyTestPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController controller = TextEditingController();

  void _speak() async {
    await flutterTts.setVolume(1);
    await flutterTts.setPitch(.8);
    await flutterTts.setSpeechRate(.8);
    await flutterTts.setLanguage("en-US");
    var txt = "";
    if(controller.text == ""){
      txt = 'This is a page with a variety of tools to help with your day to day activities.\nEach corner contains a button with a different tool.\nTop left- Text to speech\nTop right- Speech to text\nBottom left- Image to text\nBottom right- tbd';
    }else{
      txt = controller.text;
    }
    await flutterTts.speak(txt);
  }

  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";



  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);




  SpeechToText _speech = SpeechToText();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    controller.text = _lastWords;
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _speech = stt.SpeechToText();
  // }


  // stt.SpeechToText _speech = stt.SpeechToText();
  // bool _isListening = false;
  // String _text = 'Press the button and start speaking';
  // double _confidence = 1.0;

  // @override
  // void initState() {
  //   super.initState();
  //   _speech = stt.SpeechToText();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: _speak,
                            child: Container(
                              color: Colors.purple,
                              width: 200,
                              height: 200,
                              child: const Text(
                                'Text to Speech',
                                style: TextStyle(color: Colors.white, fontSize: 26.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child:
                      new Column(
                          children: [
                            Container(
                              color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    // onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                                    onPressed: _listen,
                                    child: Container(
                                      color: Colors.pink,
                                      width: 200,
                                      height: 30,
                                      child: const Text(
                                        'Speech to Text',
                                        style: TextStyle(color: Colors.white, fontSize: 26.0),
                                      ),
                                      //child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    // onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                                    onPressed: _listen,
                                    child: Container(
                                        color: Colors.pink,
                                        width: 200,
                                        height: 100,
                                        // child: const Text(
                                        //   'Speech to Text',
                                        //   style: TextStyle(color: Colors.white, fontSize: 26.0),
                                        // ),
                                        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.pink,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    // onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                                    onPressed: _listen,
                                    child: Container(
                                        color: Colors.pink,
                                        width: 200,
                                        height: 30,
                                        child:
                                        Text(
                                            'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                                            style: TextStyle(color: Colors.white, fontSize: 18.0)
                                        )
                                      // Text(
                                      //   _text,
                                      //   style: TextStyle(color: Colors.white, fontSize: 26.0),
                                      // ),
                                      //child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      )


                    // Container(
                    //   color: Colors.black,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       TextButton(
                    //         // onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                    //         onPressed: _listen,
                    //         child: Container(
                    //           color: Colors.pink,
                    //           width: 200,
                    //           height: 200,
                    //           child: const Text(
                    //             'Speech to Text',
                    //             style: TextStyle(color: Colors.white, fontSize: 26.0),
                    //           ),
                    //             //child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic)
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text('Text', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    SizedBox(
                      width: double.infinity,
                      height: 190,
                      child: TextField(
                        controller: controller,
                        maxLines: 7,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(),
                          hintText: 'This is a page with a variety of tools to help with your day to day activities.\nEach corner contains a button with a different tool.\nTop left- Text to speech\nTop right- Speech to text\nBottom left- Image to text\nBottom right- tbd',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: (){getImage(ImageSource.camera);},
                            child: Container(
                              color: Colors.green,
                              width: 200,
                              height: 200,
                              child: const Text(
                                'Image to Text (Camera)',
                                style: TextStyle(color: Colors.white, fontSize: 26.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: (){getImage(ImageSource.gallery);},
                            child: Container(
                              color: Colors.orange,
                              width: 200,
                              height: 200,
                              child: const Text(
                                'Image to Text (Gallery)',
                                style: TextStyle(color: Colors.white, fontSize: 26.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  // void getRecognisedText(XFile image) async {
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   final textDetector = GoogleMlKit.vision.textDetector();
  //   RecognisedText recognisedText = await textDetector.processImage(inputImage);
  //   await textDetector.close();
  //   scannedText = "";
  //   for (TextBlock block in recognisedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       scannedText = scannedText + line.text + "\n";
  //     }
  //   }
  //   controller.text = scannedText;
  //   textScanning = false;
  //   setState(() {});
  // }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    scannedText = recognizedText.text;

    // for (TextBlock block in recognisedText.blocks) {
    //   for (TextLine line in block.lines) {
    //     scannedText = scannedText + line.text + "\n";
    //   }
    // }
    controller.text = scannedText;

    textRecognizer.close();
  }






  // @override
  // void initState() {
  //   super.initState();
  // }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            controller.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }


// void _listen() async {
//   if (!_isListening) {
//     bool available = await _speech.initialize(
//       onStatus: (val) => print('onStatus: $val'),
//       onError: (val) => print('onError: $val'),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         onResult: (val) => setState(() {
//           _text = val.recognizedWords;
//           if (val.hasConfidenceRating && val.confidence > 0) {
//             _confidence = val.confidence;
//           }
//         }),
//       );
//     }
//   } else {
//     setState(() => _isListening = false);
//     _speech.stop();
//   }
// }

}




// import 'package:flutter/material.dart';
//
// import 'package:flutter_tts/flutter_tts.dart';
//
// // import 'package:speech_recognition/speech_recognition.dart';
// // import 'package:speech_to_text/speech_recognition_result.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// import 'package:google_ml_kit/google_ml_kit.dart';
// // import 'package:google_mlkit_text_recognition/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
// //import 'package:camera/camera.dart';
//
// void main() {
//   runApp(const TestPage());
// }
//
//
// class TestPage extends StatelessWidget {
//   const TestPage({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyTestPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyTestPage extends StatefulWidget {
//   const MyTestPage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyTestPage> createState() => _MyTestPageState();
// }
//
// class _MyTestPageState extends State<MyTestPage> {
//
//   final FlutterTts flutterTts = FlutterTts();
//   final TextEditingController controller = TextEditingController();
//
//   void _speak() async {
//     await flutterTts.setVolume(1);
//     await flutterTts.setPitch(1);
//     await flutterTts.setSpeechRate(1);
//     await flutterTts.setLanguage("en-US");
//     var txt = "";
//     if(controller.text == ""){
//       txt = 'This is a page with a variety of tools to help with your day to day activities.\nEach corner contains a button with a different tool.\nTop left- Text to speech\nTop right- Speech to text\nBottom left- Image to text\nBottom right- tbd';
//     }else{
//       txt = controller.text;
//     }
//     await flutterTts.speak(txt);
//   }
//
//   // bool textScanning = false;
//   //
//   // XFile? imageFile
//   //
//   // String scannedText = "";
//
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _speech = stt.SpeechToText();
//   // }
//
//
//   // stt.SpeechToText _speech = stt.SpeechToText();
//   // bool _isListening = false;
//   // String _text = 'Press the button and start speaking';
//   // double _confidence = 1.0;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _speech = stt.SpeechToText();
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF222222),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           TextButton(
//                             onPressed: _speak,
//                             child: Container(
//                               color: Colors.purple,
//                               width: 200,
//                               height: 200,
//                               child: const Text(
//                                 'Text to Speech',
//                                 style: TextStyle(color: Colors.white, fontSize: 26.0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           TextButton(
//                             onPressed: _speak,
//                             child: Container(
//                               color: Colors.pink,
//                               width: 200,
//                               height: 200,
//                               child: const Text(
//                                 'Speech to Text',
//                                 style: TextStyle(color: Colors.white, fontSize: 26.0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Colors.black,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//
//                     Text('Text', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20.0),),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 190,
//                       child: TextField(
//                         controller: controller,
//                         maxLines: 7,
//                         style: TextStyle(color: Colors.white, fontSize: 16.0),
//                         decoration: const InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey,
//                           border: OutlineInputBorder(),
//                           hintText: 'This is a page with a variety of tools to help with your day to day activities.\nEach corner contains a button with a different tool.\nTop left- Text to speech\nTop right- Speech to text\nBottom left- Image to text\nBottom right- tbd',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           TextButton(
//                             onPressed: (){getImage(ImageSource.camera);},
//                             child: Container(
//                               color: Colors.green,
//                               width: 200,
//                               height: 200,
//                               child: const Text(
//                                 'Image to Text (Camera)',
//                                 style: TextStyle(color: Colors.white, fontSize: 26.0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           TextButton(
//                             onPressed: (){getImage(ImageSource.gallery);},
//                             child: Container(
//                               color: Colors.orange,
//                               width: 200,
//                               height: 200,
//                               child: const Text(
//                                 'Image to Text (Gallery)',
//                                 style: TextStyle(color: Colors.white, fontSize: 26.0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   // void getImage(ImageSource source) async {
//   //   try {
//   //     final pickedImage = await ImagePicker().pickImage(source: source);
//   //     if (pickedImage != null) {
//   //       textScanning = true;
//   //       imageFile = pickedImage;
//   //       setState(() {});
//   //       getRecognisedText(pickedImage);
//   //     }
//   //   } catch (e) {
//   //     textScanning = false;
//   //     imageFile = null;
//   //     scannedText = "Error occured while scanning";
//   //     setState(() {});
//   //   }
//   // }
//   //
//   // void getRecognisedText(XFile image) async {
//   //   final inputImage = InputImage.fromFilePath(image.path);
//   //   final textDetector = GoogleMlKit.vision.textDetector();
//   //   RecognisedText recognisedText = await textDetector.processImage(inputImage);
//   //   await textDetector.close();
//   //   scannedText = "";
//   //   for (TextBlock block in recognisedText.blocks) {
//   //     for (TextLine line in block.lines) {
//   //       scannedText = scannedText + line.text + "\n";
//   //     }
//   //   }
//   //   controller.text = scannedText;
//   //   textScanning = false;
//   //   setState(() {});
//   // }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//
// //
// // void _listen() async {
// //   if (!_isListening) {
// //     bool available = await _speech.initialize(
// //       onStatus: (val) => print('onStatus: $val'),
// //       onError: (val) => print('onError: $val'),
// //     );
// //     if (available) {
// //       setState(() => _isListening = true);
// //       _speech.listen(
// //         onResult: (val) => setState(() {
// //           _text = val.recognizedWords;
// //           if (val.hasConfidenceRating && val.confidence > 0) {
// //             _confidence = val.confidence;
// //           }
// //         }),
// //       );
// //     }
// //   } else {
// //     setState(() => _isListening = false);
// //     _speech.stop();
// //   }
// // }
//
// }
//
//
//
// // import 'package:flutter/material.dart';
// //
// // class TestPage extends StatefulWidget {
// //   const TestPage({super.key});
// //
// //   @override
// //   State<TestPage> createState() => _TestPageState();
// // }
// //
// // class _TestPageState extends State<TestPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onVerticalDragDown: (DragDownDetails details) {
// //         Navigator.pop(context);
// //       },
// //       child: Container(
// //         color: Colors.blue,
// //
// //       ),
// //     );
// //   }
// // }