import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../home/presentation/cubit/disconnected_accounts_cubit.dart';

class AggregatorReconnect extends StatefulWidget {
  final String reconnectUrl;
  final Function(bool) status;

  const AggregatorReconnect(
      {Key? key, required this.reconnectUrl, required this.status})
      : super(key: key);

  @override
  _AggregatorReconnectState createState() => _AggregatorReconnectState();
}

class _AggregatorReconnectState extends State<AggregatorReconnect> {
  bool isLoading = true;

  // WebViewController? _controller;
  String returnUrl = "https://www.getwedge.com";

  _handleEventsFromJS(message) {
    Map<String, dynamic> eventData = jsonDecode(message);
    if (eventData["data"]["action"] == 'exit') {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        AnimatedOpacity(
          duration: const Duration(
            milliseconds: 300,
          ),
          opacity: isLoading ? 0 : 1,
          child: WebView(
            navigationDelegate: (NavigationRequest request) {
              log("Request $request");
              if (request.url.contains(returnUrl)) {
                if (request.url.contains("shared=true")) {
                  widget.status(true);
                  context
                      .read<DisconnectedAccountsCubit>()
                      .getDisconnectedAccountData();
                  return NavigationDecision.prevent;
                } else {
                  Navigator.pop(context);
                  widget.status(false);
                  return NavigationDecision.prevent;
                }
              }
              return NavigationDecision.navigate;
            },
            initialUrl: widget.reconnectUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  isLoading = false;
                });
              });
            },
            javascriptChannels: {
              JavascriptChannel(
                  name: 'YWebViewHandler',
                  onMessageReceived: (JavascriptMessage eventData) {
                    _handleEventsFromJS(eventData.message);
                  })
            },
          ),
        ),
        Visibility(
            visible: (isLoading),
            child: const Center(child: CircularProgressIndicator()))
      ]),
    );
  }
}
