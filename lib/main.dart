import 'dart:convert';

import 'package:easy_local_and_jwt_token/config/core_config.dart';
import 'package:easy_local_and_jwt_token/config/res/app_string.dart';
import 'package:easy_local_and_jwt_token/model/user_model.dart';
import 'package:easy_local_and_jwt_token/service/user_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('ar'),
          Locale('en'),
        ],
        path:
            'assets/translate', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: LogInPage());
  }
}

class LogInPage extends StatelessWidget {
  bool forgotPassword = false;
  LogInPage({super.key});

  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                if (context.locale.languageCode == 'ar') {
                  context.setLocale(Locale('en'));
                } else {
                  context.setLocale(Locale('ar'));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Icon(Icons.translate),
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 550,
              width: 400,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 199, 199, 199),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppString().LOGIN,
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Text(AppString().Email,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: username,
                          decoration: InputDecoration(
                            hintText: AppString().EnterE,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 114, 110, 110),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff1B2F6C),
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff1B2F6C),
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Color(0xff1B2F6C),
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Text(
                      AppString().Password,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            hintText: AppString().Enterp,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 114, 110, 110),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff1B2F6C),
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff1B2F6C),
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Color(0xff1B2F6C),
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        bool status = await UserServiceImp().logIn(UserModel(
                            username: username.text, password: password.text));

                        if (status) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoPage(),
                              ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppString().ERROR)));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                        width: 300,
                        height: 50,
                        child: Center(
                          child: Text(
                            AppString().SEND,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Checkbox(
                                value: forgotPassword,
                                onChanged: (value) {
                                  setState(() {
                                    forgotPassword = value!;
                                  });
                                },
                              ),
                            ),
                            Text(AppString().Remamber),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Todos {
  int? id;
  String? todo;
  bool? completed;
  int? userId;

  Todos({this.id, this.todo, this.completed, this.userId});

  Todos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todo = json['todo'];
    completed = json['completed'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo'] = this.todo;
    data['completed'] = this.completed;
    data['userId'] = this.userId;
    return data;
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todos> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
    });
    List<Todos> todos = await TodoServiceImp().getTodos(10, 0);
    if (!mounted) return;
    setState(() {
      _todos.clear();
      _todos.addAll(todos);
      _isLoading = false;
    });
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _addController = TextEditingController();
        return AlertDialog(
          title: Text(AppString().Adde),
          content: TextField(
            controller: _addController,
            decoration: InputDecoration(hintText: AppString().Ent),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppString().ca),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppString().Ad),
              onPressed: () async {
                if (_addController.text.isNotEmpty) {
                  Todos? newTodo = await TodoServiceImp().addTodo(
                    _addController.text,
                    false,
                  );
                  Navigator.of(context).pop();
                  if (newTodo != null) {
                    setState(() {
                      _todos.add(newTodo);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                              child: Text(
                                  'Todo has been added successfully but Adding a new todo will not add it into the server.\nIt will simulate a POST request and will return the new created todo with a new id')),
                          backgroundColor: Colors.green,
                        ),
                      );
                    });
                    _fetchTodos(); // Refresh the todos list
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add todo')),
                      );
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editTodo(int index) {
    final scaffoldMessenger = ScaffoldMessenger.of(
        context); // الحصول على ScaffoldMessenger من السياق الحالي

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _editController = TextEditingController();
        _editController.text = _todos[index].todo!;
        return AlertDialog(
          title: Text(AppString().Ed),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(hintText: AppString().Ed),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppString().ca),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppString().ed),
              onPressed: () async {
                if (_editController.text.isNotEmpty) {
                  Navigator.of(context).pop();

                  Todos? updatedTodo = await TodoServiceImp().updateTodo(
                    _todos[index].id!,
                    _editController.text,
                  );

                  if (updatedTodo != null) {
                    if (mounted) {
                      setState(() {
                        _todos[index] = updatedTodo;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Center(
                                child: Text(
                                    'The todo has been modified successfully but updating a todo will not update it into the server.\nIt will simulate a PUT/PATCH request and will return updated todo with modified data')),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                      _fetchTodos(); // Refresh the todos list
                    }
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Failed to update todo')),
                      );
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) async {
    setState(() {
      _isLoading = true;
    });
    bool deleted =
        await TodoServiceImp().deleteTodoAndFetchTodos(_todos[index].id!);
    if (deleted) {
      print('Todo deleted successfully.');
      await _fetchTodos(); // Refresh the todos list
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(
                'Todo deleted successfully but Deleting a todo will not delete it into the server.\nIt will simulate a DELETE request and will return deleted todo with isDeleted & deletedOn keys')),
        backgroundColor: Colors.green,
      ));
    } else {
      print('Failed to delete todo.');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete todo')));
    }
  }

  void _toggleCompleted(int index) async {
    bool updated = await TodoServiceImp().completeTodo(
      _todos[index].id!,
      !_todos[index].completed!,
    );
    if (updated) {
      if (!mounted) return;
      setState(() {
        _todos[index].completed = !_todos[index].completed!;
      });
      if (_todos[index].completed == true)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
              child: Text(
                  'The todo has been completed but Updating a todo will not update it into the server.\nIt will simulate a PUT/PATCH request and will return updated todo with modified data')),
          backgroundColor: Colors.green,
        ));
      else
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
              child: Text(
                  'The todo has not been completed but Updating a todo will not update it into the server.\nIt will simulate a PUT/PATCH request and will return updated todo with modified data')),
          backgroundColor: Colors.red,
        ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update todo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString().Tod),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 199, 199, 199),
          constraints: BoxConstraints(maxWidth: 500),
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _todos.isEmpty
                              ? Center(
                                  child: Text('No todos yet, add some!'),
                                )
                              : ListView.builder(
                                  itemCount: _todos.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Checkbox(
                                        value: _todos[index].completed,
                                        onChanged: (bool? value) {
                                          _toggleCompleted(index);
                                        },
                                      ),
                                      title: Text(_todos[index].todo!),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () => _editTodo(index),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => _deleteTodo(index),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _addTodo,
                          child: Text(
                            AppString().Adde,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
