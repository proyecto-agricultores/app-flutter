import 'package:agricultores_app/services/token.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

enum WithToken { yes, no }

class HTTPClient {
  static Client getClient(WithToken withToken) {
    if (withToken == WithToken.yes) {
      return HttpClientWithInterceptor.build(
        interceptors: [
          LoggingInterceptorWithToken(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(),
      );
    } else {
      return HttpClientWithInterceptor.build(
        interceptors: [
          LoggingInterceptorWithNoToken(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(),
      );
    }
  }
}

class LoggingInterceptorWithToken implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    final accessToken = await Token.getToken(TokenType.access);
    try {
      data.headers["Content-Type"] = "application/json";
      data.headers['Authorization'] = 'Bearer ' + accessToken;
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}

class LoggingInterceptorWithNoToken implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      data.headers["Content-Type"] = "application/json";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      await Token.refreshToken();
      return true;
    }
    return false;
  }
}
