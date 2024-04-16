import 'package:flutter/material.dart';
import 'package:mobileapp/modal_sheet.dart';

class IconTile extends StatelessWidget {
  const IconTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.tileIndex});

  final String title;
  final IconData icon;
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
                modalSheet(context, title, tileIndex);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: Icon(icon, size: 60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
