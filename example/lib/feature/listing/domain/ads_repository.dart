import 'package:example/feature/listing/domain/mapper/ad_mapper.dart';
import 'package:example/feature/listing/data/ads_datasource.dart';
import 'package:example/feature/listing/domain/entity/ad.dart';

abstract interface class AdsRepository {
  Future<List<Ad>> queryAds({
    required int offset,
    required int limit,
    List<String> filters = const [],
    String? sort,
  });
}

class AdsRepositoryImpl implements AdsRepository {
  const AdsRepositoryImpl({
    required this.dataSource,
    this.adMapper = const AdMapper(),
  });

  final AdsDataSource dataSource;
  final AdMapper adMapper;

  @override
  Future<List<Ad>> queryAds({
    required int offset,
    required int limit,
    List<String> filters = const [],
    String? sort,
  }) async {
    final response = await dataSource.queryAds(
      offset: offset,
      limit: limit,
      filters: filters,
      sort: sort,
    );

    return response.map(adMapper.convert).toList(growable: false);
  }
}
