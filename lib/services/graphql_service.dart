import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/character_model.dart';

class GraphQLService {
  late ValueNotifier<GraphQLClient> client;

  final String _url = 'https://rickandmortyapi.com/graphql';

  void init() {
    final HttpLink httpLink = HttpLink(_url);

    client = ValueNotifier(
      GraphQLClient(cache: GraphQLCache(), link: httpLink),
    );
  }

  Future<Map<String, dynamic>> fetchCharactersPage(int page) async {
    final String query = r'''
      query($page: Int!) {
        characters(page: $page) {
          info {
            next
          }
          results {
            id
            name
            status
            species
            gender
            image
          }
        }
      }
    ''';

    final result = await client.value.query(
      QueryOptions(document: gql(query), variables: {'page': page}),
    );

    if (result.hasException) {
      if (kDebugMode) {
        print('Error: ${result.exception.toString()}');
      }
      return {'characters': [], 'nextPage': null};
    }

    final data = result.data?['characters']['results'] as List<dynamic>;
    return {
      'characters': data.map((e) => Character.fromJson(e)).toList(),
      'nextPage': result.data?['characters']['info']['next'],
    };
  }

  Future<Character?> fetchCharacterById(String id) async {
    const String query = r'''
      query($id: ID!) {
        character(id: $id) {
          id
          name
          status
          species
          gender
          image
        }
      }
    ''';

    final result = await client.value.query(
      QueryOptions(document: gql(query), variables: {'id': id}),
    );

    if (result.hasException) {
      if (kDebugMode) {
        print('Error: ${result.exception.toString()}');
      }
      return null;
    }

    final data = result.data?['character'];

    if (data == null) {
      return null;
    }

    return Character.fromJson(data);
  }

  void dispose() {
    client.dispose();
  }
}
