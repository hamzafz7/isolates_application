import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateExample1 extends StatelessWidget {
  const IsolateExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Isolate Test"),
      ),
      body: Column(
        children: [
          const Center(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var cnt = await complexMethod();
                debugPrint("counter is:   $cnt");
              },
              child: const Text("Example 1")),
          //ISOLATE :
          ElevatedButton(
              onPressed: () async {
                // create a receiveport to listen from the new isolate :
                ReceivePort receivePort = ReceivePort();
                await Isolate.spawn(complexMethod2, receivePort.sendPort);
                receivePort.listen((total) {
                  debugPrint("total : $total");
                });
              },
              child: const Text("Example 2"))
        ],
      ),
    );
  }

  // A task which is complecated and cant be solved with async due to the computational resourses that will require
  Future<int> complexMethod() async {
    var total = 0;
    for (int i = 0; i < 1000000000; i++) {
      total = total + i;
    }
    return total;
  }
}

// Same Method working with isolates :
// Note that you should Make your method independant

Future<void> complexMethod2(SendPort sender) async {
  var total = 0;
  for (int i = 0; i < 1000000000; i++) {
    total = total + i;
  }
  sender.send(total);
}
