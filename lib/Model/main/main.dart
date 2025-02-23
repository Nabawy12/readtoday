class FetchMain {
  final String logo;
  final bool topHeaderShowsIn;
  final TopHeaderOptions topHeaderOptions;
  final bool topCategoriesShowsIn;
  final List<Category> categories;
  final bool footerShowsIn;
  final FooterOptions footerOptions;
  final ArchiveOptions archiveCategoryOptions;
  final ArchiveOptions archivePostTagOptions;
  final ArchiveOptions archiveWidgetsOptions;
  final ArchiveOptions archiveSearchOptions;
  final SocialItems socialItems;
  final AdsOptions adsOptions; // Add this line for AdsOptions

  FetchMain({
    required this.logo,
    required this.topHeaderShowsIn,
    required this.topHeaderOptions,
    required this.topCategoriesShowsIn,
    required this.categories,
    required this.footerShowsIn,
    required this.footerOptions,
    required this.archiveCategoryOptions,
    required this.archivePostTagOptions,
    required this.archiveWidgetsOptions,
    required this.archiveSearchOptions,
    required this.socialItems,
    required this.adsOptions, // Add this line to the constructor
  });

  factory FetchMain.fromJson(Map<String, dynamic> json) {
    return FetchMain(
      logo: json['logo'] ?? '',
      topHeaderShowsIn: json['top_header_showsin'] ?? false,
      topHeaderOptions: TopHeaderOptions.fromJson(
        json['top_header_options'] ?? {},
      ),
      topCategoriesShowsIn: json['top_categoryies_shows_in'] ?? false,
      categories:
          (json['categories'] as List? ?? [])
              .map((categoryJson) => Category.fromJson(categoryJson))
              .toList(),
      footerShowsIn: json['footer_showsin'] ?? false,
      footerOptions: FooterOptions.fromJson(json['footer_options'] ?? {}),
      archiveCategoryOptions: ArchiveOptions.fromJson(
        json['archive_category_options'] ?? {},
      ),
      archivePostTagOptions: ArchiveOptions.fromJson(
        json['archive_post_tag_options'] ?? {},
      ),
      archiveWidgetsOptions: ArchiveOptions.fromJson(
        json['archive_widgets_options'] ?? {},
      ),
      archiveSearchOptions: ArchiveOptions.fromJson(
        json['archive_search_options'] ?? {},
      ),
      socialItems: SocialItems.fromJson(json['socialItems'] ?? {}),
      adsOptions: AdsOptions.fromJson(
        json['ads_options'] ?? {},
      ), // Add this line for adsOptions
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'top_header_showsin': topHeaderShowsIn,
      'top_header_options': topHeaderOptions.toJson(),
      'top_categoryies_shows_in': topCategoriesShowsIn,
      'categories': categories.map((category) => category.toJson()).toList(),
      'footer_showsin': footerShowsIn,
      'footer_options': footerOptions.toJson(),
      'archive_category_options': archiveCategoryOptions.toJson(),
      'archive_post_tag_options': archivePostTagOptions.toJson(),
      'archive_widgets_options': archiveWidgetsOptions.toJson(),
      'archive_search_options': archiveSearchOptions.toJson(),
      'socialItems': socialItems.toJson(),
      'ads_options':
          adsOptions.toJson(), // Add this line to include adsOptions in toJson
    };
  }
}

class TopHeaderOptions {
  final bool menuShowsIn;
  final bool logoShowsIn;
  final bool searchShowsIn;

  TopHeaderOptions({
    required this.menuShowsIn,
    required this.logoShowsIn,
    required this.searchShowsIn,
  });

  factory TopHeaderOptions.fromJson(Map<String, dynamic> json) {
    return TopHeaderOptions(
      menuShowsIn: json['menu_showsin'] ?? false,
      logoShowsIn: json['logo_showsin'] ?? false,
      searchShowsIn: json['search_showsin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_showsin': menuShowsIn,
      'logo_showsin': logoShowsIn,
      'search_showsin': searchShowsIn,
    };
  }
}

class Category {
  final int id;
  final int count;
  final String name;

  Category({required this.id, required this.count, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      count: json['count'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'count': count, 'name': name};
  }
}

class FooterOptions {
  final bool logoShowsIn;
  final bool descriptionShowsIn;
  final String footerDescription;
  final bool socialShowsIn;
  final String socialTitle;

  FooterOptions({
    required this.logoShowsIn,
    required this.descriptionShowsIn,
    required this.footerDescription,
    required this.socialShowsIn,
    required this.socialTitle,
  });

  factory FooterOptions.fromJson(Map<String, dynamic> json) {
    return FooterOptions(
      logoShowsIn: json['logo_showsin'] ?? false,
      descriptionShowsIn: json['description_showsin'] ?? false,
      footerDescription: json['footer_description'] ?? '',
      socialShowsIn: json['social_showsin'] ?? false,
      socialTitle: json['social_title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo_showsin': logoShowsIn,
      'description_showsin': descriptionShowsIn,
      'footer_description': footerDescription,
      'social_showsin': socialShowsIn,
      'social_title': socialTitle,
    };
  }
}

class SocialItems {
  final String facebook;
  final String twitter;
  final String instagram;
  final String linkedin;
  final String youtube;

  SocialItems({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.linkedin,
    required this.youtube,
  });

  factory SocialItems.fromJson(Map<String, dynamic> json) {
    return SocialItems(
      facebook: json['Facebook'] ?? '',
      twitter: json['Twitter'] ?? '',
      instagram: json['Instagram'] ?? '',
      linkedin: json['LinkedIn'] ?? '',
      youtube: json['YouTube'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Facebook': facebook,
      'Twitter': twitter,
      'Instagram': instagram,
      'LinkedIn': linkedin,
      'YouTube': youtube,
    };
  }
}

class ArchiveOptions {
  final String boxArticleMode;
  final int postsPerPage;
  final bool sectionTitleShowsIn;
  final bool sectionDescriptionShowsIn;

  ArchiveOptions({
    required this.boxArticleMode,
    required this.postsPerPage,
    required this.sectionTitleShowsIn,
    required this.sectionDescriptionShowsIn,
  });

  factory ArchiveOptions.fromJson(Map<String, dynamic> json) {
    return ArchiveOptions(
      boxArticleMode: json['box_article_mode'] ?? '',
      postsPerPage:
          json['posts_per_page'] is String
              ? int.tryParse(json['posts_per_page']) ?? 0
              : json['posts_per_page'] ?? 0,
      sectionTitleShowsIn: json['section_title_showsin'] ?? false,
      sectionDescriptionShowsIn: json['section_description_showsin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'box_article_mode': boxArticleMode,
      'posts_per_page': postsPerPage,
      'section_title_showsin': sectionTitleShowsIn,
      'section_description_showsin': sectionDescriptionShowsIn,
    };
  }
}

class AdsOptions {
  final String adClientId;
  final String RewardedId;
  final String adUnitIdBanner;
  final String enableBannerAds;
  final String enableInterstitialAds;
  final String enableRewardedAds;

  AdsOptions({
    required this.adClientId,
    required this.adUnitIdBanner,
    required this.enableBannerAds,
    required this.enableInterstitialAds,
    required this.enableRewardedAds,
    required this.RewardedId,
  });

  factory AdsOptions.fromJson(Map<String, dynamic> json) {
    return AdsOptions(
      adClientId: json['ad_client_id']?.toString() ?? '',
      adUnitIdBanner: json['ad_unit_id_banner']?.toString() ?? '',
      enableBannerAds: json['enable_banner_ads']?.toString() ?? 'false',
      enableInterstitialAds:
          json['enable_interstitial_ads']?.toString() ?? 'false',
      enableRewardedAds: json['enable_rewarded_ads']?.toString() ?? 'false',
      RewardedId: json['ad_unit_id_rewarded']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad_client_id': adClientId,
      'ad_unit_id_banner': RewardedId,
      'ad_unit_id_rewarded': adUnitIdBanner,
      'enable_banner_ads': enableBannerAds,
      'enable_interstitial_ads': enableInterstitialAds,
      'enable_rewarded_ads': enableRewardedAds,
    };
  }
}
