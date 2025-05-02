import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  late ValueNotifier<GraphQLClient> client;

  final String _url = 'https://rickandmortyapi.com/graphql';

  void init() {
    final HttpLink httpLink = HttpLink(_url);

    client = ValueNotifier(
      GraphQLClient(cache: GraphQLCache(), link: httpLink),
    );
  }

  Future<List<dynamic>> fetchCharacters() async {
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

    return result.data?['characters']['results'] ?? [];
  }

  void dispose() {
    client.dispose();
  }
}
