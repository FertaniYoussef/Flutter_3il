import 'package:flutter/material.dart';
import 'package:newflutterapp/components/post.dart';
import 'package:newflutterapp/models/post.dart' as models;
import 'package:provider/provider.dart';
import 'package:newflutterapp/providers/post_provider.dart';
import 'package:newflutterapp/providers/user_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newflutterapp/services/location_service.dart';
import 'package:newflutterapp/services/weather_service.dart';

class HomePage extends StatelessWidget {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    TextEditingController contentController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    ValueNotifier<String?> imageUrlNotifier = ValueNotifier<String?>(null);

    imageController.addListener(() {
      if (imageController.text.isEmpty) {
        imageUrlNotifier.value = null;
      } else {
        imageUrlNotifier.value = imageController.text;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Youssef Fertani le king'),
      ),
      backgroundColor: Colors.white, // Set background color to light gray
      body: Column(
        children: [
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, postProvider, child) {
                return ListView.builder(
                  itemCount: postProvider.posts.length,
                  itemBuilder: (context, index) {
                    final post = postProvider.posts[index];
                    return Column(
                      children: [
                        Post(post: post),
                        (index != postProvider.posts.length - 1)
                            ? Container(
                                color: Colors.grey[100],
                                height: 10,
                              )
                            : Container(
                                color: Colors.white,
                                height: 10,
                                // child: const Divider(color: Colors.grey, height: 0, thickness: 1, indent: 0, endIndent: 0,),
                              )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: imageUrlNotifier,
                  builder: (context, imageUrl, child) {
                    return imageUrl != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: 60,
                                  alignment: Alignment.centerLeft,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8), // Small rounded corners on the image
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    imageUrlNotifier.value = null;
                                    imageController.clear();
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container();
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          hintText: 'Nouveau post',
                          border: InputBorder.none, // Remove the border
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  10), // Add padding to match the app's style
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(imageUrlNotifier.value != null
                          ? Icons.edit
                          : Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Moins d'arrondis sur les angles
                              ),
                              title: const Text(
                                'Ajouter une URL d\'image',
                                style: TextStyle(
                                    color: Colors
                                        .black), // Suivre le thème du reste de l'appli
                              ),
                              content: TextField(
                                controller: imageController,
                                decoration: const InputDecoration(
                                  hintText: 'Entrez l\'URL de l\'image',
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .grey), // Suivre le thème du reste de l'appli
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Annuler',
                                    style: TextStyle(
                                        color: Colors
                                            .blue), // Suivre le thème du reste de l'appli
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    imageUrlNotifier.value =
                                        imageController.text;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Ajouter',
                                    style: TextStyle(
                                        color: Colors
                                            .blue), // Suivre le thème du reste de l'appli
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final currentUser =
                            Provider.of<UserProvider>(context, listen: false)
                                .currentUser;
                        if (currentUser != null &&
                            contentController.text.isNotEmpty) {
                          Position position =
                              await _locationService.getCurrentLocation();
                          String city = await _locationService
                              .getCityFromCoordinates(position);
                          Map<String, dynamic> weatherData =
                              await _weatherService.fetchWeatherData(city);
                          double temperature =
                              weatherData['main']['temp'] - 273.15;

                          Provider.of<PostProvider>(context, listen: false)
                              .addPost(
                            models.Post(
                              owner: currentUser,
                              content: contentController.text,
                              image: imageController.text.isNotEmpty
                                  ? imageController.text
                                  : null,
                              location: city,
                              weather: '${temperature.toStringAsFixed(2)}°C',
                            ),
                          );
                          contentController.clear();
                          imageController.clear();
                          imageUrlNotifier.value = null;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
