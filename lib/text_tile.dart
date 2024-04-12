import 'package:flutter/material.dart';
import 'package:mobileapp/modal_sheet.dart';

class TextTile extends StatelessWidget {
  const TextTile(
      {super.key,
      required this.name,
      required this.title,
      required this.index});

  final String name;
  final String title;
  final int index;

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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                modalSheet(context, title, index);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text(name)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


