import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'newsPage.dart';
import 'package:cryptoPanic/authentication/bloc/signIn_bloc.dart';
import 'package:cryptoPanic/signup/views/login.dart';
import 'package:cryptoPanic/constants/constants.dart';

///widget for home page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlack,
          leading: const Icon(
            Icons.rss_feed,
            color: kColor,
          ),
          title: const Text(
            'News',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                letterSpacing: 0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              children: [
                /// fetching Profile picture
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage('${user?.photoURL}'),
                ),
                SizedBox(
                  width: 3.0,
                ),

                ///fetching User name
                Text('${user?.displayName}'),
                const SizedBox(
                  width: 2.0,
                ),
                /// logOut
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    size: 10.0,
                    color: kColor,
                  ),
                  onPressed: () =>
                      BlocProvider.of<AuthenticationBloc>(context).add(
                    AuthenticationExited(),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              ///  unsuccessfull authentication
              if (state is AuthenticationFailiure) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              }
            },

            ///Authentication
            builder: (context, state) {
              if (state is AuthenticationInitial) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationStarted());
                return CircularProgressIndicator(
                  color: kCommonColor,
                );
              } else if (state is AuthenticationLoading) {
                return CircularProgressIndicator(
                  color: kCommonColor,
                );
              } else if (state is AuthenticationSuccess) {
                /// route to news page
                return NewsPage();
              }
              return Text('Undefined state : ${state.runtimeType}');
            },
          ),
        ),
      ),
    );
  }
}
