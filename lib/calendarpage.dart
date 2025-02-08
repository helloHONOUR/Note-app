import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/backend/database_helper.dart';
import 'package:to_do_app_beta/backend/notes_service.dart';
import 'package:to_do_app_beta/edit.dart';
import 'package:to_do_app_beta/iconsfile.dart';
import 'package:to_do_app_beta/listoftodos.dart';
import 'package:to_do_app_beta/tomorrow.dart';
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';

class Calendarpage extends StatefulWidget {
  const Calendarpage({super.key});

  @override
  State<Calendarpage> createState() => _CalendarpageState();
}

class _CalendarpageState extends State<Calendarpage> {
  DatabaseHelper databaseinstance = DatabaseHelper.creatinginstance();

  Color color = const Color.fromRGBO(54, 54, 54, 1);
  FocusNode datebuttonfocus = FocusNode();
  FocusNode completedbuttonfocus = FocusNode();

  bool isloading = true;

  Widget datecontainer(int boxnum, context, dayoftheweek, dateoftheweek, Color color, bool taskpending) {
    return Container(
      width: 51,
      margin: taskpending ? const EdgeInsets.all(6) : const EdgeInsets.only(top: 6, right: 6, left: 6, bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Column(children: [
        Text(dayoftheweek.substring(0, 3),
            style: TextStyle(
                color: boxnum == 0 || boxnum == 6 ? const Color.fromARGB(255, 255, 73, 73) : Colors.white,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text('$dateoftheweek', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        taskpending ? const SizedBox(height: 4) : const SizedBox.shrink(),
        taskpending
            ? Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color == Theme.of(context).primaryColor
                      ? Colors.white
                      : Theme.of(context).primaryColor, // Circle color
                  // You can also use image, gradient, border, etc.
                ),
              )
            : const SizedBox.shrink()
      ]),
    );
  }

  datepicker(BuildContext context, listofdate) {
    int monthprovider = context.select<TodoViewModel, int>((model) => model.month);
    int year = context.select<TodoViewModel, int>((model) => model.year);
    DateTime datestobeused = context.select<TodoViewModel, DateTime>((model) => model.datestobeused);
    int? boxclicked = context.select<TodoViewModel, int?>((model) => model.boxclicked);
    String dayshowing = context.select<TodoViewModel, String>((model) => model.dayshowing);
    List listofdate = context.select<TodoViewModel, List>((model) => model.listofdate);

    String? month = monthsOfYear[monthprovider];
    final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);
    // List listofday = context.select<TodoViewModel, List>((model) => model.listofdate);
    // TodoViewModel watch = context.watch<TodoViewModel>();
    // String? month = monthsOfYear[todoViewModel.month];
    // String year = todoViewModel.year.toString();

    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      color: color,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      todoViewModel.updateleftside(true);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 15)),
                Column(children: [
                  Text('$month',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                  Text('$year', style: const TextStyle(color: Colors.white))
                ]),
                IconButton(
                    onPressed: () {
                      todoViewModel.updaterightside(true);
                    },
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15)),
              ],
            ),
          ),
          SizedBox(
            width: 600,
            height: 83,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                Color datecontainercolor = const Color.fromARGB(99, 21, 21, 21);
                int? todaysdate = boxclicked ??
                    (DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ==
                            DateTime(datestobeused.year, datestobeused.month, datestobeused.day + index)
                        ? index
                        : null);

                if (todaysdate == index) {
                  dayshowing ==
                      '${datestobeused.add(Duration(days: index)).day}-${monthsOfYear[datestobeused.add(Duration(days: index)).month]!.substring(0, 3)}-${datestobeused.add(Duration(days: index)).year}';
                  datecontainercolor = Theme.of(context).primaryColor;
                }

                String? containerdayoftheweek = daysOfWeek[datestobeused.add(Duration(days: index)).weekday];
                int containerdate = datestobeused.add(Duration(days: index)).day;

                Widget? value;

                if (listofdate.contains(
                    "${datestobeused.add(Duration(days: index)).year}-${datestobeused.add(Duration(days: index)).month.toString().length < 2 ? '0${datestobeused.add(Duration(days: index)).month}' : datestobeused.add(Duration(days: index)).month.toString()}-${datestobeused.add(Duration(days: index)).day.toString().length < 2 ? '0${datestobeused.add(Duration(days: index)).day}' : datestobeused.add(Duration(days: index)).day.toString()}")) {
                  value = GestureDetector(
                      onTap: () {
                        if (boxclicked != index) {
                          boxclicked = index;
                          todoViewModel.updatedayanddate(
                              "${datestobeused.add(Duration(days: index)).day}-${monthsOfYear[datestobeused.add(Duration(days: index)).month]!.substring(0, 3)}-${datestobeused.add(Duration(days: index)).year}",
                              "${datestobeused.add(Duration(days: index)).year}-${datestobeused.add(Duration(days: index)).month.toString().length < 2 ? '0${datestobeused.add(Duration(days: index)).month}' : datestobeused.add(Duration(days: index)).month.toString()}-${datestobeused.add(Duration(days: index)).day.toString().length < 2 ? '0${datestobeused.add(Duration(days: index)).day}' : datestobeused.add(Duration(days: index)).day.toString()}");
                        } else {
                          return;
                        }
                      },
                      child: datecontainer(
                        index,
                        context,
                        containerdayoftheweek,
                        containerdate,
                        datecontainercolor,
                        true,
                      ));
                } else {
                  value = GestureDetector(
                      onTap: () {
                        if (boxclicked != index) {
                          todoViewModel.updateboxclicked(index);
                          todoViewModel.updatedayanddate(
                              "${datestobeused.add(Duration(days: index)).day}-${monthsOfYear[datestobeused.add(Duration(days: index)).month]!.substring(0, 3)}-${datestobeused.add(Duration(days: index)).year}",
                              "${datestobeused.add(Duration(days: index)).year}-${datestobeused.add(Duration(days: index)).month.toString().length < 2 ? '0${datestobeused.add(Duration(days: index)).month}' : datestobeused.add(Duration(days: index)).month.toString()}-${datestobeused.add(Duration(days: index)).day.toString().length < 2 ? '0${datestobeused.add(Duration(days: index)).day}' : datestobeused.add(Duration(days: index)).day.toString()}");
                        } else {
                          return;
                        }
                      },
                      child: datecontainer(
                        index,
                        context,
                        containerdayoftheweek,
                        containerdate,
                        datecontainercolor,
                        false,
                      ));
                }

                return value;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TodoViewModel todoViewModel = Provider.of(context, listen: false);
    int focusmode = context.select<TodoViewModel, int>((model) => model.focusmode);
    List listofdate = context.select<TodoViewModel, List>((model) => model.listofdate);

    String dayshowing = context.select<TodoViewModel, String>((model) => model.dayshowing);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              IconButton(
                constraints: BoxConstraints.tight(const Size(50, 50)),
                splashColor: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Text(
                'Calendar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          datepicker(context, listofdate),
          Container(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              margin: const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      style: ButtonStyle(
                          side: WidgetStateProperty.all(
                              const BorderSide(color: Color.fromARGB(100, 151, 151, 151), width: 2)),
                          minimumSize: const WidgetStatePropertyAll(Size(177, 69)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          backgroundColor: WidgetStateProperty.all(
                              focusmode == 0 ? Theme.of(context).primaryColor : const Color.fromRGBO(54, 54, 54, 1))),
                      onPressed: () {
                        todoViewModel.reassigncompletedmaintodo(0);
                      },
                      child: Text(
                        dayshowing,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      style: ButtonStyle(
                          side: WidgetStateProperty.all(
                              const BorderSide(color: Color.fromARGB(100, 151, 151, 151), width: 2)),
                          minimumSize: const WidgetStatePropertyAll(Size(177, 69)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          backgroundColor: WidgetStateProperty.all(
                              focusmode == 1 ? Theme.of(context).primaryColor : const Color.fromRGBO(54, 54, 54, 1))),
                      onPressed: () {
                        todoViewModel.reassigncompletedmaintodo(1);
                      },
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )),
          Selector<TodoViewModel, List<TodoModelclass>>(
              selector: (context, todoviewmodel) => todoviewmodel.calendarPageMaintodos,
              builder: (context, calendarPageMaintodos, child) {
                return Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SlidableAutoCloseBehavior(
                            closeWhenOpened: true,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: calendarPageMaintodos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Slidable(
                                    key: Key(calendarPageMaintodos[index].id.toString()),
                                    // Specify a key if the Slidable is dismissible.

                                    // The start action pane is the one at the left or the top side.

                                    // The end action pane is the one at the right or the bottom side.
                                    endActionPane: ActionPane(
                                      key: Key(calendarPageMaintodos[index].id.toString()),
                                      dismissible: DismissiblePane(onDismissed: () {
                                        todoViewModel.deletetodo(calendarPageMaintodos[index].id);
                                      }),
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (BuildContext context) async {
                                            await todoViewModel.deletetodo(calendarPageMaintodos[index].id);
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
                                            builder: (BuildContext context) =>
                                                EditScreen(todoitem: calendarPageMaintodos[index]),
                                          ),
                                        )
                                            .then(
                                          (value) async {
                                            if (value == 'deleting') {
                                              await todoViewModel.deletetodo(calendarPageMaintodos[index].id);
                                            }
                                          },
                                        );
                                      },
                                      child: TodoListItems(
                                        modelclass: calendarPageMaintodos[index],
                                        context: context,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      )),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 61, 152, 249),
          shape: const CircleBorder(),
          onPressed: () async {
            showinputDialog(context);
            datebuttonfocus.requestFocus();
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
              personalbottombar(const Icon(Icons.home_outlined, color: Colors.white, size: 34), 'Home', () {
                Navigator.of(context).pop();
              }),
              personalbottombar(
                  const Icon(Icons.calendar_month_outlined, color: Colors.white, size: 34), 'Calendar', () {}),
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
                const Icon(Icons.person_2_outlined, color: Colors.white, size: 34),
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
