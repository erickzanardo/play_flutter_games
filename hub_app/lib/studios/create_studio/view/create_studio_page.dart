import 'package:flutter/material.dart';
import 'package:hub_domain/hub_domain.dart';

class CreateStudioPage extends StatelessWidget {
  const CreateStudioPage({super.key});

  static Route<Studio?> route() {
    return MaterialPageRoute(
      builder: (_) => const CreateStudioPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CreateStudioView();
  }
}

class CreateStudioView extends StatelessWidget {
  const CreateStudioView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
