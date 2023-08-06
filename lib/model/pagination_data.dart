class PaginationData<T> {
  List<T> data;
  int totalPages;

  PaginationData({
    required this.data,
    required this.totalPages,
  });
}
