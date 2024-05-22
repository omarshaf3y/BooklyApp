import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection Timeout with api server');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send Timeout with api server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive Timeout with api server');

      case DioExceptionType.badCertificate:
        return ServerFailure('Bad Certificate with api server');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioException.response!.statusCode!, dioException.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Request tp Api server was canceled ');

      case DioExceptionType.connectionError:
        return ServerFailure('Connection Error with api server');

      case DioExceptionType.unknown:
        if (dioException.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection');
        }
        return ServerFailure('Unexpected Error, please try again later!');

      default:
        return ServerFailure('Oops There was an Error, Please try again later');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try again later');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server Error, Please try again later');
    } else {
      return ServerFailure('Oops There was an Error, Please try again later');
    }
  }
}
