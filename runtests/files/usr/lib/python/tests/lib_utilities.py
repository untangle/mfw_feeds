import io
import tarfile

class LibUtilities:
    initialized = False

    @classmethod
    def initialize(cls):
        cls.initialized = True

    @classmethod
    def untar_file(cls, incoming_bytes=None, file_name=None):
        """
        From incoming bytes, extract contents of file_name as specified by path (e.g.,/settings.json)
        """
        if incoming_bytes is None:
            return None
        if file_name is None:
            return None
        ## !!! catch exceptions here
        fo = io.BytesIO(incoming_bytes)

        ## !!! catch exceptions here
        tf = tarfile.open(fileobj=fo)
        file_name_index = None
        for index, name in enumerate(tf.getnames()):
            if name.endswith(file_name):
                file_name_index = index
        
        if file_name_index is None:
            return None

        f = tf.extractfile(tf.getmembers()[file_name_index])
        return f.read()
        # settings = json.loads(f.read(), object_pairs_hook=collections.OrderedDict)


if LibUtilities.initialized is False:
    LibUtilities.initialize()
