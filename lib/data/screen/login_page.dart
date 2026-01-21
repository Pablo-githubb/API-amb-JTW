//Finestr de Login al iniciar l'aplicaició

import 'package:api_amb_jwt/presentation/viewmodels/user_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  build(BuildContext context)  {
    UserVM vm = context.watch<UserVM>();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    onPressed: () {
                      vm.login();
                    },
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
