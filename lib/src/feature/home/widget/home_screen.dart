import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/widget/common_actions.dart';

/// {@template home_screen}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro home_screen}
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: const Text('Home'),
            leading: const SizedBox.shrink(),
            actions: CommonActions(),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Home'),
                ],
              ),
            ),
          ),
        ],
      ));
}
