
bit = {};
local this = bit;

--与运算
function bit.band( a , b )
	return Util.Band(a,b);
end

--或运算
function bit.bor( a , b )
	return Util.Bor(a,b);
end

--非运算
function bit.neg( a )
	return Util.Neg(a);
end

--异或运算
function bit.xor( a , b )
	return Util.Xor(a,b);
end

--左移
function bit.shl( a , b )
	return Util.Shl(a,b);
end

--右移
function bit.shr( a , b )
	return Util.Shr(a,b);
end