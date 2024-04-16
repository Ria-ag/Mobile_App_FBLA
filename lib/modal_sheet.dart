import 'package:flutter/material.dart';
import 'package:mobileapp/experience.dart';
import 'package:provider/provider.dart';

Future<void> modalSheet(BuildContext context, title, index) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    builder: (BuildContext context) {
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
                    Text("More Information",
                        style: Theme.of(context).textTheme.headlineSmall),
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
                      onPressed: () => context
                          .read<MyExperiences>()
                          .add(Experience(title: title), index),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 25,
                    child: ListView(
                      //TODO: WON'T UPDATE IMMEDIATELY IF LISTVIEW, WON'T SCROLL IF COLUMN
                      children: context.watch<MyExperiences>().xpList[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
