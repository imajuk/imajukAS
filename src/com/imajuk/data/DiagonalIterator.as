package com.imajuk.data {
	import com.imajuk.data.IArray2DIterator;		/**
	 * @author yamaharu
	 */
	public class DiagonalIterator extends Array2DIterator implements IArray2DIterator 	{		public function DiagonalIterator (__array2D : Array2D) 		{			super(__array2D);			myArray = new Array();						var x : int = 0;			var y : Number = 0;			var a : Array2D = __array2D;			var r : int = a.rows;			var addX : Number = a.cols / r;			var x2 : Number = addX;			while(y < r)			{				while(x < x2)				{					var e : * = a.getElement(x ++, y);					if(e) myArray.push(e);				}				x2 += addX;				x --;				y ++;			}		}
								public override function get cursorX () : int		{			//未実装			return 0;		}								public override function get cursorY () : int		{			//未実装			return 0;		}	}
}
