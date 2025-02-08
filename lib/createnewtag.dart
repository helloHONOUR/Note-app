import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app_beta/backend/database_helper.dart';
import 'package:to_do_app_beta/backend/notes_service.dart';
import 'package:to_do_app_beta/iconsfile.dart';
import 'package:to_do_app_beta/provider%20class/TodoViewModel.dart';

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final TextEditingController categorycontroller = TextEditingController();
  bool iconbuttonclicked = false;
  DatabaseHelper databaseinstance = DatabaseHelper.creatinginstance();
  final List<Color> listofcolors = colorMapping.values.toList();
  IconData? categoryicon;
  Color? categorycolor;

  void createnewtag() async {
    TagViewModel tagViewModel = Provider.of<TagViewModel>(context, listen: false);

    {
      if (categorycontroller.text.isNotEmpty) {
        // CONVERTING THE ICON OF TAG BY USER TO STRING TO INSERT IN MAP AND DATABASE
        String iconmappedkey = '';
        MapEntry<String, IconData> iconfound;
        try {
          iconfound = iconMapping.entries.firstWhere(
            (entry) {
              return entry.value == categoryicon;
            },
            orElse: () {
              iconfound = const MapEntry<String, IconData>('defaulticon', Icons.not_interested);
              return iconfound;
            },
          );
          iconmappedkey = iconfound.key;
        } catch (e) {
          print('no icon found');
          return;
        }

        // CONVERTING THE COLOR OF TAG BY USER TO STRING TO INSERT IN MAP AND DATABASE

        MapEntry<String, Color> colorresult;
        String colormappedkey = '';
        try {
          colorresult = colorMapping.entries.firstWhere((entry) {
            return entry.value == categorycolor;
          }, orElse: () {
            colorresult = const MapEntry<String, Color>('defaultcolor', const Color.fromARGB(255, 213, 122, 122));
            return colorresult;
          });
          colormappedkey = colorresult.key;
        } catch (e) {
          print('no colour found ');
          return;
        }

        Tagclass newtag = Tagclass.frommap({
          'tagname': categorycontroller.text,
          'tagicon': iconmappedkey,
          'tagcolor': colormappedkey,
        });
        print(newtag.tagcolor);
        bool? check;
        if (tagViewModel.taglist.isNotEmpty) {
          for (Tagclass tag in tagViewModel.taglist) {
            if (tag.tagname == newtag.tagname && tag.tagcolor == newtag.tagcolor && tag.tagicon == newtag.tagicon) {
              check = true;
            } else {
              check = false;
            }
          }
        } else {
          check = false;
        }
        if (check!) {
          return;
        } else {
          await tagViewModel.addtag(newtag);
        }
      } else {
        _focusNode.requestFocus();
      }
    }
  }

  iconscontainer(String? iconname) {
    IconData? iconresult = iconMapping[iconname];

    if (iconresult != null) {
      categoryicon = iconresult;

      return Icon(
        (iconresult),
        color: Colors.white,
        size: 40,
      );
    } else {
      return const Row(
        children: [
          Icon(
            Icons.error,
            color: Color.fromARGB(1000, 255, 73, 73),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'No Icon found',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      );
    }
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create new Category',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Category name :',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    flex: 16,
                    child: TextField(
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      controller: categorycontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: 'Category name',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            borderSide: BorderSide(width: 5, color: Colors.white),
                          )),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: 40,
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        onPressed: () {
                          if (categorycontroller.text.isEmpty) {
                            _focusNode.requestFocus();
                          } else {
                            iconbuttonclicked = true;

                            setState(() {});
                            _focusNode.unfocus();
                          }
                        },
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Category icon :',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
              ),
              const SizedBox(height: 16),
              iconbuttonclicked
                  ? SizedBox(
                      height: 57,
                      child: iconscontainer(categorycontroller.text),
                    )
                  : TextButton(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          fixedSize: const WidgetStatePropertyAll(Size.fromHeight(57)),
                          backgroundColor: const WidgetStatePropertyAll(Color.fromRGBO(54, 54, 54, 1))),
                      onPressed: () {
                        _focusNode.requestFocus();
                        if (categorycontroller.text.isNotEmpty) {
                          iconbuttonclicked = true;
                          setState(() {});
                          _focusNode.unfocus();
                        } else {
                          return;
                        }
                      },
                      child: const Text('Choose icon from library')),
              const SizedBox(height: 20),
              const Text(
                'Category color :',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 55,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listofcolors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          categorycolor = listofcolors[index];

                          setState(() {});
                        },
                        child: Container(
                            width: 45,
                            margin: const EdgeInsets.only(right: 7),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: listofcolors[index]),
                            child: categorycolor == listofcolors[index]
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null),
                      );
                    }),
              ),
              const SizedBox(height: 350),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          minimumSize: const WidgetStatePropertyAll(Size(153, 48)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextButton(
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                            minimumSize: const WidgetStatePropertyAll(Size(153, 48)),
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                        onPressed: () {
                          createnewtag();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Create Category',
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
