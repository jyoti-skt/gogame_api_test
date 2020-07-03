import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StaggeredContainer extends StatelessWidget {
  StaggeredContainer(
      {@required this.title, @required this.imagename, @required this.onTap});

  final String title;
  final String imagename;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: CachedNetworkImage(
              imageUrl: imagename,
              fit: BoxFit.fill,
              height: 200,
              width: 200,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
