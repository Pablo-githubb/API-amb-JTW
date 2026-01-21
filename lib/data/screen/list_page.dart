import 'package:api_amb_jwt/presentation/viewmodels/product_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductVM>().llistarProductes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productVM = context.watch<ProductVM>();

    return Scaffold(
      appBar: AppBar(title: const Text('Llista de Productes')),
      body: productVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productVM.errorMessage != null
          ? Center(child: Text('Error: ${productVM.errorMessage}'))
          : ListView.builder(
              itemCount: productVM.products.length,
              itemBuilder: (context, index) {
                final product = productVM.products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text('${product.description} - ${product.price}€'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      // Confirm deletion dialog could be added here
                      await productVM.eliminarProducte(product.id);
                      if (productVM.errorMessage != null && context.mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('Error: ${productVM.errorMessage}')),
                         );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
