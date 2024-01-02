import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/localization/localization.dart';
import 'package:flutter_template_name/src/common/widget/scaffold_padding.dart';

/// {@template developer_screen}
/// DeveloperScreen widget.
/// {@endtemplate}
class DeveloperScreen extends StatelessWidget {
  /// {@macro developer_screen}
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(Localization.of(context).developer),
              pinned: true,
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: ScaffoldPadding.of(context).copyWith(top: 16, bottom: 16),
              sliver: SliverList.list(
                children: const <Widget>[],
              ),
            ),
          ],
        ),
      );
}
