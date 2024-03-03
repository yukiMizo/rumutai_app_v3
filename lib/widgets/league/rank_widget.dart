import 'package:flutter/material.dart';

class RankWidget extends StatelessWidget {
  final List<String> rank;
  const RankWidget(this.rank, {super.key});

  List<Widget> rankWidget(List<String> rank) {
    List<Widget> rankList = [
      if (rank.isNotEmpty)
        const Text(
          "順位",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      const SizedBox(height: 15),
    ];
    var count = 1;
    for (var team in rank) {
      rankList.add(
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          SizedBox(
            width: 12,
            height: 18,
            child: Text(
              "$count",
              style: const TextStyle(
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(
            height: 18,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 1),
                child: Text(
                  "位",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 18),
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  team,
                  style: const TextStyle(fontSize: 18, height: 1.0),
                ),
              ),
            ),
          ),
        ]),
      );
      rankList.add(const SizedBox(height: 5));
      count++;
    }
    return rankList;
  }

  @override
  Widget build(BuildContext context) {
    if (rank.isEmpty) {
      return const SizedBox();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.brown.shade800, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 5,
              right: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: rankWidget(rank),
            ),
          ),
        ),
      ],
    );
  }
}
