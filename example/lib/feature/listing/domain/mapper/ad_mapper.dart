import 'dart:convert';

import 'package:example/feature/listing/domain/entity/ad.dart';
import 'package:example/feature/listing/data/dto/ad_dto.dart';
import 'package:money2/money2.dart';

class AdMapper extends Converter<AdDto, Ad> {
  const AdMapper({
    this.adPriceMapper = const AdPriceMapper(),
  });

  final AdPriceMapper adPriceMapper;

  @override
  Ad convert(AdDto input) {
    return Ad(
      id: input.id,
      title: input.title,
      price: adPriceMapper.convert(input.price),
    );
  }
}

class AdPriceMapper extends Converter<AdPriceDto, Money> {
  const AdPriceMapper();

  @override
  Money convert(AdPriceDto input) {
    final currency = Currency.create(input.currency, 2);

    return Money.fromIntWithCurrency(input.amount, currency);
  }
}
