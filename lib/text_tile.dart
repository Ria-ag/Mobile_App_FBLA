import 'package:flutter/material.dart';
import 'package:mobileapp/experience.dart';
import 'package:mobileapp/modal_sheet.dart';
import 'package:provider/provider.dart';

class TextTile extends StatelessWidget {
  const TextTile({super.key, required this.title, required this.tileIndex});
  final String title;
  final int tileIndex;

  @override
  Widget build(BuildContext context) {
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                modalSheet(context, title, tileIndex);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
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
