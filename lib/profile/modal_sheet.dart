import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experience.dart';

// This is a method that builds the modal sheet that opens with every tile
// It takes the context, title, and type of tile
Future<void> modalSheet(context, title, tileIndex, theme) {
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("More Information",
                        style: Theme.of(context).textTheme.headlineSmall),
                    const Spacer(),
                    //This button when pressed adds an experience to the tile list and updates using a provider
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () =>
                          context.read<MyExperiences>().add(title, tileIndex),
                    ),
                    // This button when pressed closes the modal sheet
                    IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                const Divider(color: Colors.grey, thickness: 1),
                // Displays the list of experiences for each tile
                Container(
                  child: (context
                          .watch<MyExperiences>()
                          .xpList[tileIndex]
                          .isNotEmpty)
                      ? SingleChildScrollView(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: context
                                .watch<MyExperiences>()
                                .xpList[tileIndex]
                                .length,
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider (
                                  color: Colors.grey,
                                  thickness: 1.5,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return context.watch<MyExperiences>().xpList[tileIndex][index];
                              },
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10.0),
                          // Displays this text until experiences are added
                          child: Text(
                              "Looks a little empty in here. Click on the add button at the top to get started!"),
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
