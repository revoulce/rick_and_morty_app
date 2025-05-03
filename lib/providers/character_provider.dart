import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/character_model.dart';
import '../services/graphql_service.dart';

class CharacterProvider with ChangeNotifier {
  final GraphQLService graphQLService;

  final Box<String> _favoritesBox = Hive.box<String>('favorites');

  final Box<Character> cacheBox = Hive.box<Character>('characters_cache');

  final List<Character> _characters = [];

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  CharacterProvider(this.graphQLService);

  List<Character> get characters => _characters;

  Set<String> get favorites => _favoritesBox.values.toSet();

  bool get hasMore => _hasMore;

  bool get isLoading => _isLoading;

  bool isFavorite(String id) => _favoritesBox.containsKey(id);

  Future<void> loadCharacters({bool isRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    if (isRefresh) {
      _characters.clear();
      _currentPage = 1;
      _hasMore = true;
      cacheBox.clear();
    }

    final result = await graphQLService.fetchCharactersPage(_currentPage);
    final newCharacters = result['characters'] as List<Character>;

    _characters.addAll(newCharacters);
    _currentPage = result['nextPage'] ?? _currentPage;
    _hasMore = result['nextPage'] != null;

    for (var c in newCharacters) {
      cacheBox.put(c.id, c);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Character>> loadFavoriteCharacters() async {
    final ids = _favoritesBox.keys.cast<String>().toList();

    List<Character> favorites = [];

    for (final id in ids) {
      final existing = _characters.firstWhere(
        (element) => element.id == id,
        orElse:
            () => Character(
              id: '',
              name: '',
              status: '',
              species: '',
              gender: '',
              image: '',
            ),
      );

      if (existing.id.isNotEmpty) {
        favorites.add(existing);
      } else {
        final fetched = await graphQLService.fetchCharacterById(id);
        if (fetched != null) {
          favorites.add(fetched);
        }
      }
    }

    return favorites;
  }

  Future<void> loadCharactersFromCache() async {
    final cachedCharacters = cacheBox.values.toList();
    _characters.addAll(cachedCharacters);
    notifyListeners();
  }

  void toggleFavorite(Character character) {
    if (isFavorite(character.id)) {
      _favoritesBox.delete(character.id);
    } else {
      _favoritesBox.put(character.id, character.name);
    }
    notifyListeners();
  }
}
