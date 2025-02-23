/*
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readtoday/provider/single.dart';
import 'package:readtoday/widgets/Single_services/single_services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'Constants/color.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SingleServicesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SingleServicesPage(id: 508675));
  }
}

class SingleServicesPage extends StatefulWidget {
  final int id;

  const SingleServicesPage({super.key, required this.id});

  @override
  _SingleServicesPageState createState() => _SingleServicesPageState();
}

class _SingleServicesPageState extends State<SingleServicesPage> {
  late SingleServicesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = SingleServicesProvider();
    provider.fetchPosts(widget.id, isRefresh: true);

    // إضافة مستمع لتحديد المؤشر الحالي
    provider.positionsListener.itemPositions.addListener(
      provider.updateLastVisibleIndex,
    );
  }

  @override
  void dispose() {
    provider.positionsListener.itemPositions.removeListener(
      provider.updateLastVisibleIndex,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<SingleServicesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('المؤشر الحالي: ${provider.lastViewedIndex}'),
            ),
            body:
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: () async {
                        await provider.refreshPosts();
                      },
                      child: ScrollablePositionedList.builder(
                        itemCount: provider.posts.length,
                        itemBuilder: (context, index) {
                          final post = provider.posts[index];

                          // تحميل المزيد عند الوصول لآخر عنصر
                          if (index == provider.posts.length - 1 &&
                              provider.canLoadMore) {
                            final nextPostId =
                                post.customPostOptions?.getNextPost?.id;
                            if (nextPostId != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                provider.fetchPosts(nextPostId);
                              });
                            }
                          }

                          return Card(
                            child: Column(
                              children: [
                                Image.network(post.featuredMediaUrl),
                                ListTile(
                                  title: Text(
                                    post.title.rendered ?? 'بدون عنوان',
                                  ),
                                  subtitle: HtmlWidget(
                                    post.content.rendered,
                                    onLoadingBuilder: (
                                      context,
                                      element,
                                      loadingProgress,
                                    ) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colorss().MainColor,
                                        ),
                                      );
                                    },
                                    textStyle: GoogleFonts.alexandria(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      height: 1.9,
                                      color: Colors.black,
                                    ),
                                    enableCaching: false,
                                    renderMode: RenderMode.column,
                                    rebuildTriggers: [
                                      TagExtension(
                                        tagsToExtend: {"iframe"},
                                        builder: (context) {
                                          final src =
                                              context.attributes['src'] ?? "";
                                          return VideoFrameWidget(url: src);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: post.relatedPosts.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, idx) {
                                    final relatedPost = post.relatedPosts[idx];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => SingleServicesPage(
                                                  id: relatedPost.id,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(relatedPost.title),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        itemScrollController: provider.scrollControllerr,
                        itemPositionsListener: provider.positionsListener,
                      ),
                    ),
          );
        },
      ),
    );
  }
}
*/
