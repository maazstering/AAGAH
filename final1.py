from ntscraper import Nitter
import json

# List of locations to filter
locations = [
    'airport', 'aram bagh', 'baghdadi', 'bahadurabad', 'baldia', 'bahria town karachi', 'baba and bhit islands',
    'bin qasim', 'bhittai colony', 'buffer zone', 'bundal island', 'burmee colony', 'cape monze', 'catholic colony',
    'cattle colony', 'chakiwara', 'chakra goth', 'chanesar town', 'churna island', 'city railway colony', 'civil line',
    'clifton beach', 'clifton cantonment', 'clifton oyster rocks', 'dastagir colony', 'defence', 'defence view',
    'drigh colony', 'essa nagri', 'faisal cantonment', 'farooq-e-azam', 'federal b. area', 'ferozabad', 'french beach',
    'gabo pat', 'gabol colony', 'gadap', 'garden', 'garden east', 'garden west', 'ghanchi para', 'gharibabad',
    'ghausia colony', 'ghazi brohi goth', 'ghaziabad', 'gizri', 'godhra', 'golimar', 'goth faqir mohammad',
    'goth ghulam mohammad', 'goth haji behram', 'goth haji jumma khan', 'goth haji salar', 'goth mauladad',
    'goth mohammad ali', 'goth shaikhan', 'green park city', 'gujrat colony', 'gujro', 'gulbahar', 'gulistan-e-amna',
    'gulistan-e-ghazi', 'gulistan-e-iqbal', 'gulistan-e-johar', 'gulistan-e-osman', 'gulistan-e-saeed', 'gulistan-e-sheraz',
    'gulistan-e-sikandarabad', 'gulzar colony', 'gulzar-e-hijri', 'haji ali goth', 'haji camp', 'hakim ahsan', 'hanifabad',
    'harbour', 'haroonabad', 'haryana colony', 'hasrat mohani colony', 'hawke\'s bay beach', 'hijrat colony', 'hundred quarters',
    'hussain d\'silva town', 'hussainabad', 'hyderabad colony', 'hyderi', 'i. i. chundrigar road', 'ibrahim hyderi',
    'iqbal baloch colony', 'islam pura', 'islamia colony', 'islamnagar', 'ittehad town', 'jafar-e-tayyar', 'jamshed quarters',
    'kakapir', 'karachi cantonment', 'keamari', 'khiprianwala island', 'kiamari', 'korangi', 'korangi creek cantonment',
    'korangi town', 'landhi', 'landhi town', 'liaquatabad', 'lyari', 'machar colony', 'malir', 'malir cantonment',
    'manora cantonment', 'mango pir', 'mauripur', 'model colony', 'mominabad', 'murad memon', 'nazimabad', 'new karachi',
    'north nazimabad', 'orangi', 'paposh nagar', 'paradise point', 'rizvia society', 'saddar', 'saddar town', 'sandspit beach',
    'shah baig line', 'shah faisal', 'shah mureed', 'shahrah-e-faisal', 'shams pir', 'sindh industrial trading estate (site)',
    'singo line', 'soldier bazar', 'super market', 'zaman town'
]

# Function to check if a tweet contains any of the locations
def contains_location(text):
    for location in locations:
        if location.lower() in text.lower():
            return location
    return None

# Array of usernames
usernames = ["halaatupdate", "TOKCityOfLights"]

# Function to get tweets for each username
def get_tweets(username):
    # Get the latest tweets from a single user
    return Nitter().get_tweets(username, mode='user', number=100)

# Dictionary to store tweets
all_tweets = {}

# Iterate through the array of usernames and collect tweets
for username in usernames:
    tweets_data = get_tweets(username)
    tweets = tweets_data.get('tweets', [])  # Extract tweets from the 'tweets' key

    filtered_tweets = []
    for tweet in tweets:
        if isinstance(tweet, dict) and 'text' in tweet:
            location = contains_location(tweet['text'])
            if location:
                tweet['location'] = location
                filtered_tweets.append(tweet)
        else:
            print(f"Skipping invalid tweet format: {tweet}")

    if filtered_tweets:
        all_tweets[username] = filtered_tweets

# Export the collected tweets in JSON format
with open("tweets1.json", "w") as file:
    json.dump(all_tweets, file, indent=4)
