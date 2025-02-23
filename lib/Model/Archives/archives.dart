class ArchivesModel {
  final int termId;
  final ArchiveOptions archiveOptions;
  final String title;
  final String description;
  final int queryCount;
  final int paged;
  final int nextPaged;
  final bool endQuery;
  final List<ArchivePost> posts;

  ArchivesModel({
    required this.termId,
    required this.archiveOptions,
    required this.title,
    required this.description,
    required this.queryCount,
    required this.paged,
    required this.nextPaged,
    required this.endQuery,
    required this.posts,
  });

  factory ArchivesModel.fromJson(Map<String, dynamic> json) {
    return ArchivesModel(
      description: json['description']?.toString() ?? '',
      // Default to empty string if not present
      termId: int.tryParse(json['term_id'].toString()) ?? 0,
      // Default to 0 if invalid
      archiveOptions: ArchiveOptions.fromJson(json['archive_options'] ?? {}),
      // Handle null values for archiveOptions
      title: json['title']?.toString() ?? '',
      // Default to empty string if not present
      queryCount: int.tryParse(json['QueryCount'].toString()) ?? 0,
      // Default to 0 if invalid
      paged: int.tryParse(json['Paged'].toString()) ?? 1,
      // Default to 1 if invalid
      nextPaged: int.tryParse(json['nextPaged'].toString()) ?? 1,
      // Default to 1 if invalid
      endQuery: json['EndQuery'] == true,
      // Handle null/false values gracefully
      posts: json['posts'] != null
          ? List<ArchivePost>.from(
              (json['posts'] as List).map((x) => ArchivePost.fromJson(x)))
          : [], // Default to empty list if posts are missing
    );
  }
}

class ArchivePost {
  final int id;
  final String title;
  final String content;
  final String date;
  final List<Category> categories;
  final String? thumbnail;

  ArchivePost({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.categories,
    this.thumbnail,
  });

  factory ArchivePost.fromJson(Map<String, dynamic> json) {
    return ArchivePost(
      id: int.tryParse(json['ID'].toString()) ?? 0,
      // Default to 0 if invalid
      title: json['title']?.toString() ?? '',
      // Default to empty string if not present
      content: json['content']?.toString() ?? '',
      // Default to empty string if not present
      date: json['date']?.toString() ?? '',
      // Default to empty string if not present
      categories: json['category'] != null
          ? (json['category'] as List).map((x) => Category.fromJson(x)).toList()
          : [],
      // Default to empty list if category is missing
      thumbnail: json['thumbnail']?.toString(), // Null is allowed for thumbnail
    );
  }
}

class ArchiveOptions {
  final String boxArticleMode;
  final String postsPerPage;
  final bool sectionTitleShowsin;
  final bool sectionDescriptionShowsin;

  ArchiveOptions({
    required this.boxArticleMode,
    required this.postsPerPage,
    required this.sectionTitleShowsin,
    required this.sectionDescriptionShowsin,
  });

  factory ArchiveOptions.fromJson(Map<String, dynamic> json) {
    return ArchiveOptions(
      boxArticleMode: json['box_article_mode']?.toString() ??
          '', // Default to empty string if missing
      postsPerPage: json['posts_per_page']?.toString() ??
          '', // Default to empty string if missing
      sectionTitleShowsin:
          json['section_title_showsin'] == true, // Handle null/false gracefully
      sectionDescriptionShowsin: json['section_description_showsin'] ==
          true, // Handle null/false gracefully
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0, // Default to 0 if invalid
      name:
          json['name']?.toString() ?? '', // Default to empty string if missing
    );
  }
}
