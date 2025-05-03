import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/models/character_model.dart';

import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import '../models/sort_option.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  SortOption _sortOption = SortOption.idAsc;
  late Future<List<Character>> _futureFavorites;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final provider = Provider.of<CharacterProvider>(context, listen: false);
    _futureFavorites = provider.loadFavoriteCharacters();
  }

  List<Character> _sort(List<Character> list) {
    switch (_sortOption) {
      case SortOption.idAsc:
        return list..sort((a, b) => a.id.compareTo(b.id));
      case SortOption.idDesc:
        return list..sort((a, b) => b.id.compareTo(a.id));
      case SortOption.nameAsc:
        return list..sort((a, b) => a.name.compareTo(b.name));
      case SortOption.nameDesc:
        return list..sort((a, b) => b.name.compareTo(a.name));
      case SortOption.speciesAsc:
        return list..sort((a, b) => a.species.compareTo(b.species));
      case SortOption.speciesDesc:
        return list..sort((a, b) => b.species.compareTo(a.species));
      case SortOption.statusAsc:
        return list..sort((a, b) => a.status.compareTo(b.status));
      case SortOption.statusDesc:
        return list..sort((a, b) => b.status.compareTo(a.status));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          DropdownButton<SortOption>(
            value: _sortOption,
            onChanged: (value) {
              if (value != null) {
                setState(() => _sortOption = value);
                _loadFavorites();
              }
            },
            items:
                SortOption.values.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e.label));
                }).toList(),
          ),
        ],
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, value, child) {
          _futureFavorites = value.loadFavoriteCharacters();

          return FutureBuilder<List<Character>>(
            future: _futureFavorites,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final favorites = _sort(snapshot.data ?? []);

              if (favorites.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
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
              );
            },
          );
        },
      ),
    );
  }
}
