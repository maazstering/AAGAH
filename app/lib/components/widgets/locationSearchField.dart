import 'package:app/models/autocomplete_prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/apis/network_utitlity.dart';
import 'package:app/models/place_autocomplete.dart';
import 'package:app/components/widgets/variables.dart';

class LocationSearchField extends StatefulWidget {
  const LocationSearchField({super.key});

  @override
  _LocationSearchFieldState createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  List<AutocompletePrediction> placePredictions = [];

  Future<void> placeAutocomplete(String query) async {
    if (query.isEmpty) {
      setState(() {
        placePredictions = [];
      });
      return;
    }

    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": Variables.mapsAPIkey,
      },
    );

    String? response = await NetworkUtitilty.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
        TextFormField(
          onChanged: (value) {
            placeAutocomplete(value);
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: "Search your location",
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SvgPicture.asset(
                "assets/images/location_pin.svg",
                // color: secondaryColor40LightTheme,
              ),
            ),
          ),
        );
  }
}
