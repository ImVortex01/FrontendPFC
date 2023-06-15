import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'principal_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iniciar Sesión',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        colorScheme: ColorScheme.dark(
          primary: Colors.grey[900]!,
          secondary: Colors.orange,
        ),
      ),
      home: const MyHomePage(title: 'Iniciar Sesión'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Realiza la solicitud GET al backend para verificar la existencia del usuario
    var response = await http.get(Uri.parse('http://192.168.1.166:8080/usuarios/verificar?email=$email&password=$password'));

    if (response.statusCode == 200) {
      bool userExists = response.body.toLowerCase() == 'true';

      if (userExists) {
        // Usuario encontrado, navegar a la siguiente pantalla
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrincipalPage()),
        );
      } else {
        // Usuario no encontrado
        setState(() {
          _errorMessage = 'Correo o contraseña incorrectos.';
        });
      }
    } else {
      // Error en la solicitud
      setState(() {
        _errorMessage = 'Error en la solicitud.';
      });
    }
  }


  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationPage(title: 'Registro de Usuario'),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.grey[300]),
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    labelStyle: TextStyle(color: Colors.grey[300]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.grey[300]),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.grey[300]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(height: 8.0),
              OutlinedButton(
                onPressed: _register,
                child: Text('Registrarse'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange, side: BorderSide(color: Colors.orange),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla siguiente'),
      ),
      body: Center(
        child: Text('Bienvenido'),
      ),
    );
  }
}
