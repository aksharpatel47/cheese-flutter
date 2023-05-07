import 'package:flutter_app/utils/json_value_convertor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'standard_response.g.dart';

@JsonSerializable()
class ErrorMessage {
  String? errorId;
  int? statusCode;
  String? message;

  ErrorMessage(this.errorId, this.statusCode, this.message);

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => _$ErrorMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);
  static const fromJsonFactory = _$ErrorMessageFromJson;
}

@JsonSerializable()
class StandardResponse<OuterType, InnerType> {
  bool succeeded;
  List<ErrorMessage>? errors;
  String? message;
  @JsonKey(name: 'data')
  dynamic dataDoNotUse;

  @JsonKey(includeFromJson: false, includeToJson: false)
  OuterType? get data {
    try {
      if (dataDoNotUse != null) {
        if (dataDoNotUse is Iterable) {
          var value = JsonTypeParser.decodeList<InnerType>(dataDoNotUse);

          List<InnerType> newValue =
              value.map((e) => e.isValue ? e.asValue!.value : null).whereType<InnerType>().toList();

          return newValue is OuterType ? newValue as OuterType : null;
        } else {
          var value = JsonTypeParser.decode<InnerType>(dataDoNotUse);

          if (value.isValue) {
            var newValue = value.asValue!.value;

            if (newValue is OuterType)
              return newValue;
            else
              return null;
          }

          return null;
        }
      }
    } catch (e) {
      Logger().e(e.toString());
    }

    return null;
  }

  StandardResponse(this.succeeded, this.message, this.errors, this.dataDoNotUse);

  factory StandardResponse.fromData(dynamic newData) => StandardResponse(true, "", [], newData);

  factory StandardResponse.fromJson(Map<String, dynamic> json) => _$StandardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StandardResponseToJson(this);
  static const fromJsonFactory = _$StandardResponseFromJson;
}
