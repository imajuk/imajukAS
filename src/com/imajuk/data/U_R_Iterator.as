package com.imajuk.data {
	import com.imajuk.data.IArray2DIterator;		/**	 * Array2Dを以下のような順序で走査する	 * 3	6	9	12	 * 2	5	8	11	 * 1	4	7	10
	 * @author yamaharu
	 */
	public class U_R_Iterator extends Array2DIterator implements IArray2DIterator 	{		public function U_R_Iterator (__array2D : Array2D) 		{			super(__array2D);						myArray = new Array();			for (var x : int = 0;x < _cols; x ++) 			{				for (var y : int = _rows - 1;y >= 0; y --) 				{					myArray.push(__array2D.getElement(x, y));				}			}		}								override public function get cursorX () : int		{			return int(_position / _rows);		}								override public function get cursorY () : int		{			var cy : int = ((_position < _rows) ? _position + _rows : _position) % _rows;			return Math.abs(cy - (_rows - 1));		}	}
}
