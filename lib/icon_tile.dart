import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobileapp/icon_tile_provider';
import 'experience.dart';

class IconNotifier extends ChangeNotifier {
  List<Experience> xpList = [];

  void addXP(Experience xp) {
    xpList.add(xp);
    notifyListeners();
  }

  void removeXP(int index) {
    xpList.removeAt(index);
    notifyListeners();
  }
}

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
                modalSheet(context, title);
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

void modalSheet(BuildContext context, String title) {
  var readState = context.read<IconNotifier>();
  var watchState = context.watch<IconNotifier>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ChangeNotifierProvider.value(
        value: context.read<IconNotifier>(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          width: MediaQuery.of(context).size.width - 15,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Icon(Icons.add, size: 20),
                      onPressed: () {
                        // readState.addXP(
                        //   Experience(
                        //     title: "Experience ${readState.xpList.length + 1}",
                        //     // remove: (index) => readState.removeXP(index),
                        //     // index: readState.xpList.length,
                        //   ),
                        // );
                      },
                    ),
                    TextButton(
                      child:
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                //...watchState.xpList,
              ],
            ),
          ),
        ),
      );
    },
  );
}
