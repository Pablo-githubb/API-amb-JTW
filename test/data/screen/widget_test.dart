import 'package:api_amb_jwt/data/models/product.dart';
import 'package:api_amb_jwt/data/models/user.dart';
import 'package:api_amb_jwt/data/repositories/product_repository.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
import 'package:api_amb_jwt/data/screen/creation_page.dart';
import 'package:api_amb_jwt/data/screen/list_page.dart';
import 'package:api_amb_jwt/data/screen/login_page.dart';
import 'package:api_amb_jwt/data/screen/home_page.dart';
import 'package:api_amb_jwt/data/services/product_service.dart';
import 'package:api_amb_jwt/data/services/user_service.dart';
import 'package:api_amb_jwt/presentation/viewmodels/product_vm.dart';
import 'package:api_amb_jwt/presentation/viewmodels/user_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// -- Mocks --

class MockUserService implements IUserService {
  User? userToReturn;
  Exception? exceptionToThrow;

  @override
  Future<User> validateLogin(String email, String password) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userToReturn!;
  }
}

class MockUserRepository implements IUserRepository {
  User? userToReturn;
  Exception? exceptionToThrow;

  @override
  bool get authenticated => userToReturn?.authenticated ?? false;

  @override
  User get email {
    if (userToReturn == null) throw Exception('User not authenticated');
    return userToReturn!;
  }

  @override
  Future<User> validateLogin(String email, String password) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    userToReturn = User(
      email: email,
      password: '',
      authenticated: true,
      accessToken: 'token',
    );
    return userToReturn!;
  }
}

class MockProductService implements IProductService {
  @override
  Future<Product> crearProducte(String token, Product product) async {
    return product;
  }

  @override
  Future<List<Product>> getProducts(String token) async => [];

  @override
  Future<void> eliminarProducte(String token, int id) async {}
}

class MockProductRepository implements IProductRepository {
  List<Product> productsToReturn = [];
  Product? productToReturn;
  Exception? exceptionToThrow;
  int? lastDeletedId;

  @override
  Future<Product> afegirProducte(Product product) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return productToReturn ?? product;
  }

  @override
  Future<List<Product>> getProducts() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return productsToReturn;
  }

  @override
  Future<void> eliminarProducte(int id) async {
    lastDeletedId = id;
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }
}

// -- Helpers --

Widget createLoginTestApp({
  required MockUserRepository mockUserRepo,
  required MockProductRepository mockProductRepo,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserVM(userRepository: mockUserRepo),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductVM(productRepository: mockProductRepo),
      ),
    ],
    child: const MaterialApp(home: Scaffold(body: LoginPage())),
  );
}

Widget createCreationTestApp({required MockProductRepository mockProductRepo}) {
  return ChangeNotifierProvider(
    create: (_) => ProductVM(productRepository: mockProductRepo),
    child: const MaterialApp(home: ProductCreationPage()),
  );
}

Widget createListTestApp({required MockProductRepository mockProductRepo}) {
  return ChangeNotifierProvider(
    create: (_) => ProductVM(productRepository: mockProductRepo),
    child: const MaterialApp(home: ProductListPage()),
  );
}

Widget createHomeTestApp({
  required MockUserRepository mockUserRepo,
  required MockProductRepository mockProductRepo,
  double width = 800,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserVM(userRepository: mockUserRepo),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductVM(productRepository: mockProductRepo),
      ),
    ],
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 600)),
        child: SizedBox(
          width: width,
          height: 600,
          child: const MyHomePage(title: 'Test'),
        ),
      ),
    ),
  );
}

// ===================== TESTS =====================

void main() {
  // ===== LoginPage =====
  group('LoginPage Widget', () {
    late MockUserRepository mockUserRepo;
    late MockProductRepository mockProductRepo;

    setUp(() {
      mockUserRepo = MockUserRepository();
      mockProductRepo = MockProductRepository();
    });

    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(
        createLoginTestApp(
          mockUserRepo: mockUserRepo,
          mockProductRepo: mockProductRepo,
        ),
      );

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Introduix el email'), findsOneWidget);
      expect(find.text('Introduix la contrasenya'), findsOneWidget);
    });

    testWidgets('renders login button', (tester) async {
      await tester.pumpWidget(
        createLoginTestApp(
          mockUserRepo: mockUserRepo,
          mockProductRepo: mockProductRepo,
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('can enter email and password text', (tester) async {
      await tester.pumpWidget(
        createLoginTestApp(
          mockUserRepo: mockUserRepo,
          mockProductRepo: mockProductRepo,
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Introduix el email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Introduix la contrasenya'),
        'password123',
      );
      await tester.pump();

      expect(find.text('user@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('tapping login triggers authentication', (tester) async {
      await tester.pumpWidget(
        createLoginTestApp(
          mockUserRepo: mockUserRepo,
          mockProductRepo: mockProductRepo,
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Introduix el email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Introduix la contrasenya'),
        'pass',
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(mockUserRepo.userToReturn?.authenticated, isTrue);
    });

    testWidgets('shows authenticated message after login', (tester) async {
      await tester.pumpWidget(
        createLoginTestApp(
          mockUserRepo: mockUserRepo,
          mockProductRepo: mockProductRepo,
        ),
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'Introduix el email'),
        'user@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Introduix la contrasenya'),
        'pwd',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.textContaining('You are logged in as:'), findsOneWidget);
    });

    testWidgets('does not show authenticated message before login', (
      tester,
    ) async {
      await tester.pumpWidget(
        createLoginTestApp(
          mockUserRepo: mockUserRepo,
          mockProductRepo: mockProductRepo,
        ),
      );

      expect(find.textContaining('You are logged in as:'), findsNothing);
    });
  });

  // ===== ProductCreationPage =====
  group('ProductCreationPage Widget', () {
    late MockProductRepository mockProductRepo;

    setUp(() {
      mockProductRepo = MockProductRepository();
    });

    testWidgets('renders title, description and price fields', (tester) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      expect(find.text('Títol'), findsOneWidget);
      expect(find.text('Descripció'), findsOneWidget);
      expect(find.text('Preu'), findsOneWidget);
    });

    testWidgets('renders AppBar with correct title', (tester) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      expect(find.text('Nou Producte'), findsOneWidget);
    });

    testWidgets('renders create button', (tester) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      expect(find.text('Crear Producte'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows validation error when title is empty', (tester) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.tap(find.text('Crear Producte'));
      await tester.pumpAndSettle();

      expect(
        find.text('Si us plau, introdueix un títol per al producte'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation error when description is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'My Title');
      await tester.tap(find.text('Crear Producte'));
      await tester.pumpAndSettle();

      expect(
        find.text('Si us plau, introdueix una descripció per al producte'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation error when price is empty', (tester) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Title');
      await tester.enterText(find.byType(TextFormField).at(1), 'Desc');
      await tester.tap(find.text('Crear Producte'));
      await tester.pumpAndSettle();

      expect(find.text('Si us plau, introdueix un preu'), findsOneWidget);
    });

    testWidgets('shows validation error when price is not a number', (
      tester,
    ) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Title');
      await tester.enterText(find.byType(TextFormField).at(1), 'Desc');
      await tester.enterText(find.byType(TextFormField).at(2), 'abc');
      await tester.tap(find.text('Crear Producte'));
      await tester.pumpAndSettle();

      expect(
        find.text('Si us plau, introdueix un número vàlid'),
        findsOneWidget,
      );
    });

    testWidgets('creates product successfully and shows snackbar', (
      tester,
    ) async {
      mockProductRepo.productToReturn = Product(
        userId: 'u1',
        id: 1,
        title: 'New',
        price: 10.0,
        description: 'Desc',
        createdAt: DateTime(2025, 1, 1),
      );
      mockProductRepo.productsToReturn = [mockProductRepo.productToReturn!];

      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'New');
      await tester.enterText(find.byType(TextFormField).at(1), 'Desc');
      await tester.enterText(find.byType(TextFormField).at(2), '10.0');
      await tester.tap(find.text('Crear Producte'));
      await tester.pumpAndSettle();

      expect(find.text('Producte creat!!!'), findsOneWidget);
    });

    testWidgets('clears fields after successful creation', (tester) async {
      mockProductRepo.productToReturn = Product(
        userId: 'u1',
        id: 1,
        title: 'Widget',
        price: 5.0,
        description: 'Nice',
        createdAt: DateTime(2025, 1, 1),
      );
      mockProductRepo.productsToReturn = [mockProductRepo.productToReturn!];

      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Widget');
      await tester.enterText(find.byType(TextFormField).at(1), 'Nice');
      await tester.enterText(find.byType(TextFormField).at(2), '5.0');
      await tester.tap(find.text('Crear Producte'));
      await tester.pumpAndSettle();

      // Fields should be cleared
      final titleField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(0),
      );
      expect(titleField.controller?.text, '');
    });

    testWidgets('can enter text in all form fields', (tester) async {
      await tester.pumpWidget(
        createCreationTestApp(mockProductRepo: mockProductRepo),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Test Title');
      await tester.enterText(find.byType(TextFormField).at(1), 'Test Desc');
      await tester.enterText(find.byType(TextFormField).at(2), '99.99');
      await tester.pump();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Desc'), findsOneWidget);
      expect(find.text('99.99'), findsOneWidget);
    });
  });

  // ===== ProductListPage =====
  group('ProductListPage Widget', () {
    late MockProductRepository mockProductRepo;

    setUp(() {
      mockProductRepo = MockProductRepository();
    });

    testWidgets('renders AppBar with correct title', (tester) async {
      await tester.pumpWidget(
        createListTestApp(mockProductRepo: mockProductRepo),
      );
      await tester.pumpAndSettle();

      expect(find.text('Llista de Productes'), findsOneWidget);
    });

    testWidgets('shows products when loaded', (tester) async {
      mockProductRepo.productsToReturn = [
        Product(
          userId: 'u1',
          id: 1,
          title: 'Product A',
          price: 10.0,
          description: 'Desc A',
          createdAt: DateTime(2025, 1, 1),
        ),
        Product(
          userId: 'u2',
          id: 2,
          title: 'Product B',
          price: 20.5,
          description: 'Desc B',
          createdAt: DateTime(2025, 2, 1),
        ),
      ];

      await tester.pumpWidget(
        createListTestApp(mockProductRepo: mockProductRepo),
      );
      await tester.pumpAndSettle();

      expect(find.text('Product A'), findsOneWidget);
      expect(find.text('Product B'), findsOneWidget);
      expect(find.text('Desc A - 10.0€'), findsOneWidget);
      expect(find.text('Desc B - 20.5€'), findsOneWidget);
    });

    testWidgets('shows delete icon for each product', (tester) async {
      mockProductRepo.productsToReturn = [
        Product(
          userId: 'u1',
          id: 1,
          title: 'P1',
          price: 5.0,
          description: 'D1',
          createdAt: DateTime(2025, 1, 1),
        ),
      ];

      await tester.pumpWidget(
        createListTestApp(mockProductRepo: mockProductRepo),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('tapping delete calls eliminarProducte', (tester) async {
      mockProductRepo.productsToReturn = [
        Product(
          userId: 'u1',
          id: 42,
          title: 'To Delete',
          price: 5.0,
          description: 'D',
          createdAt: DateTime(2025, 1, 1),
        ),
      ];

      await tester.pumpWidget(
        createListTestApp(mockProductRepo: mockProductRepo),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(mockProductRepo.lastDeletedId, 42);
    });

    testWidgets('shows empty list when no products', (tester) async {
      mockProductRepo.productsToReturn = [];

      await tester.pumpWidget(
        createListTestApp(mockProductRepo: mockProductRepo),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('shows error message when loading fails', (tester) async {
      mockProductRepo.exceptionToThrow = Exception('Network error');

      await tester.pumpWidget(
        createListTestApp(mockProductRepo: mockProductRepo),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });

  // ===== MainArea =====
  group('MainArea Widget', () {
    testWidgets('renders child page inside Expanded container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(children: const [MainArea(page: Text('Test Page'))]),
          ),
        ),
      );

      expect(find.text('Test Page'), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('applies primaryContainer color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Scaffold(
            body: Row(children: const [MainArea(page: Text('Colored'))]),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.color, isNotNull);
    });
  });
}
