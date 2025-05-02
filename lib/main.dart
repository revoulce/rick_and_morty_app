import 'package:flutter/material.dart';
import 'services/graphql_service.dart';

void main() {
  final graphqlService = GraphQLService();
  graphqlService.init();

  runApp(MyApp(graphQLService: graphqlService));
}

class MyApp extends StatelessWidget {
  final GraphQLService graphQLService;

  MyApp({required this.graphQLService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text("Rick and Morty")),
        body: Center(child: Text("GraphQL Initialized")),
      ),
    );
  }
}
