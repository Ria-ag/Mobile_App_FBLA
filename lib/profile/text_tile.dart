import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'experience.dart';
import 'modal_sheet.dart';
import '../theme.dart';

// This class defines text tiles eg.Clubs/Organizations
class TextTile extends StatelessWidget {
  // The class requires a title and index
  const TextTile({super.key, required this.title, required this.tileIndex});
  final String title;
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    // Displays each experience summary in the body with its name
    List<Widget> nameSummary = [];
    List<Widget> dateSummary = [];
    for (Experience xp in context.watch<MyExperiences>().xpList[tileIndex]) {
      nameSummary.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.125),
        child: Text(xp.name,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white)),
      ));
    }
    // Displays each experience summary in the body with its date as well
    for (Experience xp in context.watch<MyExperiences>().xpList[tileIndex]) {
      dateSummary.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.125),
        child: Text(
          "${xp.startDate} - ${xp.endDate}",
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
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
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
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
