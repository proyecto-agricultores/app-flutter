import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({this.images});
  final List<File> images;

  @override
  State<StatefulWidget> createState() => _ImageCarouselState(this.images);
}

class _ImageCarouselState extends State<ImageCarousel>{
  _ImageCarouselState(this._images);
  final List<File> _images;
  final picker = ImagePicker();

  Future _getImage(ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);

    setState(
      () {
        if (pickedFile != null) {
          _images.add(File(pickedFile.path));
        } else {
          print('No image selected.');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _images.isNotEmpty 
          ? Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  viewportFraction: 0.6,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
                items: _images
                    .map(
                      (item) => Container(
                        height: 500.0,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: new FileImage(item),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          : Container(),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Agregar Imágenes: "),
            SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () => this._getImage(ImageSource.camera),
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
              heroTag: 'camera',
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () => this._getImage(ImageSource.gallery),
              tooltip: 'Pick Image From Library',
              child: Icon(Icons.photo_library),
              heroTag: 'library',
            )
          ],
        ),
        SizedBox(height: 50),
      ],
    );
  }
}