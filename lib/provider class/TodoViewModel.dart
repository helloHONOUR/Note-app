import 'package:flutter/material.dart';
import 'package:to_do_app_beta/backend/database_helper.dart';
import 'package:to_do_app_beta/backend/notes_service.dart';
import 'package:to_do_app_beta/iconsfile.dart';

class TodoViewModel extends ChangeNotifier {
  TodoViewModel() {
    _fetchtodo();
  }

  final DatabaseHelper _dbinstance = DatabaseHelper.creatinginstance();

  List<TodoModelclass> alltodos = [];

// STATES FOR GENERAL PAGE
  String thedayshowing = 'Today';
  String thedaynotshowing1 = 'Tomorrow';
  String thedaynotshowing2 = 'Others';

  final List<TodoModelclass> _completedtodos = [];
  final List<TodoModelclass> _otherstodo = [];
  final List<TodoModelclass> _tomorrowtodo = [];
  final List<TodoModelclass> _todaytodo = [];
  List<TodoModelclass> mainpagetodo = [];
  bool isloading = true;
  List emptylist = [];

// STATES OF CALENDAR PAGE
  final List<TodoModelclass> _calendarPageUncompletedtodos = [];
  final List<TodoModelclass> _calendarPageCompletedtodos = [];
  List<TodoModelclass> calendarPageMaintodos = [];
  List listofdate = [];
  DateTime datestobeused = DateTime.now();
  DateTime firstdayofweek = DateTime.now();
  bool leftside = false;
  bool rightside = false;
  int? boxclicked;
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  String dayshowing =
      "${DateTime.now().day}-${monthsOfYear[DateTime.now().month]!.substring(0, 3)}-${DateTime.now().year}";
  String dateshowing =
      "${DateTime.now().year}-${DateTime.now().month.toString().length < 2 ? '0${DateTime.now().month}' : DateTime.now().month.toString()}-${DateTime.now().day.toString().length < 2 ? '0${DateTime.now().day}' : DateTime.now().day.toString()}";
  int completedOruncompleted = 0;
  int focusmode = 0;

  // GETTERS FOR MAIN PAGE
  List<TodoModelclass> get completedtodos => _completedtodos;
  List<TodoModelclass> get otherstodo => _otherstodo;
  List<TodoModelclass> get tomorrowtodo => _tomorrowtodo;
  List<TodoModelclass> get todaytodo => _todaytodo;

  void isscreenloading(bool newvalue) {
    isloading = newvalue;
    notifyListeners();
  }

  void updateDayBasedOnAvailability() {
    if (todaytodo.isNotEmpty) {
      thedayshowing = 'Today';
      thedaynotshowing1 = 'Tomorrow';
      thedaynotshowing2 = 'Others';
      mainpagetodo = List.from(_todaytodo);
    } else if (tomorrowtodo.isNotEmpty) {
      thedayshowing = 'Tomorrow';
      thedaynotshowing1 = 'Today';
      thedaynotshowing2 = 'Others';
      mainpagetodo = List.from(_tomorrowtodo);
    } else if (otherstodo.isNotEmpty) {
      thedayshowing = 'Others';
      thedaynotshowing1 = 'Today';
      thedaynotshowing2 = 'Tomorrow';
      mainpagetodo = List.from(_otherstodo);
    }
  }

  void updateDaySelection() {
    if (thedayshowing == 'Tomorrow') {
      thedaynotshowing1 = 'Today';
      thedaynotshowing2 = 'Others';
      mainpagetodo = List.from(tomorrowtodo);
    } else if (thedayshowing == 'Today') {
      thedaynotshowing1 = 'Tomorrow';
      thedaynotshowing2 = 'Others';
      mainpagetodo = List.from(todaytodo);
    } else {
      thedaynotshowing1 = 'Today';
      thedaynotshowing2 = 'Tomorrow';

      mainpagetodo = List.from(otherstodo);
    }
    notifyListeners();
  }

  //READ
  Future<void> _fetchtodo() async {
    TagViewModel().fetchtags();
    _completedtodos.clear();
    _todaytodo.clear();
    _tomorrowtodo.clear();
    _otherstodo.clear();
    mainpagetodo = List.from(emptylist);

    List<Map<String, dynamic>> dbresult = await _dbinstance.readfromdbanytime();
    alltodos = maptoTODOclass(dbresult);
    for (TodoModelclass todoitem in alltodos) {
      DateTime tododate = DateTime.parse(todoitem.date);
      DateTime todoonlyDate = DateTime(tododate.year, tododate.month, tododate.day);
      DateTime todaysdate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime tomorrowdate = todaysdate.add(const Duration(days: 1));

      if (todoitem.completed == 1) {
        _completedtodos.add(todoitem);
      } else {
        if (todoonlyDate == todaysdate) {
          _todaytodo.add(todoitem);
        } else if (todoonlyDate == tomorrowdate) {
          _tomorrowtodo.add(todoitem);
        } else {
          _otherstodo.add(todoitem);
        }
      }
    }

    isscreenloading(false);
    fetchforcompletedpage();
    updateDayBasedOnAvailability();
    notifyListeners();
  }

  //INSERT
  Future<void> addtodo(TodoModelclass newtodo) async {
    Map<String, dynamic> newtodomapform = newtodo.todotomap();
    await _dbinstance.inserttodatabase(newtodomapform);
    await _fetchtodo();
    notifyListeners();
  }

  //UPDATE
  Future<void> updatetodo(id, String atributetochange, newvalue) async {
    await _dbinstance.updatingtodo(
      id,
      atributetochange,
      newvalue,
    );
    await _fetchtodo();
  }

  //UPDATE FOR TWO ATTRIBUTES
  Future<void> updatemultipleattributes(id, String firstattribute, firstvalue, secondattribute, secondvalue,
      {String? thirdattribute, String? thirdvalue}) async {
    await _dbinstance.updatingtodo(
      id,
      firstattribute,
      firstvalue,
    );
    await _dbinstance.updatingtodo(
      id,
      secondattribute,
      secondvalue,
    );
    if (thirdattribute != null && thirdvalue != null) {
      await _dbinstance.updatingtodo(
        id,
        thirdattribute,
        thirdvalue,
      );
    }

    await _fetchtodo();
  }

  //DELETE
  Future<void> deletetodo(id) async {
    await _dbinstance.deletefromdatabase(id);
    await _fetchtodo();
  }

  // READ FOR COMPLETED
  void fetchforcompletedpage() {
    _calendarPageUncompletedtodos.clear();
    _calendarPageCompletedtodos.clear();
    calendarPageMaintodos.clear();
    listofdate = List.from(emptylist);

// adding listofdate to have all the dates for all todos
    for (TodoModelclass todo in alltodos) {
      if (!listofdate.contains(todo.date)) {
        listofdate.add(todo.date);
      }
    }

    while (datestobeused.weekday != 1) {
      datestobeused = datestobeused.subtract(const Duration(days: 1));
      if (datestobeused.weekday == 1) {
        firstdayofweek = datestobeused;
      }
    }

    if (leftside) {
      datestobeused = datestobeused.subtract(const Duration(days: 7));
      firstdayofweek = datestobeused;
      rightside = false;
      leftside = false;
    }

    if (rightside) {
      datestobeused = datestobeused.add(const Duration(days: 7));
      firstdayofweek = datestobeused;
      rightside = false;
      leftside = false;
    }
    month = firstdayofweek.month;
    year = firstdayofweek.year;

    _filterbydate();
    notifyListeners();
  }

  void _filterbydate() {
    // adding listofdate to have all the dates for all todos
    for (TodoModelclass todo in alltodos) {
      if (!listofdate.contains(todo.date)) {
        listofdate.add(todo.date);
      }
    }
    List<TodoModelclass> todosforchosenday = [];
    //filtering all the todos by date
    for (TodoModelclass todo in alltodos) {
      if (todo.date == dateshowing) {
        todosforchosenday.add(todo);
      }
    }

    // seperating todosfordaychosen for completed and uncompleted
    for (TodoModelclass todo in todosforchosenday) {
      if (todo.completed != 1) {
        _calendarPageUncompletedtodos.add(todo);
      } else {
        _calendarPageCompletedtodos.add(todo);
      }
    }
    calendarPageMaintodos = _calendarPageUncompletedtodos.isEmpty
        ? _calendarPageCompletedtodos.isEmpty
            ? _calendarPageUncompletedtodos
            : _calendarPageCompletedtodos
        : _calendarPageUncompletedtodos;
    focusmode = calendarPageMaintodos == _calendarPageCompletedtodos ? 1 : 0;
  }

// reassigning variables in the provider
  void reassigncompletedmaintodo(completedOruncompleted) {
    completedOruncompleted = completedOruncompleted;
    if (completedOruncompleted == 0) {
      calendarPageMaintodos = _calendarPageUncompletedtodos;
      focusmode = 0;
    } else if (completedOruncompleted == 1) {
      calendarPageMaintodos = _calendarPageCompletedtodos;
      focusmode = 1;
    }
    notifyListeners();
  }

  void updatedayanddate(firstvalue, secvalue) {
    dayshowing = firstvalue;
    dateshowing = secvalue;
    fetchforcompletedpage();
    notifyListeners();
  }

  void updateleftside(newvalue) {
    leftside = newvalue;

    fetchforcompletedpage();
  }

  void updaterightside(newvalue) {
    rightside = newvalue;

    fetchforcompletedpage();
  }

  void updatethedayshowing(newvalue) {
    thedayshowing = newvalue;

    updateDaySelection();
  }

  void updateboxclicked(int newvalue) {
    boxclicked = newvalue;
  }

  void updatemainpagetodo(List<TodoModelclass> newvalue) {
    mainpagetodo = List.from(newvalue);
    _fetchtodo();
  }
}

class TagViewModel extends ChangeNotifier {
  TagViewModel() {
    fetchtags();
  }

  List<Tagclass> taglist = [];

  Tagclass addingtag = Tagclass.frommap({
    'tagname': 'Create New',
    'tagcolor': 'addingtagcolor',
    'tagicon': 'addingtagicon',
  });
  final DatabaseHelper _dbinstance = DatabaseHelper.creatinginstance();

  //INSERT
  Future<void> addtag(Tagclass tag) async {
    Map<String, dynamic> newtagmap = tag.tagtomap();
    await _dbinstance.inserttags(newtagmap);
    await fetchtags();
    notifyListeners();
  }

// READ
  Future<void> fetchtags() async {
    List<Map<String, dynamic>> dbresulttags = await _dbinstance.gettags();
    taglist = List.from(maptoTAGclass(dbresulttags));
    taglist.add(addingtag);
    notifyListeners();
  }

  //UPDATE
  Future<void> updatetags(id, String tagatributetochange, newvalue) async {
    await _dbinstance.updatingtags(
      id,
      tagatributetochange,
      newvalue,
    );
    await fetchtags();
  }

  //DELETE
  Future<void> deletetodo(id) async {
    await _dbinstance.deletefromdatabase(id);
    await fetchtags();
  }

  void updatecatergory() {
    notifyListeners();
  }
}
