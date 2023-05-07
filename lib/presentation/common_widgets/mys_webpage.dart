import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common_widgets/mys_webpage_bloc.dart';
import 'package:flutter_app/presentation/common_widgets/root/appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mys_webview.dart';

class MYSWebPage extends StatelessWidget {
  static final id = 'webpage';
  static final path = '/$id';

  final String? url;
  final PostRequest? postRequest;
  final String? title;
  final bool delayedHeightLoad;
  final Function(Uri?)? onLoadStart;
  final Function(Uri?)? onLoadStop;

  const MYSWebPage(
      {Key? key,
      this.url,
      this.postRequest,
      this.title,
      this.delayedHeightLoad = false,
      this.onLoadStart,
      this.onLoadStop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController(initialRefresh: false);

    var appbarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    var pageHeight = MediaQuery.of(context).size.height;

    return BlocProvider<MYSWebPageBloc>(
      create: (context) => GetIt.I<MYSWebPageBloc>()..add(MYSWebPageEvent.updateHeight(pageHeight.toInt())),
      child: Builder(builder: (context) {
        Future<bool> onPop() async {
          var webViewController = context.read<MYSWebPageBloc>().state.webViewController;
          if ((await webViewController?.canGoBack()) ?? false) {
            webViewController?.goBack();
            return false;
          }
          return true;
        }

        void onRefresh() async {
          var webViewController = context.read<MYSWebPageBloc>().state.webViewController;
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController.getUrl()));
        }

        return WillPopScope(
          onWillPop: Platform.isIOS ? null : onPop,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: getAppBar(title),
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              fit: StackFit.expand,
              children: [
                SmartRefresher(
                  scrollController: PrimaryScrollController.of(context),
                  controller: refreshController,
                  enablePullUp: false,
                  enablePullDown: true,
                  onRefresh: onRefresh,
                  physics: BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: appbarHeight),
                        Container(
                          height: context.watch<MYSWebPageBloc>().state.height.toDouble(),
                          child: MYSWebView(
                            url: url,
                            onCreated: (controller) {
                              context.read<MYSWebPageBloc>().add(MYSWebPageEvent.viewLoaded(controller));

                              if (url == null && postRequest != null)
                                controller.postUrl(url: Uri.parse(postRequest!.url), postData: postRequest!.data);
                            },
                            onLoadStart: (url) {
                              context.read<MYSWebPageBloc>().add(MYSWebPageEvent.updateLoadingState(true));
                              if (onLoadStart != null) onLoadStart!(url);
                            },
                            onLoadStop: (_) async {
                              refreshController.refreshCompleted();

                              var bloc = context.read<MYSWebPageBloc>();

                              var height = await bloc.state.webViewController?.getContentHeight();

                              if (height != null) {
                                bloc.add(MYSWebPageEvent.updateHeight(height));
                                bloc.add(MYSWebPageEvent.updateLoadingState(false));
                              }

                              if (onLoadStop != null) onLoadStop!(_);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (context.watch<MYSWebPageBloc>().state.isLoading) ...[
                  Container(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  Center(
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}

class PostRequest {
  String url;
  Uint8List data;

  PostRequest(this.url, this.data);
}
