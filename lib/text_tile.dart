import 'package:flutter/material.dart';
import 'package:mobileapp/experience.dart';

class TextTile extends StatefulWidget {
  const TextTile({super.key, required this.name, required this.title});

  final String name;
  final String title;

  @override
  State<TextTile> createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> {
  List<Widget> xpList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              onTap: () {
                modalSheet(context);
              },
              title: Text(widget.name),
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
          return SizedBox(
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
                        //height: 200,
                        width: MediaQuery.of(context).size.width - 25,
                        child: ListView(
                          children: xpList, // Display ListTiles in a ListView
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
