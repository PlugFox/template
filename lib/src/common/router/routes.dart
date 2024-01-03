import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/feature/account/widget/profile_screen.dart';
import 'package:flutter_template_name/src/feature/account/widget/settings_dialog.dart';
import 'package:flutter_template_name/src/feature/authentication/widget/signin_screen.dart';
import 'package:flutter_template_name/src/feature/authentication/widget/signup_screen.dart';
import 'package:flutter_template_name/src/feature/developer/widget/developer_screen.dart';
import 'package:flutter_template_name/src/feature/home/widget/home_screen.dart';
import 'package:octopus/octopus.dart';

enum Routes with OctopusRoute {
  signin('signin', title: 'Sign-In'),
  signup('signup', title: 'Sign-Up'),
  home('home', title: 'Octopus'),
  profile('profile', title: 'Profile'),
  developer('developer', title: 'Developer'),
  settingsDialog('settings-dialog', title: 'Settings');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(BuildContext context, OctopusNode node) => switch (this) {
        Routes.signin => const SignInScreen(),
        Routes.signup => const SignUpScreen(),
        Routes.home => const HomeScreen(),
        Routes.profile => const ProfileScreen(),
        Routes.developer => const DeveloperScreen(),
        Routes.settingsDialog => const SettingsDialog(),
      };
}
