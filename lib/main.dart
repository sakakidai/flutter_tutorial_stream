import 'package:flutter/material.dart';
import 'package:flutter_tutorial_stream/business_logic.dart';
import "dart:async";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var intStream = StreamController<int>();
  var stringStream = StreamController<String>.broadcast();
  var generator = Generator();
  var coordinator = Coordinator();
  var consumer = Consumer();

  void _incrementCounter() {
    generator.generate();
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    generator.init(intStream);
    coordinator.init(intStream, stringStream);
    consumer.init(stringStream);
    coordinator.coordinate();
    consumer.consume();

    super.initState();
  }

  @override
  void dispose() {
    intStream.close();
    stringStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              key: const Key('counter'),
              style: Theme.of(context).textTheme.headline4,
            ),
            StreamBuilder<String>(
              stream: stringStream.stream,
              initialData: "",
              builder: (context, snapshot) {
                return Text(
                  'RANDOM : ${snapshot.data}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
