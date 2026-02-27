class PaginationParams {
  final int? page;
  final int? limit;

  const PaginationParams({
    this.page ,
    this.limit,
  });

  Map<String, dynamic> toQueryParams() => {
    if (page != null) 'page': page,
    if (limit != null) 'limit': limit,
  };
}