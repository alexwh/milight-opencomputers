#!/usr/bin/env python3
from socket import socket
from time import sleep

# use tcp because opencomputers can't use udp sockets to my knowledge. the
# controller can accept tcp or udp, but it's configured to use udp by default.
sock = socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect('192.168.0.100', 8899)

# color test
for i in range(0xff):
    print(i)
    sock.send(bytearray.fromhex('20{:02x}55'.format(i)))

    # the wifi controller specs say you should send at most a message every
    # 50ms, but 20 seems to work fine before it gets inconsistent
    sleep(0.02)

for i in range(5):
    sock.send(bytearray.fromhex('210055'))
    sleep(0.3)
    sock.send(bytearray.fromhex('220055'))
    sleep(0.3)

sock.close()
