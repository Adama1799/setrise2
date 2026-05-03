import 'package:flutter/material.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Special for you", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              SizedBox(width: 20),
              _OfferCard(image: "assets/images/Image Banner 2.png", category: "Smartphone", numOfBrands: 18),
              SizedBox(width: 12),
              _OfferCard(image: "assets/images/Image Banner 3.png", category: "Fashion", numOfBrands: 24),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String image, category;
  final int numOfBrands;
  const _OfferCard({required this.image, required this.category, required this.numOfBrands, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 242, height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(image, fit: BoxFit.cover),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.black38, Colors.black26, Colors.transparent],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                    children: [
                      TextSpan(text: "$category\n", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextSpan(text: "$numOfBrands Brands"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
