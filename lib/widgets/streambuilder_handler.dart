import 'package:flutter/material.dart';

class StreamBuilderHandler<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function toReturn;

  StreamBuilderHandler({required this.stream, required this.toReturn});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream,
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
