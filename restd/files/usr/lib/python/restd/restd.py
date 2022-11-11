import collections
import json
import requests
import urllib.parse, urllib.error

class Restd:
    def get_raw(path=None):
        ## !!! perform exception catching
        # Look at result to be 200
        # print(f"http://127.0.0.1{path}")
        data = requests.get(f"http://127.0.0.1{path}")
        return data.content

    def get_string(path=None):
        ## !!! perform exception catching
        # Look at result to be 200
        # print(f"http://127.0.0.1{path}")
        data = requests.get(f"http://127.0.0.1{path}")
        return data.content.decode()

    def get(path=None):
        ## !!! perform exception catching
        # Look at result to be 200
        # print(f"http://127.0.0.1{path}")
        data = requests.get(f"http://127.0.0.1{path}")
        return json.loads(data.content, object_pairs_hook=collections.OrderedDict)

    def post(path=None, post_data=None):
        if type(post_data) is collections.OrderedDict:
            post_data = json.loads(json.dumps(post_data))
        # print()
        # print(f"http://127.0.0.1{path}")
        # print(json.dumps(post_data))
        data = requests.post(f"http://127.0.0.1{path}", data=json.dumps(post_data))
        # print(data)
        return data
        # return json.loads(data.content, object_pairs_hook=collections.OrderedDict)


