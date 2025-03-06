class KnifeItem {
  KnifeItem({
    required this.imagePath,
    required this.name,
    required this.category,
    required this.price,
    this.isLocked = false,
  });

  final String imagePath;
  final String name;
  final String category;
  final int price;
  final bool isLocked;
}
