import collections
import json
import requests
import urllib.parse, urllib.error

class Restd:
    """
    Interface with restd, commonly for API calls.
    """
    def get(path=None, return_type="json"):
        """
        Perform GET operation.

        :param str path: Required path to query
        :param str return_type: How to return the data - if "json", decode content as a json decode result, if "string" return as string, otherwise return the requests return object.
        :return As specified by return_type
        :rtype As specified by return type
        """
        data = requests.get(f"http://127.0.0.1{path}")

        if return_type is None:
            return None
        elif return_type == "json":
            return json.loads(data.content, object_pairs_hook=collections.OrderedDict)
        elif return_type == "string":
            return data.content.decode()
        return data

    def post(path=None, post_data=None, return_type="json"):
        """
        Perform POST operation.

        :param str path: Required path to query
        :param str return_type: How to return the data - if "json", decode content as a json decode result, if "string" return as string, otherwise return the requests return object.
        :return As specified by return_type
        :rtype As specified by return type
        """
        if type(post_data) is collections.OrderedDict:
            # Convert ordered dict to standard dict via dumping then re-loading
            post_data = json.loads(json.dumps(post_data))
        data = requests.post(f"http://127.0.0.1{path}", data=json.dumps(post_data))

        if return_type is None:
            return None
        elif return_type == "json":
            return json.loads(data.content, object_pairs_hook=collections.OrderedDict)
        elif return_type == "string":
            return data.content.decode()
        return data


