import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../Model/main/main.dart';
import '../Model/single/single.dart';
import '../services/API/call.dart';

class SingleServicesProvider with ChangeNotifier {
  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener positionsListener =
      ItemPositionsListener.create();
  List<Single> posts = [];
  late BuildContext context;
  bool isLoading = false;
  bool handleShare = false;
  bool canLoadMore = true;
  int paged = 1;
  bool isLoadingMore = false;
  int lastViewedIndex = 0;
  int currentIndex = 0;
  int currentPage = 0;
  double lastScrollOffset = 0.0;
  bool videobottom = false;
  int? currentArticleId;
  List<GlobalKey> _itemKeys = [];
  int autoLoadCount = 0;
  bool showFab = false;
  int? lastFirstVisibleIndex;
  double? lastLeadingEdge;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FetchMain? fetchMainDataModel;
  int lastVisibleIndex = 0;

  void checkScroll() {
    final positions = positionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // Get the first visible item (the item with the smallest index)
      final firstPosition = positions.reduce(
        (a, b) => a.index < b.index ? a : b,
      );
      final currentIndex = firstPosition.index;
      final currentLeadingEdge = firstPosition.itemLeadingEdge;

      // If the first visible item is index 0, hide the FAB
      if (currentIndex == 0) {
        if (showFab) {
          showFab = false;
          notifyListeners();
        }
      } else {
        // Check scroll direction if previous values are available
        if (lastFirstVisibleIndex != null && lastLeadingEdge != null) {
          bool scrollingUp = false;
          if (currentIndex < lastFirstVisibleIndex!) {
            // Index changed to a lower value means scrolling up
            scrollingUp = true;
          } else if (currentIndex == lastFirstVisibleIndex!) {
            // If the index is the same, check the leading edge
            if (currentLeadingEdge > lastLeadingEdge!) {
              scrollingUp = true;
            }
          }
          // Update FAB visibility if scroll direction changed
          if (scrollingUp != showFab) {
            showFab = scrollingUp;
            notifyListeners();
          }
        }
      }
      // Update previous values for the next scroll check
      lastFirstVisibleIndex = currentIndex;
      lastLeadingEdge = currentLeadingEdge;
    }
  }

  void updateLastVisibleIndex() {
    final positions = positionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // Get the first visible item (the item with the smallest index)
      final firstVisible = positions.reduce(
        (a, b) => a.index < b.index ? a : b,
      );
      // Update the last visible index only if we are scrolling down
      if (firstVisible.index > lastVisibleIndex) {
        lastVisibleIndex = firstVisible.index;
        showFab = true; // Show FAB when scrolling down
        notifyListeners();
        if (kDebugMode) {
          print(
            'Updated lastVisibleIndex (scroll down only): $lastVisibleIndex',
          );
        }
      }
    }
  }

  // دالة لجلب المقالات
  Future<void> fetchPosts(int id, {bool isRefresh = false}) async {
    if (isLoading || isLoadingMore || !canLoadMore) return;

    if (isRefresh) {
      isLoading = true;
      // We don't reset paged here so that pagination continues as expected
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    // Always use the URL with the 'Paged' parameter.
    String url =
        "https://demo.elboshy.com/new_api/wp-json/wp/v2/posts/$id?_embed&Paged=$paged";
    if (kDebugMode) {
      print("Fetching page: $paged for Post ID: $id");
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> jsonList =
            jsonResponse is List ? jsonResponse : [jsonResponse];
        if (jsonList.isNotEmpty) {
          final newPosts =
              jsonList.map((jsonItem) => Single.fromJson(jsonItem)).toList();
          // For a refresh or the first fetch, replace the list; otherwise, append new posts.
          if (isRefresh || posts.isEmpty) {
            posts = newPosts;
          } else {
            posts.addAll(
              newPosts,
            ); // Directly add all new posts without checking duplicates
          }
          paged++;
          canLoadMore = true;
        } else {
          canLoadMore = false;
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to load posts: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error fetching posts: $e");
      }
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> shareContent() async {
    // Set handleShare to true to show the progress indicator.
    handleShare = true;

    try {
      // Await the asynchronous share action.
      await Share.share('Check this out: https://www.facebook.com/');
    } finally {
      // After sharing (or if an error occurs), set handleShare back to false.
      handleShare = false;
    }
  }

  Future<void> fetchMainData() async {
    try {
      final response = await http.post(
        Uri.parse('${YourColorJson().baseUrl}/wp-json/app/v1/main'),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        fetchMainDataModel = FetchMain.fromJson(jsonResponse);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  // دالة الريفريش: نحذف كل المقالات التي قبل الفهرس الحالي (lastViewedIndex)
  Future<void> refreshPosts() async {
    if (posts.isEmpty) return;

    if (kDebugMode) {
      print("🔄 Refreshing. Last saved index: $lastViewedIndex");
    }

    // حفظ المقال الذي وصلنا له
    final savedPost = posts[lastViewedIndex];

    // مسح القائمة بالكامل
    posts.clear();
    paged = 1;
    lastViewedIndex = 0;
    // إضافة المقال المحفوظ فقط للقائمة
    fetchPosts(savedPost.id, isRefresh: true);

    // إعادة تعيين lastViewedIndex لأن المقال المحفوظ أصبح في الموضع 0

    notifyListeners();
  }

  // تحديث lastViewedIndex بحيث يتم تخزين الفهرس وليس الـ id

  // دالة الكشف عن العنصر الحالي بناءً على إزاحة التمرير

  String formatDate(String dateString) {
    return DateFormat(
      'EEEE, d MMMM, yyyy',
      'ar',
    ).format(DateTime.parse(dateString));
  }

  void clearData() {
    posts.clear();
    paged = 0;
    isLoading = false;
    isLoadingMore = false;
    lastViewedIndex = 0;
    lastScrollOffset = 0.0;
    canLoadMore = true;
    notifyListeners();
  }

  List<GlobalKey> get itemKeys {
    if (_itemKeys.length != posts.length) {
      _itemKeys = List.generate(posts.length, (index) => GlobalKey());
    }
    return _itemKeys;
  }

  void deleteAllData() {
    // Clear the list of posts.
    posts.clear();

    // Reset pagination and loading flags.
    paged = 1; // Reset to the initial page.
    isLoading = false;
    isLoadingMore = false;
    handleShare = false;

    // Reset scroll and view tracking.
    lastViewedIndex = 0;
    lastScrollOffset = 0.0;
    canLoadMore = true;

    // Clear any fetched main data.
    fetchMainDataModel = null;

    // Notify listeners that the state has changed.
    notifyListeners();
  }

  void refreshPostsFromIndex(int index) {
    var idd = posts[index].id;
    if (index < posts.length) {
      posts.clear();
      paged = 1;
      fetchPosts(idd, isRefresh: true);
      notifyListeners();
    }
  }

  void updateLastViewedIndex(int index) {
    if (index > lastViewedIndex) {
      lastViewedIndex = index;
      notifyListeners();
    }
  }

  void cleanupPreviousPosts() {
    if (posts.length > 1) {
      posts.removeAt(0);
      notifyListeners();
    }
  }

  void updateVideoBottom(bool condition1, bool condition2) {
    if (condition1 && condition2) {
      videobottom = true;
    } else {
      videobottom = false;
    }
    notifyListeners();
  }

  Future<void> launchWhatsApp() async {
    const phoneNumber = '201012126866';
    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
    final whatsappScheme = Uri.parse('whatsapp://send?phone=$phoneNumber');

    try {
      if (await canLaunchUrl(whatsappScheme)) {
        await launchUrl(whatsappScheme);
      } else if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // Inside SingleServicesProvider

  Future<void> refreshPostsFromLastVisibleIndex() async {
    // If the last visible index is 0, no need to refresh
    if (lastVisibleIndex == 0) return;

    // Get the ID of the last viewed post
    var postId = posts[lastVisibleIndex].id;

    // Clear the posts list and reset pagination
    posts.clear();
    paged = 1;

    // Fetch posts starting from the last visible post
    await fetchPosts(postId, isRefresh: true);

    // Reset the last visible index to 0 after refresh
    lastVisibleIndex = 0;

    notifyListeners();
  }

  // تحديث الصفحة الحالية
  void updateCurrentPage(int pageIndex) {
    currentPage = pageIndex;
    notifyListeners();
  }
}
