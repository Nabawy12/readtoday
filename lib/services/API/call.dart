import 'dart:convert';
import 'package:http/http.dart' as http;

class YourColorJson {
  final String baseUrl = 'https://demo.elboshy.com/new_api';

  // Fetch data from API with optional headers
  Future<dynamic> fetchData(String endpoint, String type,
      {Map<String, String>? headers}) async {
    try {
      headers ??= {};
      headers['Authorization'] = 'Bearer 9nf9EeJ4PflFeUFQIPKfJLy4';

      // Make the HTTP request and await the response
      final response = await (type == 'GET'
          ? http.get(Uri.parse('$baseUrl/wp-json/$endpoint'), headers: headers)
          : http.post(Uri.parse('$baseUrl/wp-json/$endpoint'),
              headers: headers));

      // Check if the status code is 200 (success)
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  // Handle response data to create a structured list with featured image
  List<Map<String, dynamic>> handlePostsResponse(List<dynamic> data) {
    return data.map((value) {
      var featuredMedia = value['_embedded']?['wp:featuredmedia']?[0];
      var wpterm = value['_embedded']?['wp:term']?[0];

      var largeImage =
          featuredMedia?['media_details']?['sizes']?['full']?['source_url'];
      var defaultImage =
          featuredMedia?['media_details']?['sizes']?['full']?['source_url'];
      var defaultImage_1 = featuredMedia?['source_url'];

      var category = wpterm?[0]?['name'];
      var category_id = wpterm?[0]?['id'];

      String titlee = value['title']?['rendered'] ?? '';
      String contentt = value['content']?['rendered'] ?? '';
      String expertt = value['excerpt']?['rendered'] ?? '';

/*
      final String content = stripHtmlTags(contentt);
      final String title = stripHtmlTags(titlee);
      final String expert = stripHtmlTags(expertt);
*/

      // Check for missing values
      if (titlee.isEmpty) print('Warning: Title is missing');
      if (contentt.isEmpty) print('Warning: Content is missing');
      if (expertt.isEmpty) print('Warning: Excerpt is missing');
      if (defaultImage == null) print('Warning: Default image is missing');
      if (category == null) print('Warning: Category is missing');
      if (category_id == null) print('Warning: Category ID is missing');

      // Extract related posts
      List<Map<String, dynamic>> relatedPosts =
          (value['related_posts'] as List?)
                  ?.map((post) => {
                        'id': post['ID'] ?? '',
                        'title': post['title'] ?? '',
                        'content': post['content'] ?? '',
                        'date': post['date'] ?? '',
                        'thumbnail': post['thumbnail'] ?? '',
                        'category_id': post['category']?['id'] ?? '',
                        'category_name': post['category']?['name'] ?? '',
                      })
                  .toList() ??
              [];

      // Extract custom_post_options (category, post_tag)
      List<Map<String, dynamic>> customPostOptions = [];
      print("Full custom_post_options: ${value['custom_post_options']}");
      if (value['custom_post_options'] is Map) {
        // المتغيرات لمتابعة وجود المفاتيح المطلوبة
        bool hasCategoryOrTag = false;
        bool hasVideoId = false;
        bool hasVideoPosition = false;
        bool hasGetNextPost = false;

        value['custom_post_options']?.forEach((key, postOption) {
          print("Checking key: $key, value: $postOption");

          if (key == 'category' || key == 'post_tag') {
            hasCategoryOrTag = true;
            customPostOptions.addAll(
              (postOption as List)
                  .map((item) => {
                        'ID': item['ID'] ?? '',
                        'title': item['title'] ?? '',
                      })
                  .toList(),
            );
          } else if (key == 'video_id') {
            hasVideoId = true;
            print('Video ID found: ${postOption ?? 'No video ID'}');
            customPostOptions.add({
              'video_id': postOption ?? '',
            });
          } else if (key == 'video_position') {
            hasVideoPosition = true;
            customPostOptions.add({
              'video_position': postOption ?? '',
            });
          } else if (key == 'getNextPost') {
            // هنا يتم معالجة getNextPost داخل custom_post_options مع تحويل الـ ID إلى int
            hasGetNextPost = true;
            int nextId = 0;
            // تحقق مما إذا كان postOption['ID'] رقمًا بالفعل أو يجب تحويله من string
            if (postOption['ID'] is int) {
              nextId = postOption['ID'];
            } else if (postOption['ID'] is String) {
              nextId = int.tryParse(postOption['ID']) ?? 0;
            }
            customPostOptions.add({
              'getNextPost': {
                'ID': nextId,
                'title': postOption['title'] ?? '',
                'content': postOption['content'] ?? '',
                'date': postOption['date'] ?? '',
                'category': postOption['category'] ?? [],
                'thumbnail': postOption['thumbnail'] ?? '',
              }
            });
          }
          // يمكنك إضافة شروط أخرى إذا لزم الأمر
        });

        // إضافة بيانات افتراضية في حال عدم وجود بعض المفاتيح
        if (!hasCategoryOrTag) {
          customPostOptions.add({
            'ID': '',
            'title': '',
          });
        }
        if (!hasVideoId) {
          customPostOptions.add({
            'video_id': '',
          });
        }
        if (!hasVideoPosition) {
          customPostOptions.add({
            'video_position': '',
          });
        }
        if (!hasGetNextPost) {
          // تعيين بيانات افتراضية لـ getNextPost في حال لم تكن موجودة
          customPostOptions.add({
            'getNextPost': {
              'ID': 0,
              'title': '',
              'content': '',
              'date': '',
              'category': [],
              'thumbnail': '',
            }
          });
        }
      }
      return {
        'title': titlee,
        'id': value['id'] ?? '',
        'content': contentt,
        'expert': expertt,
        'date': value['date'] ?? '',
        'image': defaultImage ?? '',
        'large': largeImage ?? '',
        'category': category ?? '',
        'category_id': category_id ?? '',
        'related_posts': relatedPosts,
        'defaultImage_1': defaultImage_1,
        'custom_post_options': customPostOptions,
      };
    }).toList();
  }

  // Fetch posts with optional pagination
  Future<List<Map<String, dynamic>>> getPosts({
    String type = 'posts',
    int page = 0,
    int perPage = 1,
    int offset = 0,
  }) async {
    try {
      String url = 'wp/v2/$type?per_page=$perPage&_embed&status=publish';
      if (page > 0) {
        url += '&page=$page';
      }
      if (offset > 0) {
        url += '&offset=$offset';
      }

      final data = await fetchData(url, type = 'GET');
      return data is List ? handlePostsResponse(data) : [];
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  // New Search function
  Future<List<Map<String, dynamic>>> searchPosts({
    required String searchQuery,
  }) async {
    try {
      String url = 'wp/v2/posts?search=$searchQuery&_embed';

      final data = await fetchData(url, 'GET');
      return data is List ? handlePostsResponse(data) : [];
    } catch (e) {
      throw Exception('Error searching posts: $e');
    }
  }

  // Fetch post by ID
  Future<Map<String, dynamic>> getPost({
    String type = 'posts',
    required int id,
  }) async {
    try {
      String url = 'wp/v2/$type/$id?_embed';
      // استخدم syntax الصحيح لتمرير named parameter
      final data = await fetchData(url, type = 'GET');

      if (data is Map) {
        var featuredMedia = data['_embedded']?['wp:featuredmedia']?[0];
        var wpterm = data['_embedded']?['wp:term']?[0];
        var largeImage =
            featuredMedia?['media_details']?['sizes']?['full']?['source_url'];
        var defaultImage =
            featuredMedia?['media_details']?['sizes']?['full']?['source_url'];
        var defaultImage_1 = featuredMedia?['source_url'];
        var category = wpterm?[0]?['name'];
        var category_id = wpterm?[0]?['id'];

        // استخراج بيانات العنوان والمحتوى والمقتطف
        String titlee = data['title']['rendered'] ?? '';
        String contentt = data['content']['rendered'] ?? '';
        String expertt = data['excerpt']['rendered'] ?? '';

        // معالجة related_posts
        List<Map<String, dynamic>> relatedPosts = [];
        if (data['related_posts'] is List) {
          relatedPosts = (data['related_posts'] as List)
              .map((post) => {
                    'id': post['ID'] ?? '',
                    'title': post['title'] ?? '',
                    'content': post['content'] ?? '',
                    'date': post['date'] ?? '',
                    'thumbnail': post['thumbnail'] ?? '',
                    'category_id': post['category']?['id'] ?? '',
                    'category_name': post['category']?['name'] ?? '',
                  })
              .toList();
        }

        // معالجة custom_post_options بما في ذلك getNextPost
        List<Map<String, dynamic>> customPostOptions = [];
        if (data['custom_post_options'] is Map) {
          // المتغيرات لمتابعة وجود المفاتيح المطلوبة
          bool hasCategoryOrTag = false;
          bool hasVideoId = false;
          bool hasVideoPosition = false;
          bool hasGetNextPost = false;

          data['custom_post_options']?.forEach((key, postOption) {
            print("Checking key: $key, value: $postOption");

            if (key == 'category' || key == 'post_tag') {
              hasCategoryOrTag = true;
              customPostOptions.addAll(
                (postOption as List)
                    .map((item) => {
                          'ID': item['ID'] ?? '',
                          'title': item['title'] ?? '',
                        })
                    .toList(),
              );
            } else if (key == 'video_id') {
              hasVideoId = true;
              print('Video ID found: ${postOption ?? 'No video ID'}');
              customPostOptions.add({
                'video_id': postOption ?? '',
              });
            } else if (key == 'video_position') {
              hasVideoPosition = true;
              customPostOptions.add({
                'video_position': postOption ?? '',
              });
            } else if (key == 'getNextPost') {
              // هنا يتم معالجة getNextPost داخل custom_post_options مع تحويل الـ ID إلى int
              hasGetNextPost = true;
              int nextId = 0;
              // تحقق مما إذا كان postOption['ID'] رقمًا بالفعل أو يجب تحويله من string
              if (postOption['ID'] is int) {
                nextId = postOption['ID'];
              } else if (postOption['ID'] is String) {
                nextId = int.tryParse(postOption['ID']) ?? 0;
              }
              customPostOptions.add({
                'getNextPost': {
                  'ID': nextId,
                  'title': postOption['title'] ?? '',
                  'content': postOption['content'] ?? '',
                  'date': postOption['date'] ?? '',
                  'category': postOption['category'] ?? [],
                  'thumbnail': postOption['thumbnail'] ?? '',
                }
              });
            }
            // يمكنك إضافة شروط أخرى إذا لزم الأمر
          });

          // إضافة بيانات افتراضية في حال عدم وجود بعض المفاتيح
          if (!hasCategoryOrTag) {
            customPostOptions.add({
              'ID': '',
              'title': '',
            });
          }
          if (!hasVideoId) {
            customPostOptions.add({
              'video_id': '',
            });
          }
          if (!hasVideoPosition) {
            customPostOptions.add({
              'video_position': '',
            });
          }
          if (!hasGetNextPost) {
            // تعيين بيانات افتراضية لـ getNextPost في حال لم تكن موجودة
            customPostOptions.add({
              'getNextPost': {
                'ID': 0,
                'title': '',
                'content': '',
                'date': '',
                'category': [],
                'thumbnail': '',
              }
            });
          }
        }

        // إرجاع الخريطة النهائية مع كل البيانات المطلوبة
        return {
          'title': titlee,
          'id': data['id'] ?? '',
          'content': contentt,
          'expert': expertt,
          'date': data['date'] ?? '',
          'image': defaultImage ?? '',
          'defaultImage_1': defaultImage_1 ?? '',
          'large': largeImage ?? '',
          'category': category ?? '',
          'category_id': category_id ?? '',
          'related_posts': relatedPosts,
          'custom_post_options': customPostOptions,
        };
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }

  // Fetch categories
  Future<List<dynamic>> getCategories() async {
    try {
      final data = await fetchData('/wp/v2/categories', 'GET');
      return data is List ? data : [];
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch posts by category
  Future<List<Map<String, dynamic>>> getPostsByCategory(
    String categoryOrTags, {
    int perPage = 10, // default value for per_page
    int page = 1, // default value for page
  }) async {
    try {
      // Add categoryOrTags parameter to the request URL
      final data = await fetchData(
        'wp/v2/posts?$categoryOrTags&_embed&per_page=$perPage&page=$page',
        'GET',
      );
      return data is List ? handlePostsResponse(data) : [];
    } catch (e) {
      throw Exception('Error fetching posts by category or tags: $e');
    }
  }

  // Fetch comments for a post
  Future<List<dynamic>> getComments(int postId) async {
    try {
      final data = await fetchData('comments?post=$postId', 'GET');
      return data is List ? data : [];
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  // Fetch posts using meta query
  Future<List<Map<String, dynamic>>> getPostsByMetaQuery({
    required String metaKey,
    required String metaValue,
    String type = 'posts',
    int page = 0,
    int perPage = 1,
  }) async {
    try {
      final url =
          '$type?per_page=$perPage&page=$page&meta_key=$metaKey&meta_value=$metaValue&_embed';
      final data = await fetchData(url, 'GET');
      return data is List ? handlePostsResponse(data) : [];
    } catch (e) {
      throw Exception('Error fetching posts by meta query: $e');
    }
  }

  // Fetch menus
  Future<List<Map<String, dynamic>>> getMenus() async {
    try {
      final data = await fetchData('menus', 'GET');
      if (data is List) {
        return data.map((menu) {
          return {
            'id': menu['id'],
            'name': menu['name'],
            'items': menu['items'] ?? [],
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching menus: $e');
    }
  }

  // New function to fetch main data with text and boolean

// New function to fetch logo data
  Future<Map<String, dynamic>> getMainData() async {
    try {
      // Replace with your actual endpoint
      final data = await fetchData('app/v1/main', 'post');

      if (data is Map) {
        // Extract logo ID and logo URL from the response
        String logoUrl = data['logo'] ?? ''; // Extract logo URL
        bool topHeader = data['TopHeader'] ?? '';
        bool CategoriesHeader = data['CategoriesHeader'] ?? '';
        bool navBar = data['NaveBar'] ?? ''; // Extract NaveBar value
        bool userAccounts =
            data['UserAccounts'] ?? false; // Extract UserAccounts boolean
        String footerDescription =
            data['Footer_Description'] ?? ''; // Extract Footer_Description

        // Return a structured map with logo data and other additional fields
        return {
          'logo': logoUrl,
          'TopHeader': topHeader,
          'NaveBar': navBar,
          'UserAccounts': userAccounts,
          'Footer_Description': footerDescription,
          'CategoriesHeader': CategoriesHeader,
        };
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      throw Exception('Error fetching main data: $e');
    }
  }

// Function to fetch home data
  Future<Map<String, dynamic>> getHomeData() async {
    try {
      // Call the fetchData method to get data from the "HomeWadgits" endpoint using POST method
      final data = await fetchData('app/v1/home/HomeWadgits', 'POST');

      // Ensure the response is in the expected map format
      if (data is Map<String, dynamic>) {
        return data; // Return the data if it's of the expected type
      } else {
        throw Exception('Unexpected data format');
      }
    } catch (e) {
      throw Exception('Error fetching home data: $e');
    }
  }
}
