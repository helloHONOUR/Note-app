class TodoModelclass {
  // static NoteService singleInstClassofNoteservice = NoteService.createinstance();
  int? id;
  String todo;
  String description;
  String date;
  int? completed;
  String? priority;
  String? tagname;
  String? notetime;
  String? tagcolor;
  String? tagicon;

  TodoModelclass(
      {this.id,
      required this.todo,
      required this.description,
      required this.date,
      this.completed,
      this.priority,
      this.notetime,
      this.tagname,
      this.tagcolor,
      this.tagicon});

// From Map to Todo Data Structure
  factory TodoModelclass.frommap(Map map) {
    return TodoModelclass(
      id: map['id'],
      todo: map['todo'],
      description: map['description'],
      date: map['date'],
      completed: map['completed'],
      priority: map['priority'],
      notetime: map['notetime'],
      tagname: map['tagname'],
      tagcolor: map['tagcolor'],
      tagicon: map['tagicon'],
    );
  }

  Map<String, dynamic> todotomap() {
    return {
      'id ': id,
      'todo': todo,
      'description': description,
      'date': date,
      'completed': completed,
      'priority': priority,
      'notetime': notetime,
      'tagname': tagname,
      'tagcolor': tagcolor,
      'tagicon': tagicon,
    };
  }
}

List<TodoModelclass> maptoTODOclass(List<Map> dbresult) {
  List<TodoModelclass> listofTODOs = [];
  for (Map map in dbresult) {
    listofTODOs.add(TodoModelclass.frommap(map));
  }
  return listofTODOs;
}

// TAG MODEL CLASS
class Tagclass {
  int? id;
  String? tagname;
  String? tagcolor;
  String? tagicon;

  Tagclass({this.id, this.tagname, this.tagcolor, this.tagicon});

// From Map to Todo Data Structure
  factory Tagclass.frommap(Map map) {
    return Tagclass(
      id: map['id'],
      tagname: map['tagname'],
      tagcolor: map['tagcolor'],
      tagicon: map['tagicon'],
    );
  }

  Map<String, dynamic> tagtomap() {
    return {
      'id ': id,
      'tagname': tagname,
      'tagcolor': tagcolor,
      'tagicon': tagicon,
    };
  }
}

List<Tagclass> maptoTAGclass(List<Map> maplist) {
  List<Tagclass> listofTAGs = [];
  for (Map map in maplist) {
    listofTAGs.add(Tagclass.frommap(map));
  }
  return listofTAGs;
}
