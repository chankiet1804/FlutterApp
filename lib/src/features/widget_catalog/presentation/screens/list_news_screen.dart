import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widget_catalog/data/models/news_model.dart';
import 'package:flutter_app/src/features/widget_catalog/data/repositories/news_repository.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/first_page_error_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/first_page_progress_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/new_page_error_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/new_page_progress_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/news_item.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/no_items_found_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/news/no_more_items_indicator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListNewsScreen extends StatefulWidget {
  const ListNewsScreen({super.key});
  @override
  State<ListNewsScreen> createState() => _ListNewsScreenState();
}

class _ListNewsScreenState extends State<ListNewsScreen> {
  static const _firstPageKey = '__first__';

  final _repository = NewsRepository();
  String? _nextCursor;

  late final _pagingController = PagingController<String, News>(
    getNextPageKey: (state) {
      if (state.pages?.isEmpty ?? true) {
        return _firstPageKey;
      }

      return _nextCursor;
    },
    fetchPage: _fetchPage,
  );

  Future<List<News>> _fetchPage(String pageKey) async {
    final cursor = pageKey == _firstPageKey ? null : pageKey;
    final page = await _repository.fetchNewsPage(cursor: cursor);
    _nextCursor = page.nextCursor;
    return page.items;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Social News'), scrolledUnderElevation: 0),
    body: PagingListener(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) => RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<String, News>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<News>(
            itemBuilder: (context, item, index) => NewsItem(item: item),
            firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
              error: state.error,
              onTryAgain: () => fetchNextPage(),
            ),
            newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
              error: state.error,
              onTryAgain: () => fetchNextPage(),
            ),
            firstPageProgressIndicatorBuilder: (_) =>
                FirstPageProgressIndicator(),
            newPageProgressIndicatorBuilder: (_) => NewPageProgressIndicator(),
            noItemsFoundIndicatorBuilder: (_) => NoItemsFoundIndicator(),
            noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
            animateTransitions: true,
            // [transitionDuration] has a default value of 250 milliseconds.
            transitionDuration: const Duration(milliseconds: 500),
          ),
        ),
      ),
    ),
  );
}
