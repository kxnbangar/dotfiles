function conky_time_to_cat(dm)
   today = os.date("%j");
   examday = 304;
   days_to_cat = tostring(examday - tonumber(today));
   mnths_to_cat = string.format("%.2f", days_to_cat/31);
   result = dm;

   if(dm == 'd') then
      result = days_to_cat;
   end

   if(dm == 'm') then
      result = mnths_to_cat;
   end

   return result;
end

--[[function conky_org()
   local file = assert(io.open ("/home/arsh/Notes/pages/dailyp.org", "r"))
   local org_text  = file:read("*all")
   file:close()
   return org_text
end--]]
