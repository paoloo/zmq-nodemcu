# ØMQ small push client for nodeMCU
This implements only a simple PUSH into the message bus, in order to provide an interface
for lightweight snesors. This code is implemented according to definitions found at
http://rfc.zeromq.org/spec:13/ZMTP/

## usage

### server side
```python
import zmq
context = zmq.Context()
sock = context.socket(zmq.PULL)
sock.bind("tcp://*:5555")
while True:
    _msg=sock.recv()
    print _msg
```
### nodeMCU side
```lua
-- first connect to your wifi
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASSWORD)
wifi.sta.autoconnect(1)
-- import library
z=require("zmqpush")
-- initialize the topic, "sensor5" here, and host and port of the server
z.init("sensor5","10.10.0.2","5555")
-- send the data(inside a string, use io:format or change lib code if you need)
z.send("18.4")
-- be happy!
```
The idea is to make the python script a router from the sensor PUSH msg into a common
PUBlisher, by creating two threads, one to recv from PUSH socket, saving into a variable
and other providing the information into bus.

### Disclaimer
This is a **quick and dirty hack** created to solve a problem, it opens and closes TCP connections for every message, require data as string and doesn't check for errors(actually, it doesn't check for anything, not even the expected **ff00 0000 0000 0000 017f** return value), it is, basically, a nodeMCU version of a **bash** command: `python -c 'import sys; from struct import pack; p = lambda : "%s%s" % (pack("BBBB", 1, 0, len(MSG)+1, 0) , MSG); sys.stdout.write(p("sensor1,15.43"))' | nc localhost 5555 | xxd` So, although it is usable and works, take care and change it to fulfil your needs(and a pull request is always welcome).

## License
[MIT License](LICENSE.md) © 2015-2016 Paolo Oliveira.
