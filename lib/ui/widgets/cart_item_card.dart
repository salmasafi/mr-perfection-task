import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/donation_request.dart';

class CartItemCard extends StatelessWidget {
  final DonationRequest donationRequest;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.donationRequest,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.height(context, 12)),
      padding: EdgeInsets.all(Responsive.width(context, 14)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(Responsive.width(context, 16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.width(context, 12)),
            child: Image.network(
              donationRequest.product.image,
              width: Responsive.width(context, 70),
              height: Responsive.width(context, 70),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: Responsive.width(context, 70),
                height: Responsive.width(context, 70),
                color: AppColors.greyLight,
                child: const Icon(Icons.image_not_supported,
                    color: AppColors.grey),
              ),
            ),
          ),
          SizedBox(width: Responsive.width(context, 14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donationRequest.product.title,
                  style: TextStyle(
                    fontSize: Responsive.height(context, 14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Responsive.height(context, 4)),
                Text(
                  'من: ${donationRequest.product.donorName}',
                  style: TextStyle(
                    fontSize: Responsive.height(context, 12),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: Responsive.height(context, 4)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.width(context, 8),
                    vertical: Responsive.height(context, 2),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(Responsive.width(context, 6)),
                  ),
                  child: Text(
                    'مجاني',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: Responsive.height(context, 10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.close,
              color: AppColors.grey,
              size: Responsive.width(context, 20),
            ),
          ),
        ],
      ),
    );
  }
}
