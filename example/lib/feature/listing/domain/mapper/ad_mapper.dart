import 'dart:convert';

import 'package:example/feature/listing/data/dto/ad_dto.dart';
import 'package:example/feature/listing/domain/entity/ad.dart';

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

class AdPriceMapper extends Converter<AdPriceDto, Price> {
  const AdPriceMapper();

  @override
  Price convert(AdPriceDto input) {
    return Price(amount: input.amount, currency: input.currency);
  }
}
