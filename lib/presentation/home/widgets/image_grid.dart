import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/enums/enums.dart';

class ImageGrid extends StatelessWidget {
  final List<String> images;
  final Function(int index)? onMediaTap;

  const ImageGrid(this.images, {Key? key, this.onMediaTap}) : super(key: key);

  int _columnCount(double width) {
    Breakpoint breakpoint = Breakpoint.fromWidth(width);
    print("Length: ${images.length}");
    if (images.length == 1) {
      return 1;
    }
    if (breakpoint == Breakpoint.mobile) {
      return (images.length == 2 || images.length == 4) ? 2 : 3;
    } else {
      return (width ~/ 200).toInt();
    }
  }

  BoxConstraints? _getConstraints(Breakpoint breakpoint) {
    print(breakpoint);
    switch (breakpoint) {
      case Breakpoint.mobile:
        return null;
      case Breakpoint.tablet:
        return const BoxConstraints(maxWidth: 100);
      case Breakpoint.desktop:
      default:
        return const BoxConstraints(maxWidth: 100);
    }
  }

  Widget _mobileView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columnCount(599.0),
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          key: ValueKey(index),
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: onMediaTap != null ? () => onMediaTap!(index) : null,
            child: Image.file(
              File(images[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Breakpoint breakpoint = Breakpoint.fromWidth(width);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return breakpoint == Breakpoint.mobile
            ? _mobileView()
            : Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    constraints: _getConstraints(breakpoint),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: onMediaTap != null
                            ? () => onMediaTap!(images.indexOf(images[index]))
                            : null,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.file(
                            File(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
