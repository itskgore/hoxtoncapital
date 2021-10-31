import 'package:flutter/material.dart';
import 'package:hoxtoncapital/models/user_cards_data.dart';
import 'package:hoxtoncapital/utils/constants.dart';
import 'package:provider/provider.dart';

class SavedCardsProvider with ChangeNotifier {
  static SavedCardsProvider of(BuildContext context, {listen: false}) {
    return Provider.of<SavedCardsProvider>(context, listen: listen);
  }

  //user Cards model reference
  List<UserCardsData> _userCardsData = [];
  List<UserCardsData> get userCardsData {
    return _userCardsData ?? [];
  }

  // carousel indicator
  int currentView = 0;

  void changeCarouselIndicator(int index) {
    currentView = index;
    notifyListeners();
  }

  // TabBar dummy data to make the views dyanmic
  List data = [
    {"tab": "A", "data": []},
    {"tab": "B", "data": []},
    {"tab": "C", "data": []},
    {"tab": "D", "data": []},
    {"tab": "E", "data": []},
    {"tab": "F", "data": []},
    {"tab": "G", "data": []},
  ];

  Future<void> getUserCards() async {
    if (_userCardsData.isEmpty) {
      try {
        var data = [
          UserCardsData(
              cardExp: "09/20",
              cardId: "XZASA",
              cardNumber: ["4321", "1234", "1213", "1232"],
              gradient: ["#1e2045", "#4c4079"]
                  .map((e) => HexColor.fromHex(e))
                  .toList()),
          UserCardsData(
              cardExp: "09/20",
              cardId: "XZASA",
              cardNumber: ["4321", "1234", "1213", "1232"],
              gradient: ["#3b5a00", "#2d3a00"]
                  .map((e) => HexColor.fromHex(e))
                  .toList()),
          UserCardsData(
              cardExp: "09/20",
              cardId: "XZASA",
              cardNumber: ["4321", "1234", "1213", "1232"],
              gradient: ["#12426a", "#31b4ec"]
                  .map((e) => HexColor.fromHex(e))
                  .toList()),
        ];
        _userCardsData.addAll(data);
        changeCarouselIndicator(0);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
