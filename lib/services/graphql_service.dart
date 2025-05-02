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

  Future<List<Character>> fetchCharacters() async {
    final String readCharacters = '''
    query {
      characters {
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
      QueryOptions(document: gql(readCharacters)),
    );

    if (result.hasException) {
      if (kDebugMode) {
        print('Error: ${result.exception.toString()}');
      }
      return [];
    }

    final data = result.data?['characters']['results'] as List<dynamic>;
    return data.map((json) => Character.fromJson(json)).toList();
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

  void dispose() {
    client.dispose();
  }
}
