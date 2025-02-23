import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../Model/Categories/categoris.dart';
import '../../Model/main/main.dart';
import '../../services/API/call.dart';

class HomeProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isInternetConnected = true;
  FetchMain? _fetchMainDataModel;
  List<Categoryy> _categories = [];
  int _currentOffset = 0;
  bool _hasMorePosts = true;
  List<Map<String, dynamic>> _posts = [];

  bool get isLoading => _isLoading;

  bool get isInternetConnected => _isInternetConnected;

  FetchMain? get fetchMainDataModel => _fetchMainDataModel;

  List<Categoryy> get categories => _categories;

  List<Map<String, dynamic>> get posts => _posts;

  Future<void> fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('${YourColorJson().baseUrl}/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        _fetchMainDataModel = FetchMain.fromJson(jsonResponse);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${YourColorJson().baseUrl}/wp-json/wp/v2/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _categories = data.map((json) => Categoryy.fromJson(json)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts({bool isButtonPress = false}) async {
    if (!_hasMorePosts) return;

    _isLoading = true;
    notifyListeners();

    try {
      final api = YourColorJson();
      final morePosts = await api.getPosts(perPage: 10, offset: _currentOffset);

      _posts.addAll(morePosts);
      _currentOffset += 10;
      _hasMorePosts = morePosts.length >= 10;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void checkInternetConnection() async {
    _isInternetConnected = await InternetConnection().hasInternetAccess;
    notifyListeners();
  }
}
