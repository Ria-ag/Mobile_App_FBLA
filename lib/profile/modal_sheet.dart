import 'package:flutter/material.dart';
import 'experience.dart';
import 'package:provider/provider.dart';

//this is a method that builds the modal sheet that opens with every tile
//it takes the context, title, and type of tile 
Future<void> modalSheet(BuildContext context, title, tileIndex) {
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
                    //this button when pressed adds an experience to the tile list and updates using a provider
                    TextButton(
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () =>
                          context.read<MyExperiences>().add(title, tileIndex),
                    ),
                    //this button when pressed closes the modal sheet
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
                //displays the list of experiences for each tile
                SizedBox(
                  width: MediaQuery.of(context).size.width - 25,
                  height: MediaQuery.of(context).size.height - 130,
                  child: (context
                          .watch<MyExperiences>()
                          .xpList[tileIndex]
                          .isNotEmpty)
                      ? SingleChildScrollView(
                          child: Column(
                            children: context
                                .watch<MyExperiences>()
                                .xpList[tileIndex],
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10.0),
                          //displays this text until experiences are added
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
