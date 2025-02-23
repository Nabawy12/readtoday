// Model for Category
class Category {
  final int id;
  final String name;
  final String content;

  Category({
    required this.id,
    required this.name,
    required this.content,
  });

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Category(id: 0, name: 'No Category', content: '');

    return Category(
      id: _parseInt(json, 'id'),
      name: _parseString(json, 'name', 'No Category'),
      content: _parseString(json, 'content', 'No Category'),
    );
  }

  static int _parseInt(Map<String, dynamic>? json, String key) {
    if (json != null && json.containsKey(key) && json[key] is int) {
      return json[key];
    }
    return 0; // Default value if null or not an integer
  }

  static String _parseString(
      Map<String, dynamic>? json, String key, String defaultValue) {
    if (json != null &&
        json.containsKey(key) &&
        json[key] is String &&
        json[key].isNotEmpty) {
      return json[key];
    }
    return defaultValue;
  }
}

// Model for Post
class Post {
  final int id;
  final String title;
  final String content;
  final String date;
  final String? thumbnail;
  final Category category;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.thumbnail,
    required this.category,
  });

  factory Post.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Post.empty();

    // Handle category as a list
    dynamic categoryJson = json['category'];
    Category category;
    if (categoryJson is List) {
      category = categoryJson.isNotEmpty
          ? Category.fromJson(categoryJson[0])
          : Category(id: 0, name: 'No Category', content: '');
    } else {
      category = Category.fromJson(categoryJson ?? {});
    }

    return Post(
      id: _parseInt(json, 'ID'),
      title: _parseString(json, 'title', 'No Title'),
      content: _parseString(json, 'content', 'No Content'),
      date: _parseString(json, 'date', 'No Date'),
      thumbnail: json.containsKey('thumbnail') && json['thumbnail'] is String
          ? json['thumbnail']
          : null,
      category: category,
    );
  }

  static int _parseInt(Map<String, dynamic>? json, String key) {
    if (json != null && json.containsKey(key) && json[key] is int) {
      return json[key];
    }
    return 0;
  }

  static String _parseString(
      Map<String, dynamic>? json, String key, String defaultValue) {
    if (json != null &&
        json.containsKey(key) &&
        json[key] is String &&
        json[key].isNotEmpty) {
      return json[key];
    }
    return defaultValue;
  }

  static Post empty() {
    return Post(
      id: 0,
      title: 'No Title',
      content: 'No Content',
      date: 'No Date',
      thumbnail: null,
      category: Category(id: 0, name: 'No Category', content: ''),
    );
  }
}

class WidgetContent {
  final String widgetType;
  final bool scrollLoader;
  final int queryCount;
  final int paged;
  final int nextPaged;
  final bool endQuery;
  final List<Post> posts;
  final String widgetID;

  WidgetContent({
    required this.widgetType,
    required this.scrollLoader,
    required this.queryCount,
    required this.paged,
    required this.nextPaged,
    required this.endQuery,
    required this.posts,
    required this.widgetID,
  });

  factory WidgetContent.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return WidgetContent(
        widgetType: 'No Type',
        scrollLoader: false,
        queryCount: 0,
        paged: 1,
        nextPaged: 2,
        endQuery: false,
        posts: [],
        widgetID: 'No WidgetID',
      );
    }

    var postsFromJson = json['posts'];
    List<Post> postList = (postsFromJson is List)
        ? postsFromJson.map((i) => Post.fromJson(i)).toList()
        : [];

    return WidgetContent(
      widgetType: _parseString(json, 'Widget_type', 'No Type'),
      scrollLoader:
          json.containsKey('ScrollLoader') && json['ScrollLoader'] is bool
              ? json['ScrollLoader']
              : false,
      queryCount: _parseInt(json, 'QueryCount'),
      paged: _parseInt(json, 'Paged', 1),
      nextPaged: _parseInt(json, 'nextPaged', 2),
      endQuery: json.containsKey('EndQuery') && json['EndQuery'] is bool
          ? json['EndQuery']
          : false,
      posts: postList,
      widgetID: _parseString(json, 'WidgetID', 'No WidgetID'),
    );
  }

  static int _parseInt(Map<String, dynamic>? json, String key,
      [int defaultValue = 0]) {
    if (json != null && json.containsKey(key) && json[key] is int) {
      return json[key];
    }
    return defaultValue;
  }

  static String _parseString(
      Map<String, dynamic>? json, String key, String defaultValue) {
    if (json != null &&
        json.containsKey(key) &&
        json[key] is String &&
        json[key].isNotEmpty) {
      return json[key];
    }
    return defaultValue;
  }

  Post getPostById(int postId) {
    return posts.firstWhere(
      (post) => post.id == postId,
      orElse: () => Post.empty(),
    );
  }

  List<Category> getCategoriesForPost(int postId) {
    var post = getPostById(postId);
    return [post.category];
  }
}
