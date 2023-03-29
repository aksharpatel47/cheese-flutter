# flutter_app

A new Flutter application.

## Getting Started
```shell
flutterfire configure --project flutter-demo-61588
```

## Code Organization in Flutter Apps

A flutter app is organized into the following layers:

1. **UI layer**: Widgets that define the app's user interface.
2. **Business logic layer**: Widgets that define the app's state and business logic.
3. **Data layer**: Services and other objects that fetch and store data.
4. **Utilities**: Functions, variables and extensions used to reduce code duplication.

### UI Layer

The UI layer will have the following entities:

1. common_widgets: Widgets that are used across the app.
2. pages: Widgets that represent a page in the app.
  1. page_components: Widgets that are only used in a specific page.

### Business Logic Layer

The business logic layer will have the following files:

1. blocs: Business logic components.
2. state: State objects that are used by the blocs.

### Data Layer

The data layer will have the following files:

1. api clients: Classes that fetch data from the network.
2. local repositories: Classes that fetch data from the local database or cache.
3. services: Classes that are used as a utility to abstract away data fetching logic.
4. models: Classes that represent the data that is fetched from the network or local database.

### Utilities

The utilities layer will have the following:

1. extensions: Extensions that extend existing in-built or library classes.
2. functions: Utility functions that are used across the app.
3. constants: Constants that are used across the app.

## Description of different folders

1. common_widgets: Widgets that are used across the app.
2. presentation or pages: Widgets that represent a page in the app.
3. repositories: Classes that fetch data from the local database or cache.
4. apiclients: Classes that fetch data from the network.
5. services: Classes that are used as a utility to abstract away data fetching logic.
6. models: Classes that represent the data that is fetched from the network or local database.
7. utilities: Utility functions that are used across the app.

## Interface Oriented Programming

The ideal way to organize code in Flutter is to use the interface oriented programming paradigm. This means that the code should be organized around the interfaces that the code implements. This is in contrast to the traditional object oriented programming paradigm where the code is organized around the classes that the code inherits from.

For example,

```dart
// an example of a class without using interface oriented programming

class Logger {
  ConsoleWriter _consoleWriter = ConsoleWriter();

  void log(String text) {
    _consoleWriter.write(text);
  }
}

// example explaining interface oriented programming in dart
// similar to Writer interface in Golang

abstract class Writer {
  void write(String text);
}

class ConsoleWriter implements Writer {
  void write(String text) {
    print(text);
  }
}

class FileWriter implements Writer {
  void write(String text) {
    // write to file
  }
}

// A class that uses the Writer interface
class Logger {
  final Writer _writer;

  Logger(this._writer);

  void log(String text) {
    _writer.write(text);
  }
}
```

Advantages of using interface oriented programming:

1. The code is more loosely coupled.
2. Using tools like [Dart's code generation](https://pub.dev/packages/build_runner) and [Mockito](https://pub.dev/packages/mockito), we can easily generate mocks for the interfaces and use that for writing unit tests.
3. Doesn't take more effort from the developer since the IDE will automaticlly generate function definitions in the class that implements the interface.


```dart
// example of writing a test for logger class using Mockito

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Writer {
  void write(String text);
}

@GenerateMocks([MockSpec<Writer>()])
import 'writer.mocks.dart';

void main() {
  test('Logger writes to the writer', () {
    final mockWriter = MockWriter();
    final logger = Logger(mockWriter);

    logger.log('Hello');

    verify(mockWriter.write('Hello')).called(1);
  });
}
```

### How to implement interface oriented programming in Flutter?

1. Create an abstract class with the list of functions for the class that you plan to implement.
2. Create a class that implements the abstract class.

```dart

abstract class ApiClient {
  Future<List<Photo>> getPhotos();
}

class ApiClientImpl implements ApiClient {
  @override
  Future<List<Photo>> getPhotos() async {
    // fetch photos from network
  }
}
```

## Dependency Injection

Dependency injection is a software design pattern that allows us to implement the interface oriented programming paradigm in Flutter. It allows us to inject dependencies into the classes that need them. This technique allows us to write unit tests for the classes that use the dependencies.

```dart
// example of dependency injection in dart
abstract class Writer {
  void write(String text);
}

@Singleton(as: Writer)
class ConsoleWriter implements Writer {
  void write(String text) {
    print(text);
  }
}

@injectable
class Logger {
  final Writer _writer;

  Logger(this._writer);

  void log(String text) {
    _writer.write(text);
  }
}

// auto register dependencies in configure.dart
@injectableInit
Future<void> configureInjection(String environment) {
  $initGetIt(getIt, environment: environment);
}

// using configureInjection function in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Environment.prod);
  runApp(MyApp());
}
```

### Lifetime of dependencies

1. **Singleton**: The dependency is created only once and is reused across the app.
2. **Injectable**: The dependency is created every time it is injected.

### Library that allows us to implement dependency injection in Flutter

injectable: https://pub.dev/packages/injectable

The above library allows us to generate code needed for dependency injection. All the dependencies are automatically registered without the need to manually register them.

## State Management

State management is a technique that allows us to manage the state of the app. The state of the app can be anything from the current theme of the app to the current user logged in.

### Flutter Bloc

In most cases, we will use the [Flutter Bloc](https://pub.dev/packages/flutter_bloc) library to manage the state of the app.

```dart
// example of using flutter bloc using freezed

// state.dart

part 'state.freezed.dart';

@freezed
abstract class CounterState with _$CounterState {
  const factory CounterState({
    @required int count,
  }) = _CounterState;

  factory CounterState.initial() => CounterState(count: 0);
}

// events.dart

part 'events.freezed.dart';

@freezed
abstract class CounterEvent with _$CounterEvent {
  const factory CounterEvent.increment() = _Increment;
  const factory CounterEvent.decrement() = _Decrement;
}

// bloc.dart

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState.initial()) {
    on<CounterEvent>((event, emit) {
      event.map(
        increment: (_) => emit(state.copyWith(count: state.count + 1)),
        decrement: (_) => emit(state.copyWith(count: state.count - 1)),
      );
    });
  }
}
```

### Why use Freezed with Flutter Bloc?

1. The state of the app is immutable.
2. Freezed provides us with the ability to write union types (enums with data) in Dart.

```dart
// an example showing why we should use freezed with flutter bloc
// a simple enum showing the state of network request
enum NetworkState {
  loading,
  success,
  error,
}

// using freezed to write union types in dart
part 'network_state.freezed.dart';

@freezed
abstract class NetworkState with _$NetworkState {
  const factory NetworkState.loading() = _Loading;
  // success with result
  const factory NetworkState.success({@required String result}) = _Success;
  // error with error message
  const factory NetworkState.error({@required String message}) = _Error;
}

// using the NetworkState type in the bloc

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkState.loading()) {
    on<NetworkEvent>((event, emit) {
      event.map(
        fetch: (_) async {
          try {
            final result = await _fetchData();
            emit(NetworkState.success(result: result));
          } catch (e) {
            emit(NetworkState.error(message: e.toString()));
          }
        },
      );
    });
  }
}

// using the NetworkState type in the UI

class NetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => Center(child: CircularProgressIndicator()),
          success: (state) => Center(child: Text(state.result)),
          error: (state) => Center(child: Text(state.message)),
        );
      },
    );
  }
}
```

### Using Inherited Widgets for passing state

In some cases, we want our entire app to be aware of a particular state. In such cases, we can use the [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) class to pass the state to the entire app.

```dart
// example of using inherited widgets
// example inherited widget

class FrogColor extends InheritedWidget {
  const FrogColor({
    super.key,
    required this.color,
    required super.child,
  });

  final Color color;

  static FrogColor? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FrogColor>();
  }

  static FrogColor of(BuildContext context) {
    final FrogColor? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FrogColor oldWidget) => color != oldWidget.color;
}

// using the inherited widget in the UI

class FrogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FrogColor(
      color: Colors.green,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Frog', style: TextStyle(color: FrogColor.of(context).color))),
        ),
        body: Center(
          child: Frog(),
        ),
      );
  }
}

```

## Networking in Flutter

### Library to use for networking

Chopper: https://pub.dev/packages/chopper

### How to use Chopper?

```dart
// example chopperclient

part 'api.chopper.dart';

@ChopperApi(baseUrl: '/photos')
abstract class ApiClient extends ChopperService {
  static ApiClient create([ChopperClient client]) => _$ApiClient(client);

  @Get()
  Future<Response<List<Photo>>> getPhotos();
}

// example of using the chopper client
void main() async {
  final client = ChopperClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    services: [
      ApiClient.create(),
    ],
    converter: JsonConverter(),
  );

  final response = await client.getService<ApiClient>().getPhotos();
  print(response.body);
}
```

### Use Chopper with dependency injection

```dart
// example of using chopper with dependency injection

// api_client.dart

part 'api_client.chopper.dart';

@ChopperApi(baseUrl: '/photos')
abstract class ApiClient extends ChopperService {
  static ApiClient create([ChopperClient client]) => _$ApiClient(client);

  @Get()
  Future<Response<List<Photo>>> getPhotos();
}
```





## External libraries to use

1. Retrofit: https://pub.dev/packages/retrofit
2. Freezed: https://pub.dev/packages/freezed
3. Equatable: https://pub.dev/packages/equatable
4. Injectable: https://pub.dev/packages/injectable
5. mockito: https://pub.dev/packages/mockito
6. json_serializable: https://pub.dev/packages/json_serializable
7. Flutter Forms: https://pub.dev/packages/flutter_form_builder
8. Flutter Bloc: https://pub.dev/packages/flutter_bloc
9. go_router: https://pub.dev/packages/go_router
10. 