// product.dart

class Product {
  final int? id;
  final String name;
  final String unit;
  final String price;
  final String productId;

  bool isSelected;

  Product({
    this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.productId,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'price': price,
      'productId': productId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      price: map['price'],
      productId: map['productId'],
      isSelected: false,
    );
  }
}
