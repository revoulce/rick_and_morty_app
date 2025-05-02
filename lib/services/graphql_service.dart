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

  void dispose() {
    client.dispose();
  }
}
