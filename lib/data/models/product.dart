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
    return Product(
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      id: json['id'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'price': price,
      'description': description,
    };
    
    // Només incloure user_id i id si són vàlids/necessaris
    // Suposant que Supabase genera ID i createdAt, i user_id via auth
    if (userId != 0) data['user_id'] = userId;
    // data['created_at'] = createdAt.toIso8601String(); // Normalment deixem que ho posi la BD
    if (id != 0) data['id'] = id;
    
    return data;
  }
}
