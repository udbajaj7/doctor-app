import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../../../Models/MedicalFiles.dart';
import '../../../components/size_config.dart';

class ImageListView extends StatelessWidget {
  final int index;
  final List<MedicalFiles> images;

  ImageListView({required this.images, required this.index});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // final double itemHeight = getProportionateScreenHeight(300);
    PageController _controller = PageController(initialPage: index);

    return Material(
      color: Colors.white,
      // child: PhotoViewGallery.builder(
      //   scrollPhysics: const BouncingScrollPhysics(),
      //   builder: (BuildContext context, int index) {
      //     return PhotoViewGalleryPageOptions(
      //       imageProvider:
      //           Image.memory(base64Decode(images[index].fileData)).image,
      //       // initialScale:
      //       //     PhotoViewComputedScale.contained *
      //       //         0.8,
      //       // heroAttributes:
      //       //     PhotoViewHeroAttributes(
      //       //         tag: galleryItems[index].id),
      //     );
      //   },
      //   itemCount: images.length,
      //   loadingBuilder: (context, event) => Center(
      //     child: Container(
      //       width: getProportionateScreenWidth(20),
      //       height: getProportionateScreenHeight(20),
      //       child: CircularProgressIndicator(
      //         value: event == null
      //             ? 0
      //             : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
      //       ),
      //     ),
      //   ),
      //   pageController: _controller,
      //   // backgroundDecoration:
      //   //     widget.backgroundDecoration,
      //   // pageController: widget.pageController,
      //   // onPageChanged: onPageChanged,
      // ),
      child: ListView.builder(
          controller: _controller,
          itemBuilder: (context, _index) {
            return Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              child: SizedBox(
                  height: getProportionateScreenHeight(300),
                  child: PinchZoom(
                    
                    child: Image(
                        image:
                            Image.memory(base64Decode(images[_index].fileData))
                                .image),
                    maxScale: 2.5,
                    onZoomStart: () {
                      print('Start zooming cat');
                    },
                    onZoomEnd: () {
                      print('Stop zooming cat');
                    },
                  )),
            );
          },
          itemCount: images.length)
    );
  }
}
