--predefine

function Color(r, g, b, a)
	local color = {};
	color.r = r
	color.g = g
	color.b = b
	color.a = a
	return color
end


function round(x)
	return x + 0.5 - (x + 0.5)%1
end