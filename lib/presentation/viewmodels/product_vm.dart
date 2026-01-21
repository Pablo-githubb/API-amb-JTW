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

  Future<void> afegirProducte(
    String title,
    String description,
    double price,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newProduct = Product(
        userId:
            '', //Supabase assigna l'ID de l'usuari automàticament. No cal proporcionar-lo, l'inicio amb una cadena buida solament
        title: title,
        price: price,
        description: description,
        createdAt: DateTime.now(),
        id: 0, //Supabase assigna l'ID automàticament. No cal proporcionar-lo, l'inicio amb 0 solament
      );
      final createdProduct = await _productRepository.afegirProducte(
        newProduct,
      );
      products.add(createdProduct);
      
      // Update the products list if necessary or handled by llistaProdutes()
      await llistarProductes();
      
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarProducte(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _productRepository.deleteProduct(id);
      products.removeWhere((product) => product.id == id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> llistarProductes() async {
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
