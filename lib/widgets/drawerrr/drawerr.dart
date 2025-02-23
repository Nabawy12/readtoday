/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gate_saudi_arabia/screens/archive/archive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:skeletons/skeletons.dart';
import '../../Model/Home/home.dart';

class CustomDrawer_home extends StatefulWidget {
  final void Function()? onTap;

  const CustomDrawer_home({Key? key, required this.onTap}) : super(key: key);

  @override
  _CustomDrawer_homeState createState() => _CustomDrawer_homeState();
}

class _CustomDrawer_homeState extends State<CustomDrawer_home> {
  // Fetch categories from the API
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://demo.elboshy.com/new_api/wp-json/wp/v2/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Material(
        type: MaterialType.transparency,
        child: Drawer(
          backgroundColor: Colors.white,
          shape: null,
          clipBehavior: Clip.none,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: SafeArea(
              child: FutureBuilder<List<Category>>(
                future: fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildMenuItem_sketlon('');
                      },
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('لا توجد اقسام'));
                  } else {
                    final categories = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'الأقسام',
                          style: GoogleFonts.alexandria(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                            // Use ListView.builder to allow scrolling
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return InkWell(
                                  overlayColor: WidgetStatePropertyAll(
                                      Colors.transparent),
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Archive(
                                            from_categories: true,
                                            onTab: () {
                                              Navigator.pop(context);
                                            },
                                            id: category.id,
                                            name: category.name!,
                                            title_show: true,
                                          ),
                                        ));
                                  },
                                  child: _buildMenuItem(category.name));
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to build each menu item with the desired style
  Widget _buildMenuItem(String? title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title ?? 'No Name',
                          // If title is null, display 'No Name'
                          style: GoogleFonts.alexandria(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(
            height: 2.5,
          ),
          Divider(),
          SizedBox(
            height: 2.5,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem_sketlon(String? title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Use Skeleton when the title is null
                        title == null
                            ? SkeletonParagraph(
                                style: SkeletonParagraphStyle(
                                  lines: 1,
                                  spacing: 6,
                                  lineStyle: SkeletonLineStyle(
                                    height: 10,
                                    borderRadius: BorderRadius.circular(5),
                                    minLength: 120,
                                    randomLength: true,
                                  ),
                                ),
                              )
                            : Text(
                                title,
                                style: GoogleFonts.alexandria(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 2.5),
          Divider(),
          SizedBox(height: 2.5),
        ],
      ),
    );
  }
}
*/
