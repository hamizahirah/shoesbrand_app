import 'package:flutter/material.dart';
import 'package:shoesbrand/models/brand.dart';

//Purpose: This widget builds a list of cards displaying brand details
class BrandBuilder extends StatelessWidget {
  const BrandBuilder({
    super.key,
    required this.future,
  });
  final Future<List<Brand>> future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Brand>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final brand = snapshot.data![index];
              return _buildBrandCard(brand, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildBrandCard(Brand brand, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                brand.id.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(brand.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
