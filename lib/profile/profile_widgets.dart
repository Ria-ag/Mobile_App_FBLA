import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_app_state.dart';
import '../theme.dart';
import 'experience.dart';
import 'modal_sheet.dart';

// This class defines icon tiles, like Athletics
class IconTile extends StatelessWidget {
  // Needs an icon, title and tile index (which indicates the type of title)
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
              style:
                  // If the IconTile has a long name, the fon size will be smaller
                  (title == "Community Service" || title == "Performing Arts")
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
                  modalSheet(context, tileIndex).then((value) =>
                      context.read<MyAppState>().saveXpToDB(tileIndex));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      shadow,
                    ],
                  ),
                  // If the tile is a community service tile, it displays the number of hours rather than an icon
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

// This class defines text tiles, like Clubs/Organizations
class TextTile extends StatefulWidget {
  // The class requires a title and index
  const TextTile({super.key, required this.title, required this.tileIndex});
  final String title;
  final int tileIndex;

  @override
  State<TextTile> createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> {
  @override
  Widget build(BuildContext context) {
    List<Widget> nameSummary = [];
    List<Widget> dateSummary = [];

    for (Experience xp
        in context.watch<MyAppState>().appUser.xpList[widget.tileIndex]) {
      // Displays each experience summary in the body with its name
      if (!xp.editable) {
        nameSummary.add(
          Text(
            xp.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        // Displays each experience summary in the body with its date as well
        dateSummary.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.125),
            child: Text(
              "${xp.startDate} - ${xp.endDate}",
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          // On click, the text tile opens up a modal sheet with the category's experiences
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                modalSheet(context, widget.tileIndex).then((value) =>
                    context.read<MyAppState>().saveXpToDB(widget.tileIndex));
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 40),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [shadow],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: nameSummary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: dateSummary,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
