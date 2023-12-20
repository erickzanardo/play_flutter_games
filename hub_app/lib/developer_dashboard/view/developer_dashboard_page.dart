import 'package:flutter/material.dart';
import 'package:play_flutter_games_hub/l10n/l10n.dart';
import 'package:play_flutter_games_hub/studios/studios.dart';

class DeveloperDashboardPage extends StatelessWidget {
  const DeveloperDashboardPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const DeveloperDashboardPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DeveloperDashboardView();
  }
}

class DeveloperDashboardView extends StatelessWidget {
  const DeveloperDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.developerDashboard),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  UserStudiosPage.route(),
                );
              },
              child: Text(l10n.myStudios),
            ),
          ],
        ),
      ),
    );
  }
}
