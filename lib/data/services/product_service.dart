import 'dart:convert';

import 'package:api_amb_jwt/data/models/product.dart';
import 'package:http/http.dart' as http;

abstract class IProductService {
  Future<Product> crearProducte(String token, Product product);
  Future<List<Product>> getProducts(String token);
}

class ProductService implements IProductService {
  static const String _appUrl =
      'https://itvyvvxonnsdoqokvikw.supabase.co/rest/v1/products';
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0dnl2dnhvbm5zZG9xb2t2aWt3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0ODE1NTQsImV4cCI6MjA4MTA1NzU1NH0.6AxDj1flnnqtBvOjoKe9_MehqBwo0kNgxLGOf4VKQ5A';

  @override
  Future<Product> crearProducte(String token, Product product) async {
    final response = await http.post(
      Uri.parse(_appUrl),
      //Aquest són els headers demanats a l'enunciat per a les capçaleres addicionals del Supabase
      headers: {
        'apikey': _apiKey,
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',

        // Per aconseguir que la petició de creació només torni un producte i no una llista de productes heu d’incloure la capçalera:
        'Accept': 'application/vnd.pgrst.object+json',
        //Per aconseguir que la petició de creació de producte us retorni les dades del producte creat heu d’incloure la capçalera:
        'Prefer': 'return=representation',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  @override
  Future<List<Product>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse('$_appUrl?select=*'),
      headers: {'apikey': _apiKey, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.body}');
    }
  }
}
