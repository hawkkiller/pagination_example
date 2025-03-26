import 'package:collection/collection.dart';
import 'package:example/feature/listing/domain/ads_repository.dart';
import 'package:example/feature/listing/domain/entity/ad.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AdsEvent {
  const AdsEvent();
}

final class AdsEventPaginate extends AdsEvent {
  const AdsEventPaginate({required this.isReverseDirection});

  final bool isReverseDirection;
}

final class AdsEventRefresh extends AdsEvent {
  const AdsEventRefresh();
}

sealed class AdsState {
  const AdsState({
    this.items = const [],
    this.hasMore = true,
    this.offset = 0,
  });

  final List<Ad> items;
  final bool hasMore;
  final int offset;
  Object? get error => null;
  bool get isLoading => false;
}

final class AdsStateIdle extends AdsState {
  const AdsStateIdle({super.items, super.hasMore, super.offset});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdsStateIdle &&
        const DeepCollectionEquality().equals(other.items, items) &&
        other.hasMore == hasMore;
  }

  @override
  int get hashCode => const DeepCollectionEquality().hash(items) ^ hasMore.hashCode;
}

final class AdsStateLoading extends AdsState {
  const AdsStateLoading({super.items, super.hasMore, super.offset});

  @override
  final bool isLoading = true;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdsStateLoading &&
        const DeepCollectionEquality().equals(other.items, items) &&
        other.hasMore == hasMore;
  }

  @override
  int get hashCode => const DeepCollectionEquality().hash(items) ^ hasMore.hashCode;
}

final class AdsStateError extends AdsState {
  const AdsStateError({
    super.items,
    super.hasMore,
    super.offset,
    required this.error,
  });

  @override
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdsStateError &&
        const DeepCollectionEquality().equals(other.items, items) &&
        other.hasMore == hasMore &&
        other.error == error;
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^ hasMore.hashCode ^ error.hashCode;
}

final class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc(this.adsRepository) : super(const AdsStateIdle()) {
    on<AdsEvent>(
      (event, emit) => switch (event) {
        AdsEventPaginate() => _onPaginate(emit),
        AdsEventRefresh() => _onRefresh(emit),
      },
    );
  }

  final AdsRepository adsRepository;

  Future<void> _onPaginate(Emitter<AdsState> emit) async {
    if (state.isLoading || !state.hasMore) return;

    emit(AdsStateLoading(
      items: state.items,
      hasMore: state.hasMore,
      offset: state.offset,
    ));

    try {
      final ads = await adsRepository.queryAds(
        offset: state.offset,
        limit: 20,
      );

      emit(
        AdsStateIdle(
          items: [...state.items, ...ads],
          hasMore: ads.length == 20,
          offset: state.offset + ads.length,
        ),
      );
    } catch (e) {
      emit(AdsStateError(
        items: state.items,
        hasMore: state.hasMore,
        error: e,
        offset: state.offset,
      ));
    }
  }

  Future<void> _onRefresh(Emitter<AdsState> emit) async {
    if (state.isLoading) return;

    emit(AdsStateLoading(
      items: state.items,
      hasMore: state.hasMore,
      offset: state.offset,
    ));

    try {
      final ads = await adsRepository.queryAds(
        offset: 0,
        limit: 20,
      );

      emit(
        AdsStateIdle(
          items: ads,
          hasMore: ads.isNotEmpty,
          offset: ads.length,
        ),
      );
    } catch (e) {
      emit(AdsStateError(
        items: state.items,
        hasMore: state.hasMore,
        error: e,
        offset: state.offset,
      ));
    }
  }
}
