import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/backend/database_helper.dart';
import 'package:to_do_app_beta/listoftodos.dart';
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';

class Completed extends StatefulWidget {
  const Completed({
    super.key,
  });

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  DatabaseHelper databaseinstance = DatabaseHelper.creatinginstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Completed',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        }),
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, model, child) {
          return Container(
            color: Colors.black,
            child: model.completedtodos.isNotEmpty
                ? SlidableAutoCloseBehavior(
                    closeWhenOpened: true,
                    child: ListView.builder(
                        itemCount: model.completedtodos.length,
                        itemBuilder: (BuildContext context, int index) {
                          ValueKey valuekey = ValueKey(model.completedtodos[index].id.toString());
                          return Slidable(
                            key: valuekey,
                            // Specify a key if the Slidable is dismissible.

                            // The start action pane is the one at the left or the top side.

                            // The end action pane is the one at the right or the bottom side.
                            endActionPane: ActionPane(
                              key: valuekey,
                              dismissible: DismissiblePane(onDismissed: () {
                                model.deletetodo(model.completedtodos[index].id);
                              }),
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    model.deletetodo(model.completedtodos[index].id);
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
                            child: TodoListItems(
                              modelclass: model.completedtodos[index],
                              context: context,
                            ),
                          );
                        }),
                  )
                : const Center(
                    child: Text('Completed tasks appears here', style: TextStyle(color: Colors.white, fontSize: 18))),
          );
        },
      ),
      drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.topStart,
                child: const ListTile(
                  minTileHeight: 250,
                  tileColor: Color.fromARGB(255, 174, 26, 223),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Today/',
                    (route) => false,
                  );
                },
                leading: const Icon(Icons.today),
                title: const Text('Today'),
                minTileHeight: 60,
                tileColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Tomorrow/',
                    (route) => false,
                  );
                },
                leading: const Icon(Icons.next_plan_outlined),
                title: const Text('Tomorrow'),
                minTileHeight: 60,
                tileColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              const ListTile(
                leading: Icon(Icons.watch_later),
                title: Text('Someday'),
                minTileHeight: 60,
                tileColor: Color.fromARGB(255, 255, 255, 255),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Completed/',
                    (route) => false,
                  );
                },
                leading: const Icon(Icons.done_all),
                title: const Text('Completed'),
                minTileHeight: 60,
                tileColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          )),
    );
  }
}
