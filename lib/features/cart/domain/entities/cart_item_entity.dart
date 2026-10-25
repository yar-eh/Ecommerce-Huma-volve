class CartItemEntity {
  final int productId;
  final String title;
  final String imageUrl;
  final double price;
  final String size;
  final int colorValue;
  final int quantity;

  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.colorValue,
    this.quantity = 1,
  });

  /// Same product + size + color = same cart line.
  String get key => '$productId-$size-$colorValue';

  double get lineTotal => price * quantity;

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
    productId: productId,
    title: title,
    imageUrl: imageUrl,
    price: price,
    size: size,
    colorValue: colorValue,
    quantity: quantity ?? this.quantity,
  );
}
