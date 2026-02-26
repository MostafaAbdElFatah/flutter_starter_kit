import 'package:equatable/equatable.dart';

import '../entities/pagination_result.dart';

abstract class ListPaginatedState<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;

  const ListPaginatedState({
    required this.items,
    required this.currentPage,
    required this.hasMore,
    this.isLoading = false,
  });

  ListPaginatedState.paginated(
    PaginatedResult<T> result, {
    this.isLoading = false,
  })  : items = result.items,
        currentPage = result.currentPage,
        hasMore = result.currentPage != result.totalPages;


  int get nextPage => currentPage + 1;

  @override
  List<Object?> get props => [items, currentPage, hasMore, isLoading];
}
