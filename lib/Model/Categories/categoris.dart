class Categoryy {
  final int id;
  final int count;
  final String? name;
  final String? slug;
  final String? link;
  final String? icon;

  Categoryy({
    required this.id,
    required this.count,
    required this.icon,
    this.name,
    this.slug,
    this.link,
  });

  // Convert a Categoryy instance into a Map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'link': link,
      'icon': icon,
      'count': count,
    };
  }

  // Create a Categoryy instance from a Map (for JSON deserialization)
  factory Categoryy.fromJson(Map<String, dynamic> json) {
    return Categoryy(
      id: json['id'] is int ? json['id'] : 0,
      name: json['name'] is String ? json['name'] : '',
      slug: json['slug'] is String ? json['slug'] : '',
      link: json['link'] is String ? json['link'] : '',
      icon: json['icon'] is String ? json['icon'] : '',
      count: json['count'] is int ? json['count'] : 0,
    );
  }
}
