import 'package:flutter/material.dart';
import 'package:mobileapp/modal_sheet.dart';

class IconTile extends StatelessWidget {
  const IconTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.index});

  final String title;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Icon(icon, size: 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
