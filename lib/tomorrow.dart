import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/backend/notes_service.dart';
import 'package:to_do_app_beta/calendarpage.dart';
import 'package:to_do_app_beta/completed.dart';
import 'package:to_do_app_beta/createnewtag.dart';
import 'package:to_do_app_beta/edit.dart';
import 'package:to_do_app_beta/iconsfile.dart';
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';
import 'listoftodos.dart';
import 'package:intl/intl.dart' as intl;

String errorMessage = '';
void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("Coming Soon"),
        content: const Text("This feature is still in development. Stay tuned!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

personalbottombar(Icon icon, label, void Function() onpressed) {
  return Column(
    children: [
      IconButton(onPressed: onpressed, tooltip: label, icon: icon),
      const SizedBox(
        height: 3,
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      )
    ],
  );
}

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  int? priorityselected;
  DateTime? selecteddate;
  TimeOfDay? selectedtime;
  String? dialogUIdate;
  int? dialogUIpriority;
  Tagclass dialogUItag = Tagclass();

  bool tagchosen = false;
  Tagclass tagselected = Tagclass();
  TextEditingController prioritycontroller = TextEditingController();
  TextEditingController todocontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    errorMessage = '';
    timecontroller.dispose();
    todocontroller.dispose();
    descriptioncontroller.dispose();
    datecontroller.dispose();
    dialogUIdate = null;
    dialogUIpriority = null;
    dialogUItag = Tagclass();
    tagselected = Tagclass();
  }

  @override
  Widget build(BuildContext context) {
    // List<Tagclass> taglist = context.select<TagViewModel, List<Tagclass>>((model) => model.taglist);
    Tagclass addingtag = context.select<TagViewModel, Tagclass>((model) => model.addingtag);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      backgroundColor: const Color.fromRGBO(54, 54, 54, 1),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        height: MediaQuery.of(context).size.height * 0.30,
        child: StatefulBuilder(
          builder: (BuildContext context, setsState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Add Task',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    //TEXTFIELD FOR NOTE
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 254, 254, 254), // Color of the border
                            width: 1.0, // Thickness of the border
                          ),
                        ),
                        labelText: 'NOTE',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),

                        // hintText: 'Note',
                      ),
                      controller: todocontroller,
                    ),
                    //TEXTFIELD FOR DESCRIPTION
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 254, 254, 254), // Color of the border
                            width: 1.0, // Thickness of the border
                          ),
                        ),
                        labelText: 'DESCRIPTION',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      controller: descriptioncontroller,
                    ),
                  ]),
                ),
                // TIME / TAG / PRIORITY
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  height: 75,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 330,
                        child: Row(
                          children: [
                            //ADDING TIME
                            SizedBox(
                              child: TextButton(
                                  onPressed: () async {
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    ).then((value) async {
                                      if (value != null) {
                                        selecteddate = value; // Store the selected date in state

                                        dialogUIdate = intl.DateFormat('yyyy/MM/dd').format(selecteddate!);
                                        datecontroller.text = intl.DateFormat('yyyy-MM-dd').format(selecteddate!);
                                        TimeOfDay? pickedtime = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(), // The default date shown in the picker
                                        );
                                        if (pickedtime != null) {
                                          selectedtime = pickedtime; // Store the selected date in state

                                          if (!context.mounted) return;
                                          timecontroller.text = selectedtime!.format(context);
                                          setsState(() {});
                                        }
                                      } else {
                                        Navigator.of(context).pop;
                                      }
                                    });
                                  },
                                  child: dialogUIdate == null
                                      ? const Icon(
                                          Icons.timer_outlined,
                                          color: Colors.white,
                                        )
                                      : Text(dialogUIdate!)),
                            ),

                            //ADDING TAG
                            SizedBox(
                              child: TextButton(
                                  onPressed: () async {
                                    tagselected = Tagclass();

                                    tagchosen = false;
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          // bool result = taglist.any((tag) => tag == addingtag);
                                          // result ? null : taglist.add(addingtag);

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
                                                    style: TextStyle(
                                                        fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                                                    'Choose Category',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: 530,
                                                    child: Selector<TagViewModel, List<Tagclass>>(
                                                        selector: (context, tagViewmodel) => tagViewmodel.taglist,
                                                        builder: (context, taglist, chuld) {
                                                          return GridView.builder(
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 3, // Number of columns
                                                              mainAxisSpacing: 15, // Spacing between rows
                                                              crossAxisSpacing: 15, // Spacing between columns
                                                            ),
                                                            itemCount: taglist.length,
                                                            itemBuilder: (context, index) {
                                                              Color? color = taglist[index] == taglist.last
                                                                  ? colorMapping[addingtag.tagcolor]
                                                                  : colorMapping[taglist[index].tagcolor];
                                                              // if (taglist[index] == taglist.last) {
                                                              //   color = addingtag['color'];
                                                              // } else {
                                                              //   color = colorMapping[taglist[index]['color']];
                                                              // }

                                                              Color decriptioncolor = color!;

                                                              if (taglist[index] == taglist.last) {
                                                                return Column(children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(context)
                                                                          .push(MaterialPageRoute(builder: (context) {
                                                                        return const Description();
                                                                      }));
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          color: decriptioncolor,
                                                                          borderRadius: const BorderRadius.all(
                                                                              Radius.circular(6))),
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
                                                                      tagselected = taglist[index];

                                                                      setsState2(() {});
                                                                    },
                                                                    child: Column(children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            color: decriptioncolor,
                                                                            border: taglist[index] == tagselected
                                                                                ? Border.all(
                                                                                    width: 2, color: Colors.white)
                                                                                : Border.all(width: 0),
                                                                            borderRadius: const BorderRadius.all(
                                                                                Radius.circular(6))),
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
                                                                    ]));
                                                              }
                                                            },
                                                            padding: const EdgeInsets.all(10),
                                                          );
                                                        })),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        )),
                                                        minimumSize:
                                                            const WidgetStatePropertyAll(Size(double.maxFinite, 48)),
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                                                    onPressed: () {
                                                      if (tagchosen) {
                                                        dialogUItag = tagselected;
                                                        Navigator.of(context).pop();
                                                        setsState(() {});
                                                      } else {
                                                        return;
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Add Category',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ]);
                                            }),
                                          ));
                                        });
                                  },
                                  child: dialogUItag != tagselected
                                      ? const Icon(
                                          Icons.note_add_outlined,
                                          color: Colors.white,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: colorMapping[dialogUItag.tagcolor],
                                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                                          margin: const EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                iconMapping[dialogUItag.tagicon],
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                dialogUItag.tagname.toString().substring(0, 1).toUpperCase() +
                                                    dialogUItag.tagname.toString().substring(1),
                                                style: const TextStyle(color: Colors.white),
                                              )
                                            ],
                                          ),
                                        )),
                            ), //ADDING PRIORITY
                            Container(
                              child: TextButton(
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          const List listofpriority = [1, 2, 3, 4, 5, 6, 7, 8, 9];
                                          int? priorityclicked;

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
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.white),
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
                                                              gridDelegate:
                                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 4, // Number of columns
                                                                mainAxisSpacing: 15, // Spacing between rows
                                                                crossAxisSpacing: 15, // Spacing between columns
                                                              ),
                                                              itemCount: listofpriority.length,
                                                              itemBuilder: (context, index) {
                                                                int prioritynum = listofpriority[index];
                                                                if (prioritynum == priorityclicked) {
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Theme.of(context).primaryColor,
                                                                        borderRadius: BorderRadius.circular(6)),
                                                                    height: 50,
                                                                    child: Column(
                                                                      children: [
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(top: 8, bottom: 8),
                                                                          child: Icon(
                                                                              color: Colors.white, Icons.flag_outlined),
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
                                                                      priorityclicked = prioritynum;
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
                                                                            child: Icon(
                                                                                color: Colors.white,
                                                                                Icons.flag_outlined),
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
                                                                    minimumSize: const WidgetStatePropertyAll(
                                                                        Size(double.infinity, 50)),
                                                                    shape:
                                                                        WidgetStatePropertyAll(RoundedRectangleBorder(
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
                                                                  style:
                                                                      TextStyle(color: Theme.of(context).primaryColor),
                                                                ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 5,
                                                              child: TextButton(
                                                                style: ButtonStyle(
                                                                    minimumSize: const WidgetStatePropertyAll(
                                                                        Size(double.infinity, 50)),
                                                                    shape:
                                                                        WidgetStatePropertyAll(RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(5.0),
                                                                    )),
                                                                    backgroundColor: WidgetStatePropertyAll(
                                                                        Theme.of(context).primaryColor)),
                                                                onPressed: () {
                                                                  priorityselected = priorityclicked;

                                                                  dialogUIpriority = priorityclicked;

                                                                  Navigator.of(context).pop();
                                                                  setsState(() {});
                                                                },
                                                                child: const Text(
                                                                  'Save',
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
                                  },
                                  child: dialogUIpriority == null
                                      ? const Icon(
                                          Icons.flag_outlined,
                                          color: Colors.white,
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(bottom: 4),
                                          padding: const EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(color: Colors.white, Icons.flag_outlined),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 3.0),
                                                child: Text(
                                                    style: const TextStyle(color: Colors.white),
                                                    dialogUIpriority.toString()),
                                              ),
                                            ],
                                          ))),
                            ),

                            //MAKING THE TODOITEM
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: () async {
                              if (todocontroller.text.isEmpty || descriptioncontroller.text.isEmpty) {
                                // errorMessage = 'please input your todo';
                                // setsState(() {});

                                Navigator.of(context).pop();
                              } else {
                                TodoModelclass newtodo = TodoModelclass(
                                    todo: todocontroller.text,
                                    description: descriptioncontroller.text,
                                    date: datecontroller.text.isEmpty
                                        ? "${DateTime.now().year}-${DateTime.now().month.toString().length < 2 ? '0${DateTime.now().month}' : DateTime.now().month.toString()}-${DateTime.now().day.toString().length < 2 ? '0${DateTime.now().day}' : DateTime.now().day.toString()}"
                                        : datecontroller.text,
                                    completed: 0,
                                    notetime: timecontroller.text.isEmpty
                                        ? TimeOfDay.now().format(context).toString()
                                        : timecontroller.text,
                                    priority: priorityselected == null ? '1' : priorityselected.toString(),
                                    tagname: tagselected.tagname ?? 'No tag',
                                    tagcolor: tagselected.tagcolor ?? 'defaultcolor',
                                    tagicon: tagselected.tagicon ?? 'defaulticon');

                                final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);
                                await todoViewModel.addtodo(newtodo);
                                if (context.mounted) Navigator.of(context).pop();
                                todocontroller.clear();
                                datecontroller.clear();
                              }
                            },
                            child: const Icon(Icons.send_rounded)),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
      // title: const Text('Input your todo'),
    );
  }
}

showinputDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogWidget();
      });
}

class Tomorrow extends StatefulWidget {
  const Tomorrow({
    super.key,
  });

  @override
  State<Tomorrow> createState() => _TomorrowState();
}

class _TomorrowState extends State<Tomorrow> {
  @override
  void dispose() {
    // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TodoViewModel todoViewmodel = Provider.of<TodoViewModel>(context, listen: false);
    List<TodoModelclass> maintodoselect =
        context.select<TodoViewModel, List<TodoModelclass>>((model) => model.mainpagetodo);
    bool isloading = context.select<TodoViewModel, bool>((model) => model.isloading);

    String thedayshowing = context.select<TodoViewModel, String>((model) => model.thedayshowing);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Home',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_outlined),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.checklist,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const Completed();
                }));
              },
            ),
          )
        ],
      ),
      body: isloading
          ? Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Colors.black,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    child: Row(
                      children: [
                        PopupMenuButton(
                          position: PopupMenuPosition.under,
                          onSelected: (value) {
                            todoViewmodel.updatethedayshowing(value.toString());
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                  value: todoViewmodel.thedaynotshowing1, child: Text(todoViewmodel.thedaynotshowing1)),
                              PopupMenuItem(
                                  value: todoViewmodel.thedaynotshowing2, child: Text(todoViewmodel.thedaynotshowing2)),
                            ];
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color.fromRGBO(54, 54, 54, 100),
                            ),
                            constraints: BoxConstraints.loose(const Size(double.infinity, double.infinity)),
                            padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                            height: 50,
                            child: Row(
                              children: [
                                Text(
                                  thedayshowing,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Selector<TodoViewModel, List<TodoModelclass>>(
                    selector: (context, todoviewmodel) => todoviewmodel.mainpagetodo,
                    builder: (context, mainpagetodo, child) {
                      print('building');
                      return mainpagetodo.isNotEmpty
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  SlidableAutoCloseBehavior(
                                    closeWhenOpened: true,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: mainpagetodo.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          ValueKey valuekey = ValueKey(mainpagetodo[index].id.toString());
                                          return Slidable(
                                            key: valuekey,

                                            // The start action pane is the one at the left or the top side.

                                            // The end action pane is the one at the right or the bottom side.
                                            endActionPane: ActionPane(
                                              key: valuekey,
                                              dismissible: DismissiblePane(onDismissed: () {
                                                todoViewmodel.deletetodo(mainpagetodo[index].id);
                                              }),
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (BuildContext context) {
                                                    todoViewmodel.deletetodo(mainpagetodo[index].id);
                                                  },
                                                  backgroundColor: const Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                ),
                                              ],
                                            ),

                                            // The child of the Slidable is what the user sees when the
                                            // component is not dragged.
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) => EditScreen(
                                                      todoitem: mainpagetodo[index],
                                                    ),
                                                  ),
                                                )
                                                    .then(
                                                  (value) async {
                                                    if (value == 'deleting') {
                                                      await todoViewmodel.deletetodo(mainpagetodo[index].id);
                                                    }
                                                  },
                                                );

                                                todoViewmodel.updatemainpagetodo(mainpagetodo);
                                              },
                                              child: TodoListItems(
                                                modelclass: mainpagetodo[index],
                                                context: context,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 90),
                                  SizedBox(
                                      width: 445,
                                      height: 289,
                                      child: Image(image: AssetImage('lib/assets/Todopic.png'))),
                                  Text('What do you want to do today?',
                                      style: TextStyle(color: Colors.white, fontSize: 20)),
                                  SizedBox(height: 4),
                                  Text('Tap + to add your tasks', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            );
                    },
                  )
                ],
              ),
            ),

      // drawer: Drawer(
      //     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //     child: Column(
      //       children: [
      //         Container(
      //           alignment: AlignmentDirectional.topStart,
      //           child: const ListTile(
      //             minTileHeight: 250,
      //             tileColor: Color.fromARGB(255, 223, 105, 26),
      //           ),
      //         ),
      //         ListTile(
      //           onTap: () {
      //             Navigator.of(context).pushNamedAndRemoveUntil(
      //               '/Today/',
      //               (route) => false,
      //             );
      //           },
      //           leading: const Icon(Icons.today),
      //           title: const Text('Today'),
      //           minTileHeight: 60,
      //           tileColor: const Color.fromARGB(255, 255, 255, 255),
      //         ),
      //         ListTile(
      //           onTap: () {
      //             Navigator.of(context).pushNamedAndRemoveUntil(
      //               '/Tomorrow/',
      //               (route) => false,
      //             );
      //           },
      //           leading: const Icon(Icons.next_plan_outlined),
      //           title: const Text('Tomorrow'),
      //           minTileHeight: 60,
      //           tileColor: const Color.fromARGB(255, 255, 255, 255),
      //         ),
      //         const ListTile(
      //           leading: Icon(Icons.watch_later),
      //           title: Text('Someday'),
      //           minTileHeight: 60,
      //           tileColor: Color.fromARGB(255, 255, 255, 255),
      //         ),
      //         ListTile(
      //           onTap: () {
      //             Navigator.of(context).pushNamedAndRemoveUntil(
      //               '/Completed/',
      //               (route) => false,
      //             );
      //           },
      //           leading: const Icon(Icons.done_all),
      //           title: const Text('Completed'),
      //           minTileHeight: 60,
      //           tileColor: const Color.fromARGB(255, 255, 255, 255),
      //         ),
      //       ],
      //     )),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 61, 152, 249),
          shape: const CircleBorder(),
          onPressed: () async {
            await showinputDialog(context);
          },
          tooltip: 'Increment',
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(54, 54, 54, 1),
          height: 93,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              personalbottombar(const Icon(Icons.home_outlined, color: Colors.white, size: 34), 'Home', () {}),
              personalbottombar(const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 34), 'Calendar',
                  () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) => const Calendarpage()))
                    .then((_) {
                  todoViewmodel.updatemainpagetodo(maintodoselect);
                });
              }),
              const SizedBox(width: 5),
              personalbottombar(
                  const Icon(
                    Icons.lock_clock_outlined,
                    color: Colors.white,
                    size: 34,
                    semanticLabel: 'Focus',
                    applyTextScaling: true,
                  ),
                  'clock', () {
                showComingSoonDialog(context);
              }),
              personalbottombar(
                const Icon(
                  Icons.person_2_outlined,
                  color: Colors.white,
                  size: 34,
                ),
                'Profile',
                () {
                  showComingSoonDialog(context);
                },
              ),
            ],
          )),
    );
  }
}
