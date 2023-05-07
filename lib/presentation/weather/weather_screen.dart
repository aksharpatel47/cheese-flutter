import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common_widgets/drawer.dart';
import 'package:flutter_app/presentation/weather/weather_bloc.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

class WeatherScreen extends StatelessWidget {
  static String id = "weather";
  static String path = "/$id";

  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Screen"),
      ),
      drawer: AppDrawer(),
      body: BlocProvider<WeatherBloc>(
        create: (context) => GetIt.I<WeatherBloc>(),
        child: Builder(builder: (context) {
          return BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  success: (_) {
                    formKey.currentState?.fields['search']?.didChange(null);
                  });
            },
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  WeatherSearchBar(formKey: formKey),
                  Expanded(
                    child: BlocBuilder<WeatherBloc, WeatherState>(
                      builder: (context, state) {
                        return state.when(
                          success: (weather) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  weather.location.fullLocation,
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Weather on\n", style: TextStyle(fontSize: 17, color: Colors.grey)),
                                      TextSpan(
                                          text: weather.current.observationTime,
                                          style: TextStyle(fontSize: 25, color: Colors.black)),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (weather.current.weatherIcons.isNotEmpty) ...[
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Image.network(weather.current.weatherIcons.first)
                                ],
                                if (weather.current.weatherDescriptions.isNotEmpty) ...[
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    weather.current.weatherDescriptions.first,
                                    style: TextStyle(fontSize: 30),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ],
                            );
                          },
                          empty: (loadingStatus, failure) {
                            if (loadingStatus == LoadingStatus.Error && failure != null)
                              return Center(child: Text(failure.message));
                            else if (loadingStatus == LoadingStatus.InProgress)
                              return Center(child: CircularProgressIndicator());
                            else
                              return SizedBox();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class WeatherSearchBar extends StatelessWidget {
  const WeatherSearchBar({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: FormBuilderTextField(
              name: 'search',
              decoration: InputDecoration(hintText: 'Enter City'),
              textCapitalization: TextCapitalization.words,
              validator: FormBuilderValidators.required(),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              if (formKey.currentState?.saveAndValidate() ?? false) {
                String search = formKey.currentState?.fields['search']?.value ?? '';
                context.read<WeatherBloc>().add(WeatherEvent.search(search));
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
