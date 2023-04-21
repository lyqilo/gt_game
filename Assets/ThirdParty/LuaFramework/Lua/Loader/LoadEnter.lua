
luaFiles = {};

require "Loader/LoadCore";			--核心脚本载入
require "Loader/LoadCommon";		--全局脚本载入

Loader = {};
function Loader.GetLoadFiles()
	local _luaFiles = luaFiles;
	luaFiles = nil;
	Loader.GetLoadFiles = nil;
	Loader = nil;
	--返回需要加载的文件
	return unpack(_luaFiles);
end




