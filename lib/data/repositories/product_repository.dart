import 'package:api_amb_jwt/data/models/product.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
import 'package:api_amb_jwt/data/services/product_service.dart';

abstract class IProductRepository {
  Future<Product> afegirProducte(Product product);
  Future<List<Product>> getProducts();
  Future<void> eliminarProducte(int id);
}

class ProductRepository implements IProductRepository {
  final IProductService _productService;
  final IUserRepository _userRepository;

  ProductRepository({
    required IProductService productService,
    required IUserRepository userRepository,
  })  : _productService = productService,
        _userRepository = userRepository;

  String get _token => _userRepository.email.accessToken;

  @override
  /// Crida al servei per afegir un nou producte, passant el token d'autenticació actual.
  Future<Product> afegirProducte(Product product) async {
    return await _productService.crearProducte(_token, product);
  }

  @override
  /// Recupera la llista de productes mitjançant el servei.
  Future<List<Product>> getProducts() async {
    return await _productService.getProducts(_token);
  }

  @override
  /// Elimina un producte específic (per ID) utilitzant el servei.
  Future<void> eliminarProducte(int id) async {
    return await _productService.eliminarProducte(_token, id);
  }
}
