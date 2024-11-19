import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool isListVisible = false;
  List<bool> isDispatched =
      List<bool>.filled(10, false); // Track the status of each task item

  void toggleListVisibility() {
    setState(() {
      isListVisible = !isListVisible;
    });
  }

  void dispatchTask(int index) {
    setState(() {
      isDispatched[index] = true; // Update the status of the task item
    });
  }

  void editTask(int index) {
    setState(() {
      isDispatched[index] = false; // Revert the status back to "Dispatch"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        actions: [
          ElevatedButton(
            onPressed: toggleListVisibility,
            child: Text(isListVisible ? "dispatched" : "not dispatch"),
          ),
        ],
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: isListVisible
          ? ListView.builder(
              itemCount: 10, // Replace with your list length
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Task Item ${index + 1}'),
                  trailing: ElevatedButton(
                    onPressed: isDispatched[index]
                        ? null // Disable the button if the task is already dispatched
                        : () => dispatchTask(index),
                    child:
                        Text(isDispatched[index] ? 'Dispatched' : 'Dispatch'),
                  ),
                  // leading: IconButton(
                  //   onPressed: isDispatched[index]
                  //       ? () =>
                  //           editTask(index) // Enable editing only if dispatched
                  //       : null,
                  //   icon: Icon(Icons.edit),
                  // ),
                );
              },
            )
          : Center(
              child: Text('No Tasks Available'),
            ),
    );
  }
}
