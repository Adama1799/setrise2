import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';

class WriteReviewScreen extends StatefulWidget {
  final String productId, productName, productImage;
  const WriteReviewScreen({super.key, required this.productId, required this.productName, required this.productImage});
  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _titleCtrl = TextEditingController(), _reviewCtrl = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _titleCtrl.dispose(); _reviewCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty || _reviewCtrl.text.trim().isEmpty) {
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(content: const Text('Please fill all fields'), actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(ctx))]));
      return;
    }
    Navigator.pop(context);
    showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(content: const Text('Thank you for your review! 🎉'), actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(ctx))]));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.white,
        leading: CupertinoNavigationBarBackButton(color: AppColors.black, onPressed: () => Navigator.pop(context)),
        middle: const Text('Write a Review', style: TextStyle(color: AppColors.black)),
        trailing: CupertinoButton(padding: EdgeInsets.zero, child: const Text('Submit', style: TextStyle(color: AppColors.shop, fontWeight: FontWeight.bold)), onPressed: _submit),
      ),
      child: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(widget.productImage, width: 80, height: 80, fit: BoxFit.cover)),
          const SizedBox(width: 16),
          Expanded(child: Text(widget.productName, style: const TextStyle(color: AppColors.black, fontSize: 17, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 24),
        const Text('Rating', style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          child: Icon(i < _rating ? CupertinoIcons.star_fill : CupertinoIcons.star, color: AppColors.shop, size: 36),
        ))),
        const SizedBox(height: 24),
        const Text('Title', style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CupertinoTextField(controller: _titleCtrl, placeholder: 'Summarize your experience', style: const TextStyle(color: AppColors.black), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border))),
        const SizedBox(height: 20),
        const Text('Your Review', style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CupertinoTextField(controller: _reviewCtrl, maxLines: 5, placeholder: 'Share your experience...', style: const TextStyle(color: AppColors.black), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border))),
      ]))),
    );
  }
}
