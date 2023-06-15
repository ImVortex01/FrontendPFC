import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyProjectDetailsPage extends StatefulWidget {
  final String projectName;

  MyProjectDetailsPage({required this.projectName});

  @override
  _MyProjectDetailsPageState createState() => _MyProjectDetailsPageState();
}

class _MyProjectDetailsPageState extends State<MyProjectDetailsPage> {
  List<ProjectTask> todoTasks = [];
  List<ProjectTask> doingTasks = [];
  List<ProjectTask> doneTasks = [];

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  Future<void> _getTasks() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.166:8080/tareas?proyecto=${widget.projectName}'));

      if (response.statusCode == 200) {
        final tasks = json.decode(response.body) as List<dynamic>;

        setState(() {
          todoTasks = tasks
              .where((task) => task['proyecto']['nombre'] == widget.projectName && task['estado'] == 'To Do')
              .map((task) => ProjectTask.fromJson(task))
              .toList();
          doingTasks = tasks
              .where((task) => task['proyecto']['nombre'] == widget.projectName && task['estado'] == 'Doing')
              .map((task) => ProjectTask.fromJson(task))
              .toList();
          doneTasks = tasks
              .where((task) => task['proyecto']['nombre'] == widget.projectName && task['estado'] == 'Done')
              .map((task) => ProjectTask.fromJson(task))
              .toList();
        });
      } else {
        throw Exception('Error al obtener las tareas');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          MyTaskColumn(
            title: 'To Do',
            tasks: todoTasks,
            onTaskAdded: (name, description) {
              _createTask(name, description, 'To Do');
            },
          ),
          MyTaskColumn(
            title: 'Doing',
            tasks: doingTasks,
            onTaskAdded: (name, description) {
              _createTask(name, description, 'Doing');
            },
          ),
          MyTaskColumn(
            title: 'Done',
            tasks: doneTasks,
            onTaskAdded: (name, description) {
              _createTask(name, description, 'Done');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createTask(String name, String description, String status) async {
    final newTask = ProjectTask(name: name, description: description, status: status);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.166:8080/tareas?proyecto=${widget.projectName}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newTask.toJson()),
      );

      if (response.statusCode == 200) {
        setState(() {
          final createdTask = ProjectTask.fromJson(json.decode(response.body));
          if (status == 'To Do') {
            todoTasks.add(createdTask);
          } else if (status == 'Doing') {
            doingTasks.add(createdTask);
          } else if (status == 'Done') {
            doneTasks.add(createdTask);
          }
        });
      } else {
        throw Exception('Error al crear la tarea');
      }
    } catch (error) {
      print(error);
    }
  }
}

class MyTaskColumn extends StatefulWidget {
  final String title;
  final List<ProjectTask> tasks;
  final Function(String name, String description) onTaskAdded;

  MyTaskColumn({
    required this.title,
    required this.tasks,
    required this.onTaskAdded,
  });

  @override
  _MyTaskColumnState createState() => _MyTaskColumnState();
}

class _MyTaskColumnState extends State<MyTaskColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(4.0),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                return ListTile(
                  title: Text(task.name),
                  subtitle: Text(task.description),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Eliminar') {
                        _deleteTask(task);
                      }
                    },
                    itemBuilder: (context) {
                      return ['Eliminar'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showAddTaskDialog,
            child: Text('Agregar Tarea'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String description = '';

        return AlertDialog(
          title: Text('Agregar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                widget.onTaskAdded(name, description);
                Navigator.pop(context);
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(ProjectTask task) {
    setState(() {
      widget.tasks.remove(task);
    });
  }
}

class ProjectTask {
  final String name;
  final String description;
  final String status;

  ProjectTask({
    required this.name,
    required this.description,
    required this.status,
  });

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
      name: json['nombre'],
      description: json['descripcion'],
      status: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'descripcion': description,
      'estado': status,
    };
  }
}//Estilo ok
