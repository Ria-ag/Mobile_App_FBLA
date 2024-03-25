import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.icon, required this.title});

  final String title;
  final IconData icon;

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
                modalSheet(context);
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
