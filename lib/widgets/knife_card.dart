import 'package:flutter/material.dart';
import 'package:knife_hit_game/models/knife_item.dart';

class KnifeCard extends StatelessWidget {
  const KnifeCard({
    super.key,
    required this.knife,
    required this.isSelected,
    required this.onTap,
  });

  final KnifeItem knife;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[600],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                ],
                border: isSelected ? Border.all(color: Colors.amber) : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        color:
                            Colors
                                .blueGrey[600], // Ensure background color is solid
                        padding: const EdgeInsets.all(6),
                        child:
                            knife.isLocked
                                ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.grey.withOpacity(0.7),
                                    BlendMode.saturation,
                                  ),
                                  child: Image.asset(
                                    knife.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                : Image.asset(
                                  knife.imagePath,
                                  fit: BoxFit.contain,
                                ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.blueGrey[800],
                      ),
                      child: Text(
                        knife.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (knife.isLocked)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.lock, color: Colors.white, size: 16),
                ),
              ),
            if (isSelected)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
