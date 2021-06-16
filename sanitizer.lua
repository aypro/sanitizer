local utils = require 'mp.utils'
local msg = require 'mp.msg'

function convert(censored_human, delay)
    delay = delay or 0
    censored = {}
    for i,v in ipairs(censored_human) do
        s1 = (string.sub(v[1],1,2) * 3600) + (string.sub(v[1],4,5) * 60) + (string.sub(v[1],7,8) * 1) - 1 + delay
        s2 = (string.sub(v[2],1,2) * 3600) + (string.sub(v[2],4,5) * 60) + (string.sub(v[2],7,8) * 1) + 1 + delay  
        censored[i] = {s1,s2}
    end
    return censored
end

censored={}

RRRrrrr = {
    {"00:07:02","00:07:18"},
    {"00:07:27","00:07:54"},
    {"00:17:36","00:18:32"},
    {"00:31:26","00:31:46"},
    {"01:19:49","01:19:51"},
    {"01:27:54","01:28:07"}
}

love_death_robots = {
    {"00:05:00","00:05:01"},   
}

inside_s06e03 = {
    {"00:25:41","00:25:46"},   
    {"00:25:59","00:26:05"}    
}

riders_of_justice = {
    {"00:39:48","00:39:59"},
    {"00:40:02","00:40:08"},
    {"00:59:18","01:00:13"},
    {"01:07:12","01:07:24"},
    {"01:07:45","01:08:16"} 
}


-- Convert to seconds
love_death_robots = convert(love_death_robots)
inside_s06e03 = convert(inside_s06e03)
riders_of_justice = convert(riders_of_justice, -5)

function check_for_action()
    current = mp.get_property_number("time-pos")
    for i,v in ipairs(censored) do
        if ( current >= v[1] and current <= v[2] ) then
            mp.set_property_number("time-pos",v[2])
            mp.osd_message("Skipped censored section from " .. utils.to_string(v[1]) .. " to " .. utils.to_string(v[2]))
        end
    end
end

function censor()
    if (mp.get_property("filename/no-ext") == "Love.Death.and.Robots.S02E03.1080p.HEVC.x265-MeGusta") then
        mp.osd_message("File loaded, censoring ready")
        censored = love_death_robots     
        mp.add_periodic_timer(1, check_for_action)
    end
    if (mp.get_property("filename/no-ext") == "inside.no.9.s06e03.1080p.hdtv.h264-uktv") then
        mp.osd_message("File loaded, censoring ready")
        censored = inside_s06e03     
        mp.add_periodic_timer(1, check_for_action)
    end   
    if (mp.get_property("filename/no-ext") == "inside.no.9.s06e03.720p.hdtv.x264-uktv") then
        mp.osd_message("File loaded, censoring ready")
        censored = inside_s06e03     
        mp.add_periodic_timer(1, check_for_action)
    end    
    if (mp.get_property("filename/no-ext") == "Riders.of.Justice.2020.DANISH.1080p.BluRay.x264.DTS-FGT") then
        mp.osd_message("File loaded, censoring ready")
        censored = riders_of_justice     
        mp.add_periodic_timer(1, check_for_action)
    end        
end

mp.register_event("file-loaded", censor)