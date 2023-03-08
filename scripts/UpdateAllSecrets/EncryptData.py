#!/usr/bin/env python3
import sys, getopt
from base64 import b64encode
from nacl import encoding, public

def findAndEncrypt(argv):
    # Init variables
    data = ''
    key = ''
    # Get arguments from CLI
    opts, args = getopt.getopt(argv,"hd:k:",["data=","key="])
    # Parse out arguments from CLI
    for opt, arg in opts:
        if opt == '-h':
            print('EncryptData.py -d <data> -k <key>')
            sys.exit()
        elif opt in ("-d", "--data"):
            data = arg
        elif opt in ("-k", "--key"):
            key = arg
    # Exit if data and key not set
    if data == '' or key == '':
        print('--data and --key must be set run with -h for info')
        sys.exit()
    # Encrypt a Unicode string using the public key
    public_key = public.PublicKey(key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key)
    encrypted = sealed_box.encrypt(data.encode("utf-8"))
    # Return encrypted data
    return b64encode(encrypted).decode("utf-8")

if __name__ == "__main__":
    # Run function and print result
    print(findAndEncrypt(sys.argv[1:]))