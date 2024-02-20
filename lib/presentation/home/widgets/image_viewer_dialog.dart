import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageViewDialog extends StatefulWidget {
  final List<String> images;
  final int? initialIndex;

  const ImageViewDialog(this.images, {this.initialIndex = 0, super.key});
  @override
  State<ImageViewDialog> createState() => _ImageViewDialogState();
}

class _ImageViewDialogState extends State<ImageViewDialog> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex!);
    _currentIndex = widget.initialIndex!;
  }

  void switchPage(int index) {
    if ((_pageController!.page! - index).abs() > 1) {
      _pageController!.jumpToPage(index);
    } else {
      _pageController!.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  PageController? _pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Close',
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.images.length,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  key: ValueKey(index),
                  child: Image.file(
                    File(widget.images[index]),
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: index == _currentIndex
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    key: ValueKey(index),
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          switchPage(index);
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.file(
                          File(widget.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
