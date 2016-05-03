#!/usr/bin/env python

import sys
import socket

i = 0

iset = set()

with open(sys.argv[1], 'r') as f:
    for line in f:
        if not i:
            ip = line.strip()[2:].replace("\0", "").replace("\r", "")
            i += 1
        else:
            ip = line.strip().replace("\0", "").replace("\r", "")
        try:
            socket.inet_aton(ip)
            if ip not in iset:
                print ip
                iset.add(ip)
        except socket.error:
            pass
