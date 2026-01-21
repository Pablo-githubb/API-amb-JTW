class Product {
  final int userId;
  final int id;
  final String title;
  final double price;
  final String description;
  final DateTime createdAt;

  Product(
    this.userId,
    this.description,
    this.createdAt, {
    required this.id,
    required this.title,
    required this.price,
  });

  /**
   * Estructura del body del JSON de cada producte a Supabase
   */
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['userid'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      json['description'],
      DateTime.parse(json['data']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'price': price,
      'description': description,
      'created_at': createdAt,
      'id': id,
    };
  }
}
