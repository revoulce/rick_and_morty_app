import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Список персонажей')),
      body:
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: provider.characters.length,
                itemBuilder: (context, index) {
                  final character = provider.characters[index];

                  return ListTile(
                    leading: Image.network(character.image),
                    title: Text(character.name),
                    subtitle: Text(
                      '${character.species} - ${character.status}',
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.loadCharacters(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
