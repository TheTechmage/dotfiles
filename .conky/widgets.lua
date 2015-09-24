--[[

All credit to londonali1010 for the hollow widgets script and for the clockwise rings function.  http://londonali1010.deviantart.com/art/Conky-Widgets-Script-141963883

The Counter-clockwise ring function is my own edit of the clockwise rings function for ease of use (as opposed to the counter-clockwise rings script, also by londonali).

Graph widget code is by wlourf, and I've configured it myself to work inside londonali's widget script and play nicely with everything else.  http://wlourf.deviantart.com/art/Graph-Widget-for-Conky-1-1-184541530

--JeSuisNerd

--]]

require 'cairo'

-- CLOCKWISE RINGS
function ring(cr, name, arg, max, bgc, bga, fgc, fga, xc, yc, r, t, sa, ea)
	local function rgb_to_r_g_b(colour,alpha)
		return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
	end

	local function draw_ring(pct)
		local angle_0=sa*(2*math.pi/360)-math.pi/2
		local angle_f=ea*(2*math.pi/360)-math.pi/2
		local pct_arc=pct*(angle_f-angle_0)

		-- Draw background ring

		cairo_arc(cr,xc,yc,r,angle_0,angle_f)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
		cairo_set_line_width(cr,t)
		cairo_stroke(cr)

		-- Draw indicator ring

		cairo_arc(cr,xc,yc,r,angle_0,angle_0+pct_arc)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
		cairo_stroke(cr)
	end

	local function setup_ring()
		local str = ''
		local value = 0

		str = string.format('${%s %s}', name, arg)
		str = conky_parse(str)

		value = tonumber(str)
		if value == nil then value = 0 end
		pct = value/max

		draw_ring(pct)
	end    

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then setup_ring() end
end



-- CCW RINGS
function ring_ccw(cr, name, arg, max, bgc, bga, fgc, fga, xc, yc, r, t, sa, ea)
	local function rgb_to_r_g_b(colour,alpha)
		return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
	end

	local function draw_ring(pct)
		local angle_0=sa*(2*math.pi/360)-math.pi/2
		local angle_f=ea*(2*math.pi/360)-math.pi/2
		local pct_arc=pct*(angle_f-angle_0)

		-- Draw background ring

		cairo_arc(cr,xc,yc,r,angle_0,angle_f)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
		cairo_set_line_width(cr,t)
		cairo_stroke(cr)

		-- Draw indicator ring

		cairo_arc(cr,xc,yc,r,angle_f-pct_arc,angle_f)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
		cairo_stroke(cr)
	end

	local function setup_ring()
		local str = ''
		local value = 0

		str = string.format('${%s %s}', name, arg)
		str = conky_parse(str)

		value = tonumber(str)
		if value == nil then value = 0 end
		pct = value/max

		draw_ring(pct)
	end    

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then setup_ring() end
end



--------------------------------------------------------------------------------------------------------------------------------------
--[[
3 parameters are mandatory
name            - the name of the conky variable to display,
													for example for {$cpu cpu0}, just write name="cpu"
arg                     - the argument of the above variable,
													for example for {$cpu cpu1}, just write arg="cpu1"
													arg can be a numerical value if name=""
max                     - the maximum value the above variable can reach,
													for example for {$cpu cpu1}, just write max=100 or less or more

Optional parameters:
x,y             - coordinates of the bottom-left corner of the graph,
							relative to the top-left corner of the conky window
													default =  bottom-left corner of the conky window
width       - width of the graph, default = 100 pixels
height      - height of the graph, default = 20 pixels
nb_values   - number of values to display in the graph, default=width
							i.e. 1 pixel for 1 value
autoscale   - if set to true, calculate the max valeu of the y axis and
							doesn't use the max parameter above, default=false
skew_x      - skew graph around x axis, défaut = 0
skew_y      - skew graph around y axis, défaut = 0
angle       - angle of rotation of the graph in degress, default = 0
							i.e. a horizontal graph)
inverse     - if set to true, graph are draw from right to left, default=false
background  - if set to false, background is not drawn, default=true
foreground  - if set to false, foreground is not drawn, default=true
							foreground = plain graph
bg_bd_size  - size of the border of the background, default=0=no border
fg_bd_size  - size of the border of the foreground, default=0=no border


Colours tables below are defined into braces :
{position in the gradient (0 to 1), colour in hexadecimal, alpha (0 to 1)}
example for a single colour table :
{{0,0xFFAA00,1}} position parameter doesn't matter
example for a two-colours table :
{{0,0xFFAA00,1},{1,0x00AA00,1}} or {{0.5,0xFFAA00,1},{1,0x00AA00,1}}
example for a three-colours table :
{{0,0xFFAA00,1},{0.5,0xFF0000,1},{1,0x00AA00,1}}

bg_colour       - colour table for background,
													default = {{0,0x000000,.5},{1,0xFFFFFF,.5}}
fg_colour       - colour table for foreground,
													default = {{0,0x00FFFF,1},{1,0x0000FF,1}}
bg_bd_colour- colour table for background border,
													default = {{1,0xFFFFFF,1}}                     
fg_bd_colour- colour table for foreground border,
													default = {{1,0xFFFF00,1}}                     

bg_orientation, bg_bd_orientation, fg_orientation, fg_bd_orientation,
								- "orientation" defines the starting point of the gradient,
									default="nn"
													there are 8 available starting points :
													"nw","nn","ne","ee","se","ss","sw","ww"
													(n for north, w for west ...)
													theses 8 points are the 4 corners + the 4 middles of graph
													so a gradient "nn" will go from "nn" to "ss"
													a gradient "nw" will go from "nw" to "se"

draw_me     - if set to false, graph is not drawn (default = true)
							it can be used with a conky string, if the string returns 1, the graph is drawn :
							example : "${if_empty ${wireless_essid wlan0}}${else}1$endif"
]]
function set_settings(offsetx, offsety)
	graph_settings={
		--eth0
		{
			name="upspeedf",
			arg="eth0",
			max=1000,
			autoscale=true,
			x=offsetx+85,
			y=offsety+785,
			width=160,
			height=42,
			nb_values=100,
			background=true,
			foreground=true,
			inverse=true,
			bg_bd_size=1,
			fg_bd_size=3,
			angle=-90,
			fg_orientation="ss",
			bg_orientation="nn",
			bg_colour = {{0,0xa49a30,0},{1,0xa49a30,.1}},
			fg_colour = {{0,0xa49a30,0.7},{1,0x348a8f,0.7}},
			fg_bd_colour={{0,0xa49a30,0}},
			bg_bd_colour={{0,0xa49a30,0.7}},
			draw_me=true,
		},
		{
			name="downspeedf",
			arg="eth0",
			max=1000,
			autoscale=true,
			x=offsetx+87,
			y=offsety+625,
			width=160,
			height=42,
			nb_values=100,
			background=true,
			foreground=true,
			inverse=true,
			bg_bd_size=1,
			fg_bd_size=3,
			angle=90,
			fg_orientation="ss",
			bg_orientation="nn",
			bg_colour = {{0,0xa49a30,0},{1,0xa49a30,.1}},
			fg_colour = {{0,0xa49a30,0.7},{1,0x348a8f,0.7}},
			fg_bd_colour={{0,0xa49a30,0}},
			bg_bd_colour={{0,0xa49a30,0.7}},
			draw_me=true,
		},
		--wlan0
		{
			name="upspeedf",
			arg="wlan0",
			max=1000,
			autoscale=true,
			x=offsetx+200,
			y=offsety+785,
			width=160,
			height=42,
			nb_values=100,
			background=true,
			foreground=true,
			inverse=true,
			bg_bd_size=1,
			fg_bd_size=3,
			angle=-90,
			fg_orientation="ss",
			bg_orientation="nn",
			bg_colour = {{0,0x348a8f,0},{1,0x348a8f,.1}},
			fg_colour = {{.3,0x348a8f,0.7},{1,0xa49a30,0.7}},
			fg_bd_colour={{0,0x348a8f,0}},
			bg_bd_colour={{0,0x348a8f,0.7}},
			draw_me=true,
		},
		{
			name="downspeedf",
			arg="wlan0",
			max=1000,
			autoscale=true,
			x=offsetx+202,
			y=offsety+625,
			width=160,
			height=42,
			nb_values=100,
			background=true,
			foreground=true,
			inverse=true,
			bg_bd_size=1,
			fg_bd_size=3,
			angle=90,
			fg_orientation="ss",
			bg_orientation="nn",
			bg_colour = {{0,0x348a8f,0},{1,0x348a8f,.1}},
			fg_colour = {{.3,0x348a8f,0.7},{1,0x348a8f,0.7}},
			fg_bd_colour={{0,0x348a8f,0}},
			bg_bd_colour={{0,0x348a8f,0.7}},
			draw_me=true,
		}
	}
end

function check_settings(t)
	--tables are check only when conky start
	if t.name==nil and t.arg==nil then
		print ("No input values ... use parameters 'name'" ..
				 " with 'arg' or only parameter 'arg' ")
		return 1
	end

	if t.max==nil then
		print ("No maximum value defined, use 'max'")
		print ("for name=" .. t.name .. " with arg=" .. t.arg)
		return 1
	end
	if t.name==nil then t.name="" end
	if t.arg==nil then t.arg="" end
	return 0
end

function draw_graph(t)
	--drawing function

	local function rgb_to_r_g_b(colour)
		return ((colour[2] / 0x10000) % 0x100) / 255., ((colour[2] / 0x100) % 0x100) / 255., (colour[2] % 0x100) / 255., colour[3]
	end

	local function linear_orientation(o,w,h)
		--set gradient for bg and bg border
		local p
		if o=="nn" then
			p={w/2,h,w/2,0}
		elseif o=="ne" then
			p={w,h,0,0}
		elseif o=="ww" then
			p={0,h/2,w,h/2}
		elseif o=="se" then
			p={w,0,0,h}
		elseif o=="ss" then
			p={w/2,0,w/2,h}
		elseif o=="ee" then
			p={w,h/2,0,h/2}        
		elseif o=="sw" then
			p={0,0,w,h}
		elseif o=="nw" then
			p={0,h,w,0}
		end
		return p
	end

	local function linear_orientation_inv(o,w,h)
		--set gradient for fg and fg border
		local p
		if o=="ss" then
			p={w/2,h,w/2,0}
		elseif o=="sw" then
			p={w,h,0,0}
		elseif o=="ee" then
			p={0,h/2,w,h/2}
		elseif o=="nw" then
			p={w,0,0,h}
		elseif o=="nn" then
			p={w/2,0,w/2,h}
		elseif o=="ww" then
			p={w,h/2,0,h/2}        
		elseif o=="ne" then
			p={0,0,w,h}
		elseif o=="se" then
			p={0,h,w,0}
		end
		return p
	end


	--set default values

	--cancel drawing if not needed
	if t.draw_me~=nil and conky_parse(tostring(t.draw_me)) ~= "1" then
		return
	end



	if t.height==nil        then t.height=20 end
	--checked in previous part : width and nb_values

	if t.background==nil    then t.background=true end
	if t.bg_bd_size==nil    then t.bg_bd_size=0 end
	if t.x==nil                 then t.x=t.bg_bd_size end
	if t.y==nil                 then t.y=conky_window.height -t.bg_bd_size end
	if t.bg_colour==nil     then t.bg_colour={{0,0x000000,.5},{1,0xFFFFFF,.5}} end
	if t.bg_bd_colour==nil  then t.bg_bd_colour={{1,0xFFFFFF,1}} end

	if t.foreground==nil    then t.foreground=true end
	if t.fg_colour==nil     then t.fg_colour={{0,0x00FFFF,1},{1,0x0000FF,1}} end

	if t.fg_bd_size==nil    then t.fg_bd_size=0 end
	if t.fg_bd_colour==nil  then t.fg_bd_colour={{1,0xFFFF00,1}} end

	if t.autoscale==nil     then t.autoscale=false end
	if t.inverse==nil       then t.inverse=false end
	if t.angle==nil         then t.angle=0 end

	if t.bg_bd_orientation==nil then t.bg_bd_orientation="nn" end
	if t.bg_orientation==nil then t.bg_orientation="nn" end
	if t.fg_bd_orientation==nil then t.fg_bd_orientation="nn" end
	if t.fg_orientation==nil then t.fg_orientation="nn" end

	--check colours tables
	for i=1, #t.fg_colour do    
		if #t.fg_colour[i]~=3 then
			print ("error in fg_colour table")
			t.fg_colour[i]={1,0x0000FF,1}
		end
	end

	for i=1, #t.fg_bd_colour do    
		if #t.fg_bd_colour[i]~=3 then
			print ("error in fg_bd_colour table")
			t.fg_bd_colour[i]={1,0x00FF00,1}
		end
	end

	for i=1, #t.bg_colour do    
		if #t.bg_colour[i]~=3 then
			print ("error in background color table")
			t.bg_colour[i]={1,0xFFFFFF,0.5}
		end
	end    

	for i=1, #t.bg_bd_colour do    
		if #t.bg_bd_colour[i]~=3 then
			print ("error in background border color table")
			t.bg_bd_colour[i]={1,0xFFFFFF,1}
		end
	end    

	--calculate skew parameters if needed
	if t.flag_init then
		if t.skew_x == nil then
			t.skew_x=0
		else
			t.skew_x = math.pi*t.skew_x/180    
		end
		if t.skew_y == nil then
			t.skew_y=0
		else
			t.skew_y = math.pi*t.skew_y/180    
		end
		t.flag_init=false
	end

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_join(cr,CAIRO_LINE_JOIN_ROUND)

	local matrix0 = cairo_matrix_t:create()
	tolua.takeownership(matrix0)
	cairo_save(cr)
	cairo_matrix_init (matrix0, 1,t.skew_y,t.skew_x,1,0,0)
	cairo_transform(cr,matrix0)

	local ratio=t.width/t.nb_values

	cairo_translate(cr,t.x,t.y)
	cairo_rotate(cr,t.angle*math.pi/180)
	cairo_scale(cr,1,-1)

	--background
	if t.background then
		local pts=linear_orientation(t.bg_orientation,t.width,t.height)
		local pat = cairo_pattern_create_linear (pts[1],pts[2],pts[3],pts[4])
		for i=1, #t.bg_colour do
			--print ("i",i,t.colour[i][1], rgb_to_r_g_b(t.colour[i]))
			cairo_pattern_add_color_stop_rgba (pat, t.bg_colour[i][1], rgb_to_r_g_b(t.bg_colour[i]))
		end
		cairo_set_source (cr, pat)
		cairo_rectangle(cr,0,0,t.width,t.height)       
		cairo_fill(cr) 
		cairo_pattern_destroy(pat)
	end

	--autoscale
	cairo_save(cr)
	if t.autoscale then
		t.max= t.automax*1.1
	end

	local scale_x = t.width/(t.nb_values-1)
	local scale_y = t.height/t.max

	--define first point of the graph
	if updates-updates_gap <t.nb_values then
		t.beg = t.beg - 1
		--next line prevent segmentation error when conky window is redraw
		--quicly when another window "fly" over it
		if t.beg<0 then t.beg=0 end
	else
		t.beg=0
	end
	if t.inverse then cairo_scale(cr,-1,1)
		cairo_translate(cr,-t.width,0)
	end

	--graph foreground
	if t.foreground then
		local pts_fg=linear_orientation_inv(t.fg_orientation,t.width,t.height)
		local pat = cairo_pattern_create_linear (pts_fg[1],pts_fg[2],pts_fg[3],pts_fg[4])
		for i=1,#t.fg_colour,1 do
			cairo_pattern_add_color_stop_rgba (pat, 1-t.fg_colour[i][1], rgb_to_r_g_b(t.fg_colour[i]))
		end
		cairo_set_source (cr, pat)

		cairo_move_to(cr,t.beg*scale_x,0)
		cairo_line_to(cr,t.beg*scale_x,t.values[t.beg+1]*scale_y)
		for i=t.beg, t.nb_values-1 do
			cairo_line_to(cr,i*scale_x,t.values[i+1]*scale_y)              
		end
		cairo_line_to(cr,(t.nb_values-1)*scale_x,0)
		cairo_close_path(cr)
		cairo_fill(cr)
		cairo_pattern_destroy(pat)
	end

	--graph_border
	if t.fg_bd_size>0 then
		local pts=linear_orientation_inv(t.fg_bd_orientation,t.width,t.height)
		local pat = cairo_pattern_create_linear (pts[1],pts[2],pts[3],pts[4])
		for i=1,#t.fg_bd_colour,1 do
			cairo_pattern_add_color_stop_rgba (pat, 1-t.fg_bd_colour[i][1], rgb_to_r_g_b(t.fg_bd_colour[i]))
		end
		cairo_set_source (cr, pat)
		cairo_move_to(cr,t.beg*scale_x,t.values[t.beg+1]*scale_y)
		for i=t.beg, t.nb_values-1 do
			cairo_line_to(cr,i*scale_x,t.values[i+1]*scale_y)              
		end
		cairo_set_line_width(cr,t.fg_bd_size)
		cairo_stroke(cr)
		cairo_pattern_destroy(pat)
	end
	cairo_restore(cr)

	--background border
	if t.bg_bd_size>0 then
		local pts=linear_orientation(t.bg_bd_orientation,t.width,t.height)
		local pat = cairo_pattern_create_linear (pts[1],pts[2],pts[3],pts[4])
		for i=1, #t.bg_bd_colour do
			--print ("i",i,t.colour[i][1], rgb_to_r_g_b(t.colour[i]))
			cairo_pattern_add_color_stop_rgba (pat, t.bg_bd_colour[i][1], rgb_to_r_g_b(t.bg_bd_colour[i]))
		end
		cairo_set_source (cr, pat)
		cairo_rectangle(cr,0,0,t.width,t.height)       
		cairo_set_line_width(cr,t.bg_bd_size)
		cairo_stroke(cr)
		cairo_pattern_destroy(pat)     
	end    

	cairo_restore(cr)

end

function conky_widgets()
	if conky_window == nil then return end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	local w=conky_window.width
	local h=conky_window.height
	cr = cairo_create(cs)
	local x = 1326
	local y = -16

	--Rings--

	--ring (cr, type, argument, maxvalue, backcolor, backalpha, forecolor, forealpha, x, y, radius, thickness, start, end)
	ring(cr,     'cpu',             'cpu0',           100, 0x020202, .1, 0x7365BC, 1, x + 95,  y + 178, 62, 4, 90, 360)
	ring(cr,     'cpu',             'cpu1',           100, 0x020202, .1, 0x34678F, 1, x + 95,  y + 178, 55, 4, 90, 360)
	ring(cr,     'cpu',             'cpu2',           100, 0x020202, .1, 0x348a8f, 1, x + 95,  y + 178, 48, 4, 90, 360)
	ring(cr,     'cpu',             'cpu3',           100, 0x020202, .1, 0x348f43, 1, x + 95,  y + 178, 41, 4, 90, 360)
	ring(cr,     'cpu',             'cpu4',           100, 0x020202, .1, 0x8f8834, 1, x + 95,  y + 178, 34, 4, 90, 360)
	ring(cr,     'cpu',             'cpu5',           100, 0x020202, .1, 0xb55511, 1, x + 95,  y + 178, 27, 4, 90, 360)
	ring(cr,     'cpu',             'cpu6',           100, 0x020202, .1, 0x942a36, 1, x + 95,  y + 178, 20, 4, 90, 360)
	ring(cr,     'cpu',             'cpu7',           100, 0x020202, .1, 0x7365BC, 1, x + 95,  y + 178, 13, 4, 90, 360)
	ring_ccw(cr, 'memperc',         '',               100, 0x020202, .1, 0xa49a30, 1, x + 190, y + 293, 62, 4, 0,  270)
	ring(cr,     'fs_used_perc',    '/',              100, 0x020202, .1, 0x348f43, 1, x + 95,  y + 413, 62, 4, 90, 360)
	ring(cr,     'fs_used_perc',    '/media/school/', 100, 0x020202, .1, 0x8f8834, 1, x + 95,  y + 413, 55, 4, 90, 360)
	ring(cr,     'fs_used_perc',    '/home/',         100, 0x020202, .1, 0x7365BC, 1, x + 95,  y + 413, 48, 4, 90, 360)
	ring_ccw(cr, 'battery_percent', 'BAT0',           100, 0x020202, .1, 0xa49a30, 1, x + 190, y + 526, 62, 4, 0,  270)



	--Graphs--
	updates=tonumber(conky_parse('${updates}'))
	--start drawing after "updates_gap" updates
	--prevent segmentation error for cpu
	updates_gap=5
	flagOK=0
	if updates<=1 or graph_settings == nil or true then    
		set_settings(x, y)

		for i in pairs(graph_settings) do
			if graph_settings[i].width==nil then graph_settings[i].width=100 end
			if graph_settings[i].nb_values==nil then  
				graph_settings[i].nb_values= graph_settings[i].width
			end
			--create an empty table to store values
			graph_settings[i]["values"]={}
			--beginning point
			graph_settings[i].beg = graph_settings[i].nb_values
			--graph_settings[i].beg = 0
			for j =1, graph_settings[i].nb_values do
				graph_settings[i].values[j]=0
			end
			graph_settings[i].flag_init=true
			flagOK=flagOK + check_settings(graph_settings[i])

		end
	end

	if flagOK>0 then
		--abort script if error in one of the tables
		print ("ERROR : Check the graph_setting table")
		return
	end

	--drawing process
	if updates > updates_gap then
		for i in pairs(graph_settings) do
			if graph_settings[i].draw_me==true then graph_settings[i].draw_me = nil end
			if (graph_settings[i].draw_me==nil or conky_parse(tostring(graph_settings[i].draw_me)) == "1") then
				local nb_values=graph_settings[i].nb_values
				graph_settings[i].automax=0
				for j =1, nb_values do
					if graph_settings[i].values[j+1]==nil then
						graph_settings[i].values[j+1]=0
					end

					graph_settings[i].values[j]=graph_settings[i].values[j+1]
					if j==nb_values then
						--store value
						if graph_settings[i].name=="" then
							value=graph_settings[i].arg
						else
							value=tonumber(conky_parse('${' ..
																	graph_settings[i].name .. " " ..
																	graph_settings[i].arg ..'}'))
						end
						graph_settings[i].values[nb_values]=value
					end
					graph_settings[i].automax=math.max(graph_settings[i].automax,
																				graph_settings[i].values[j])
					--should stop weird glitches at beginning when no values reported yet for upspeed or diskio
					if graph_settings[i].automax == 0 then graph_settings[i].automax = 1 end
				end
				draw_graph(graph_settings[i])
			end
		end
	end

	cairo_destroy(cr)

end
