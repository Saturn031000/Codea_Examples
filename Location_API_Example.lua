-- Location
function setup()
    location.disable()
    location.enable()
    parameter.action("Open in Google Maps", function() openURL("http://www.google.com/maps/place/"..location.latitude..","..location.longitude) end)
end
function draw()
    background(0, 0, 0, 255)
    fill(255, 255, 255, 255)
    strokeWidth(5)
    font("HelveticaNeue-UltraLight")
    fontSize(64)
    textWrapWidth(WIDTH)
    text("Your latitude: "..location.latitude.."°", WIDTH/2, HEIGHT/4*3)
    text("Your longitude: "..location.longitude.."°", WIDTH/2, HEIGHT/2)
    text("Your altitude: "..location.altitude.." m", WIDTH/2, HEIGHT/4)
end
