import 'package:flutter/material.dart';

class Helper {
  static String getCategoryEmojie(String category) {
    if (category.toLowerCase() == "food") {
      return "🍔";
    }
    if (category.toLowerCase() == "travel") {
      return "🚗";
    }
    if (category.toLowerCase() == "shopping") {
      return "🛍";
    }
    if (category.toLowerCase() == "entertainment") {
      return "🎥";
    }
    if (category.toLowerCase() == "bills") {
      return "💰";
    }
    if (category.toLowerCase() == "health") {
      return "💊";
    }
    if (category.toLowerCase() == "education") {
      return "🎓";
    }
    if (category.toLowerCase() == "others") {
      return "🤷‍♂️";
    }

    return "💰";
  }

  static Color getCategoryColor(String category) {
    if (category.toLowerCase() == "food") {
      return Colors.amber;
    }
    if (category.toLowerCase() == "travel") {
      return Colors.green;
    }
    if (category.toLowerCase() == "shopping") {
      return Colors.pink;
    }
    if (category.toLowerCase() == "entertainment") {
      return Colors.blue;
    }
    if (category.toLowerCase() == "bills") {
      return Colors.orange;
    }
    if (category.toLowerCase() == "health") {
      return Colors.green;
    }
    if (category.toLowerCase() == "education") {
      return Colors.cyanAccent;
    }

    return Colors.grey;
  }
}
