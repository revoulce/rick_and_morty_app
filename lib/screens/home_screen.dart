import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFirsLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirsLoad) {
      final provider = Provider.of<CharacterProvider>(context, listen: false);
      provider.loadCharacters();
      _isFirsLoad = false;
    }
  }

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
    );
  }
}
