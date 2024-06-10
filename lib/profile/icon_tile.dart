import 'package:flutter/material.dart';
import '../theme.dart';
import 'modal_sheet.dart';

// This class defines icon tiles eg.Athletics

class IconTile extends StatelessWidget {
  // Needs an icon, the title, and which tile it is
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
      padding: const EdgeInsets.only(bottom: 7.5),
      child: SizedBox(
        height: 160,
        width: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: (title == "Community Service")
                  ? Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(fontSizeFactor: 0.925, color: Colors.white)
                  : Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // On click the text tile opens up a modal sheet with its data in it
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  modalSheet(context, title, tileIndex, theme);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      shadow,
                    ],
                  ),
                  // If it is a community service tile it displays the number of hours not the icon
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
                                    .headlineLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                              Text(
                                "hours",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
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
