import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/character_model.dart';
import '../services/graphql_service.dart';

class CharacterProvider with ChangeNotifier {
  final GraphQLService graphQLService;

  final Box<String> _favoritesBox = Hive.box<String>('favorites');

  final List<Character> _characters = [];

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  CharacterProvider(this.graphQLService);

  List<Character> get characters => _characters;

  Set<String> get favorites => _favoritesBox.values.toSet();

  List<Character> get favoriteCharacters =>
      _characters.where((c) => isFavorite(c.id)).toList();

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
    }

    final result = await graphQLService.fetchCharactersPage(_currentPage);
    final newCharacters = result['characters'] as List<Character>;

    _characters.addAll(newCharacters);
    _currentPage = result['nextPage'] ?? _currentPage;
    _hasMore = result['nextPage'] != null;

    _isLoading = false;
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
