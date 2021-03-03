import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousel extends StatefulWidget {
  final List<File> images;
  final getImage;

  const ImageCarousel({
    Key key,
    @required this.images,
    @required this.getImage,
  }) : super(key: key);

  @override
  ImageCarouselState createState() => ImageCarouselState(images, getImage);
}

class ImageCarouselState extends State<ImageCarousel> {
  final List<File> images;
  final getImage;
  final picker = ImagePicker();
  ImageCarouselState(this.images, this.getImage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        images.isNotEmpty
            ? Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    viewportFraction: 0.6,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                  ),
                  items: images.map((item) {
                    return Stack(
                      children: [
                        Container(
                          height: 500.0,
                          decoration: new BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: new FileImage(item),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: -20,
                          child: RawMaterialButton(
                            elevation: 2.0,
                            fillColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 25.0,
                              color: Colors.white,
                            ),
                            shape: CircleBorder(),
                            onPressed: () {
                              images.remove(item);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
              onPressed: () => this.getImage(ImageSource.camera),
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
              heroTag: 'camera',
            ),
            SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () => this.getImage(ImageSource.gallery),
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
