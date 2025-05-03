import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/providers/theme_provider.dart';

import '../providers/character_provider.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFirstLoad = true;

  void _setupScrollListener(CharacterProvider provider) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.loadCharacters();
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isFirstLoad) {
      final provider = Provider.of<CharacterProvider>(context, listen: false);

      provider.loadCharactersFromCache().then((value) {
        provider.loadCharacters();
      });

      _setupScrollListener(provider);
      _isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Список персонажей'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleThemeMode();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: GridView.builder(
          controller: _scrollController,
          itemCount: provider.characters.length + (provider.hasMore ? 1 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            if (index >= provider.characters.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final character = provider.characters[index];
            return CharacterCard(character: character);
          },
        ),
      ),
    );
  }
}
