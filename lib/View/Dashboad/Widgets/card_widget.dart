import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Dashboad/Widgets/custome_card.dart';
import 'package:tailer_shop/Viewmodel/dash_card_details.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    final cardDetails = CardDetails();
    return GridView.builder(
      itemCount: cardDetails.cardData.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 15, mainAxisSpacing: 12),
      itemBuilder: (context, index) => CustomCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              cardDetails.cardData[index].icon,
              width: 30,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 4),
              child: Text(
                cardDetails.cardData[index].value,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              cardDetails.cardData[index].title,
              style: TextStyle(
                  fontSize: 13,
                  color: const Color.fromARGB(255, 39, 39, 39),
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
