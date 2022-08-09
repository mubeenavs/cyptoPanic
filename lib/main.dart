import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication/bloc/signIn_bloc.dart';

import 'authentication/providers/firebase.dart';
import 'authentication/providers/googleSignIn.dart';
import 'authentication/repository/auth_repository.dart';
import 'home/repository/repository.dart';
import 'home/views/HomePage.dart';
import 'package:cryptoPanic/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        authenticationRepository: AuthenticationRepository(
          authenticationFirebaseProvider: AuthenticationFirebaseProvider(
            firebaseAuth: FirebaseAuth.instance,
          ),
          googleSignInProvider: GoogleSignInProvider(
            googleSignIn: GoogleSignIn(),
          ),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kBlack,
        ),
        home: MultiRepositoryProvider(
          child: HomePage(),
          providers: [
            RepositoryProvider(
              create: (context) => HomeRepository(),
            ),
          ],
        ),
      ),
    );
  }
}
