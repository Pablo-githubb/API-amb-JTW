class Product {
  final int userId;
  final int id;
  final String title;
  final double price;
  final String description;
  final DateTime createdAt;

  Product(
    {
    required this.userId,
    required this.title,
    required this.price,
    required this.description,
    required this.createdAt,     
    required this.id
  });

  /// Estructura del body del JSON de cada producte a Supabase
   
  factory Product.fromJson(Map<String, dynamic> json) {
    DateTime createdDate;
    if (json['created_at'] != null) {
      createdDate = DateTime.parse(json['created_at']);
    } else {
      createdDate = DateTime.now();
    }

    return Product(
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      createdAt: createdDate,
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'description': description,
        // Només incloure user_id i id si són vàlids/necessaris
        if (userId != 0) 'user_id': userId,
        if (id != 0) 'id': id,
      };
}
