package com.imajuk.data 
{
	import flash.geom.Point;	
	import flash.geom.Rectangle;	

	import com.imajuk.data.Array2DIterator;
	import com.imajuk.data.IArray2DIterator;

	/**
	 * @author yamaharu
	 */
	public class CircleIterator extends Array2DIterator implements IArray2DIterator 
	{
		public function CircleIterator (__array2D : Array2D, __target : IGrid, __distance : Number)
		{
			super(__array2D);
			
			myArray = [];
			//センター
			var cx : Number = __target.width * 0.5;
			var cy : Number = __target.height * 0.5;
			var cs : Number = __target.cellWidth;
			var cw : Number = __target.cellWidth * 0.5;			var ch : Number = __target.cellHeight * 0.5;
			var cp : Point = new Point(cx, cy);
			var i : IArray2DIterator = __target.iterator();
			var cell : Grid2DCell;
			var info : Rectangle;
			var tp : Point;
			var x : int;
			var y : int;
			while(i.hasNext())
			{				x = i.cursorX;
				y = i.cursorY;
				cell = i.next();
				info = cell.cellInfo;
				tp = new Point(info.x + cw, info.y + ch);
				var d : Number = Point.distance(cp, tp);
				if(d <= __distance && d > __distance - cs)
					myArray.push(__array2D.getElement(x, y));
			}
		}

		
		
		public override function get cursorX () : int
		{
			return 0;
		}

		
		
		public override function get cursorY () : int
		{
			return 0;
		}
	}
}
