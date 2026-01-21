import 'package:api_amb_jwt/data/models/product.dart';
import 'package:api_amb_jwt/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductVM extends ChangeNotifier {
  final IProductRepository _productRepository;

  List<Product> products = [];

  bool isLoading = false;
  String? errorMessage;
  ProductVM({required IProductRepository productRepository})
      : _productRepository = productRepository;

  Future<void> afegirProducte(String title, double price) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newProduct = Product(
        userId: 0, // El backend hauria de gestionar això o ignorar-ho si utilitza auth.uid()
        title: title,
        price: price,
        description: 'Descripció per defecte', // O passar-ho per paràmetre
        createdAt: DateTime.now(),
        id: 0 // El backend generarà l'ID
      );
      final createdProduct = await _productRepository.afegirProducte(newProduct);
      products.add(createdProduct);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> llistaProdutes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await _productRepository.getProducts();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
