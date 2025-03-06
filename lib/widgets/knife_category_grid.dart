import 'package:flutter/material.dart';
import 'package:knife_hit_game/models/knife_item.dart';
import 'package:knife_hit_game/widgets/knife_card.dart';

class KnifeCategoryGrid extends StatelessWidget {
  const KnifeCategoryGrid({
    super.key,
    required this.category,
    required this.knives,
    required this.selectedKnife,
    required this.onKnifeSelected,
    required this.crossAxisCount,
  });

  final String category;
  final List<KnifeItem> knives;
  final KnifeItem? selectedKnife;
  final Function(KnifeItem) onKnifeSelected;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
        // Category grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: knives.length,
            itemBuilder: (context, index) {
              final knife = knives[index];
              return KnifeCard(
                knife: knife,
                isSelected: selectedKnife?.name == knife.name,
                onTap: () => onKnifeSelected(knife),
              );
            },
          ),
        ),
        // Spacing after each category
        const SizedBox(height: 16),
      ],
    );
  }
}
