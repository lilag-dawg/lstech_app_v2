import 'package:flutter/material.dart';
import 'package:lstech_app/models/item.dart';
import 'package:lstech_app/widgets/expandedViewWidget.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Item item1 = Item(body: [
    ExpandedValue(
        text:
            "Entrez la longueur de manivelle de votre pédalier (en mm). Cela correspond à la mesure du trait en bleu de l’image ci-dessous.",
        imageUrl: "assets/crank_length.jpg")
  ], headerValue: "Première utilisation");

  Item item2 = Item(body: [
    ExpandedValue(
        text:
            "Assurez que votre Wattzaᵀᴹ est bien connecté à votre téléphone."),
    ExpandedValue(
        text: "a. Allez dans l’onglet connexion Bluetooth",
        imageUrl: "assets/homescreen_bluetooth.png"),
    ExpandedValue(
        text: "b. Réveiller le Wattzaᵀᴹ en faisant quelques tours de pédale."),
    ExpandedValue(
        text: "c. Repérez le Wattzaᵀᴹ à votre écran et appuyez sur connexion."),
    ExpandedValue(
      text: "d. Votre appareil est maintenant connecté à votre téléphone.",
    )
  ], headerValue: "Connexion Bluetooth");

  Item item3 = Item(body: [
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

  void _handlePress(String id) {
    switch (id) {
      case "item1":
        setState(() {
          item1.isExpanded = true;
          item2.isExpanded = false;
          item3.isExpanded = false;
        });
        break;
      case "item2":
        setState(() {
          item1.isExpanded = false;
          item2.isExpanded = true;
          item3.isExpanded = false;
        });
        break;
      case "item3":
        setState(() {
          item1.isExpanded = false;
          item2.isExpanded = false;
          item3.isExpanded = true;
        });
        break;
      default:
    }
  }

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
              onPress: () {
                _handlePress("item1");
              },
            ),
            ExpandedViewWidget(
              data: item2,
              onPress: () {
                _handlePress("item2");
              },
            ),
            ExpandedViewWidget(
              data: item3,
              onPress: () {
                _handlePress("item3");
              },
            )
          ],
        ),
      ),
    );
  }
}
