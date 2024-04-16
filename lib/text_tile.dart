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
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
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
                  color: Theme.of(context).colorScheme.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
