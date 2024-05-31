import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/models/autocomplete_prediction.dart';
import 'package:app/apis/network_utitlity.dart';
import 'package:app/models/place_autocomplete.dart';
import 'package:app/screens/home/constants.dart';
import 'package:app/components/widgets/locationListTile.dart';

class LocationSearchWidget extends StatefulWidget {
  final Function(AutocompletePrediction) onLocationSelected;

  const LocationSearchWidget({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  List<AutocompletePrediction> placePredictions = [];
  bool showListView = false;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  Future<void> placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": Variables.mapsAPIkey,
        "components": 'country:pk'
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
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          showListView = true;
        });
      } else {
        setState(() {
          showListView = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (value) {
            placeAutocomplete(value);
            setState(() {
              // Update the visibility flag based on search bar text
              showListView = value.isNotEmpty; // Show list view if search bar text is not empty
            });
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
        if (showListView)
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: placePredictions.length,
                itemBuilder: (context, index) => LocationListTile(
                  press: () {
                    // Trigger the callback with the selected location
                    widget.onLocationSelected(placePredictions[index]);
                    // Update the text field with the selected place
                    _controller.text = placePredictions[index].description!;
                    // Hide the list view
                    setState(() {
                      showListView = false;
                      _focusNode.unfocus();
                    });
                  },
                  location: placePredictions[index].description!,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
