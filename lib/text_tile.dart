import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  const TextTile(
      {super.key, required this.name, required this.title, this.trailing = ""});

  final String name;
  final String trailing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
              title: Text(name),
              trailing: Text(trailing),
            ),
          ),
        ],
      ),
    );
  }
}

void modalSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
                    ],
                  ),
                ],
              ),
            ));
      });
}
