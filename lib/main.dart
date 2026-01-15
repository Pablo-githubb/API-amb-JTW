import 'package:api_amb_jwt/data/repositories/product_repository.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
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
          create: (context) =>
              UserRepository(userService: context.read()),
        ),

    // TODO: IMPLEMENTARRRRR
    //Nous providers de autentication i authoritation
    //    Provider<IProductService>(create: (context) => ProductService()),
    //    Provider<IProductRepository>(
    //      create: (context) => ProductRepository(userService(): context.read()),
    //    ),
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
    // TODO: IMPLEMENTARRRRR
    //    ChangeNotifierProvider(
    //      create: (context) => ProductVM(productRepository: context.read()),
    //    ),
      ],
      child: MaterialApp(
        title: 'API-amb-JWT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        ),
        home: MyHomePage(title: '',),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = LoginPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');

    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          return Scaffold(
            body: Row(children: [MainArea(page: page)]),
            bottomNavigationBar: NavigationBar(
              destinations: [
                NavigationDestination(icon: Icon(Icons.exit_to_app), label: 'Login'),
              
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
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
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.exit_to_app),
                        label: Text('Login'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
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

//Classe encarregada del canvia de la barra de navegació del les pàgines. 
class MainArea extends StatelessWidget {
  const MainArea({super.key, required this.page});

  final Widget page;

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



//Finestr de Login al iniciar l'aplicaició

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    UserVM vm = context.watch<UserVM>();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: vm.emailController,
                    decoration: InputDecoration(labelText: 'Enter Username'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: vm.passwordController,
                    decoration: InputDecoration(labelText: 'Enter Password'),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        vm.emailController.text.isNotEmpty &&
                            vm.passwordController.text.isNotEmpty
                        ? () async {
                            await vm.login();
                          }
                        : null,
                    child: Text('Login'),
                  ),

                  if (vm.authenticated)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('You are logged in as: ${vm.email}'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
