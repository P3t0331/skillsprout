import 'package:flutter/material.dart';

class FutureBuilderHandler<T> extends StatelessWidget {
  final Future<T> future;
  final Function toReturn;

  FutureBuilderHandler({required this.future, required this.toReturn});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return toReturn(snapshot);
        });
  }
}
