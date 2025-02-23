class SearchModel {
  final int queryCount;
  final String paged;
  final int nextPaged;
  final bool endQuery;
  final List<PostSearch> postsSearch;

  SearchModel({
    required this.queryCount,
    required this.paged,
    required this.nextPaged,
    required this.endQuery,
    required this.postsSearch,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      queryCount: json['QueryCount'] ?? 0,
      // Default to 0 if missing
      paged: json['Paged'] ?? '',
      // Default to empty string if missing
      nextPaged: json['nextPaged'] ?? 0,
      // Default to 0 if missing
      endQuery: json['EndQuery'] ?? false,
      // Default to false if missing
      postsSearch: json['posts'] != null
          ? List<PostSearch>.from(
              json['posts'].map((post) => PostSearch.fromJson(post)))
          : [], // Handle null case for posts
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'QueryCount': queryCount,
      'Paged': paged,
      'nextPaged': nextPaged,
      'EndQuery': endQuery,
      'posts': postsSearch.map((post) => post.toJson()).toList(),
    };
  }
}

class PostSearch {
  final int id;
  final String title;
  final String content;
  final String date;
  final List<CategorySearch> categorySearch;
  final String thumbnail;

  PostSearch({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.categorySearch,
    required this.thumbnail,
  });

  factory PostSearch.fromJson(Map<String, dynamic> json) {
    return PostSearch(
      id: json['ID'] ?? 0,
      // Default to 0 if missing
      title: json['title'] ?? '',
      // Default to empty string if missing
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      categorySearch: json['category'] != null
          ? List<CategorySearch>.from(json['category']
              .map((category) => CategorySearch.fromJson(category)))
          : [],
      thumbnail: json['thumbnail'] ?? '', // Default to empty string if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'title': title,
      'content': content,
      'date': date,
      'category': categorySearch.map((category) => category.toJson()).toList(),
      'thumbnail': thumbnail,
    };
  }
}

class CategorySearch {
  final int id;
  final String name;

  CategorySearch({
    required this.id,
    required this.name,
  });

  factory CategorySearch.fromJson(Map<String, dynamic> json) {
    return CategorySearch(
      id: json['id'] ?? 0, // Default to 0 if missing
      name: json['name'] ?? '', // Default to empty string if missing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
