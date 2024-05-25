import requests
from bs4 import BeautifulSoup
from flask import Flask, request, jsonify

app = Flask(__name__)

API_KEY = ''
average_speed_kmh = 40  # Assume an average speed of 40 km/h

# Function to get coordinates from an address
def get_coordinates(address):
    geocode_url = f"https://maps.googleapis.com/maps/api/geocode/json?address={address}&key={API_KEY}"
    response = requests.get(geocode_url).json()
    if response['status'] == 'OK':
        location = response['results'][0]['geometry']['location']
        return f"{location['lat']},{location['lng']}"
    else:
        raise Exception(f"Error fetching location data for {address}: {response['status']}")

# Route for the API
@app.route('/get_traffic', methods=['POST'])
def get_traffic():
    data = request.get_json()
    if not data or 'start' not in data or 'end' not in data:
        return jsonify({"error": "Please provide 'start' and 'end' locations in the JSON payload"}), 400

    start_address = data['start']
    end_address = data['end']
    
    try:
        start_latlng = get_coordinates(start_address)
        end_latlng = get_coordinates(end_address)
    except Exception as e:
        return jsonify({"error": str(e)}), 400

    # Use Directions API to get traffic information
    directions_url = f"https://maps.googleapis.com/maps/api/directions/json?origin={start_latlng}&destination={end_latlng}&departure_time=now&key={API_KEY}"
    directions_response = requests.get(directions_url).json()

    if directions_response['status'] == 'OK':
        route = directions_response['routes'][0]
        legs = route['legs'][0]

        result = {
            "start_address": legs['start_address'],
            "end_address": legs['end_address'],
            "distance": legs['distance']['text'],
            "duration_with_traffic": legs.get('duration_in_traffic', {}).get('text', 'No data'),
            "duration_without_traffic": legs['duration']['text'],
            "detailed_steps": []
        }

        for step in legs['steps']:
            instruction = step['html_instructions']
            distance_step = step['distance']['text']

            # Extract road name from HTML instructions
            soup = BeautifulSoup(instruction, 'html.parser')
            road_name_tags = soup.find_all('b')
            road_name = None

            # Select the last <b> tag if multiple are found (assumes the last one is the road name)
            if road_name_tags:
                road_name = road_name_tags[-1].get_text()

            if not road_name or road_name.lower() in ['left', 'right', 'straight']:
                road_name = 'Unknown road'

            # Convert distance to km and duration to hours for calculation
            distance_km = float(distance_step.split()[0])  # Assumes distance is in "km" and format is like "1.2 km"
            expected_duration_hours = distance_km / average_speed_kmh
            expected_duration_seconds = expected_duration_hours * 3600  # Convert hours to seconds

            duration_in_traffic_step_seconds = step.get('duration_in_traffic', {}).get('value', step['duration']['value'])

            # Check if duration with traffic is greater than expected duration by 1 minute (60 seconds)
            if duration_in_traffic_step_seconds > expected_duration_seconds + 60:
                expected_duration_minutes = expected_duration_seconds / 60
                duration_in_traffic_minutes = duration_in_traffic_step_seconds / 60
                result["detailed_steps"].append({
                    "road_name": road_name,
                    "expected_duration_mins": round(expected_duration_minutes, 2),
                    "duration_with_traffic_mins": round(duration_in_traffic_minutes, 2)
                })

        return jsonify(result)
    else:
        return jsonify({"error": "Error fetching traffic data", "status": directions_response['status']}), 500

if __name__ == '__main__':
    app.run(debug=True)
