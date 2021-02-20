import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousel extends StatelessWidget{
  ImageCarousel({this.images, this.getImage});
  final List<File> images;
  final getImage;
  final picker = ImagePicker();

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
                items: images
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