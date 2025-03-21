import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../models/location.dart';
import '../services/geolocation_service.dart';
import '../services/openweathermap_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  Future<Iterable<Location>>? locationsSearchResults;
  @override
  Widget build(BuildContext context) {
    final api = context.read<OpenWeatherMapApi>();

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Nom de la ville'),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                locationsSearchResults = api.searchLocations(query);
              });
            },
            child: const Text('Rechercher'),
          ),
          if (query.isEmpty)
            const Text('Saisissez une ville dans la barre de recherche.')
          else
            FutureBuilder(
              future: locationsSearchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Une erreur est survenue.\n${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return const Text('Aucun résultat pour cette recherche.');
                }

                return Column(
                  children: [
                    for (final location in snapshot.data!)
                      ListTile(
                        title: Text(location.name),
                        subtitle: Text('${location.country} '),
                        trailing: Text(
                          '${location.lat.toStringAsFixed(2)}, ${location.lon.toStringAsFixed(2)}',
                        ),
                        onTap: () {
                          // Action à effectuer quand l'utilisateur sélectionne une ville
                          print('Ville sélectionnée: ${location.name}');
                          // Vous pourriez naviguer vers une page de détails ici
                        },
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
