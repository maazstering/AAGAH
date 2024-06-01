import 'package:app/components/themes/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:app/components/themes/appTheme.dart';

class LocationSearchField extends StatelessWidget {
  final Function(Prediction) onLocationSelected;
  final String hintText;
  final TextEditingController controller;

  LocationSearchField({
    required this.onLocationSelected,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: Variables.mapsAPIkey,
      inputDecoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppTheme.greyColor),
        filled: true,
        fillColor: AppTheme.mediumGreyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      debounceTime: 800,
      countries: const ["pk"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        onLocationSelected(prediction);
      },
      itemClick: (Prediction prediction) {
        onLocationSelected(prediction);
        controller.text = prediction.description!;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description!.length));
      },
    );
  }
}
