import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'principal_page.dart';

class NuevoProyectoPage extends StatefulWidget {
  const NuevoProyectoPage({Key? key}) : super(key: key);

  @override
  _NuevoProyectoPageState createState() => _NuevoProyectoPageState();
}

class _NuevoProyectoPageState extends State<NuevoProyectoPage> {
  TextEditingController _nombreController = TextEditingController();
  FocusNode _nombreFocusNode = FocusNode();
  bool _showErrorMessage = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _nombreFocusNode.dispose();
    super.dispose();
  }

  Future<void> _crearProyecto() async {
    String nombreProyecto = _nombreController.text.trim();

    if (nombreProyecto.isEmpty) {
      // El nombre del proyecto está vacío
      setState(() {
        _showErrorMessage = true;
      });
      return;
    }

    var response = await http.post(
      Uri.parse('http://192.168.1.166:8080/proyectos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombreProyecto
      }),
    );

    if (response.statusCode == 200) {
      // Se crea el proyecto correctamente
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrincipalPage()),
      );
      print('Proyecto creado con éxito');
    } else {
      // Error en la solicitud
      print('Error al crear el proyecto. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Proyecto'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextFormField(
                  controller: _nombreController,
                  style: TextStyle(color: Colors.grey[300]),
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Colors.grey[300]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _nombreFocusNode.requestFocus();
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      // Realizar acciones adicionales al cambiar el valor del campo de nombre
                      _showErrorMessage = false;
                    });
                  },
                  focusNode: _nombreFocusNode,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _crearProyecto,
                child: Text(
                  'Crear Proyecto',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Volver',
                  style: TextStyle(color: Colors.orange),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange),
                ),
              ),
              if (_showErrorMessage)
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'El nombre del proyecto no puede estar vacío.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}