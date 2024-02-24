import 'dart:io';

import 'package:flutter/material.dart';

class ImageRow extends StatelessWidget {
  final List<String> images;
  final Function(String)? onRemove;
  const ImageRow({super.key, required this.images, this.onRemove});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Code for viewing image
                    },
                    child: Image.file(
                      File(images[index]),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      tooltip: 'Remove image',
                      splashRadius: 20,
                      onPressed: () {
                        onRemove!(images[index]);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
