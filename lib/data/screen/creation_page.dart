import 'package:api_amb_jwt/presentation/viewmodels/product_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCreationPage extends StatefulWidget {
  const ProductCreationPage({super.key});

  @override
  State<ProductCreationPage> createState() => _ProductCreationPageState();
}

class _ProductCreationPageState extends State<ProductCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productVM = context.watch<ProductVM>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nou Producte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Títol'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Si us plau, introdueix un títol per al producte';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripció'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Si us plau, introdueix una descripció per al producte';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Preu'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Si us plau, introdueix un preu';
                    } else if (double.tryParse(value) == null) {
                      return 'Si us plau, introdueix un número vàlid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                if (productVM.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        productVM.afegirProducte(
                          _titleController.text,
                          _descriptionController.text,
                          double.parse(_priceController.text),
                        );

                        if (productVM.errorMessage != null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(productVM.errorMessage!)),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Producte creat!!!'),
                              ),
                            );
                            _titleController.clear();
                            _descriptionController.clear();
                            _priceController.clear();
                          }
                        }
                      }
                    },
                    child: const Text('Crear Producte'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
