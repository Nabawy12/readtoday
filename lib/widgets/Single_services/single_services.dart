import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoFrameWidget extends StatefulWidget {
  final String url;

  const VideoFrameWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoFrameWidgetState createState() => _VideoFrameWidgetState();
}

class _VideoFrameWidgetState extends State<VideoFrameWidget>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController webViewController;
  String? videoId;
  String? thumbnailUrl;

  @override
  bool get wantKeepAlive => true; // Retain state to avoid unnecessary reloads

  @override
  void initState() {
    super.initState();
    webViewController =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    extractThumbnailUrl(widget.url);
  }

  /// Extract thumbnail URL from the provided video URL
  void extractThumbnailUrl(String url) {
    if (url.contains("youtube.com") || url.contains("youtu.be")) {
      RegExp regex = RegExp(
        r"(?:youtube\.com\/embed\/|youtu\.be\/|youtube\.com\/watch\?v=)([a-zA-Z0-9_-]+)",
      );
      Match? match = regex.firstMatch(url);
      if (match != null) {
        videoId = match.group(1);
        thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg";
      }
    } else if (url.contains("dailymotion.com")) {
      RegExp regex = RegExp(r"dailymotion\.com\/video\/([a-zA-Z0-9]+)");
      Match? match = regex.firstMatch(url);
      if (match != null) {
        videoId = match.group(1);
        thumbnailUrl = "https://www.dailymotion.com/thumbnail/video/$videoId";
      }
    } else {
      thumbnailUrl = null; // No thumbnail if URL is not supported
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Show the video inside a dialog with WebView
  void _showVideoDialog() {
    final dialogWebViewController =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

    dialogWebViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (String url) {
          print("Page finished loading: $url");
        },
      ),
    );

    dialogWebViewController.loadRequest(Uri.parse(widget.url));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 300,
            height: 200,
            child: WebViewWidget(controller: dialogWebViewController),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: GestureDetector(
        onTap: _showVideoDialog,
        child:
            thumbnailUrl != null
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        thumbnailUrl!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SvgPicture.asset('assets/images/youtube.svg'),
                  ],
                )
                : Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.play_circle_fill_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
      ),
    );
  }
}
