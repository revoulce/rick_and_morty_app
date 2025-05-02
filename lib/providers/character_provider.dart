import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/character_model.dart';
import '../services/graphql_service.dart';

class CharacterProvider with ChangeNotifier {
  final GraphQLService graphQLService;

  final Box<String> _favoritesBox = Hive.box<String>('favorites');

  CharacterProvider(this.graphQLService);

  List<Character> _characters = [];
  bool _isLoading = false;

  List<Character> get characters => _characters;

  bool get isLoading => _isLoading;

  Set<String> get favorites => _favoritesBox.values.toSet();

  bool isFavorite(String id) => _favoritesBox.containsKey(id);

  List<Character> get favoriteCharacters =>
      _characters.where((c) => isFavorite(c.id)).toList();

  Future<void> loadCharacters() async {
    _isLoading = true;
    notifyListeners();

    _characters = await graphQLService.fetchCharacters();

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
