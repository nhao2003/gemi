import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GemiTextField extends StatefulWidget {
  final Function(String text, List<XFile>? images)? onSend;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Function()? onTap;
  final FocusNode? focusNode;
  const GemiTextField({
    super.key,
    this.onSend,
    this.padding,
    this.margin,
    this.onTap,
    this.focusNode,
  });

  @override
  State<GemiTextField> createState() => _GemiTextFieldState();
}

class _GemiTextFieldState extends State<GemiTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile>? _images;
  FocusNode? _focusNode;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusNode = widget.focusNode ?? FocusNode();
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: Column(
        children: [
          if (_images != null) _buildImageList(),
          TextField(
            autofocus: false,
            maxLines: 5,
            minLines: 1,
            focusNode: _focusNode,
            onTapOutside: (event) {
              _focusNode?.unfocus();
            },
            controller: _textEditingController,
            onTap: widget.onTap,
            decoration: InputDecoration(
                labelText: 'Enter a prompt here',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                filled: true,
                //e9eef6
                fillColor: const Color(0xffE9EEF6),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        tooltip: 'Upload image(s)',
                        onPressed: () {
                          _imagePicker.pickMultiImage().then((value) {
                            setState(() {
                              _images = value;
                            });
                          });
                        },
                        icon: const Icon(Icons.add_photo_alternate_outlined)),
                    IconButton(
                      tooltip: 'Use microphone',
                      onPressed: () {},
                      icon: const Icon(Icons.mic_none_outlined),
                    ),
                    IconButton(
                      tooltip: 'Submit',
                      onPressed: () {
                        widget.onSend?.call(
                          _textEditingController.text,
                          _images,
                        );
                        FocusScope.of(context).unfocus();
                        _textEditingController.clear();
                        setState(() {
                          _images = null;
                        });
                      },
                      icon: const Icon(Icons.send_outlined),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _images!.length,
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
                    child: FutureBuilder<Uint8List?>(
                      future: _images != null
                          ? _images![index].readAsBytes()
                          : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      tooltip: 'Remove image',
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          _images!.removeAt(index);
                        });
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
