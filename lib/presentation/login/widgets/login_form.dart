import 'package:flutter/material.dart';
import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/presentation/auth/auth_bloc.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      bool isLoading = state.loadingStatus == LoadingStatus.InProgress;

      return Column(
        children: <Widget>[
          FormBuilder(
            enabled: !isLoading,
            key: _formKey,
            child: _getFormBody(context),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login"),
                      if (isLoading) ...[
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white.withOpacity(0.7),
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      );
    });
  }

  void _onLoginPressed() {
    _formKey.currentState?.save();
    if (_formKey.currentState?.validate() ?? false) {
      var formData = LoginFormData.fromJson(_formKey.currentState!.value);
      BlocProvider.of<AuthBloc>(context).add(
        AuthEvent.logIn(formData),
      );
    } else {
      print("validation failed");
    }
  }

  Widget _getFormBody(BuildContext context) {
    return Column(
      children: <Widget>[
        FormBuilderTextField(
          key: Key('username'),
          name: 'username',
          decoration: InputDecoration(labelText: 'Email or Phone number'),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        ),
        FormBuilderTextField(
          key: Key('password'),
          name: 'password',
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        ),
      ],
    );
  }
}
