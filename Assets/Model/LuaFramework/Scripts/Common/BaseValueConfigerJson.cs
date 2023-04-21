namespace LuaFramework
{	
	public struct BaseValueConfigerJson
	{				
		public string moduleName { get; set; }	
		public string dirPath { get; set; }		
		public uint crc { get; set; }
		public string hash { get; set; }	
		public string md5 { get; set; }		
		public int version { get; set; }		
		public string size { get; set; }
	}
}
