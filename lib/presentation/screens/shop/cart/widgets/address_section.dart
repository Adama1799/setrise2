// lib/presentation/screens/shop/cart/widgets/address_section.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import '../../checkout_models.dart';

class AddressSection extends StatelessWidget {
  final List<Address> addresses;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AddressSection({
    super.key,
    required this.addresses,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(addresses.length, (i) {
        final addr = addresses[i];
        final isSelected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.shop.withOpacity(0.2) : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.shop : AppColors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? CupertinoIcons.check_mark_circled : CupertinoIcons.circle,
                  color: isSelected ? AppColors.shop : AppColors.grey2,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addr.name, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                      Text('${addr.street}, ${addr.city}', style: const TextStyle(color: AppColors.grey2, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
