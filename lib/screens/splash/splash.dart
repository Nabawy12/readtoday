import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Model/main/main.dart';
import '../../screens/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  FetchMain? _fetchMainDataModel; // نموذج لتخزين البيانات المسترجعة
  bool isLoading = true;
  String? error;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _clearCache(); // مسح أي بيانات مخزنة مؤقتًا قبل التحميل
    _fetchMainData(); // استدعاء الدالة لتحميل البيانات من الـ API
  }

  // دالة لمسح البيانات المخزنة مؤقتًا من SharedPreferences
  void _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // مسح جميع البيانات من SharedPreferences
  }

  // دالة لتحميل البيانات من الـ API
  void _fetchMainData() async {
    try {
      // تحميل البيانات من الـ API
      final response = await http.post(
        Uri.parse('https://demo.elboshy.com/new_api/wp-json/app/v1/main'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        setState(() {
          _fetchMainDataModel = FetchMain.fromJson(
            jsonResponse,
          ); // تعبئة النموذج بالبيانات
          isLoading = false; // إيقاف مؤشر التحميل
        });
        _controller.forward(); // بدء التحريك
      } else {
        setState(() {
          error = 'فشل في تحميل البيانات';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'فشل في تحميل البيانات';
        isLoading = false;
      });
    }
  }

  // دالة للتنقل إلى الشاشة التالية بعد تحميل البيانات
  void _navigateToNextScreen() async {
    if (isLoading || _fetchMainDataModel == null) return;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => Home(
              apiKey: '9nf9EeJ4PflFeUFQIPKfJLy4',
              fetchMainDataModel: _fetchMainDataModel!,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading && _fetchMainDataModel != null) {
      _navigateToNextScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox() // مؤشر التحميل أثناء تحميل البيانات
            else
              // بعد تحميل البيانات، عرض الشعار
              Image.network(
                _fetchMainDataModel?.logo ?? '',
                width: 120,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const SizedBox(width: 550, height: 550);
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.grey, size: 50);
                },
              ),
          ],
        ),
      ),
    );
  }
}
