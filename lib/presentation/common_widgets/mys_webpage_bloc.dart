import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'mys_webpage_bloc.freezed.dart';

@injectable
class MYSWebPageBloc extends Bloc<MYSWebPageEvent, MYSWebPageState> {
  MYSWebPageBloc() : super(MYSWebPageState(1, true, null)) {
    on<MYSWebPageEvent>((event, emit) async {
      await event.when(
        updateHeight: (int height) async {
          emit(state.copyWith(height: height));
        },
        updateLoadingState: (bool isLoading) async {
          emit(state.copyWith(isLoading: isLoading));
        },
        viewLoaded: (InAppWebViewController webViewController) async {
          emit(state.copyWith(webViewController: webViewController));
        },
      );
    });
  }
}

@freezed
class MYSWebPageState with _$MYSWebPageState {
  const factory MYSWebPageState(int height, bool isLoading, InAppWebViewController? webViewController) = _State;
}

@freezed
class MYSWebPageEvent with _$MYSWebPageEvent {
  const factory MYSWebPageEvent.updateHeight(int height) = _UpdateHeight;
  const factory MYSWebPageEvent.updateLoadingState(bool isLoading) = _UpdateLoadingState;
  const factory MYSWebPageEvent.viewLoaded(InAppWebViewController webViewController) = _ViewLoaded;
}
