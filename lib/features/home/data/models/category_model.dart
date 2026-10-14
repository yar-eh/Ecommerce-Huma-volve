import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  const HomeCategoryModel({super.id, super.name});

  HomeCategoryModel.fromJson(Map<String, dynamic> json)
    : super(id: json['id'] ?? 0, name: json['name'] ?? '');
}
