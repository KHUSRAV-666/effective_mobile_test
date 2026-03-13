import 'package:effective_mobile_test/core/theme/app_spacing.dart';
import 'package:effective_mobile_test/features/home/presentation/providers/hero_provider.dart';
import 'package:effective_mobile_test/shared/widgets/hero/hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(heroNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(heroNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Герои Rick & Morty')),
      body: charactersAsync.when(
        data: (characters) => ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.s),
          itemCount: characters.length + 1,
          itemBuilder: (context, index) {
            if (index < characters.length) {
              return HeroCard(hero: characters[index]);
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
          },
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
      ),
    );
  }
}
