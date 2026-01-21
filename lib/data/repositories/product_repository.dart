import 'package:api_amb_jwt/data/models/product.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
import 'package:api_amb_jwt/data/services/product_service.dart';

abstract class IProductRepository {
  Future<Product> afegirProducte(Product product);
  Future<List<Product>> getProducts();
  Future<void> deleteProduct(int id);
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
  Future<Product> afegirProducte(Product product) async {
    return await _productService.crearProducte(_token, product);
  }

  @override
  Future<List<Product>> getProducts() async {
    return await _productService.getProducts(_token);
  }

  @override
  Future<void> deleteProduct(int id) async {
    return await _productService.deleteProduct(_token, id);
  }
}
