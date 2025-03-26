import 'package:flutter/widgets.dart';
import 'package:pagination/src/core/pagination_state.dart';

class PaginatedBuilder<T extends PaginationState> extends StatelessWidget {
  const PaginatedBuilder({
    required this.state,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.builder,
    super.key,
  });

  final T state;

  /// Called when the [state] is loading and [state.items] is empty.
  final WidgetBuilder loadingBuilder;

  /// Called when the [state] is in error state and [state.items] is empty.
  final WidgetBuilder errorBuilder;

  /// Content of a paginated view.
  ///
  /// This builder is returned when [state.items] is not empty.
  /// This is called even when it is loading or error.
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.items.isEmpty) {
      return loadingBuilder(context);
    }

    if (state.error != null && state.items.isEmpty) {
      return errorBuilder(context);
    }

    return builder(context);
  }
}
