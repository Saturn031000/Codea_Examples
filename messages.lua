
--# Main
-- Message
supportedOrientations(LANDSCAPE_ANY)

function setup()
    h = Multiplayer(recieve, start)
    parameter.action("HOST", function() h:hostGame() end)
    parameter.text("lIp", "")
    parameter.text("lPo", "")
    parameter.action("JOIN", function() h:joinGame(lIp, lPo) parameter.clear() newParams() end)
    message = ""
end

function draw()
    background(0, 0, 0, 255)
    strokeWidth(5)
    fill(255)
    font("HelveticaNeue-Light")
    fontSize(50)
    textWrapWidth(WIDTH)
    text(message, WIDTH/2, HEIGHT/2)
    h:update()
end

function receive(d)
    local tb = loadstring("return " .. d)()
    message = tb
end

function start()
    
end

function newParams()
    parameter.text("msg", "")
    parameter.action("SEND", function() h:sendData(msg) end)
end

--# Multiplayer
local socket = require("socket")

Multiplayer = class()

function Multiplayer:init(dcb, ccb)
    self.my_ip, self.my_port = self:getLocalIP(), 5400
    self.peer_ip, self.peer_port = nil, self.my_port

    self.client = socket.udp()
    self.client:settimeout(0)

    self.connected = false
    self.is_host = false
    self.searching = false

    self.dataCallback = dcb or function() end
    self.connectedCallback = ccb or function() end
end

-- Returns this iPad's local ip
function Multiplayer:getLocalIP()
    local randomIP = "192.167.188.122"
    local randomPort = "3102" 
    local randomSocket = socket.udp() 
    randomSocket:setpeername(randomIP,randomPort) 

    local localIP, somePort = randomSocket:getsockname()

    randomSocket:close()
    randomSocket = nil

    return localIP
end

-- Set the connected status and call the connection callback if needed
function Multiplayer:setConnectedVal(bool)
    self.connected = bool

    if self.connected then
        self.connectedCallback()
    end
end

function Multiplayer:setHostVal(bool)
    self.is_host = bool
end

-- Prepare to be the host
function Multiplayer:hostGame()
    print("Connect to " .. self.my_ip .. ":" .. self.my_port)

    self.client:setsockname(self.my_ip, self.my_port)

    self:setConnectedVal(false)
    self.is_host = true
    self.searching = false
end

-- Find a host
function Multiplayer:findGame()
    print("Searching for games...")

    self.searching = true

    local ip_start, ip_end = self.my_ip:match("(%d+.%d+.%d+.)(%d+)")
    for i = 1, 255 do
        if i ~= tonumber(ip_end) then
            tween.delay(0.01 * i, function()
                self.client:setsockname(ip_start .. i, self.my_port)
                self.client:sendto("connection_confirmation", ip_start .. i, self.my_port)
            end)
        end
    end
end

-- Prepare to join a host
function Multiplayer:joinGame(ip, port)
    self.peer_ip, self.peer_port = ip, port

    self.client:setsockname(ip, port)

    self.is_host = false
    self.searching = false

    self:sendData("connection_confirmation")
end

-- Send data to the other client
function Multiplayer:sendData(msg_to_send)
    if self.peer_ip then
        self.client:sendto(msg_to_send, self.peer_ip, self.peer_port)
    end
end

-- Check for data received from the other client
function Multiplayer:checkForReceivedData()
    local data, msg_or_ip, port_or_nil = self.client:receivefrom()
    if data then
            -- Store the ip of this new client so you can send data back
            self.peer_ip, self.peer_port = msg_or_ip, port_or_nil

            if not self.connected and data == "connection_confirmation" then
                self:sendData("connection_confirmation")
                self:setConnectedVal(true)
            end

            -- Call callback with received data
            if data ~= "connection_confirmation" then
                self.dataCallback(data)
            end
    end
end

function Multiplayer:update()
    self:checkForReceivedData()
end
