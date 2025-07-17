class ProductColor {
  final String productId;
  final String color;
  final String sortOrder;
  final String name;
  final String href;

  ProductColor({
    required this.productId,
    required this.color,
    required this.sortOrder,
    required this.name,
    required this.href,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      productId: json['product_id'] ?? '',
      color: json['color'] ?? '',
      sortOrder: json['sort_order'] ?? '',
      name: json['name'] ?? '',
      href: json['href'] ?? '',
    );
  }
}