import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskify/Code_Folders/Pages/Landing_Pages/LoginPage.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({super.key});

  @override
  State<HomeScreenMain> createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
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
      await FirebaseFirestore.instance.collection("data").add({
        "Title": titleController.text,
        "Description": descriptionController.text
      });
      titleController.clear();
      descriptionController.clear();
    }
  }

  // Delete task from Firestore
  Future<void> deleteTask(String id) async {
    await FirebaseFirestore.instance.collection("data").doc(id).delete();
  }

  // Update task in Firestore
  Future<void> updateTask(String id) async {
    FirebaseFirestore.instance.collection("data").doc(id).update({
      "Title": updateTitleController.text,
      "Description": updateDescriptionController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        leading: Builder(
          builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.person));
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Add Task"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration:
                                const InputDecoration(labelText: "Title"),
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration:
                                const InputDecoration(labelText: "Description"),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              await addTaskToFirestore();
                              Navigator.pop(context);
                            },
                            child: const Text("Add")),
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
              icon: const Icon(CupertinoIcons.plus))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                child: Container(
              color: Colors.blue,
            )),
            const Expanded(child: Text("Data List")),
            Padding(
              padding: const EdgeInsets.only(top: 550),
              child: Align(
                alignment: Alignment.bottomLeft,
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
                    icon: const Icon(Icons.logout)),
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("data").snapshots(),
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
              child: Text("No tasks available"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var userdata = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(userdata["Title"]),
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
                              TextFormField(
                                controller: updateTitleController,
                                decoration:
                                    const InputDecoration(labelText: "Title"),
                              ),
                              TextFormField(
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
                                child: const Text("Add")),
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
                      icon: const Icon(Icons.delete)),
                );
              },
            );
          }
        },
      ),
    );
  }
}
