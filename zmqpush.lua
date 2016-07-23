-- 0MQ small push client for nodeMCU based on definitions found at http://rfc.zeromq.org/spec:13/ZMTP/
local zmqpush = {topic="", host="", port=""}

zmqpush.init = function(topic,host,port)
  zmqpush.topic=topic
  zmqpush.host=host
  zmqpush.port=port
end

zmqpush.frame = function(datablock)
  block = ''
  for _,i in pairs{1,0,string.len(datablock)+1,0} do block=block..string.char(i) end
  block=block..datablock
  return block
end

zmqpush.send = function(v)
  local skct = nil
  local sendr = function()
    sckt:send(zmqpush.frame(zmqpush.topic .. "," .. v))
    sckt:close()
  end
  sckt = net.createConnection(net.TCP,0)
  sckt:on("connection",sendr)
  sckt:connect(zmqpush.port,zmqpush.host)
end

return zmqpush