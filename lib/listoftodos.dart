//listtile
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/backend/notes_service.dart';
import 'package:to_do_app_beta/edit.dart';
import 'package:to_do_app_beta/backend/database_helper.dart';
import 'package:to_do_app_beta/iconsfile.dart';
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';
import 'package:to_do_app_beta/tomorrow.dart';

class TodoListItems extends StatefulWidget {
  final TodoModelclass modelclass;

  const TodoListItems({
    super.key,
    required BuildContext context,
    required this.modelclass,
  });

  @override
  State<TodoListItems> createState() => _TodoListItemsState();
}

class _TodoListItemsState extends State<TodoListItems> {
  get tagcontainer {
    return Container(
      decoration: BoxDecoration(
          color: colorMapping[widget.modelclass.tagcolor], borderRadius: const BorderRadius.all(Radius.circular(8))),
      width: 140,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            iconMapping[widget.modelclass.tagicon],
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            // widget.modelclass!.tag?.substring(0, 1).toUpperCase() + widget.tag!.substring(1),
            widget.modelclass.tagname!,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  get prioritycontainer {
    return Container(
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
              child: Text(style: const TextStyle(color: Colors.white), widget.modelclass.priority!),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Icon checkbox = const Icon(
      Icons.circle_outlined,
      color: Colors.white,
    );
    String wordcount = '';
    String widgettime = '';

    widgettime = widget.modelclass.notetime!;
    if (widget.modelclass.todo.length > 25) {
      wordcount = '${widget.modelclass.todo.substring(0, 25)}.....';
    } else {
      wordcount = widget.modelclass.todo;
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 16, 10, 15),
      height: 90.0,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(54, 54, 54, 100), // Background color
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          border: Border.all(
            // Border color
            width: 1.0, // Border width
          )),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          widget.modelclass.completed == 0
              ? SizedBox(
                  width: 50,
                  child: IconButton(
                    onPressed: () async {
                      checkbox = const Icon(
                        Icons.check_circle_outline_outlined,
                        color: Colors.white,
                      );

                      final todoViewModel = Provider.of<TodoViewModel>(context, listen: false);
                      todoViewModel.updatetodo(widget.modelclass.id, 'completed', 1);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Congrats!!! your task ${widget.modelclass.todo} has been completed '),
                            duration: const Duration(seconds: 2), // How long the SnackBar stays visible
                            // action: SnackBarAction(
                            //   label: 'UNDO',
                            //   onPressed: () {},
                            // ),
                          ),
                        );
                      }
                    },
                    icon: checkbox,
                  ),
                )
              : const SizedBox(
                  width: 50,
                  child: Icon(
                    Icons.done_all_outlined,
                    color: Colors.white,
                  ),
                ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    wordcount.substring(0, 1).toUpperCase() + wordcount.substring(1),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: widget.modelclass.tagname != null
                            ? const EdgeInsets.only(top: 0.0)
                            : const EdgeInsets.only(top: 6.0),
                        child: Text(
                          widgettime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  tagcontainer,
                  const SizedBox(
                    width: 10,
                  ),
                  prioritycontainer,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
