import 'dart:io';

import 'package:dio/dio.dart';

import '../failure/failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is SocketException) {
      return Failure(
        failureMessage: 'No internet connection. Please check your network.',
      );
    }

    if (error is FormatException || error is TypeError) {
      return Failure(
        failureMessage: 'Something went wrong while processing the data.',
      );
    }

    return Failure(
      failureMessage: 'Something went wrong. Please try again later.',
    );
  }

  static Failure _handleDioError(DioException error) {
    final message = _extractServerMessage(error.response?.data);
    final ecommerceFailure = _handleEcommerceError(message);

    if (ecommerceFailure != null) {
      return ecommerceFailure;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(
          failureMessage: 'Connection timed out. Please try again.',
        );

      case DioExceptionType.sendTimeout:
        return Failure(failureMessage: 'Request timed out while sending data.');

      case DioExceptionType.receiveTimeout:
        return Failure(failureMessage: 'The server took too long to respond.');

      case DioExceptionType.badCertificate:
        return Failure(
          failureMessage: 'A secure connection could not be established.',
        );

      case DioExceptionType.connectionError:
        return Failure(
          failureMessage: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.cancel:
        return Failure(failureMessage: 'The request was cancelled.');

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.unknown:
        return Failure(failureMessage: 'An unexpected network error occurred.');
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static Failure _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return Failure(
          failureMessage: 'Invalid request. Please check your input.',
        );

      case 401:
        return Failure(
          failureMessage: 'Your session has expired. Please log in again.',
        );

      case 403:
        return Failure(
          failureMessage: 'You do not have permission to perform this action.',
        );

      case 404:
        return Failure(
          failureMessage: 'The requested resource could not be found.',
        );

      case 405:
        return Failure(
          failureMessage: 'This action is not supported by the server.',
        );

      case 408:
        return Failure(
          failureMessage: 'The request timed out. Please try again.',
        );

      case 409:
        return Failure(
          failureMessage: 'A conflict occurred. Please refresh and try again.',
        );

      case 410:
        return Failure(failureMessage: 'This resource is no longer available.');

      case 413:
        return Failure(
          failureMessage: 'The uploaded file or request is too large.',
        );

      case 415:
        return Failure(
          failureMessage: 'The server does not support this data format.',
        );

      case 422:
        return Failure(
          failureMessage:
              'Some information is invalid. Please check your input.',
        );

      case 429:
        return Failure(
          failureMessage: 'Too many requests. Please wait and try again.',
        );

      case 500:
        return Failure(failureMessage: 'An internal server error occurred.');

      case 501:
        return Failure(
          failureMessage: 'This feature is not supported by the server.',
        );

      case 502:
        return Failure(
          failureMessage: 'The server received an invalid response.',
        );

      case 503:
        return Failure(
          failureMessage: 'The service is temporarily unavailable.',
        );

      case 504:
        return Failure(failureMessage: 'The server took too long to respond.');

      default:
        if (statusCode != null && statusCode >= 500) {
          return Failure(
            failureMessage: 'A server error occurred. Please try again later.',
          );
        }

        if (statusCode != null && statusCode >= 400) {
          return Failure(failureMessage: 'The request could not be completed.');
        }

        return Failure(
          failureMessage: 'An unexpected error occurred. Please try again.',
        );
    }
  }

  static Failure? _handleEcommerceError(String? message) {
    if (message == null || message.isEmpty) return null;

    final text = message.toLowerCase();

    // Product inventory
    if (text.contains('out of stock') ||
        text.contains('insufficient stock') ||
        text.contains('insufficient quantity')) {
      return Failure(
        failureMessage: 'This product does not have enough stock available.',
      );
    }

    if (text.contains('product unavailable') ||
        text.contains('product is unavailable') ||
        text.contains('product not available')) {
      return Failure(failureMessage: 'This product is currently unavailable.');
    }

    // Coupons and discounts
    if (text.contains('invalid coupon') ||
        text.contains('invalid promo code') ||
        text.contains('coupon expired') ||
        text.contains('coupon has expired')) {
      return Failure(
        failureMessage: 'This discount code is invalid or has expired.',
      );
    }

    if (text.contains('minimum order')) {
      return Failure(
        failureMessage: 'Your order does not meet the minimum purchase amount.',
      );
    }

    // Payments
    if (text.contains('payment failed') || text.contains('payment declined')) {
      return Failure(
        failureMessage: 'Payment failed. Please try another payment method.',
      );
    }

    if (text.contains('payment timeout')) {
      return Failure(
        failureMessage: 'Payment timed out. Please verify your order status.',
      );
    }

    // Authentication
    if (text.contains('token expired') ||
        text.contains('token has expired') ||
        text.contains('jwt expired')) {
      return Failure(
        failureMessage: 'Your session has expired. Please log in again.',
      );
    }

    // Cart
    if (text.contains('cart is empty') || text.contains('empty cart')) {
      return Failure(
        failureMessage: 'Your cart is empty. Add products before checkout.',
      );
    }

    // Orders
    if (text.contains('order not found')) {
      return Failure(failureMessage: 'We could not find this order.');
    }

    return null;
  }

  static String? _extractServerMessage(dynamic data) {
    if (data is String) return data;

    if (data is Map) {
      for (final key in ['message', 'error_description', 'error', 'detail']) {
        final value = data[key];

        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return null;
  }
}
