import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';
import '../widgets/character_card.dart';

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
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: GridView.builder(
                  itemCount: provider.characters.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final character = provider.characters[index];
                    return CharacterCard(character: character);
                  },
                ),
              ),
    );
  }
}
