package com.imajuk.animations 
{
	import com.imajuk.utils.DictionaryUtil;    

	import flash.utils.Dictionary;    

	/**
	 * @author yamaharu
	 */
	public class Pool 
	{
		private var _size:uint;
		private var d:Dictionary;
		private var reverseRef:Dictionary;

		public function Pool(size:uint = 100) 
		{
			d = new Dictionary(true);
			reverseRef = new Dictionary(true);
			this._size = size;
		}

		public function toString():String 
		{
			return "com.imajuk.animations.Pool";
		}

		public function checkIn(key:*, node:*):void
		{
			if(d[key])
        	   throw new Error("キー" + key + "は既にチェックインされています.");
        	   
			if(currentSize >= _size)
                return;
        	
			d[key] = node;
			reverseRef[node] = key;
		}

		public function checkOut(key:* = null):*
		{
			var o:*;
			if(key == null)
			{
				o = DictionaryUtil.random(d);
				d[reverseRef[o]] = null;
			}
			else
			{
				o = d[key];
				release(key);
			}
			return o;
		}

		public function release(key:*):void
		{
			d[key] = null;
		}

		public function get size():uint
		{
			return _size;
		}

		public function get currentSize():uint
		{
			return DictionaryUtil.count(d);
		}
	}
}
