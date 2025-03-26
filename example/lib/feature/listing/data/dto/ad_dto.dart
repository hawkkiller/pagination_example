class AdDto {
  const AdDto({
    required this.id,
    required this.title,
    required this.price,
  });

  final String id;
  final String title;
  final AdPriceDto price;

  factory AdDto.fromJson(Map<String, Object?> json) {
    if (json
        case {
          'id': final String id,
          'title': final String title,
          'price': final Map<String, Object?> price,
        }) {
      return AdDto(
        id: id,
        title: title,
        price: AdPriceDto.fromJson(price),
      );
    }

    throw FormatException(
      'Invalid JSON format for AdDto: $json',
    );
  }
}

class AdPriceDto {
  const AdPriceDto({
    required this.amount,
    required this.currency,
  });

  final int amount;
  final String currency;

  factory AdPriceDto.fromJson(Map<String, Object?> json) {
    if (json
        case {
          'amount': final int amount,
          'currency': final String currency,
        }) {
      return AdPriceDto(
        amount: amount,
        currency: currency,
      );
    }

    throw FormatException(
      'Invalid JSON format for AdPriceDto: $json',
    );
  }
}
