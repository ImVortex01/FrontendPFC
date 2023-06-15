import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'nuevo_proyecto.dart';
import 'projectDetails_page.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  List<String> proyectos = [];
  List<int> proyectosIds = [];

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
  }

  Future<void> _cargarProyectos() async {
    var response = await http.get(
      Uri.parse('http://192.168.1.166:8080/proyectos'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<String> nombres = [];
      List<int> ids = [];

      for (var proyecto in data) {
        nombres.add(proyecto['nombre']);
        ids.add(proyecto['id']);
      }

      setState(() {
        proyectos = nombres;
        proyectosIds = ids;
      });
    } else {
      print('Error al cargar los proyectos. Código de estado: ${response.statusCode}');
    }
  }

  void _navigateToProject(String projectName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyProjectDetailsPage(projectName: projectName)),
    );
  }

  Future<void> _deleteProject(String projectName) async {
    var response = await http.delete(
      Uri.parse('http://192.168.1.166:8080/proyectos?nombre=$projectName'),
    );

    if (response.statusCode == 200) {
      setState(() {
        proyectos.remove(projectName);
      });
    } else {
      print('Error al eliminar el proyecto. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos'),
        actions: [
          IconButton(
            onPressed: () {
             //Pendiente
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.orange,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Divider(color: Colors.white),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Proyectos',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Ajustes',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Pendiente
              },
            ),
            Expanded(child: SizedBox()),
            Container(
              color: Colors.orange,
              child: ListTile(
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: proyectos.length,
        itemBuilder: (context, index) {
          final projectName = proyectos[index];

          return Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              title: Text(
                projectName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // Redirecciona al proyecto seleccionado
                _navigateToProject(projectName);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Eliminar proyecto'),
                      content: Text('¿Desea eliminar el proyecto "$projectName"?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteProject(projectName);
                            Navigator.of(context).pop();
                          },
                          child: Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoProyectoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
