#!/usr/bin/env python3
# Francesco Conti <f.conti@unibo.it>
#
# Copyright (C) 2016-2018 ETH Zurich, University of Bologna.
# All rights reserved.

# switch to "git@github.com" if you have an SSH public key deployed on GitHub
# and you want to push things there
DEFAULT_SERVER = "https://github.com"

IPSTOOLS_DIR = 'ipstools'
IPSTOOLS_COMMIT = '16db053f44f632b37198325ba339f9ebda14efa3'

#################################
## DO NOT EDIT BELOW THIS LINE ##
#################################

import sys,os,subprocess

class tcolors:
    OK      = '\033[92m'
    WARNING = '\033[93m'
    ERROR   = '\033[91m'
    ENDC    = '\033[0m'

def execute(cmd, silent=False):
    if silent:
        devnull = open(os.devnull, 'wb')
        stdout = devnull
    else:
        stdout = None
    ret = subprocess.call(cmd.split(), stdout=stdout)
    if silent:
        devnull.close()
    return ret

def execute_out(cmd, silent=False):
    p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    out, err = p.communicate()
    return out

# Strip trailing slashes from `DEFAULT_SERVER`.
DEFAULT_SERVER = DEFAULT_SERVER.rstrip('/')

# Update IPApproX tools in `./IPSTOOLS_DIR` to specified commit and import them.
if not os.path.exists(IPSTOOLS_DIR):
    delim = ':' if '@' in DEFAULT_SERVER else '/'
    execute("git clone {}{}pulp-platform/IPApproX {}".format(DEFAULT_SERVER, delim, IPSTOOLS_DIR))
elif not os.path.isdir(IPSTOOLS_DIR):
    sys.exit("Error: '{}' exists but is not a directory!".format(IPSTOOLS_DIR))
cwd = os.getcwd()
os.chdir(IPSTOOLS_DIR)
execute("git fetch --all", silent=True)
execute("git checkout {}".format(IPSTOOLS_COMMIT))
os.chdir(cwd)
import ipstools
