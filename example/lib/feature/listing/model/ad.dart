import 'package:money2/money2.dart';

class Ad {
  const Ad({
    required this.id,
    required this.title,
    required this.price,
  });

  final String id;
  final String title;
  final Money price;

  @override
  String toString() {
    return 'Ad(id: $id, title: $title, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ad && other.id == id && other.title == title && other.price == price;
  }

  @override
  int get hashCode => Object.hash(id, title, price);
}
