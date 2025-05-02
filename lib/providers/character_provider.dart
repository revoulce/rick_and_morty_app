import 'package:flutter/material.dart';

import '../models/character_model.dart';
import '../services/graphql_service.dart';

class CharacterProvider with ChangeNotifier {
  final GraphQLService graphQLService;

  CharacterProvider(this.graphQLService);

  List<Character> _characters = [];
  bool _isLoading = false;

  List<Character> get characters => _characters;

  bool get isLoading => _isLoading;

  Future<void> loadCharacters() async {
    _isLoading = true;
    notifyListeners();

    _characters = await graphQLService.fetchCharacters();

    _isLoading = false;
    notifyListeners();
  }
}
