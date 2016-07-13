from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

#Variables that contains the user credentials to access Twitter API 
access_token = "4332060682-Sl7N7jvWeYfoZRMenqrfjmRpaJDsd6RTbVLLvKx"
access_token_secret = "nJpXDgASMF8NHScAiXtEzw6tYT9XET6FFCiAdfY36V68i"
consumer_key = "juYcxwrY044iOQ8omJr0EjH2l"
consumer_secret = "fLUS0IdDhjkLkRXYkQJk84iuGj1nEgIMimZnZesQcupTSAO8pu"


#This is a basic listener that just prints received tweets to stdout.
class StdOutListener(StreamListener):

    def on_data(self, data):
        print(data)
        return True

    def on_error(self, status):
        print(status)


if __name__ == '__main__':

    #This handles Twitter authetification and the connection to Twitter Streaming API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)

    #This line filter Twitter Streams to capture data by the keywords: 'python', 'javascript', 'ruby'
    stream.filter(track=['python', 'javascript', 'ruby'])