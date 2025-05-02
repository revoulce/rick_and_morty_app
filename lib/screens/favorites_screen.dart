import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';
import '../widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);
    final favorites = provider.favoriteCharacters;

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body:
          favorites.isEmpty
              ? const Center(child: Text('Нет избранных персонажей'))
              : Padding(
                padding: const EdgeInsets.all(6),
                child: GridView.builder(
                  itemCount: favorites.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return CharacterCard(character: favorites[index]);
                  },
                ),
              ),
    );
  }
}
