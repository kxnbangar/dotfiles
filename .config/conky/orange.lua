require 'cairo'

clock_h = {
   {
      name='time',
      arg='%I',
      max_value=12,
      x=1788,
      y=96,
      graph_radius=72,
      graph_thickness=4,
      graph_unit_angle=30,
      graph_unit_thickness=30,
      graph_bg_colour=0xffffff,
      graph_bg_alpha=0.0,
      graph_fg_colour=0xFFFFFF,
      graph_fg_alpha=0.4,
      txt_radius=24,
      txt_weight=1,
      txt_size=0.0,
      txt_fg_colour=0xFFFFFF,
      txt_fg_alpha=0.6,
      graduation_radius=68,
      graduation_thickness=6,
      graduation_mark_thickness=2,
      graduation_unit_angle=30,
      graduation_fg_colour=0xFFFFFF,
      graduation_fg_alpha=0.4,
   },
}

clock_m = {
   {
      name='time',
      arg='%M',
      max_value=60,
      x=1788,
      y=96,
      graph_radius=84,
      graph_thickness=2,
      graph_unit_angle=6,
      graph_unit_thickness=6,
      graph_bg_colour=0xffffff,
      graph_bg_alpha=0.1,
      graph_fg_colour=0xFFFFFF,
      graph_fg_alpha=0.8,
      txt_radius=48,
      txt_weight=0,
      txt_size=0.0,
      txt_fg_colour=0xFFFFFF,
      txt_fg_alpha=0.6,
      graduation_radius=78,
      graduation_thickness=0,
      graduation_mark_thickness=2,
      graduation_unit_angle=30,
      graduation_fg_colour=0xFFFFFF,
      graduation_fg_alpha=0.0,
   },
}

clock_s = {
   {
      name='time',
      arg='%S',
      max_value=60,
      x=1788,
      y=96,
      graph_radius=78,
      graph_thickness=2,
      graph_unit_angle=6,
      graph_unit_thickness=2,
      graph_bg_colour=0xffffff,
      graph_bg_alpha=0.0,
      graph_fg_colour=0xFFFFFF,
      graph_fg_alpha=0.6,
      txt_radius=48,
      txt_weight=0.0,
      txt_size=12.0,
      txt_fg_colour=0xFFFFFF,
      txt_fg_alpha=0.6,
      graduation_radius=0,
      graduation_thickness=0,
      graduation_mark_thickness=0,
      graduation_unit_angle=0,
      graduation_fg_colour=0xFFFFFF,
      graduation_fg_alpha=0.0,
   },
}

-------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
-- converts color in hexa to decimal
--
function rgb_to_r_g_b(colour, alpha)
   return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-------------------------------------------------------------------------------
--                                                            angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)
--
function angle_to_position(start_angle, current_angle)
   local pos = current_angle + start_angle
   return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end

-------------------------------------------------------------------------------
--                                                              draw_clock_ring
-- displays clock
--
function draw_clock_ring(display, data, value)
   local max_value = data['max_value']
   local x, y = data['x'], data['y']
   local graph_radius = data['graph_radius']
   local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
   local graph_unit_angle = data['graph_unit_angle']
   local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
   local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']

   -- background ring
   cairo_arc(display, x, y, graph_radius, 0, 2 * math.pi)
   cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
   cairo_set_line_width(display, graph_thickness)
   cairo_stroke(display)

   -- arc of value
   local val = (value % max_value)
   local i = 1
   while i <= val do
      cairo_arc(display, x, y, graph_radius,(  ((graph_unit_angle * i) - graph_unit_thickness)*(2*math.pi/360)  )-(math.pi/2),((graph_unit_angle * i) * (2*math.pi/360))-(math.pi/2))
      cairo_set_source_rgba(display,rgb_to_r_g_b(graph_fg_colour,graph_fg_alpha))
      cairo_stroke(display)
      i = i + 1
   end
   local angle = (graph_unit_angle * i) - graph_unit_thickness

   -- graduations marks
   local graduation_radius = data['graduation_radius']
   local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
   local graduation_unit_angle = data['graduation_unit_angle']
   local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
   if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
      local nb_graduation = 360 / graduation_unit_angle
      local i = 1
      while i <= nb_graduation do
	 cairo_set_line_width(display, graduation_thickness)
	 cairo_arc(display, x, y, graduation_radius, (((graduation_unit_angle * i)-(graduation_mark_thickness/2))*(2*math.pi/360))-(math.pi/2),(((graduation_unit_angle * i)+(graduation_mark_thickness/2))*(2*math.pi/360))-(math.pi/2))
	 cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
	 cairo_stroke(display)
	 cairo_set_line_width(display, graph_thickness)
	 i = i + 1
      end
   end

   -- text
   local txt_radius = data['txt_radius']
   local txt_weight, txt_size = data['txt_weight'], data['txt_size']
   local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
   local movex = txt_radius * (math.cos((angle * 2 * math.pi / 360)-(math.pi/2)))
   local movey = txt_radius * (math.sin((angle * 2 * math.pi / 360)-(math.pi/2)))
   cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, txt_weight);
   cairo_set_font_size (display, txt_size);
   cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha));
   cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3);
   cairo_show_text (display, value);
   cairo_stroke (display);
end

-------------------------------------------------------------------------------
--                                                               go_clock_rings
-- loads data and displays clock
--
function go_clock_rings(display)
   local function load_clock_rings(display, data)
      local str, value = '', 0
      str = string.format('${%s %s}',data['name'], data['arg'])
      str = conky_parse(str)
      value = tonumber(str)
      draw_clock_ring(display, data, value)
   end

   for i in pairs(clock_h) do
      load_clock_rings(display, clock_h[i])
   end
   for i in pairs(clock_m) do
      load_clock_rings(display, clock_m[i])
   end
   for i in pairs(clock_s) do
      load_clock_rings(display, clock_s[i])
   end
end

-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
   if conky_window == nil then
      return
   end

   local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
   local display = cairo_create(cs)

   local updates = conky_parse('${updates}')
   update_num = tonumber(updates)

   if update_num > 5 then
      go_clock_rings(display)
   end

   cairo_surface_destroy(cs)
   cairo_destroy(display)
end
