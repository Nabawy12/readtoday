int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class Category {
  int id;
  String title;

  Category({
    required this.id,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: _parseInt(json['id']),
      title: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
    };
  }
}

class MoreHomePost {
  int id;
  String title;
  String? thumbnail;
  Category category;
  String content;
  String date;

  MoreHomePost({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.category,
    required this.content,
    required this.date,
  });

  factory MoreHomePost.fromJson(Map<String, dynamic> json) {
    var categoryList = json['category'] as List? ?? [];
    return MoreHomePost(
      id: _parseInt(json['ID']),
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'],
      category: categoryList.isNotEmpty
          ? Category.fromJson(categoryList.first)
          : Category(id: 0, title: ''),
      content: json['content'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'title': title,
      'thumbnail': thumbnail,
      'category': [category.toJson()],
      'content': content,
      'date': date,
    };
  }
}

class ArchiveOptions {
  String boxArticleMode;
  int postsPerPage;
  bool sectionTitleShowsin;

  ArchiveOptions({
    required this.boxArticleMode,
    required this.postsPerPage,
    required this.sectionTitleShowsin,
  });

  factory ArchiveOptions.fromJson(Map<String, dynamic> json) {
    return ArchiveOptions(
      boxArticleMode: json['box_article_mode'] ?? '',
      postsPerPage: _parseInt(json['posts_per_page']),
      sectionTitleShowsin: json['section_title_showsin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'box_article_mode': boxArticleMode,
      'posts_per_page': postsPerPage,
      'section_title_showsin': sectionTitleShowsin,
    };
  }
}

class MoreHome {
  String widgetType;
  bool scrollLoader;
  int queryCount;
  int paged;
  int nextPaged;
  bool endQuery;
  String widgetID;
  String title;
  ArchiveOptions archiveOptions;
  List<MoreHomePost> posts;

  MoreHome({
    required this.widgetType,
    required this.scrollLoader,
    required this.queryCount,
    required this.paged,
    required this.nextPaged,
    required this.endQuery,
    required this.widgetID,
    required this.title,
    required this.archiveOptions,
    required this.posts,
  });

  factory MoreHome.fromJson(Map<String, dynamic> json) {
    var postsList = json['posts'] as List? ?? [];
    return MoreHome(
      widgetType: json['Widget_type'] ?? '',
      scrollLoader: json['ScrollLoader'] ?? false,
      queryCount: _parseInt(json['QueryCount']),
      paged: _parseInt(json['Paged']),
      nextPaged: _parseInt(json['nextPaged']),
      endQuery: json['EndQuery'] ?? false,
      widgetID: json['WidgetID'] ?? '',
      title: json['title'] ?? '',
      archiveOptions: ArchiveOptions.fromJson(json['archive_options'] ?? {}),
      posts: postsList.map((e) => MoreHomePost.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Widget_type': widgetType,
      'ScrollLoader': scrollLoader,
      'QueryCount': queryCount,
      'Paged': paged,
      'nextPaged': nextPaged,
      'EndQuery': endQuery,
      'WidgetID': widgetID,
      'title': title,
      'archive_options': archiveOptions.toJson(),
      'posts': posts.map((e) => e.toJson()).toList(),
    };
  }
}
