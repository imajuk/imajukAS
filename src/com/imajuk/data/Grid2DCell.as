package com.imajuk.data 
{
	import flash.geom.Rectangle;	
	/**
	 * @author yamaharu
	 */
	public class Grid2DCell 
	{
		private var _indexX : int;
		private var _indexY : int;
		private var _info : Rectangle;
		private var _data : *;

		
		public function Grid2DCell (__idxX : int, __idxY : int, __cellInfo : Rectangle) 
		{
			_indexX = __idxX;
			_indexY = __idxY;
			_info = __cellInfo;
		}

		
		
		
		//---------------------------------------------------------------------------------getter
		public function toString () : String 
		{
			//			return "Grid2DCell [" + _indexX + ", " + _indexY + ", cell=" + _info + "]";			return "[" + _indexX + ", " + _indexY + ", cell=" + _info + "]";
		}

		
		
		
		public function get cellInfo () : Rectangle
		{
			return _info;
		}

		
		
		
		public function set cellInfo (__r : Rectangle) : void
		{
			_info = __r;
		}

		
		
		
		public function get indexX () : int
		{
			return _indexX;
		}

		
		
		
		public function set indexX (__value : int) : void
		{
			_indexX = __value;
		}

		
		
		
		public function get indexY () : int
		{
			return _indexY;
		}

		
		
		
		public function set indexY (__value : int) : void
		{
			_indexY = __value;
		}

		
		
		
		public function get data () : *		{
			return _data;
		}

		
		
		
		public function set data (__data : *) : void
		{
			_data = __data;
		}

		
		
		
		public function clone () : Grid2DCell
		{
			var c : Grid2DCell = new Grid2DCell(_indexX, _indexY, _info.clone());
			c.data = _data; 
			return c;
		}
	}
}
