import 'package:flutter/foundation.dart';

class ListItem {
  final String id;
  final String naslov;
  final String datum;
  final String vreme;

  ListItem({
    required this.id,
    required this.naslov,
    required this.datum,
    required this.vreme
  });
}
