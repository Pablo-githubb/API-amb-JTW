import 'package:api_amb_jwt/data/screen/creation_page.dart';
import 'package:api_amb_jwt/data/screen/list_page.dart';
import 'package:api_amb_jwt/data/screen/login_page.dart';
import 'package:api_amb_jwt/presentation/viewmodels/product_vm.dart';
import 'package:api_amb_jwt/presentation/viewmodels/user_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Classe encarregada del canvia de la barra de navegació del les pàgines.
/// Classe principal per a la gestió de la interfície i canvis de pantalla.
class MainArea extends StatelessWidget {
  final Widget page;

  const MainArea({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(title: ''),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserVM>();

    if (!userVM.authenticated) {
      return const Scaffold(body: LoginPage());
    }

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const ProductCreationPage();
        break;
      case 1:
        page = const ProductListPage();
        break;
      case 2:
        page = const Center(child: CircularProgressIndicator());
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    final destinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.add_circle_outline),
        label: Text('Crear'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.list),
        label: Text('Llistar'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.logout),
        label: Text('Logout'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Scaffold(
            body: page,
            bottomNavigationBar: NavigationBar(
              destinations: const [
                NavigationDestination(icon: Icon(Icons.add), label: 'Crear'),
                NavigationDestination(icon: Icon(Icons.list), label: 'Llista'),
                NavigationDestination(
                  icon: Icon(Icons.logout),
                  label: 'Sortir',
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                //Si fem clic a la casella de Logout, s'ens treu la sessió automàticament
                if (value == 2) {
                  userVM.logout();
                  // Reset index or handle navigation
                  setState(() {
                    selectedIndex = 0;
                  });
                } else {
                  setState(() {
                    selectedIndex = value;
                  });
                }
              },
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 800,
                    destinations: destinations,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      if (value == 2) {
                        userVM.logout();
                        setState(() {
                          selectedIndex = 0;
                        });
                      } else {
                        setState(() {
                          selectedIndex = value;
                        });
                      }
                    },
                  ),
                ),
                MainArea(page: page),
              ],
            ),
          );
        }
      },
    );
  }
}
