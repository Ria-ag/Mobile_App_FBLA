import 'package:flutter/material.dart';
import 'modal_sheet.dart';

//this class defines icon tiles eg.Athletics

class IconTile extends StatelessWidget {
  //needs an icon, the title, and which tile it is
  const IconTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.tileIndex});
  final String title;
  final dynamic icon;
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: SizedBox(
        width: 185,
        child: Column(
          children: [
            Text(
              title,
              style: (title == "Community Service")
                  ? Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(fontSizeFactor: 0.925)
                  : Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            //on click the text tile opens up a modal sheet with its data in it
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
                  //if it is a community service tile it displays the number of hours not the icon
                  child: Center(
                    child: (icon.runtimeType == IconData)
                        ? Icon(icon, size: 60)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$icon",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                              Text("hours",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
