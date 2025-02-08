import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/backend/database_helper.dart';
import 'package:to_do_app_beta/backend/notes_service.dart';
import 'package:to_do_app_beta/createnewtag.dart';
import 'package:to_do_app_beta/iconsfile.dart';
import 'package:intl/intl.dart' as intl;
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';

class EditScreen extends StatefulWidget {
  final TodoModelclass todoitem;

  const EditScreen({super.key, required this.todoitem});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TodoModelclass todoitem;

  TextEditingController editingtodoController = TextEditingController();
  TextEditingController editingdescriptionController = TextEditingController();
  List listofpriority = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  Tagclass tagclicked = Tagclass();
  bool tagchosen = false;
  String selecteddate = '';

  @override
  void initState() {
    super.initState();
    todoitem = widget.todoitem;
  }

  void popscreen(value) {
    if (value == 'Deleting') {
      Navigator.of(context).pop('Deleting');
    } else {
      return;
    }
  }

  Future showEditDialog(BuildContext context) {
    FocusNode autofocus = FocusNode();
    final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);

    return showDialog(
        context: context,
        builder: (context) {
          editingtodoController.text = todoitem.todo;
          editingdescriptionController.text = todoitem.description;
          autofocus.requestFocus();
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            backgroundColor: const Color.fromRGBO(54, 54, 54, 1),
            content: SizedBox(
              width: 600,
              height: MediaQuery.of(context).size.height * 0.23,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: BorderDirectional(bottom: BorderSide(width: 1, color: Colors.white))),
                      child: const Center(
                        child: Text(
                          'Edit Task title',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      )),
                  TextField(
                    focusNode: autofocus,
                    controller: editingtodoController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 254, 254, 254), // Color of the border
                          width: 1.0, // Thickness of the border
                        ),
                      ),

                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),

                      // hintText: 'Note',
                    ),
                  ),
                  TextField(
                    controller: editingdescriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 254, 254, 254), // Color of the border
                          width: 1.0, // Thickness of the border
                        ),
                      ),

                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),

                      // hintText: 'Note',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextButton(
                            style: ButtonStyle(
                                minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                backgroundColor: const WidgetStatePropertyAll(
                                  Color.fromRGBO(54, 54, 54, 1),
                                )),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextButton(
                            style: ButtonStyle(
                                minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                            onPressed: () {
                              todoViewModel.updatemultipleattributes(todoitem.id, 'todo', editingtodoController.text,
                                  'description', editingdescriptionController.text);
                              todoitem.todo = editingtodoController.text;
                              todoitem.description = editingdescriptionController.text;
                              setState(() {});

                              if (context.mounted) Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future showcategorydialog(BuildContext context) {
    final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);
    TagViewModel tagViewModel = Provider.of<TagViewModel>(context, listen: false);
    tagclicked = Tagclass();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.99,
            color: const Color.fromRGBO(54, 54, 54, 1),
            child: StatefulBuilder(builder: (BuildContext context, setsState2) {
              return Column(children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: const BoxDecoration(
                      border: BorderDirectional(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                  )),
                  child: const Text(
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                    'Choose Category',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 530,
                  child: Selector<TagViewModel, List<Tagclass>>(
                    selector: (context, tagviewmodel) => tagviewmodel.taglist,
                    builder: (context, taglist, child) {
                      bool result = taglist.any((tag) => tag == tagViewModel.addingtag);
                      result ? null : taglist.add(tagViewModel.addingtag);
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          mainAxisSpacing: 15, // Spacing between rows
                          crossAxisSpacing: 15, // Spacing between columns
                        ),
                        itemCount: taglist.length,
                        itemBuilder: (context, index) {
                          Color? color = taglist[index] == taglist.last
                              ? colorMapping[tagViewModel.addingtag.tagcolor]
                              : colorMapping[tagViewModel.taglist[index].tagcolor];

                          Color decriptioncolor = color!;

                          if (taglist[index] == taglist.last) {
                            return Column(children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return const Description();
                                  }));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: decriptioncolor, borderRadius: const BorderRadius.all(Radius.circular(6))),
                                  height: 75,
                                  width: 75,
                                  child: Center(
                                    child: Icon(iconMapping[taglist[index].tagicon],
                                        color: decriptioncolor.withGreen(900)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                taglist[index].tagname!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ]);
                          } else {
                            return GestureDetector(
                              onTap: () {
                                tagchosen = true;
                                tagclicked = taglist[index];
                                print(todoitem.tagicon);
                                print(tagclicked.tagicon);
                                setsState2(() {});
                              },
                              child: taglist[index] == tagclicked
                                  ? Column(children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: decriptioncolor,
                                            border: Border.all(width: 2, color: Colors.white),
                                            borderRadius: const BorderRadius.all(Radius.circular(6))),
                                        height: 75,
                                        width: 75,
                                        child: Center(
                                            child: Icon(
                                          iconMapping[taglist[index].tagicon],
                                          color: decriptioncolor.withGreen(900),
                                        )),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        taglist[index].tagname!,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ])
                                  : Column(children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: decriptioncolor,
                                            borderRadius: const BorderRadius.all(Radius.circular(6))),
                                        height: 75,
                                        width: 75,
                                        child: Center(
                                            child: Icon(
                                          iconMapping[taglist[index].tagicon],
                                          color: decriptioncolor.withGreen(900),
                                        )),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        taglist[index].tagname!,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ]),
                            );
                          }
                        },
                        padding: const EdgeInsets.all(10),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TextButton(
                          style: ButtonStyle(
                              minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                              backgroundColor: const WidgetStatePropertyAll(
                                Color.fromRGBO(54, 54, 54, 1),
                              )),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextButton(
                          style: ButtonStyle(
                              minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                              backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                          onPressed: () async {
                            if (tagchosen) {
                              todoitem.tagname = tagclicked.tagname;
                              todoitem.tagcolor = tagclicked.tagcolor;
                              todoitem.tagicon = tagclicked.tagicon;

                              todoViewModel.updatemultipleattributes(
                                  todoitem.id, 'tagname', tagclicked.tagname, 'tagcolor', tagclicked.tagcolor,
                                  thirdattribute: 'tagicon', thirdvalue: tagclicked.tagicon);
                              setState(() {});
                            } else {
                              return;
                            }

                            if (context.mounted) Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]);
            }),
          ));
        });
  }

  Future showprioritydialog(BuildContext context) async {
    final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);

    String? priorityclicked = todoitem.priority;

    if (context.mounted) {
      return showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                  padding: const EdgeInsets.all(14),
                  height: MediaQuery.of(context).size.height * 0.41,
                  width: MediaQuery.of(context).size.width * 0.99,
                  color: const Color.fromRGBO(54, 54, 54, 1),
                  child: StatefulBuilder(builder: (context, setstate3) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              border: BorderDirectional(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          )),
                          child: const Text(
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                            'Task Priority',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                              top: 15,
                            ),
                            height: 250,
                            child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, // Number of columns
                                  mainAxisSpacing: 15, // Spacing between rows
                                  crossAxisSpacing: 15, // Spacing between columns
                                ),
                                itemCount: listofpriority.length,
                                itemBuilder: (context, index) {
                                  int prioritynum = listofpriority[index];
                                  if (prioritynum.toString() == priorityclicked) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(6)),
                                      height: 50,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 8, bottom: 8),
                                            child: Icon(color: Colors.white, Icons.flag_outlined),
                                          ),
                                          Text(
                                            prioritynum.toString(),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        priorityclicked = prioritynum.toString();
                                        setstate3(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(39, 39, 39, 1),
                                            borderRadius: BorderRadius.circular(6)),
                                        height: 50,
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(top: 8, bottom: 8),
                                              child: Icon(color: Colors.white, Icons.flag_outlined),
                                            ),
                                            Text(
                                              prioritynum.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                })),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 5,
                                child: TextButton(
                                  style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      )),
                                      backgroundColor: const WidgetStatePropertyAll(
                                        Color.fromRGBO(54, 54, 54, 1),
                                      )),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                child: TextButton(
                                  style: ButtonStyle(
                                      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      )),
                                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                                  onPressed: () async {
                                    if (priorityclicked == null) {
                                      return;
                                    } else {
                                      todoViewModel.updatetodo(todoitem.id, 'priority', priorityclicked);
                                      todoitem.priority = priorityclicked;
                                      setState(() {});
                                    }

                                    if (context.mounted) Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  })),
            );
          });
    }
  }

  Future<String?> deletedialog(BuildContext context) async {
    final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);

    return await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            backgroundColor: const Color.fromRGBO(54, 54, 54, 1),
            content: SizedBox(
              width: 600,
              height: MediaQuery.of(context).size.height * 0.23,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: BorderDirectional(bottom: BorderSide(width: 1, color: Colors.white))),
                      child: const Center(
                        child: Text(
                          'Delete Task',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      )),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text(
                      'Are you sure you want to delete this task?',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TextButton(
                            style: ButtonStyle(
                                minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                backgroundColor: const WidgetStatePropertyAll(
                                  Color.fromRGBO(54, 54, 54, 1),
                                )),
                            onPressed: () {
                              Navigator.of(context).pop(null);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextButton(
                            style: ButtonStyle(
                                minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                            onPressed: () async {
                              // await todoViewModel.deletetodo(todoitem.id);
                              if (context.mounted) Navigator.of(context).pop('deleting');
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget editscaffold() {
    Provider.of<TagViewModel>(context, listen: false);
    final model = Provider.of<TodoViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                IconButton(
                  constraints: BoxConstraints.tight(const Size(50, 50)),
                  splashColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 24, right: 24),
            // width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        const Icon(Icons.task_outlined, color: Colors.white),
                        Padding(
                            padding: const EdgeInsets.only(left: 21.0),
                            child: Text(
                                todoitem.todo.toString().substring(0, 1).toUpperCase() +
                                    todoitem.todo.toString().substring(1),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.7)))
                      ]),
                      // const Icon(Icons.edit_outlined, size: 25, color: Colors.white)
                      IconButton(
                          onPressed: () async {
                            await showEditDialog(context);
                          },
                          icon: const Icon(Icons.edit_outlined, size: 25, color: Colors.white))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Text(todoitem.description,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white)))
                    ])
                  ],
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_month_outlined, color: Colors.white, size: 25),
                        Padding(
                          padding: EdgeInsets.only(left: 21.0),
                          child: Text(
                            'Task Date :',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(todoitem.date),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((value) {
                            if (value == null) {
                              return;
                            } else {
                              selecteddate = intl.DateFormat('yyyy-MM-dd').format(value);
                              todoitem.date = selecteddate;
                              model.updatetodo(todoitem.id, 'date', selecteddate);
                              setState(() {});
                            }
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(50, 50)),
                          shape:
                              WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(81, 255, 255, 255)),
                        ),
                        child: Text(
                          todoitem.date,
                          style: const TextStyle(color: Colors.white),
                        ))
                  ],
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined, color: Colors.white, size: 25),
                        Padding(
                          padding: EdgeInsets.only(left: 21.0),
                          child: Text(
                            'Task Timer :',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(), // The default date shown in the picker
                          ).then((value) async {
                            if (value == null) {
                              return;
                            } else {
                              String selectedtime = value.format(context);
                              todoitem.notetime = selectedtime;
                              model.updatetodo(todoitem.id, 'notetime', selectedtime);
                              setState(() {});
                            }
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(50, 50)),
                          shape:
                              WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(81, 255, 255, 255)),
                        ),
                        child: Text(
                          todoitem.notetime!,
                          style: const TextStyle(color: Colors.white),
                        ))
                  ],
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(children: [
                      Icon(Icons.note_add_outlined, color: Colors.white),
                      Padding(
                          padding: EdgeInsets.only(left: 21.0),
                          child: Text('Task Category :', style: TextStyle(fontSize: 19, color: Colors.white)))
                    ]),
                    TextButton(
                        onPressed: () async {
                          await showcategorydialog(context);
                        },
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(50, 50)),
                          shape:
                              WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(81, 255, 255, 255)),
                        ),
                        child: Row(
                          children: [
                            Icon(iconMapping[todoitem.tagicon], color: colorMapping[todoitem.tagcolor]),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              todoitem.tagname.toString().substring(0, 1).toUpperCase() +
                                  todoitem.tagname.toString().substring(1),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(children: [
                      Icon(Icons.flag_outlined, color: Colors.white),
                      Padding(
                          padding: EdgeInsets.only(left: 21.0),
                          child: Text('Task Priority :', style: TextStyle(fontSize: 19, color: Colors.white)))
                    ]),
                    TextButton(
                        onPressed: () async {
                          await showprioritydialog(context);
                        },
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(Size(50, 50)),
                          shape:
                              WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(81, 255, 255, 255)),
                        ),
                        child: Text(
                          'Priority ${todoitem.priority}',
                          style: const TextStyle(color: Colors.white),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 38,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 24),
            child: Row(
              children: [
                TextButton(
                  style: ButtonStyle(
                    minimumSize: const WidgetStatePropertyAll(Size(20, 50)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                  ),
                  onPressed: () async {
                    await deletedialog(context).then((value) {
                      if (value == 'deleting') {
                        Navigator.of(context).pop('deleting');
                      } else {
                        return;
                      }
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 21.0),
                          child: Text('Delete Task ', style: TextStyle(fontSize: 19, color: Colors.red))),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return editscaffold();
  }
}
