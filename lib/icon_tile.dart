import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experience.dart';

class IconTile extends StatefulWidget {
  const IconTile({super.key, required this.icon, required this.title});

  final String title;
  final IconData icon;

  @override
  State<IconTile> createState() => _IconTileState();
}

class _IconTileState extends State<IconTile> {
  List<Widget> xpList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                modalSheet(context);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Icon(widget.icon, size: 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return ChangeNotifierProvider.value(
            value: context.read<MyExperiences>(),
            child: SizedBox(
                height: MediaQuery.of(context).size.height - 50,
                width: MediaQuery.of(context).size.width - 15,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("More Information"),
                          const Spacer(),
                          TextButton(
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          TextButton(
                              child: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  xpList.add(Experience(title: widget.title));
                                });
                              }),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 25,
                          child: ListView(
                            children: xpList, // Display ListTiles in a ListView
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
