import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required this.title});

  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _register() async {
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verificar que los campos no estén vacíos
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, complete todos los campos.';
      });
      return;
    }

    // Realizar la solicitud POST al backend para registrar el usuario.
    var response = await http.post(
      Uri.parse('http://192.168.1.166:8080/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': username,
        'password': password,
        'correoElectronico': email
      }),
    );

    if (response.statusCode == 200) {
      // Registro de usuario correcto
      Navigator.pop(context);
    } else {
      // Error en el registro de usuario
      setState(() {
        _errorMessage = 'Error al registrar el usuario.';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
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
                  controller: _usernameController,
                  style: TextStyle(color: Colors.grey[300]),
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
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
                onPressed: _register,
                child: Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(height: 8.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Volver'),
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
