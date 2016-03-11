function love.conf(t)
	author = "anthony"
	
	--t.identity = nil                    -- The name of the save directory (string)
    --t.version = "0.10.1"                -- The LÖVE version this game was made for (string)
    t.console = true                   -- Attach a console (boolean, Windows only)
    --t.accelerometerjoystick = true      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    --t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean) 
    --t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
	
	t.window.title = "Hex Test"         -- The window title (string)
    --t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    --t.window.width = 800                -- The window width (number)
    --t.window.height = 600               -- The window height (number)
    --t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = true          -- Let the window be user-resizable (boolean)
    t.window.minwidth = 300               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 200              -- Minimum window height if the window is resizable (number)
    --t.window.fullscreen = false         -- Enable fullscreen (boolean)
    --t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    --t.window.vsync = true               -- Enable vertical sync (boolean)
    --t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    --t.window.display = 1                -- Index of the monitor to show the window in (number)
    --t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    --t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    --t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)

end
