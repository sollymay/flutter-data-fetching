import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  Widget build(context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        final item = snapshot.data;
        final commentsList = item.kids.map((kidId) {
          return Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          );
        }).toList();

        return Column(
          children: <Widget>[
            ListTile(
              title: buildText(item),
              subtitle: item.by == "" ? Text('Comment Deleted') : Text(item.by),
              contentPadding: EdgeInsets.only(
                left: 16.0 * (depth + 1),
                right: 16.0,
              ),
            ),
            Divider(),
            ...commentsList,
          ],
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', "\n\n")
        .replaceAll('</p>', '')
        .replaceAll('&#x2F;', "/");

    return Text(text);
  }
}
