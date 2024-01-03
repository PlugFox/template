import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template_name/src/common/constant/pubspec.yaml.g.dart';
import 'package:flutter_template_name/src/common/localization/localization.dart';
import 'package:flutter_template_name/src/common/model/dependencies.dart';
import 'package:flutter_template_name/src/common/widget/scaffold_padding.dart';
import 'package:flutter_template_name/src/feature/developer/widget/logs_dialog.dart';
import 'package:octopus/octopus.dart';
import 'package:url_launcher/url_launcher_string.dart' as url_launcher;

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
            // --- App bar --- //

            SliverAppBar(
              title: Text(Localization.of(context).developer),
              pinned: true,
              floating: true,
              snap: true,
            ),

            // --- Authentication --- //

            _GroupSeparator(title: Localization.of(context).authentication),
            const _OpenUriTile(title: 'Profile', description: 'Information about current user'),
            const _OpenUriTile(title: 'Refresh session', description: 'Refresh current user\'s session'),
            const _OpenUriTile(title: 'Logout', description: 'Logout current user'),
            SliverPadding(
              padding: ScaffoldPadding.of(context).copyWith(top: 16, bottom: 16),
              sliver: const SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: Placeholder(),
                ),
              ),
            ),

            // --- Application information --- //

            _GroupSeparator(title: Localization.of(context).application),
            const _ShowApplicationInfoTile(),
            const _ShowLicensePageTile(),
            const _ShowApplicationDependenciesTile(),
            const _ShowApplicationDevDependenciesTile(),
            const _ShowLogsScreenTile(),

            // --- Navigation --- //

            _GroupSeparator(title: Localization.of(context).navigation),
            const _ResetNavigationTile(),

            // --- Database --- //

            _GroupSeparator(title: Localization.of(context).database),
            const _ViewDatabaseTile(),
            const _ClearDatabaseTile(),

            // --- Useful links --- //

            _GroupSeparator(title: Localization.of(context).usefulLinks),
            const _OpenUriTile(title: 'Flutter', description: 'Flutter website', uri: 'https://flutter.dev'),
            const _OpenUriTile(title: 'Flutter API', description: 'Framework API', uri: 'https://api.flutter.dev'),
            const _OpenUriTile(title: 'Portal', description: 'User portal'),
            const _OpenUriTile(title: 'Tasks', description: 'Tasks tracker'),
            const _OpenUriTile(title: 'Repository', description: 'Project repository'),
            const _OpenUriTile(title: 'Pull requests', description: 'Pull requests list'),
            const _OpenUriTile(title: 'Jenkins', description: 'CI/CD pipeline'),
            const _OpenUriTile(title: 'Figma', description: 'Designs system'),
            const _OpenUriTile(title: 'Firebase', description: 'Firebase console'),
            const _OpenUriTile(title: 'Sentry', description: 'Sentry console'),

            /* SliverPadding(
              padding: ScaffoldPadding.of(context).copyWith(top: 16, bottom: 16),
              sliver: SliverList.list(
                children: const <Widget>[],
              ),
            ), */

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      );
}

class _GroupSeparator extends StatelessWidget {
  const _GroupSeparator({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  width: 48,
                  child: Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1),
                ),
                const Expanded(
                  child: Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _CopyTile extends StatelessWidget {
  const _CopyTile({required this.title, this.subtitle, this.content});

  final String title;
  final String? subtitle;
  final String? content;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        // Add QR code generation
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: () {
          Clipboard.setData(ClipboardData(text: content ?? (subtitle == null ? title : '$title: $subtitle')));
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
                SnackBar(content: Text(Localization.of(context).copied), duration: const Duration(seconds: 3)));
        },
      );
}

class _ShowApplicationInfoTile extends StatelessWidget {
  const _ShowApplicationInfoTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('Application information'),
            subtitle: const Text(
              'Show information about the application.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Octopus.of(context).showDialog<void>(
              (context) => AboutDialog(
                /* applicationName: pubspec.name, */
                applicationVersion: Pubspec.version.representation,
                applicationIcon: const SizedBox.square(dimension: 64, child: Icon(Icons.apps, size: 64)),
                children: <Widget>[
                  const _CopyTile(
                    title: 'Name',
                    subtitle: Pubspec.name,
                    content: Pubspec.name,
                  ),
                  _CopyTile(
                    title: 'Version',
                    subtitle: Pubspec.version.representation,
                    content: Pubspec.version.representation,
                  ),
                  const _CopyTile(
                    title: 'Description',
                    subtitle: Pubspec.description,
                    content: Pubspec.description,
                  ),
                  const _CopyTile(
                    title: 'Homepage',
                    subtitle: Pubspec.homepage,
                    content: Pubspec.homepage,
                  ),
                  const _CopyTile(
                    title: 'Repository',
                    subtitle: Pubspec.repository,
                    content: Pubspec.repository,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _ShowLicensePageTile extends StatelessWidget {
  const _ShowLicensePageTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: Text(MaterialLocalizations.of(context).viewLicensesButtonLabel),
            subtitle: Text(
              MaterialLocalizations.of(context).licensesPageTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => showLicensePage(
              context: context,
              applicationName: Pubspec.name,
              applicationVersion: Pubspec.version.representation,
              applicationIcon: const SizedBox.square(dimension: 64, child: Icon(Icons.apps, size: 64)),
              useRootNavigator: true,
            ),
          ),
        ),
      );
}

class _ShowApplicationDependenciesTile extends StatelessWidget {
  const _ShowApplicationDependenciesTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('Dependencies'),
            subtitle: const Text(
              'Show dependencies.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Octopus.of(context).showDialog<void>(
              (context) => Dialog(
                insetPadding: const EdgeInsets.all(64),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: 480,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Dependencies',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          children: <Widget>[
                            for (final dependency in Pubspec.dependencies.entries)
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Chip(
                                  label: Text('${dependency.key}: ${dependency.value}'),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ShowApplicationDevDependenciesTile extends StatelessWidget {
  const _ShowApplicationDevDependenciesTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('Dev Dependencies'),
            subtitle: const Text(
              'Show developers dependencies.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Octopus.of(context).showDialog<void>(
              (context) => Dialog(
                insetPadding: const EdgeInsets.all(64),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: 480,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Dev Dependencies',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          children: <Widget>[
                            for (final dependency in Pubspec.devDependencies.entries)
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Chip(
                                  label: Text('${dependency.key}: ${dependency.value}'),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _ShowLogsScreenTile extends StatelessWidget {
  const _ShowLogsScreenTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('Logs'),
            subtitle: const Text(
              'Show logs.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => LogsDialog.show(context).ignore(),
          ),
        ),
      );
}

class _ResetNavigationTile extends StatelessWidget {
  const _ResetNavigationTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('Reset navigation'),
            subtitle: const Text(
              'Reset navigation stack.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Octopus.of(context).popAll(),
          ),
        ),
      );
}

class _ViewDatabaseTile extends StatelessWidget {
  const _ViewDatabaseTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('View database'),
            subtitle: const Text(
              'View database content.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Octopus.of(context).showDialog<void>(
              (_) => Dialog(
                child: DriftDbViewer(Dependencies.of(context).database),
              ),
            ),
          ),
        ),
      );
}

class _ClearDatabaseTile extends StatelessWidget {
  const _ClearDatabaseTile();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: ListTile(
            title: const Text('Drop database'),
            subtitle: const Text(
              'Clear database content.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              final db = Dependencies.of(context).database;
              Future<void>(() async {
                await db.customStatement('PRAGMA foreign_keys = OFF');
                try {
                  await db.batch((batch) {
                    // ignore: prefer_foreach
                    for (final table in db.allTables) batch.deleteAll(table);
                  });
                } finally {
                  await db.customStatement('PRAGMA foreign_keys = ON');
                }
              }).then<void>(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Database cleared'), duration: Duration(seconds: 3)),
                ),
                // ignore: inference_failure_on_untyped_parameter
                onError: (error) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Database clear failed: $error'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class _OpenUriTile extends StatelessWidget {
  const _OpenUriTile({
    required this.title,
    required this.description,
    this.uri,
    super.key, // ignore: unused_element
  });

  final String title;
  final String description;
  final String? uri;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: ScaffoldPadding.of(context),
        sliver: SliverToBoxAdapter(
          child: Opacity(
            opacity: uri == null ? 0.5 : 1,
            child: ListTile(
              title: Text(title),
              subtitle: Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: uri == null ? null : () => url_launcher.launchUrlString(uri!).ignore(),
            ),
          ),
        ),
      );
}
