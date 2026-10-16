import 'package:ecommerce_app_huma_volve/core/utils/image_url_extractor.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.categoryName,
    super.images,
  });

  ProductDetailsModel.fromJson(Map<String, dynamic> json)
    : super(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        slug: json['slug'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        description: json['description'] ?? '',
        categoryName: json['category']?['name'] ?? '',
        images: ImageUrlExtractor.extractValidUrls(
          (json['images'] as List? ?? const [])
              .map((e) => e.toString())
              .toList(),
        ),
      );
}
