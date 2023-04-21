namespace LuaFramework
{	
	public struct BaseAppInfoJson
	{	
		public string pakName { get; set; }
		public int version { get; set; }	
		public bool share { get; set; }
		public bool online { get; set; }
		public bool buy { get; set; }
		public int[] gameOrder { get; set; }
		public string extend { get; set; }
	}
}
