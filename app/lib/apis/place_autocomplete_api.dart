import 'package:app/apis/network_utitlity.dart';
import 'package:app/models/autocomplete_prediction.dart';
import 'package:app/models/place_autocomplete.dart';
import 'package:app/components/widgets/variables.dart';

class AutocompleteService {
  
  Future<List<AutocompletePrediction>> placeAutocomplete(String query) async {
    if (query.isEmpty) {
      return [];
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
      return result.predictions ?? [];
    } else {
      return [];
    }
  }
}
