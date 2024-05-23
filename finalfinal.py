from flask import Flask, jsonify, request
from ntscraper import Nitter
from googletrans import Translator

app = Flask(__name__)

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
    'singo line', 'soldier bazar', 'super market', 'zaman town', 'central'
]

# Function to check if a tweet contains any of the locations
def contains_location(text):
    for location in locations:
        if location.lower() in text.lower():
            return location
    return None

# Function to get tweets for each username
def get_tweets(username):
    # Get the latest 100 tweets from a single user
    return Nitter().get_tweets(username, mode='user', number=100)

# Function to translate Urdu tweets to English
def translate_tweets(tweets):
    translator = Translator()
    translated_tweets = []
    
    for tweet in tweets:
        try:
            # Extract the tweet text
            tweet_text = tweet.get('text', '')
            
            # Normalize the text
            tweet_text_normalized = tweet_text.replace('*', ' ')
            
            # Translate if the tweet is in Urdu
            translated_text = translator.translate(tweet_text_normalized, src='ur', dest='en').text
            
            # Create a copy of the tweet with the translated text
            translated_tweet = tweet.copy()
            translated_tweet['text'] = translated_text
            
            translated_tweets.append(translated_tweet)
        except Exception as e:
            print(f"Error translating tweet: {e}")
            continue
    
    return translated_tweets

@app.route('/tweets', methods=['GET'])
def get_filtered_tweets():
    usernames = request.args.getlist('usernames')
    all_tweets = {}

    for username in usernames:
        result = get_tweets(username)
        
        # Check if 'tweets' key is present in the result dictionary
        if isinstance(result, dict) and 'tweets' in result:
            tweets = result['tweets']
            
            # Translate the tweets
            translated_tweets = translate_tweets(tweets)
            
            # Filter tweets based on location
            filtered_tweets = []
            for tweet in translated_tweets:
                if isinstance(tweet, dict) and 'text' in tweet:
                    location = contains_location(tweet['text'])
                    if location:
                        tweet['location'] = location
                        filtered_tweets.append(tweet)
                else:
                    print(f"Skipping invalid tweet format: {tweet}")

            if filtered_tweets:
                all_tweets[username] = filtered_tweets
        else:
            print(f"No valid tweets returned for {username}")
            all_tweets[username] = []

    return jsonify(all_tweets)

if __name__ == '__main__':
    app.run(debug=True)
