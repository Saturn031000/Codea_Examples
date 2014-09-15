-- Stopwatch
displayMode(FULLSCREEN)

-- Use this function to perform your initial setup
function setup()
    print("Stopwatch")
    timer=0
    running=false
    btpy1=50
    btpy2=50
    parameter.boolean("Decimal", false, function() resetTimer() end)
    flash=0
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(0, 0, 0, 255)
    fill(255, 255, 255, 255)
    -- This sets the line thickness
    strokeWidth(5)
    font("HelveticaNeue-UltraLight")
    fontSize(90)
    -- Do your drawing here
    text("START", WIDTH/4, HEIGHT/3)
    if running==false then
                text("RESET", WIDTH/4*3, HEIGHT/3)
            else
                text("STOP", WIDTH/4*3, HEIGHT/3)
            end
    pushStyle()
    noStroke()
    fill(255, 255, 255, btpy1)
    ellipse(WIDTH/4, HEIGHT/3, 300)
    fill(255, 255, 255, btpy2)
    ellipse(WIDTH/4*3, HEIGHT/3, 300)
    popStyle()
    if running then
        timer = timer + DeltaTime
    end
    if Decimal then  
        text(string.format("%0.3f",timer), WIDTH/2, HEIGHT/2 + 200)
    else
        text(string.format("%d",timer), WIDTH/2, HEIGHT/2 + 200)
    end
end

function resetTimer()
    timer=0
end

function touched(t)
    if t.state==BEGAN then
        if t.x>WIDTH/4-150 and t.x<WIDTH/4+150 and t.y>HEIGHT/3-150 and t.y<HEIGHT/3+150 then
            running=true
            btpy1=150
        end
        if t.x>WIDTH/4*3-150 and t.x<WIDTH/4*3+150 and t.y>HEIGHT/3-150 and t.y<HEIGHT/3+150 then
            btpy2=150
            if running==false then
                resetTimer()
            else
                running=false
            end
        end
    end
    if t.state==ENDED then
        btpy1=50
        btpy2=50
    end
end
