


import 'package:artstation/repositories/repositories.dart';
import 'package:artstation/screens/signup/cubit/signup_cubit.dart';
import 'package:artstation/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                      content: state.failure.message,
                  )
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.orangeAccent,
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(children: <Widget>[
                              Text("CORGI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28), textAlign: TextAlign.center,),
                              Text("GRAM", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 28), textAlign: TextAlign.center),
                            ],
                              mainAxisAlignment: MainAxisAlignment.center,),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Username'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .usernameChanged(value),
                              validator: (value) => value.trim().isEmpty
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be at least 6 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () => _submitForm(
                                context,
                                state.status == SignupStatus.submitting,
                              ),
                              child: const Text('Sign Up'),
                            ),
                            const SizedBox(height: 12.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Colors.grey[200],
                              textColor: Colors.black,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Back to Login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}