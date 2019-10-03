#!/usr/bin/env python3
"""
pyregex-findall utilizes the python regex parser to run complicated regex against custom files (or defaults to /etc/os-release)

"""

import sys
import re
import getopt

opts = None

class Options():
    """Options parses the command line arguments"""
    def __init__(self):
        self.fileName = "/etc/os-release"
        self.regexpattern = None
        self.captureGroupIndex = None

    def set_regexPattern(self, arg):
        """ Set the regex pattern arg """
        self.regexpattern = arg

    def set_fileName(self, arg):
        """ Set the filename to run regex on """
        self.fileName = arg

    def set_capturegroupindex(self, arg):
        """ Set the capture group index """
        self.captureGroupIndex = int(arg)

    def parse_args(self):
        """ Parse command line arguments """
        handlers = {
            '-p': self.set_regexPattern,
            '-f': self.set_fileName,
            '-c': self.set_capturegroupindex
        }

        try:
            (optlist, args) = getopt.getopt(sys.argv[1:], "p:f:c:", ["pattern=", "filename=","capturegroupindex="])
            
        except getopt.GetoptError as exc:
            print(exc)
            print_usage(1)

        for opt in optlist:
            handlers[opt[0]](opt[1])
        
        if self.regexpattern is None:
            sys.stderr.write("Pattern (-p or --pattern) is required\n")
            print_usage(1)

        return args


def print_usage(exit_code):
    """Print usage"""
    sys.stderr.write("""\
%s Usage:
  required args:
    -p  <pattern>   : regex pattern (required)
  optional args:
    -f <file>       : filename to run against (defaults to /etc/os-release)
    -c <index>      : capture group index to return If no index is passed in, the result is a json array
""" % sys.argv[0])
    exit(exit_code)


def main():
    """
    main()
    """
    global opts
    opts = Options()
    opts.parse_args()
    
    pattern = re.compile(opts.regexpattern)
    with open(opts.fileName) as f:
        fileResult = f.read()

    results = re.findall(pattern, fileResult)

    if opts.captureGroupIndex is not None:
        print(results[opts.captureGroupIndex])
    else:
        print(results)

main()