/// Represents a paginated Branches search result.
class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
  });

  /// The list of has items returned for this page.
  final List<T> items;

  /// The current page number.
  final int currentPage;

  /// The total number of pages available.
  final int totalPages;
}
