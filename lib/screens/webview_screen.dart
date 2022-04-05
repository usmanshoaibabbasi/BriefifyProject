import 'dart:io';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String url;

  const WebviewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool _loading = true;
  bool _error = false;
  bool _pageNavigationLoading = false;
  bool _ignorePop = false;
  double _progress = 0.0;
  final _key = UniqueKey();
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return WillPopScope(
      onWillPop: () async {
        if (_ignorePop) return true;
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: !_loading && !_error
                ? Image.asset(
                    appLogo,
                    height: 50,
                  )
                : Container(),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kPrimaryColorLight,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
            onPressed: () {
              Navigator.pop(context);
            },
            color: kSecondaryColorDark,
            padding: const EdgeInsets.all(0),
          ),
        ),
        body: Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (int progress) {
                setState(() {
                  _progress = progress / 100;
                });
                if (progress == 100) {
                  setState(() {
                    _loading = false;
                  });
                }
              },
              onPageStarted: (String url) {
                setState(() {
                  _pageNavigationLoading = true;
                });
              },
              onPageFinished: (String result) {
                _pageNavigationLoading = false;
              },
              onWebViewCreated: (WebViewController controller) {
                _controller = controller;
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _error = true;
                });
              },
            ),
            if (_loading)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        appLogo,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      CircularProgressIndicator(
                        value: _progress,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            if (_error)
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      _controller.reload();
                      setState(() {
                        _error = false;
                        _loading = true;
                      });
                    },
                    child: const Text('Error'),
                    textColor: Colors.white,
                  ),
                ),
              ),
            if (_pageNavigationLoading && !_error && !_loading)
              const Center(
                child: SpinKitCircle(
                  size: 50,
                  color: Colors.red,
                ),
              )
          ],
        ),
      ),
    );
  }
}
