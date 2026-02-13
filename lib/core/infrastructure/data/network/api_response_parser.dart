import 'package:injectable/injectable.dart';

import '../../../utils/log.dart';
import 'api_client.dart';
import '../../../services/parser/payload_parser.dart';

abstract class APIResponseParser {
  Future<T> parse<T>({
    required int? statusCode,
    required String? message,
    required Map<String, dynamic> data,
    required APICallback parser,
  });
}

@LazySingleton(as: APIResponseParser)
class IsolateAPIResponseParser implements APIResponseParser {
  static const String _parserKey = 'parser';
  static const String _statusCodeKey = 'statusCode';
  static const String _messageKey = 'message';
  static const String _dataKey = 'data';
  final PayloadParser _payloadParser;

  IsolateAPIResponseParser(PayloadParser payloadParser)
      : _payloadParser = payloadParser;

  @override
  Future<T> parse<T>({
    required int? statusCode,
    required String? message,
    required Map<String, dynamic> data,
    required APICallback parser,
  }) async {
    try {
      return await _payloadParser.parse<T>(
        input: <String, dynamic>{
          _parserKey: parser,
          _statusCodeKey: statusCode,
          _messageKey: message,
          _dataKey: data,
        },
        parser: IsolateAPIResponseParser._parseInIsolate,
      );
    } catch (error, stackTrace) {
      Log.warning('Isolate parsing failed, falling back to main isolate.');
      Log.error('[API Parse Fallback]', error: error, stackTrace: stackTrace);
      return parser(statusCode, message, data) as T;
    }
  }

  static dynamic _parseInIsolate(dynamic args) {
    final parser = args[_parserKey] as APICallback<dynamic>;
    final statusCode = args[_statusCodeKey] as int?;
    final message = args[_messageKey] as String?;
    final data = Map<String, dynamic>.from(args[_dataKey] as Map);
    return parser(statusCode, message, data);
  }
}
