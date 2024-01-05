import 'package:homelyf_services/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage({Key? key}) : super(key: key);

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1, // Adjust as needed
    );

    // Listen for page changes to update _currentIndex
    _pageController.addListener(() {
      int nextIndex =
          _pageController.page!.round() % GlobalVariables.carouselImages.length;
      if (_currentIndex != nextIndex) {
        setState(() {
          _currentIndex = nextIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    GlobalVariables.carouselImages[
                        index % GlobalVariables.carouselImages.length],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        // Custom indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              List.generate(GlobalVariables.carouselImages.length, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
