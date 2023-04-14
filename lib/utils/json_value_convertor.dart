import 'package:async/async.dart';
import 'package:flutter_app/models/address.dart';
import 'package:flutter_app/models/cheese_error.dart';
import 'package:flutter_app/models/contact.dart';
import 'package:flutter_app/models/email.dart';
import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/remote_config_data.dart';
import 'package:flutter_app/models/todo.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/weather.dart';

class JsonTypeParser {
  static Result<T> decode<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      throw Exception(T.toString());
    }
    return Result.value(jsonFactory(values));
  }

  static List<Result<T>> decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<Result<T>>((v) => decode<T>(v)).toList();
}

typedef T JsonFactory<T>(Map<String, dynamic> json);

const Map<Type, JsonFactory> factories = {
  Person: Person.fromJson,
  Contact: Contact.fromJson,
  Email: Email.fromJson,
  Address: Address.fromJson,
  Token: Token.fromJson,
  RemoteConfigData: RemoteConfigData.fromJson,
  User: User.fromJson,
  Weather: Weather.fromJson,
  WeatherRequest: WeatherRequest.fromJson,
  Location: Location.fromJson,
  Current: Current.fromJson,
  Todo: Todo.fromJson,
  TodoResponse: TodoResponse.fromJson,
  TodoStatus: TodoStatus.fromJson,
  CheeseError: CheeseError.fromJson,
  Map: mapFunction,
};

Map mapFunction(Map<String, dynamic> json) {
  return json;
}
