// lib/presentation/screens/shop/cart/widgets/address_section.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      children: addresses.asMap().entries.map<Widget>((e) {
        final i = e.key;
        final addr = e.value;
        return RadioListTile<int>(
          value: i,
          groupValue: selectedIndex,
          onChanged: (v) => onChanged(v!),
          activeColor: AppColors.shop,
          title: Text(addr.name, style: const TextStyle(color: CupertinoColors.white)),
          subtitle: Text('${addr.street}, ${addr.city}', style: const TextStyle(color: CupertinoColors.systemGrey)),
        );
      }).toList(),
    );
  }
}
