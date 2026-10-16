import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  final String productId;

  const ShareProductButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final productLink =
            'https://humavolve-a8800.web.app/products/$productId';

        final shareMessage =
            'Check out this product at HumaVolve!\n'
            '$productLink';

        await SharePlus.instance.share(
          ShareParams(
            text: shareMessage,
            subject: 'Check out this product at HumaVolve!',
          ),
        );
      },
      icon: const Icon(Icons.share),
    );
  }
}
