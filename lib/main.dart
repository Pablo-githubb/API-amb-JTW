import 'package:api_amb_jwt/data/repositories/product_repository.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
import 'package:api_amb_jwt/data/screen/home_page.dart';
import 'package:api_amb_jwt/data/services/product_service.dart';
import 'package:api_amb_jwt/data/services/user_service.dart';
import 'package:api_amb_jwt/presentation/viewmodels/product_vm.dart';
import 'package:api_amb_jwt/presentation/viewmodels/user_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<IUserService>(create: (context) => UserService()),
        Provider<IUserRepository>(
          create: (context) => UserRepository(userService: context.read()),
        ),

        Provider<IProductService>(create: (context) => ProductService()),
        Provider<IProductRepository>(
          create: (context) => ProductRepository(
            productService: context.read(),
            userRepository: context.read(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserVM(userRepository: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductVM(productRepository: context.read()),
        ),
      ],
      child: MaterialApp(
        title: 'API-amb-JWT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        ),
        home: MyHomePage(title: ''),
      ),
    );
  }
}
