import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';

import '../Landing_Pages/LoginPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController updateTitleController = TextEditingController();
  final TextEditingController updateDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    updateTitleController.dispose();
    updateDescriptionController.dispose();
    super.dispose();
  }

  // Add new task to Firestore
  Future<void> addTaskToFirestore() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      String dateKey =
          formatDateKey(selectedDate); // Format the date for unique key
      await FirebaseFirestore.instance
          .collection("data")
          .doc(dateKey)
          .collection("tasks")
          .add({
        "Title": titleController.text,
        "Description": descriptionController.text,
      });
      titleController.clear();
      descriptionController.clear();
    }
  }

  // Delete task from Firestore
  Future<void> deleteTask(String taskId) async {
    String dateKey =
        formatDateKey(selectedDate); // Format the date for unique key
    await FirebaseFirestore.instance
        .collection("data")
        .doc(dateKey)
        .collection("tasks")
        .doc(taskId)
        .delete();
  }

  // Update task in Firestore
  Future<void> updateTask(String taskId) async {
    String dateKey =
        formatDateKey(selectedDate); // Format the date for unique key
    FirebaseFirestore.instance
        .collection("data")
        .doc(dateKey)
        .collection("tasks")
        .doc(taskId)
        .update({
      "Title": updateTitleController.text,
      "Description": updateDescriptionController.text,
    });
  }

  // Helper function to format date as a string key
  String formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  var selectedDate = DateTime.now(); // Initialize to current date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Screen",
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 30),
                          child: TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                                labelText: "Title",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 10,
                          ),
                          child: TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                                labelText: "Description",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  addTaskToFirestore();
                                  Navigator.pop(context);
                                },
                                child: const Text("Add Task")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              CupertinoIcons.plus,
              color: Colors.blueGrey,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                padding: EdgeInsets.all(0),
                child: Container(
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 550),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Loginpage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            HorizontalWeekCalendar(
              minDate: DateTime(2025, 1, 1),
              maxDate: DateTime(2030, 12, 31),
              initialDate:
                  selectedDate, // Use selectedDate to make sure the calendar reflects the current date
              onDateChange: (date) {
                setState(() {
                  selectedDate =
                      date; // Update selectedDate when a user selects a new date
                });
              },
              showTopNavbar: true,
              monthFormat: "MMMM yyyy",
              showNavigationButtons: true,
              weekStartFrom: WeekStartFrom.Monday,
              borderRadius: BorderRadius.circular(7),
              activeBackgroundColor: Colors.blueGrey,

              activeTextColor: Colors.white,
              inactiveBackgroundColor: Colors.blueGrey.withOpacity(.3),
              inactiveTextColor: Colors.white,
              disabledTextColor: Colors.grey,
              disabledBackgroundColor: Colors.grey.withOpacity(.3),
              activeNavigatorColor: Colors.blueGrey,
              inactiveNavigatorColor: Colors.blueGrey,

              monthColor: Colors.blueGrey,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("data")
                    .doc(formatDateKey(
                        selectedDate)) // Use formatted today's date
                    .collection("tasks")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No tasks available for today"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var userdata = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(
                            userdata["Title"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(userdata["Description"]),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Update Task"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: updateTitleController,
                                        decoration: const InputDecoration(
                                            labelText: "Title"),
                                      ),
                                      TextField(
                                        controller: updateDescriptionController,
                                        decoration: const InputDecoration(
                                            labelText: "Description"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          await updateTask(
                                              snapshot.data!.docs[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Update")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"))
                                  ],
                                );
                              },
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              deleteTask(userdata.id);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
