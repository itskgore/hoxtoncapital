import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';

import '../../app.dart';
import '../utils/wedge_func_methods.dart';
import '../utils/wedge_snackBar.dart';

abstract class Failure extends Equatable {
  final String? responseMsg;

  const Failure(this.responseMsg);
  @override
  List<Object> get props => [];
  String? get apiMsg;
  String displayErrorMessage();
}

// General failures
class ServerFailure extends Failure {
  final String? message;
  const ServerFailure({this.message}) : super(message);
  @override
  displayErrorMessage() {
    return message ?? "An error Occurred,try again later";
  }

  @override
  // TODO: implement apiMsg
  String? get apiMsg => message;
}

class CacheFailure extends Failure {
  @override
  displayErrorMessage() {
    return "An error Occurred, try again Later";
  }

  final String? message;
  const CacheFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
}

class InternetFailure extends Failure {
  final String? message;
  const InternetFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "You are Offline! please check your internet";
  }
}

//Unauthorized
class Unauthorized extends Failure {
  final String? message;
  const Unauthorized({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Invalid Passcode";
  }
}

class NotFoundFailure extends Failure {
  final String? message;
  const NotFoundFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "User ID not found. Please check and retry";
  }
}

class UserNotFoundFailure extends Failure {
  final String? message;
  const UserNotFoundFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "User ID not found. Please check and retry";
  }
}

class UserLockedFailure extends Failure {
  final String? message;
  const UserLockedFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "User locked, please contact the administrator";
  }
}

class TermsConditionsAlreadyAcceptedFailure extends Failure {
  final String? message;
  const TermsConditionsAlreadyAcceptedFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Terms and conditions already accepted, please restart the application.";
  }
}

class BankCashReplicatedFailure extends Failure {
  final String? message;
  const BankCashReplicatedFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Balance should not be same as with actual one";
  }
}

class EmptyServerData extends Failure {
  final String? message;
  const EmptyServerData({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "No data available!";
  }
}

class EmailValidationFailure extends Failure {
  final String? message;
  const EmailValidationFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;

  @override
  displayErrorMessage() {
    return message ?? "Invalid Email!";
  }
}

class InvalidCurrentPassword extends Failure {
  final String? message;
  const InvalidCurrentPassword({this.message}) : super(message);
  @override
  String? get apiMsg => message;

  @override
  displayErrorMessage() {
    return message ?? "Invalid password supplied, check your current password!";
  }
}

class CredentialValidationFailure extends Failure {
  const CredentialValidationFailure({this.message}) : super(message);
  final String? message;

  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return translate!.loginErrorMessage;
  }
}

class LargeImageFailure extends Failure {
  final String? message;
  const LargeImageFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Image Size should be less than 5 MB";
  }
}

class LargeScreenShotImageFailure extends Failure {
  const LargeScreenShotImageFailure({this.message}) : super(message);
  final String? message;
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Image Size should be less than 10 MB";
  }
}

class LargeDocumentImageFailure extends Failure {
  final String? message;
  const LargeDocumentImageFailure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Image/Doc Size should be less than 10 MB";
  }
}

class InternetConnectFailure extends Failure {
  final String? message;

  const InternetConnectFailure({this.message}) : super(message);
  @override
  String? get apiMsg => "You are disconnected from the internet.";
  @override
  displayErrorMessage() {
    return "You are disconnected from the internet.";
  }
}

class ServerConnectionCancelled extends Failure {
  final String? message;

  const ServerConnectionCancelled({this.message}) : super(message);
  @override
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Connection cancelled";
  }
}

class ConnectionTimeout extends Failure {
  final String? message;

  const ConnectionTimeout({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Connecting timed out [10000ms]";
  }
}

class InvalidOTP extends Failure {
  final String? message;

  const InvalidOTP({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Invalid Code";
  }
}

class ResendCodeFailiure extends Failure {
  final String? message;

  const ResendCodeFailiure({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Failed, please try after 5 minute";
  }
}

class TokenExpired extends Failure {
  final String? message;

  const TokenExpired({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "Token Expired";
  }
}

class OTPExpired extends Failure {
  final String? message;

  const OTPExpired({this.message}) : super(message);
  @override
  String? get apiMsg => message;
  @override
  displayErrorMessage() {
    return "You reached the maximum count of otp attempts. Please login again";
  }
}

class ServerStatus {
  final bool status;
  Failure? failure;

  ServerStatus({required this.status, required this.failure});
}

Future<bool> isInternetAvailable() async {
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  if (isConnected) {
    return true;
  } else {
    throw const InternetConnectFailure();
  }
}

Future<ServerStatus> hanldeStatusCode(Response<dynamic> result) async {
  if (result.statusCode == 201 || result.statusCode == 200) {
    return ServerStatus(status: true, failure: null);
  } else if (result.statusCode == 401) {
    if (result.data.containsKey("code") ||
        result.data.containsKey("Invalid Authentication Token")) {
      // await RootApplicationAccess().refreshToken();
      return ServerStatus(status: false, failure: const TokenExpired());
    } else if (result.data['message'].toLowerCase() ==
            "Invalid Credentials.".toLowerCase() ||
        result.data['message'].toLowerCase().contains(
            "Invalid login credentials, please check your login and password"
                .toLowerCase()) ||
        result.data['message']
            .toLowerCase()
            .contains("Invalid username/password".toLowerCase())) {
      return ServerStatus(
          status: false,
          failure: Unauthorized(message: translate!.loginErrorMessage));
    } else if (result.data['message']
        .toLowerCase()
        .contains("Invalid user id".toLowerCase())) {
      return ServerStatus(
          status: false, failure: const CredentialValidationFailure());
    } else if (result.data['message']
        .toLowerCase()
        .contains("Token is expired".toLowerCase())) {
      return ServerStatus(status: false, failure: const TokenExpired());
    } else if (result.data['message'].toLowerCase().contains(
        "API key is expired, Please contact the administrator".toLowerCase())) {
      return ServerStatus(status: false, failure: const TokenExpired());
    } else {
      // RootApplicationAccess().logoutAndClearData();
      return ServerStatus(
          status: false,
          failure: Unauthorized(message: result.data['message'] ?? ""));
    }
  } else if (result.statusCode == 403) {
    final msg = result.data['message'] ?? "";
    if (msg
        .toString()
        .toLowerCase()
        .contains("terms and condition already accepted.")) {
      return ServerStatus(
          status: false,
          failure: const TermsConditionsAlreadyAcceptedFailure());
    } else {
      return ServerStatus(
          status: false, failure: UserLockedFailure(message: msg));
    }
  } else if (result.statusCode == 413) {
    if (result.data.containsKey("message")) {
      if (result.data["message"].toLowerCase() ==
          "request file too large, please check multipart config"
              .toLowerCase()) {
        return ServerStatus(
            status: false, failure: const LargeDocumentImageFailure());
      } else {
        return ServerStatus(status: false, failure: const LargeImageFailure());
      }
    } else {
      return ServerStatus(status: false, failure: const LargeImageFailure());
    }
  } else if (result.statusCode == 404) {
    if (result.data.containsKey("message")) {
      if (result.data['message'].toLowerCase() ==
          "Unable to find user for the given email".toLowerCase()) {
        return ServerStatus(
            status: false, failure: const UserNotFoundFailure());
      } else if (result.data['message'].toLowerCase() ==
          "Invalid Credentials.".toLowerCase()) {
        return ServerStatus(
            status: false,
            failure: Unauthorized(message: result.data['message'] ?? ""));
      } else {
        return ServerStatus(status: false, failure: const ServerFailure());
      }
    } else {
      return ServerStatus(status: false, failure: const ServerFailure());
    }
  } else if (result.statusCode == 422) {
    if ("Invalid password supplied, check your current password"
            .toLowerCase() ==
        result.data['message'].toLowerCase()) {
      return ServerStatus(
          status: false,
          failure: InvalidCurrentPassword(message: result.data['message']));
    } else {
      if (result.data['message'] != null) {
        showSnackBar(
            context: navigatorKey.currentState!.context,
            title: "${result.data['message']}");
      }
      return ServerStatus(
          status: false,
          failure: EmailValidationFailure(message: result.data['message']));
    }
  } else if (result.statusCode == 406) {
    return ServerStatus(
        status: false, failure: InvalidOTP(message: result.data['message']));
  } else if (result.statusCode == 429) {
    return ServerStatus(
        status: false,
        failure: ResendCodeFailiure(message: result.data['message']));
  } else if (result.statusCode == 423) {
    return ServerStatus(status: false, failure: const OTPExpired());
  } else {
    if (result.data['message'] != null) {
      showSnackBar(
          context: navigatorKey.currentState!.context,
          title: "${result.data['message']}");
    }
    return ServerStatus(status: false, failure: const ServerFailure());
  }
}

handleThrownException(dynamic e) {
  AppAnalytics().trackEvent(
      eventName: "mobile_catched_errors", parameters: {"error": e.toString()});
  if (e.toString().contains("SocketException")) {
    log("exception: Internet error");
    throw InternetConnectFailure(message: e.message);
  } else if (e is SocketException) {
    log("exception: Internet error");
    throw InternetConnectFailure(message: e.message);
  } else if (e.toString().contains("Connecting timed out [10000ms]")) {
    log("exception: timeout error");
    throw ConnectionTimeout(message: e.message);
  } else if (e.toString().contains("You are disconnected from the internet.")) {
    log("exception: Internet error");
    throw InternetConnectFailure(message: e.message);
  } else if (e is SocketException) {
    log("exception: Internet error");
    throw InternetConnectFailure(message: e.message);
  } else if (e is UserLockedFailure) {
    log("exception: user locked");

    throw UserLockedFailure(message: e.message);
  } else if (e is LargeImageFailure) {
    log("exception: image Exception");

    throw LargeImageFailure(message: e.message);
  } else if (e is EmailValidationFailure) {
    log("exception: email Exception");

    throw EmailValidationFailure(message: e.message);
  } else if (e is UserNotFoundFailure) {
    log("exception: user not found Exception");

    throw UserNotFoundFailure(message: e.message);
  } else if (e is Unauthorized) {
    log("exception: user auth Unauthorized");

    throw Unauthorized(message: e.message);
  } else if (e is TokenExpired) {
    log("exception: user auth TokenExpired");

    throw TokenExpired(message: e.message);
  } else if (e is LargeDocumentImageFailure) {
    throw LargeDocumentImageFailure(message: e.message);
  } else if (e is InvalidOTP) {
    throw InvalidOTP(message: e.message);
  } else if (e is ResendCodeFailiure) {
    throw ResendCodeFailiure(message: e.message);
  } else if (e is OTPExpired) {
    throw OTPExpired(message: e.message);
  } else if (e is CredentialValidationFailure) {
    throw CredentialValidationFailure(message: e.message);
  } else {
    log("exception:",
        error: " server exception", name: "handleThrownException");
    // showSnackBar(
    //     context: navigatorKey.currentContext!,
    //     title: "Something went wrong please try again later!");

    throw const ServerFailure(
        message: "Something went wrong please try again later!");
  }
}
