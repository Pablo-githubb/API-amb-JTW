import 'package:api_amb_jwt/presentation/viewmodels/product_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Finestra on es mostra el llistat complet de productes amb l'opció d'eliminar-los.
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
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
                    onPressed: () {
                      productVM.eliminarProducte(product.id);
                      if (context.mounted) {
                        if (productVM.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Producte eliminat')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductVM>().llistarProductes();
    });
  }
}
