class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Postt {
  final int id;
  final String title;
  final String content;
  final String date;
  final String thumbnail;

  Postt({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.thumbnail,
  });

  factory Postt.fromJson(Map<String, dynamic> json) {
    return Postt(
      id: json['ID'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      thumbnail: json['thumbnail'],
    );
  }
}

class Story {
  final Category category;
  final List<Postt> posts;

  Story({required this.category, required this.posts});

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      category: Category.fromJson(json['category']),
      posts: (json['posts'] as List)
          .map((postJson) => Postt.fromJson(postJson))
          .toList(),
    );
  }
}

class ApiResponse {
  final Map<String, Story> stories;

  ApiResponse({required this.stories});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      stories: Map.fromEntries(
        json.entries.map(
          (entry) => MapEntry(entry.key, Story.fromJson(entry.value)),
        ),
      ),
    );
  }
}
