import 'package:example/feature/listing/model/ad_dto.dart';
import 'package:http/http.dart';

abstract interface class AdsDataSource {
  Future<List<AdDto>> queryAds({
    required int offset,
    required int limit,
    List<String> filters = const [],
    String? sort,
  });
}

class AdsDataSourceRest implements AdsDataSource {
  const AdsDataSourceRest(this.http);

  final Client http;

  @override
  Future<List<AdDto>> queryAds({
    required int offset,
    required int limit,
    List<String> filters = const [],
    String? sort,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://api.example.com/ads?offset=$offset&limit=$limit&filters=${filters.join(',')}&sort=$sort',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load ads');
    }

    final jsonResponse = response.body as List<Object?>;
    return jsonResponse
        .whereType<Map<String, Object?>>()
        .map(AdDto.fromJson)
        .toList(growable: false);
  }
}

class AdsDatasourceFake implements AdsDataSource {
  const AdsDatasourceFake();

  @override
  Future<List<AdDto>> queryAds({
    required int offset,
    required int limit,
    List<String> filters = const [],
    String? sort,
  }) async {
    await Future.delayed(const Duration(milliseconds: 5000));

    return List.generate(
      limit,
      (index) => AdDto(
        id: "${offset + index}",
        price: AdPriceDto(amount: (offset + index) * 100, currency: 'USD'),
        title: 'Ad ${offset + index}',
      ),
    );
  }
}
