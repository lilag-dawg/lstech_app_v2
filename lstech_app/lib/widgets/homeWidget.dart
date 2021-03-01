import 'package:flutter/material.dart';
import 'package:lstech_app/models/item.dart';
import 'package:lstech_app/widgets/expandedViewWidget.dart';

class HomeWidget extends StatelessWidget {
  final Item item1 = Item(body: [
    ExpandedValue(
        text:
            "Entrez la longueur de manivelle de votre pédalier (en mm). Cela correspond à la mesure du trait en brun de l’image ci-dessous.",
        imageUrl: "assets/crank_length.png")
  ], headerValue: "Première utilisation");

  final Item item2 = Item(body: [
    ExpandedValue(
        text:
            "Assurez que votre WattzaTM est bien connecté à votre téléphone."),
    ExpandedValue(
        text: "a. Allez dans l’onglet connexion Bluetooth",
        imageUrl: "assets/homescreen_bluetooth.png"),
    ExpandedValue(
        text: "b. Réveiller le WattzaTM en faisant quelques tours de pédale."),
    ExpandedValue(
        text: "c. Repérez le WattzaTM à votre écran et appuyez sur connexion."),
    ExpandedValue(
      text: "d. Votre appareil est maintenant connecté à votre téléphone.",
    )
  ], headerValue: "Connexion Bluetooth");

  final Item item3 = Item(body: [
    ExpandedValue(
        text:
            "1. Cliquez sur l'icônes démarrer au bas de l’écran pour démarrer une séance d’entraînement.",
        imageUrl: "assets/homescreen_play.png"),
    ExpandedValue(
        text: "2. Cliquez sur le bouton pause pour mettre la séance en pause.",
        imageUrl: "assets/homescreen_pause.png"),
    ExpandedValue(
        text:
            "3. Pour voir votre sommaire d’entraînement, cliquez sur stats. Il s’agit d’un visionnement éphémère. L’appareil ne conserve pas  en mémoire vos entraînements pour le moment.")
  ], headerValue: "Effectuer un entraînement");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sommaire de l'application",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            ExpandedViewWidget(
              data: item1,
            ),
            ExpandedViewWidget(
              data: item2,
            ),
            ExpandedViewWidget(
              data: item3,
            )
          ],
        ),
      ),
    );
  }
}
