class ProductDetailsEntity {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final String categoryName;
  final List<String> images;

  const ProductDetailsEntity({
    this.id = 0,
    this.title = '',
    this.slug = '',
    this.price = 0,
    this.description = '',
    this.categoryName = '',
    this.images = const [],
  });
}
