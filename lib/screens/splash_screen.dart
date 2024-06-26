import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(const FetchCharacters(0, 20));
    });
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return RotationTransition(
                turns: _controller,
                child: Image.asset('assets/logo.png'),
              );
            } else if (state is HomeLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigateToHomeScreen();
              });
              return const SizedBox.shrink();
            } else if (state is HomeError) {
              _controller.stop();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context).errorState(state.message)),
                  TextButton(
                    child: Text(AppLocalizations.of(context).retry),
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(const FetchCharacters(0, 20));
                      _controller.repeat();
                    },
                  ),
                ],
              );
            } else {
              return Text(AppLocalizations.of(context).unknownState);
            }
          },
        ),
      ),
    );
  }
}
