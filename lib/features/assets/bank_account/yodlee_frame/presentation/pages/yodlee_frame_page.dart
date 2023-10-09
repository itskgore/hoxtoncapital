import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/presentation/pages/bank_success_page.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/presentation/bloc/cubit/yodlee_intergration_cubit.dart';

class YodleeFramePage extends StatefulWidget {
  final institutionId;
  final providerName;
  final Function(bool, {required String source}) successPopUpp;
  final institutelogo;

  YodleeFramePage({
    required this.institutionId,
    required this.providerName,
    required this.successPopUpp,
    required this.institutelogo,
  });

  @override
  _YodleeFramePageState createState() => _YodleeFramePageState();
}

class _YodleeFramePageState extends State<YodleeFramePage> {
  WebViewController? _controller;
  AggregatorProvider _aggregator = AggregatorProvider.Yodlee;
  bool isLoading = true;
  String returnUrl = "https://www.getwedge.com";
  String fastLinkURL =
      'https://fl4.development.yodlee.uk/authenticate/UKPre-Prod-126/fastlink?channelAppName=ukpreprod';
  String configName = "";

  _loadFastLink(token) async {
    String _htmlString = '''<html>
        <body>
            <form name="fastlink-form" action="$fastLinkURL" method="POST">
                <input name="accessToken" value="Bearer $token" hidden="true" />
                <input name="extraParams" value="configName=$configName&flow=add&providerId=${widget.institutionId}" hidden="true" />
            </form>
            <script type="text/javascript">
                window.onload = function () {
                    document.forms["fastlink-form"].submit();
                }
            </script>
        </body>
        </html>''';

    try {
      if (_aggregator == AggregatorProvider.Yodlee) {
        await _controller!.loadUrl(Uri.dataFromString(_htmlString,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());
      } else if (_aggregator == AggregatorProvider.Saltedge) {
        await _controller!.loadUrl(fastLinkURL);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _handleEventsFromJS(message) {
    Map<String, dynamic> eventData = jsonDecode(message);

    // EventsInfoMap.add(eventData);
    if (eventData["type"] == "OPEN_EXTERNAL_URL") {
      String url = eventData["data"]["url"];
      _launchURL(url);
    }

    if (eventData["type"] == "POST_MESSAGE") {
      if (eventData["data"]["status"] == "USER_CLOSE_ACTION") {
        try {
          widget.successPopUpp(false,
              source: widget.providerName.toString().toLowerCase());
        } catch (e) {
          print(e.toString());
        }
      }

      if (eventData["data"]["sites"] != null) {
        if (eventData["data"]["sites"][0]["status"] == "SUCCESS" &&
            eventData["data"]["action"] == 'exit') {
          widget.successPopUpp(true,
              source: widget.providerName.toString().toLowerCase());
        }

        if (eventData["data"]["sites"][0]["status"] == "ACTION_ABANDONED" &&
            eventData["data"]["action"] == 'exit') {
          widget.successPopUpp(false,
              source: widget.providerName.toString().toLowerCase());
          // Navigator.pop(context);
        }
      } else if (eventData["data"]["action"] == 'exit') {
        Navigator.pop(context);
      }
    }
  }

  //TODO: @shahbaz why we are using this function only for yodlee (why not for Saltedge)
  // trackSuccessAnalytics() {
  //   final result = locator<SharedPreferences>()
  //       .getString(RootApplicationAccess.userPreferences);
  //   final data = UserPreferencesModel.fromJson(json.decode(result!));
  //   AppAnalytics().trackEvent(
  //       eventName: "fi-integration-mobile",
  //       parameters: {'user': data.pseudonym.toString(), 'provider': 'yodlee'});
  // }

  _launchURL(url) async {}

  @override
  void initState() {
    super.initState();

    // context.read<YodleeIntergrationCubit>().getData(body: {
    //   'provider': "Saltedge",
    //   'data': {
    //     "institutionId": "starlingbank_oauth_client_gb",
    //     "returnTo": returnUrl
    //   }
    // });
    context.read<YodleeIntegrationCubit>().getData(body: {
      'provider': "${widget.providerName}",
      'data': {
        "institutionId": "${widget.institutionId}",
        "returnTo": returnUrl
      }
    });
    // Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<YodleeIntegrationCubit, YodleeIntegrationState>(
        listener: (context, state) async {
          if (state is YodleeIntegrationLoaded) {
            await Future.delayed(const Duration(milliseconds: 1500));
            if (state.data.yodlee != null) {
              _aggregator = AggregatorProvider.Yodlee;
              fastLinkURL = state.data.yodlee!.fastlinkURL;
              configName = state.data.yodlee!.fastlinkConfiguration;
              _loadFastLink(state.data.yodlee!.token
                  .accessToken); //Ay6BzF4o5N5wmvktKbkjzYhHK9Yy  //state.data.yodlee.token.accessToken
            } else if (state.data.saltedgeEntity != null) {
              _aggregator = AggregatorProvider.Saltedge;

              fastLinkURL = state.data.saltedgeEntity!.redirectUrl;
              _loadFastLink(fastLinkURL);
            }

            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                isLoading = false;
              });
            });
          }
          if (state is YodleeIntegrationError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is YodleeIntegrationLoaded) {
            return Stack(children: [
              AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 300,
                ),
                opacity: isLoading ? 0 : 1,
                child: WebView(
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.contains(returnUrl)) {
                      if (request.url.contains("shared=true")) {
                        getIsUserInOnBoardingState()
                            ? cupertinoNavigator(
                                context: context,
                                screenName: BankSuccessPage(
                                  instituteId: widget.institutionId,
                                  isManuallyAdded: false,
                                  showSaltedgeConcernedNote: widget.providerName
                                          .toString()
                                          .toLowerCase() ==
                                      AggregatorProvider.Saltedge.name
                                          .toLowerCase(),
                                ),
                                type: NavigatorType.PUSHREMOVEUNTIL)
                            : widget.successPopUpp(
                                true,
                                source: widget.providerName
                                    .toString()
                                    .toLowerCase(),
                              );
                        return NavigationDecision.prevent;
                      } else {
                        Navigator.pop(context);
                        return NavigationDecision.prevent;
                      }
                    }
                    return NavigationDecision.navigate;
                  },
                  initialUrl: fastLinkURL,
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: {
                    JavascriptChannel(
                        name: 'YWebViewHandler',
                        onMessageReceived: (JavascriptMessage eventData) {
                          _handleEventsFromJS(eventData.message);
                        })
                  },
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                  },
                ),
              ),
              Visibility(
                  visible: (isLoading),
                  child: const Center(child: CircularProgressIndicator()))
            ]);
          } else if (state is YodleeIntegrationError) {
            return const Center(child: Text("An error Occurred"));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
