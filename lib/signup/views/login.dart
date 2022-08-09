import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptoPanic/home/repository/repository.dart';
import 'package:cryptoPanic/authentication/bloc/signIn_bloc.dart';
import 'package:cryptoPanic/home/views/HomePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cryptoPanic/constants/constants.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kCommonColor,
        body: Builder(
          builder: (context) {
            return BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationSuccess) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiRepositoryProvider(
                          providers: [
                            RepositoryProvider(
                              create: (context) => HomeRepository(),
                            ),
                          ],
                          child: HomePage(),
                        ),
                      ));
                } else if (state is AuthenticationFailiure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              buildWhen: (current, next) {
                if (next is AuthenticationSuccess) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is AuthenticationInitial ||
                    state is AuthenticationFailiure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://play-lh.googleusercontent.com/E1HD4Y1rp0RbbU-8kWBYodXy8nDEX8sIzrBeBb3F_Rd2IP5VblkhHWo2_oUwHTTpovE'),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Text(
                          'CRYPTO ',
                          style: kLoginHead1,
                        ),
                        const Text(
                          'PANIC',
                          style: kLoginHead2,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          width: 200.0,
                          child: TextButton.icon(
                            icon:const FaIcon(FontAwesomeIcons.google,color: kCommonColor,) ,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(3.0),
                              primary: kCommonColor,
                              backgroundColor: kBlack,
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () =>
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                              AuthenticationGoogleStarted(),
                            ),
                            label: const Text('Sign In With Google'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is AuthenticationLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: kBlack,
                  ));
                }
                return Center(
                    child: Text('Undefined state : ${state.runtimeType}'));
              },
            );
          },
        ),
      ),
    );
  }
}
