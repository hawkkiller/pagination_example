import 'package:example/feature/listing/bloc/ads_bloc.dart';
import 'package:example/feature/listing/data/ads_datasource.dart';
import 'package:example/feature/listing/domain/ads_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final scrollController = ScrollController();
  final bloc = AdsBloc(const AdsRepositoryImpl(dataSource: AdsDatasourceFake()));

  @override
  void initState() {
    super.initState();
    bloc.add(const AdsEventPaginate(isReverseDirection: false));
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    bloc.close();
    scrollController.dispose();
    super.dispose();
  }

  var _scrollLock = false;

  void _onScroll() {
    if (_scrollLock) return;

    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * .8) {
      final isReverseDirection =
          scrollController.position.userScrollDirection == ScrollDirection.reverse;
      _scrollLock = true;
      bloc.add(AdsEventPaginate(isReverseDirection: isReverseDirection));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: BlocConsumer<AdsBloc, AdsState>(
        bloc: bloc,
        listener: (context, state) {
          if (!state.isLoading) {
            _scrollLock = false;
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              if (state.isLoading && state.items.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state.error != null && state.items.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Error: ${state.error}',
                      style: TextStyle(color: colors.error),
                    ),
                  ),
                )
              else ...[
                SliverList.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final ad = state.items[index];
                    return ListTile(
                      title: Text(ad.title),
                      subtitle: Text(ad.price.format()),
                      onTap: () {
                        // Handle ad tap
                      },
                    );
                  },
                ),
                if (state.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ]
            ],
          );
        },
      ),
    );
  }
}
