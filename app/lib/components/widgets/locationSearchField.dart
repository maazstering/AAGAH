import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/models/autocomplete_prediction.dart';
import 'package:app/apis/network_utitlity.dart';
import 'package:app/models/place_autocomplete.dart';
import 'package:app/screens/home/constants.dart';
import 'package:app/components/widgets/locationListTile.dart';

class LocationSearchWidget extends StatefulWidget {
  const LocationSearchWidget({Key? key}) : super(key: key);

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  List<AutocompletePrediction> placePredictions = [];

  Future<void> placeAutocomplete(String query) async {
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
    return Column(
      children: [
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
                color: secondaryColor40LightTheme,
              ),
            ),
          ),
        ),
        const Divider(
          height: 4,
          thickness: 4,
          color: secondaryColor5LightTheme,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => LocationListTile(
              press: () {},
              location: placePredictions[index].description!,
            ),
          ),
        ),
      ],
    );
  }
}
