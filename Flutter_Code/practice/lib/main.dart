import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int add(int a, int b) {
    return a + b;
  }

  String gender = "Male";

  TextEditingController c = TextEditingController();

  bool checked = false;

  double value = 10;

  int index = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //  1) Display text and button
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text("Hello world", style: TextStyle(fontSize: 24)),
      //       ElevatedButton(onPressed: () {}, child: Text("Click")),
      //     ],
      //   ),
      // ),

      // 2) Using function
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text("Sum: ${add(2,3)}")
      //     ],
      //   ),
      // ),

      // 3) Simple Increment & Decrement app
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text("Count: ${_counter}"),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           ElevatedButton(
      //             onPressed: () {
      //               setState(() {
      //                 _counter++;
      //               });
      //             },
      //             child: Text("Increment"),
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               setState(() {
      //                 _counter = 0;
      //               });
      //             },
      //             child: Text("Reset"),
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               setState(() {
      //                 _counter--;
      //               });
      //             },
      //             child: Text("Decrement"),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),

      // TextField & TextEditing Controller
      // body: Center(
      //   child: Column(
      //     children: [
      //       TextField(
      //         controller: c,
      //         decoration: InputDecoration(labelText: "Enter name"),
      //         // Important
      //         onChanged: (value) {
      //           setState(() {});
      //         },
      //       ),
      //       Text(c.text),
      //     ],
      //   ),
      // ),

      // Radio Button
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       RadioListTile(title: Text("Male"),
      //         value: "Male",
      //         groupValue: gender,
      //         onChanged: (value) => {
      //           setState(() {
      //             gender = value!;
      //           }),
      //         },
      //       )
      //     ],
      //   ),
      // ),

      // CheckBox
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text("Hello"),
      //       Checkbox(
      //         value: checked,
      //         onChanged: (val) {
      //           setState(() {
      //             checked = val!;
      //           });
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      // Slider
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Slider(
      //         value: value,
      //         min: 0,
      //         max: 100,
      //         onChanged: (v) {
      //           setState(() {
      //             value = v;
      //           });
      //         },
      //       ),
      //     ],
      //   )
      // ),

      // BottomNavigation Bar
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       BottomNavigationBar(
      //         currentIndex: index,
      //         onTap: (i) {
      //           setState(() {
      //             index = i;
      //           });
      //         },
      //         items: [
      //           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //           BottomNavigationBarItem(
      //             icon: Icon(Icons.settings),
      //             label: "Settings",
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),

      // ListView
      body: ListView(
        children: [
          ListTile(title: Text("Item 1")),
          ListTile(title: Text("Item 2")),
          ListTile(title: Text("Item 3")),
          ListTile(title: Text("Item 4")),

          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(title: Text("Item $index"));
            },
          ),

        ],
      ),
    );
  }
}
