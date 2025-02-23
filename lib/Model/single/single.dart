/// دالة عامة لتحويل القيمة إلى List من النوع T بشكل آمن.
List<T> safeList<T>(dynamic value, T Function(dynamic) converter) {
  if (value is List) {
    return value.map(converter).toList();
  } else if (value is Map) {
    return [converter(value)];
  }
  return <T>[];
}

/// النموذج الرئيسي للمقال (Single)
class Single {
  int id;
  DateTime date;
  DateTime dateGmt;
  SingleGuid guid;
  DateTime modified;
  DateTime modifiedGmt;
  String slug;
  String status;
  String type;
  String link;
  SingleTitle title;
  SingleContent content;
  SingleExcerpt excerpt;
  int author;
  int featuredMedia; // رقم معرف الصورة المميزة (featured_media)
  String commentStatus;
  String pingStatus;
  bool sticky;
  String template;
  String format;
  SingleMeta meta;
  List<int> categories;
  List<int> tags;
  List<String> classList;
  List<SingleRelatedPost> relatedPosts;
  SingleCustomPostOptions customPostOptions;
  SingleLinks links;
  SingleEmbedded embedded;
  List<SingleFeaturedMedia> wpFeaturedMedia;

  Single({
    required this.id,
    required this.date,
    required this.dateGmt,
    required this.guid,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.featuredMedia,
    required this.commentStatus,
    required this.pingStatus,
    required this.sticky,
    required this.template,
    required this.format,
    required this.meta,
    required this.categories,
    required this.tags,
    required this.classList,
    required this.relatedPosts,
    required this.customPostOptions,
    required this.links,
    required this.embedded,
    required this.wpFeaturedMedia,
  });

  factory Single.fromJson(Map<String, dynamic> json) {
    // أولاً، نستخرج الكائن المضمَّن
    final embedded = SingleEmbedded.fromJson(json['_embedded'] ?? {});

    return Single(
      id: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? json['id']
          : 0,
      date: (json['date'] != null && json['date'].toString().isNotEmpty)
          ? DateTime.tryParse(json['date']) ?? DateTime.now()
          : DateTime.now(),
      dateGmt:
          (json['date_gmt'] != null && json['date_gmt'].toString().isNotEmpty)
              ? DateTime.tryParse(json['date_gmt']) ?? DateTime.now()
              : DateTime.now(),
      guid: SingleGuid.fromJson(json['guid'] ?? {}),
      modified:
          (json['modified'] != null && json['modified'].toString().isNotEmpty)
              ? DateTime.tryParse(json['modified']) ?? DateTime.now()
              : DateTime.now(),
      modifiedGmt: (json['modified_gmt'] != null &&
              json['modified_gmt'].toString().isNotEmpty)
          ? DateTime.tryParse(json['modified_gmt']) ?? DateTime.now()
          : DateTime.now(),
      slug: (json['slug'] != null && json['slug'].toString().isNotEmpty)
          ? json['slug']
          : '',
      status: (json['status'] != null && json['status'].toString().isNotEmpty)
          ? json['status']
          : '',
      type: (json['type'] != null && json['type'].toString().isNotEmpty)
          ? json['type']
          : '',
      link: (json['link'] != null && json['link'].toString().isNotEmpty)
          ? json['link']
          : '',
      title: SingleTitle.fromJson(json['title'] ?? {}),
      content: SingleContent.fromJson(json['content'] ?? {}),
      excerpt: SingleExcerpt.fromJson(json['excerpt'] ?? {}),
      author: (json['author'] != null && json['author'].toString().isNotEmpty)
          ? json['author']
          : 0,
      featuredMedia: (json['featured_media'] != null &&
              json['featured_media'].toString().isNotEmpty)
          ? json['featured_media']
          : 0,
      commentStatus: (json['comment_status'] != null &&
              json['comment_status'].toString().isNotEmpty)
          ? json['comment_status']
          : '',
      pingStatus: (json['ping_status'] != null &&
              json['ping_status'].toString().isNotEmpty)
          ? json['ping_status']
          : '',
      sticky: json['sticky'] ?? false,
      template:
          (json['template'] != null && json['template'].toString().isNotEmpty)
              ? json['template']
              : '',
      format: (json['format'] != null && json['format'].toString().isNotEmpty)
          ? json['format']
          : '',
      meta: SingleMeta.fromJson(json['meta'] ?? {}),
      categories: safeList<int>(json['categories'], (e) => e as int),
      tags: safeList<int>(json['tags'], (e) => e as int),
      classList: safeList<String>(json['class_list'], (e) => e.toString()),
      relatedPosts: safeList<SingleRelatedPost>(
          json['related_posts'], (e) => SingleRelatedPost.fromJson(e)),
      customPostOptions:
          SingleCustomPostOptions.fromJson(json['custom_post_options'] ?? {}),
      links: SingleLinks.fromJson(json['_links'] ?? {}),
      embedded: embedded,
      wpFeaturedMedia: (json['wp:featuredmedia'] != null &&
              (json['wp:featuredmedia'] is List &&
                  (json['wp:featuredmedia'] as List).isNotEmpty))
          ? safeList<SingleFeaturedMedia>(
              json['wp:featuredmedia'],
              (e) => SingleFeaturedMedia.fromJson(e),
            )
          : (embedded.featuredMedia ?? []),
    );
  }

  /// خاصية getter تُعيد رابط الصورة المميزة الأولى (إن وُجدت)
  String get featuredMediaUrl {
    return wpFeaturedMedia.isNotEmpty ? wpFeaturedMedia.first.sourceUrl : '';
  }
}

/// نموذج حقل guid
class SingleGuid {
  String rendered;

  SingleGuid({required this.rendered});

  factory SingleGuid.fromJson(Map<String, dynamic> json) {
    return SingleGuid(
      rendered:
          (json['rendered'] != null && json['rendered'].toString().isNotEmpty)
              ? json['rendered']
              : '',
    );
  }
}

/// نموذج حقل title (العنوان)
class SingleTitle {
  String rendered;

  SingleTitle({required this.rendered});

  factory SingleTitle.fromJson(Map<String, dynamic> json) {
    return SingleTitle(
      rendered:
          (json['rendered'] != null && json['rendered'].toString().isNotEmpty)
              ? json['rendered']
              : '',
    );
  }
}

/// نموذج حقل content (المحتوى)
class SingleContent {
  String rendered;
  bool protected;

  SingleContent({required this.rendered, required this.protected});

  factory SingleContent.fromJson(Map<String, dynamic> json) {
    return SingleContent(
      rendered:
          (json['rendered'] != null && json['rendered'].toString().isNotEmpty)
              ? json['rendered']
              : '',
      protected: json['protected'] ?? false,
    );
  }
}

/// نموذج حقل excerpt (المُلخص)
class SingleExcerpt {
  String rendered;
  bool protected;

  SingleExcerpt({required this.rendered, required this.protected});

  factory SingleExcerpt.fromJson(Map<String, dynamic> json) {
    return SingleExcerpt(
      rendered:
          (json['rendered'] != null && json['rendered'].toString().isNotEmpty)
              ? json['rendered']
              : '',
      protected: json['protected'] ?? false,
    );
  }
}

/// نموذج حقل meta
class SingleMeta {
  String footnotes;

  SingleMeta({required this.footnotes});

  factory SingleMeta.fromJson(Map<String, dynamic> json) {
    return SingleMeta(
      footnotes:
          (json['footnotes'] != null && json['footnotes'].toString().isNotEmpty)
              ? json['footnotes']
              : '',
    );
  }
}

/// نموذج الـ related_posts
class SingleRelatedPost {
  int id;
  String title;
  String content;
  String date;
  String thumbnail;
  SingleCategory category;

  SingleRelatedPost({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.thumbnail,
    required this.category,
  });

  factory SingleRelatedPost.fromJson(Map<String, dynamic> json) {
    return SingleRelatedPost(
      id: (json['ID'] != null && json['ID'].toString().isNotEmpty)
          ? json['ID']
          : 0,
      title: (json['title'] != null && json['title'].toString().isNotEmpty)
          ? json['title']
          : '',
      content:
          (json['content'] != null && json['content'].toString().isNotEmpty)
              ? json['content']
              : '',
      date: (json['date'] != null && json['date'].toString().isNotEmpty)
          ? json['date']
          : '',
      thumbnail:
          (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty)
              ? json['thumbnail']
              : '',
      category: SingleCategory.fromJson(json['category'] ?? {}),
    );
  }
}

/// نموذج التصنيف (Category) ضمن الـ related_posts
class SingleCategory {
  int id;
  String name;

  SingleCategory({required this.id, required this.name});

  factory SingleCategory.fromJson(Map<String, dynamic> json) {
    return SingleCategory(
      id: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? json['id']
          : ((json['ID'] != null && json['ID'].toString().isNotEmpty)
              ? json['ID']
              : 0),
      name: (json['name'] != null && json['name'].toString().isNotEmpty)
          ? json['name']
          : '',
    );
  }
}

/// نموذج حقل custom_post_options
class SingleCustomPostOptions {
  List<SingleOptionCategory> category;
  List<SingleOptionPostTag> postTag;
  String videoId;
  String videoPosition;
  int appViews;
  SingleNextPost getNextPost;

  SingleCustomPostOptions({
    required this.category,
    required this.postTag,
    required this.videoId,
    required this.videoPosition,
    required this.appViews,
    required this.getNextPost,
  });

  factory SingleCustomPostOptions.fromJson(Map<String, dynamic> json) {
    return SingleCustomPostOptions(
      category: safeList<SingleOptionCategory>(
          json['category'], (e) => SingleOptionCategory.fromJson(e)),
      postTag: safeList<SingleOptionPostTag>(
          json['post_tag'], (e) => SingleOptionPostTag.fromJson(e)),
      videoId:
          (json['video_id'] != null && json['video_id'].toString().isNotEmpty)
              ? json['video_id']
              : '',
      videoPosition: (json['video_position'] != null &&
              json['video_position'].toString().isNotEmpty)
          ? json['video_position']
          : '',
      appViews:
          (json['app_views'] != null && json['app_views'].toString().isNotEmpty)
              ? json['app_views']
              : 0,
      getNextPost: SingleNextPost.fromJson(json['getNextPost'] ?? {}),
    );
  }
}

/// نموذج عنصر التصنيف ضمن custom_post_options
class SingleOptionCategory {
  int id;
  String title;

  SingleOptionCategory({required this.id, required this.title});

  factory SingleOptionCategory.fromJson(Map<String, dynamic> json) {
    return SingleOptionCategory(
      id: (json['ID'] != null && json['ID'].toString().isNotEmpty)
          ? json['ID']
          : 0,
      title: (json['title'] != null && json['title'].toString().isNotEmpty)
          ? json['title']
          : '',
    );
  }
}

/// نموذج عنصر الوسم ضمن custom_post_options
class SingleOptionPostTag {
  int id;
  String title;

  SingleOptionPostTag({required this.id, required this.title});

  factory SingleOptionPostTag.fromJson(Map<String, dynamic> json) {
    return SingleOptionPostTag(
      id: (json['ID'] != null && json['ID'].toString().isNotEmpty)
          ? json['ID']
          : 0,
      title: (json['title'] != null && json['title'].toString().isNotEmpty)
          ? json['title']
          : '',
    );
  }
}

/// نموذج حقل getNextPost ضمن custom_post_options
class SingleNextPost {
  int id;
  String title;
  String content;
  String date;
  List<SingleCategory> category;
  String thumbnail;

  SingleNextPost({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.thumbnail,
  });

  factory SingleNextPost.fromJson(Map<String, dynamic> json) {
    return SingleNextPost(
      id: (json['ID'] != null && json['ID'].toString().isNotEmpty)
          ? json['ID']
          : 0,
      title: (json['title'] != null && json['title'].toString().isNotEmpty)
          ? json['title']
          : '',
      content:
          (json['content'] != null && json['content'].toString().isNotEmpty)
              ? json['content']
              : '',
      date: (json['date'] != null && json['date'].toString().isNotEmpty)
          ? json['date']
          : '',
      category: safeList<SingleCategory>(
          json['category'], (e) => SingleCategory.fromJson(e)),
      thumbnail:
          (json['thumbnail'] != null && json['thumbnail'].toString().isNotEmpty)
              ? json['thumbnail']
              : '',
    );
  }
}

/// نموذج حقل _links
class SingleLinks {
  Map<String, dynamic> links;

  SingleLinks({required this.links});

  factory SingleLinks.fromJson(Map<String, dynamic> json) {
    return SingleLinks(links: json);
  }
}

/// فئة _embedded لتشمل الحقول: author, wp:featuredmedia, wp:term
class SingleEmbedded {
  final List<Author>? authors;
  final List<SingleFeaturedMedia>? featuredMedia;
  final List<SingleEmbeddedCategory>? categories;

  SingleEmbedded({this.authors, this.featuredMedia, this.categories});

  factory SingleEmbedded.fromJson(Map<String, dynamic> json) {
    return SingleEmbedded(
      authors: (json['author'] as List<dynamic>?)
          ?.map((e) => Author.fromJson(e))
          .toList(),
      featuredMedia: (json['wp:featuredmedia'] as List<dynamic>?)
          ?.map((e) => SingleFeaturedMedia.fromJson(e))
          .toList(),
      categories: (json['wp:term'] as List<dynamic>?)
          ?.expand((categoryList) => categoryList)
          .map((e) => SingleEmbeddedCategory.fromJson(e))
          .toList(),
    );
  }
}

/// نموذج الكاتب (author)
class Author {
  final int id;
  final String name;
  final String url;
  final String description;
  final String link;
  final String slug;
  final AvatarUrls avatarUrls;

  Author({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.link,
    required this.slug,
    required this.avatarUrls,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? json['id']
          : 0,
      name: (json['name'] != null && json['name'].toString().isNotEmpty)
          ? json['name']
          : '',
      url: (json['url'] != null && json['url'].toString().isNotEmpty)
          ? json['url']
          : '',
      description: (json['description'] != null &&
              json['description'].toString().isNotEmpty)
          ? json['description']
          : '',
      link: (json['link'] != null && json['link'].toString().isNotEmpty)
          ? json['link']
          : '',
      slug: (json['slug'] != null && json['slug'].toString().isNotEmpty)
          ? json['slug']
          : '',
      avatarUrls: AvatarUrls.fromJson(json['avatar_urls'] ?? {}),
    );
  }
}

/// نموذج عناوين الصور الخاصة بالكاتب (avatar_urls)
class AvatarUrls {
  final String size24;
  final String size48;
  final String size96;

  AvatarUrls({
    required this.size24,
    required this.size48,
    required this.size96,
  });

  factory AvatarUrls.fromJson(Map<String, dynamic> json) {
    return AvatarUrls(
      size24: (json['24'] != null && json['24'].toString().isNotEmpty)
          ? json['24']
          : '',
      size48: (json['48'] != null && json['48'].toString().isNotEmpty)
          ? json['48']
          : '',
      size96: (json['96'] != null && json['96'].toString().isNotEmpty)
          ? json['96']
          : '',
    );
  }
}

/// نموذج الصور المميزة (wp:featuredmedia)
class SingleFeaturedMedia {
  final int id;
  final String date;
  final String slug;
  final String type;
  final String link;
  final String title;
  final int author;
  final int featuredMedia;
  final String caption;
  final String altText;
  final String mediaType;
  final String mimeType;
  final SingleMediaDetails mediaDetails;
  final String sourceUrl;

  SingleFeaturedMedia({
    required this.id,
    required this.date,
    required this.slug,
    required this.type,
    required this.link,
    required this.title,
    required this.author,
    required this.featuredMedia,
    required this.caption,
    required this.altText,
    required this.mediaType,
    required this.mimeType,
    required this.mediaDetails,
    required this.sourceUrl,
  });

  factory SingleFeaturedMedia.fromJson(Map<String, dynamic> json) {
    return SingleFeaturedMedia(
      id: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? json['id']
          : 0,
      date: (json['date'] != null && json['date'].toString().isNotEmpty)
          ? json['date']
          : '',
      slug: (json['slug'] != null && json['slug'].toString().isNotEmpty)
          ? json['slug']
          : '',
      type: (json['type'] != null && json['type'].toString().isNotEmpty)
          ? json['type']
          : '',
      link: (json['link'] != null && json['link'].toString().isNotEmpty)
          ? json['link']
          : '',
      title: (json['title'] != null &&
              json['title']['rendered'] != null &&
              json['title']['rendered'].toString().isNotEmpty)
          ? json['title']['rendered']
          : '',
      author: (json['author'] != null && json['author'].toString().isNotEmpty)
          ? json['author']
          : 0,
      featuredMedia: (json['featured_media'] != null &&
              json['featured_media'].toString().isNotEmpty)
          ? json['featured_media']
          : 0,
      caption: (json['caption'] != null &&
              json['caption']['rendered'] != null &&
              json['caption']['rendered'].toString().isNotEmpty)
          ? json['caption']['rendered']
          : '',
      altText:
          (json['alt_text'] != null && json['alt_text'].toString().isNotEmpty)
              ? json['alt_text']
              : '',
      mediaType: (json['media_type'] != null &&
              json['media_type'].toString().isNotEmpty)
          ? json['media_type']
          : '',
      mimeType:
          (json['mime_type'] != null && json['mime_type'].toString().isNotEmpty)
              ? json['mime_type']
              : '',
      mediaDetails: SingleMediaDetails.fromJson(json['media_details'] ?? {}),
      sourceUrl: (json['source_url'] != null &&
              json['source_url'].toString().isNotEmpty)
          ? json['source_url']
          : '',
    );
  }
}

/// نموذج تفاصيل الصورة المميزة
class SingleMediaDetails {
  final int width;
  final int height;
  final String file;
  final int filesize;
  final Map<String, SingleImageSize> sizes;

  SingleMediaDetails({
    required this.width,
    required this.height,
    required this.file,
    required this.filesize,
    required this.sizes,
  });

  factory SingleMediaDetails.fromJson(Map<String, dynamic> json) {
    var sizesMap = <String, SingleImageSize>{};
    if (json['sizes'] != null) {
      json['sizes'].forEach((key, value) {
        sizesMap[key] = SingleImageSize.fromJson(value);
      });
    }
    return SingleMediaDetails(
      width: (json['width'] != null && json['width'].toString().isNotEmpty)
          ? json['width']
          : 0,
      height: (json['height'] != null && json['height'].toString().isNotEmpty)
          ? json['height']
          : 0,
      file: (json['file'] != null && json['file'].toString().isNotEmpty)
          ? json['file']
          : '',
      filesize:
          (json['filesize'] != null && json['filesize'].toString().isNotEmpty)
              ? json['filesize']
              : 0,
      sizes: sizesMap,
    );
  }
}

/// نموذج حجم معين من الصورة (مثل medium, thumbnail, full)
class SingleImageSize {
  final String file;
  final int width;
  final int height;
  final int filesize;
  final String mimeType;
  final String sourceUrl;

  SingleImageSize({
    required this.file,
    required this.width,
    required this.height,
    required this.filesize,
    required this.mimeType,
    required this.sourceUrl,
  });

  factory SingleImageSize.fromJson(Map<String, dynamic> json) {
    return SingleImageSize(
      file: (json['file'] != null && json['file'].toString().isNotEmpty)
          ? json['file']
          : '',
      width: (json['width'] != null && json['width'].toString().isNotEmpty)
          ? json['width']
          : 0,
      height: (json['height'] != null && json['height'].toString().isNotEmpty)
          ? json['height']
          : 0,
      filesize:
          (json['filesize'] != null && json['filesize'].toString().isNotEmpty)
              ? json['filesize']
              : 0,
      mimeType:
          (json['mime_type'] != null && json['mime_type'].toString().isNotEmpty)
              ? json['mime_type']
              : '',
      sourceUrl: (json['source_url'] != null &&
              json['source_url'].toString().isNotEmpty)
          ? json['source_url']
          : '',
    );
  }
}

/// نموذج التصنيف (Category) ضمن wp:term
class SingleEmbeddedCategory {
  final int id;
  final String link;
  final String name;
  final String slug;
  final String taxonomy;
  final String icon;

  SingleEmbeddedCategory({
    required this.id,
    required this.link,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.icon,
  });

  factory SingleEmbeddedCategory.fromJson(Map<String, dynamic> json) {
    return SingleEmbeddedCategory(
      id: (json['id'] != null && json['id'].toString().isNotEmpty)
          ? json['id']
          : 0,
      link: (json['link'] != null && json['link'].toString().isNotEmpty)
          ? json['link']
          : '',
      name: (json['name'] != null && json['name'].toString().isNotEmpty)
          ? json['name']
          : '',
      slug: (json['slug'] != null && json['slug'].toString().isNotEmpty)
          ? json['slug']
          : '',
      taxonomy:
          (json['taxonomy'] != null && json['taxonomy'].toString().isNotEmpty)
              ? json['taxonomy']
              : '',
      icon: (json['icon'] != null && json['icon'].toString().isNotEmpty)
          ? json['icon']
          : '',
    );
  }
}

/// نموذج _links داخل featured media (اختياري)
class SingleMediaLinks {
  final Map<String, dynamic> links;

  SingleMediaLinks({required this.links});

  factory SingleMediaLinks.fromJson(Map<String, dynamic> json) {
    return SingleMediaLinks(links: json);
  }
}
