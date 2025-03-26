import 'package:collection/collection.dart';

abstract class PaginationState<T> {
  const PaginationState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    this.error,
  });

  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final Object? error;
}

abstract class PaginationStateOffset<T> extends PaginationState<T> {
  const PaginationStateOffset({
    super.items = const [],
    super.isLoading = false,
    super.hasMore = true,
    this.offset = 0,
    super.error,
  });

  final int offset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationStateOffset<T> &&
        const DeepCollectionEquality().equals(other.items, items) &&
        other.isLoading == isLoading &&
        other.hasMore == hasMore &&
        other.offset == offset;
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(items) ^
      error.hashCode ^
      isLoading.hashCode ^
      hasMore.hashCode ^
      offset.hashCode;
}
