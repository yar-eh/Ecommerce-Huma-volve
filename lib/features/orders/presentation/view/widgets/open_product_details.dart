import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentaion/view/product_details_screen.dart';
import 'package:flutter/material.dart';

void openProductDetails(BuildContext context, CartItemEntity item) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProductDetailsScreen(
        productId: item.productId,
        initialColorValue: item.colorValue,
        initialSize: item.size,
      ),
    ),
  );
}
