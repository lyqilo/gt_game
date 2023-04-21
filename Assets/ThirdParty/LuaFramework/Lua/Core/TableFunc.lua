--string拓展
function string.length( str )
	return Util.GetStrLength( str );
end

function string.trim(s) 
	return (string.gsub(s, "^%s*(.-)%s*$", "%1")) 
end

--[[function string.split(str, szSeparator)
	local strLen = string.len(str);
	local nFindStartIndex = 1;
	local nSplitIndex = 1;
	local nSplitArray = {};
	while true do
		local nFindLastIndex = string.find(str, szSeparator, nFindStartIndex );
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, strLen );
			break;
		end
		nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, nFindLastIndex - 1);
		nFindStartIndex = nFindLastIndex + string.len(szSeparator);
		nSplitIndex = nSplitIndex + 1;
	end
	return nSplitArray;
end--]]

--table拓展
function table.nums( tb , ignoreFunc )
	local count = 0;
	for k,v in pairs(tb or {}) do
		if v ~= nil then
			if ignoreFunc == nil or ignoreFunc then
				if type(v) ~= "function" then
					count = count + 1;
				end
			else
				count = count + 1;
			end
		end
	end
	return count;
end

--折叠table
function table.fold( tb )
	local maxn = table.maxn(tb);
	local i = 1;
	repeat
		local v = tb[i];
		if v == nil then
			local j = i + 1;
			repeat 
				local nextv = tb[j];
				if nextv ~= nil then
					tb[i] = nextv;
					tb[j] = nil;
					break;
				else
					j = j + 1;
				end
			until j > maxn;
		end
		i = i + 1;
	until i > maxn;
	return tb;
end

--lua拓展方法
--[[function clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end--]]

--打印Table方法
local tabSort = "    ";
local strBuilder = StringBuilder:new();
local writeTable;
writeTable = function ( tbData , indent )
	indent = indent + 1;
	if tbData._fields == nil then
		strBuilder:Append("{\n");
		for key, value in pairs(tbData) do
			if type(key) ~= "function" then
				for i=1,indent do
					strBuilder:Append(tabSort);
				end
				if type(key) ~= "string" then
					strBuilder:Append(string.format("[%s] = ",key));
				else
					strBuilder:Append(string.format("[\"%s\"] = ",key));
				end
				if type(value) == "table" then
					writeTable(value , indent);
				else
					if type(value) ~= "string" then
						strBuilder:Append(string.format("%s;\n",value));
					else
						strBuilder:Append(string.format("\"%s\";\n",value));
					end
				end
			end
		end	
	else
		strBuilder:Append("{ --PotoData\n");
		local potoStrs = string.split(tostring(tbData),"\n");
		local linesLen = #potoStrs;
		for i,potoLine in ipairs(potoStrs) do
			if i ~= linesLen then
				for i=1,indent + 1 do
					strBuilder:Append(tabSort);
				end
			end
			if potoLine ~= "" then
				strBuilder:Append(potoLine);
				strBuilder:Append("\n");
			end
		end
	end
	for i=1,indent - 1 do
		strBuilder:Append(tabSort);
	end
	strBuilder:Append("};\n");
end


function logTable( tb )
	writeTable(tb,0);
	local logMsg = strBuilder:ToString();
	strBuilder:Clear();
	log(logMsg);
end

function logWarnTable( tb )
	writeTable(tb,0);
	local logMsg = strBuilder:ToString();
	strBuilder:Clear();
	logWarn(logMsg);
end

function logErrorTable( tb )
	writeTable(tb,0);
	local logMsg = strBuilder:ToString();
	strBuilder:Clear();
	logError(logMsg);
end