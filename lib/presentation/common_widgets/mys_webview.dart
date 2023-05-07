import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class MYSWebView extends StatelessWidget {
  const MYSWebView({
    super.key,
    this.url,
    this.onCreated,
    this.onLoadStart,
    this.onLoadStop,
  });

  final String? url;
  final Function(Uri?)? onLoadStart;
  final Function(Uri?)? onLoadStop;
  final Function(InAppWebViewController)? onCreated;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
          disableVerticalScroll: true,
          useShouldOverrideUrlLoading: true,
        ),
      ),
      onWebViewCreated: (controller) {
        if (onCreated != null) onCreated!(controller);
      },
      onLoadStart: (_, __) {
        if (onLoadStart != null) onLoadStart!(__);
      },
      onLoadStop: (controller, url) async {
        if (onLoadStop != null) onLoadStop!(url);
      },
      initialUrlRequest: url != null ? URLRequest(url: Uri.tryParse(url!)) : null,
      shouldOverrideUrlLoading: (_, action) async {
        var url = action.request.url;
        var scheme = url?.scheme;

        if (["http", "https", "about"].contains(scheme?.toLowerCase())) return NavigationActionPolicy.ALLOW;

        if (url != null) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
