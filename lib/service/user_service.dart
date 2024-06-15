import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_local_and_jwt_token/config/core_config.dart';
import 'package:easy_local_and_jwt_token/config/header_config.dart';
import 'package:easy_local_and_jwt_token/main.dart';
import 'package:easy_local_and_jwt_token/model/user_info.dart';

import 'package:easy_local_and_jwt_token/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserSerivce {
  Dio dio = Dio();

  late Response response;
  String baseurl = 'https://dummyjson.com/';

  Future<bool> logIn(UserModel user);
  Future<UserInfoModel?> getMyInfo();
}

class UserServiceImp extends UserSerivce {
  @override
  Future<bool> logIn(UserModel user) async {
    try {
      response = await dio.post(baseurl + 'auth/login',
          data: user.toMap(), options: getHeader(useToken: false));

      if (response.statusCode == 200) {
        core
            .get<SharedPreferences>()
            .setString('token', response.data['token']);

        core.get<SharedPreferences>().setInt('userId', response.data['id']);
        //  print("userIdfgdgdfgd");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<UserInfoModel?> getMyInfo() async {
    try {
      response = await dio.get(baseurl + 'auth/me', options: getHeader());

      if (response.statusCode == 200) {
        UserInfoModel user = UserInfoModel.fromMap(response.data);
        core.get<SharedPreferences>().setString('offline user', user.toJson());
        return user;
      } else {
        // return UserInfoModel.fromJson(
        //     core.get<SharedPreferences>().getString('offline user')!);
        return null;
      }
    } catch (e) {
      print(e);
      // return UserInfoModel.fromJson(
      //     core.get<SharedPreferences>().getString('offline user')!);
      return null;
    }
  }
}

abstract class TodoService {
  Dio dio = Dio();

  late Response response;
  String baseurl = 'https://dummyjson.com/';

  Future<List<Todos>> getTodos(int limit, int skip);
}

class TodoServiceImp extends TodoService {
  @override
  Future<List<Todos>> getTodos(int limit, int skip) async {
    try {
      final prefs = GetIt.I<SharedPreferences>();
      final int? userId = prefs.getInt('userId');
      //print(userId);
      response = await dio.get(
        baseurl + 'todos/user/' + userId.toString(),
        queryParameters: {'limit': limit, 'skip': skip},
      );
      if (response.statusCode == 200) {
        List<Todos> todos = (response.data['todos'] as List)
            .map((todo) => Todos.fromJson(todo))
            .toList();
        return todos;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<bool> deleteTodoAndFetchTodos(int id) async {
    try {
      response = await dio.delete(
        baseurl + 'todos/$id',
      );
      //  print("assssssssssssssssssssssssssssssssss");
      //  print(response.statusCode);
      //   print("assssssssssssssssssssssssssssssssss");
      if (response.statusCode == 200) {
        print('Todo deleted successfully on server.');
        return true;
      } else {
        print(
            'Failed to delete todo on server. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred while deleting todo: $e');
      return false;
    }
  }

  @override
  Future<bool> completeTodo(int id, bool completed) async {
    try {
      response = await dio.put(
        baseurl + 'todos/$id',
        data: {
          'completed': completed,
        },
      );
      //   print("lkaslkalsdlaslkdalskdlasdks");
      // print(response.statusCode);
      //  print("lkaslkalsdlaslkdalskdlasdks");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<Todos?> addTodo(String todo, bool completed) async {
    try {
      final prefs = GetIt.I<SharedPreferences>();
      final int? userId = prefs.getInt('userId');

      response = await dio.post(
        baseurl + 'todos/add',
        data: {
          'todo': todo,
          'completed': completed,
          'userId': userId,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Todos.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Todos?> updateTodo(int id, String todo) async {
    try {
      response = await dio.put(
        baseurl + 'todos/$id',
        data: {
          'todo': todo,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        return Todos.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
