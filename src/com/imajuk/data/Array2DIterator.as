package com.imajuk.data {
	import com.imajuk.data.IArray2DIterator;		/**	 * Array2Dを走査するイテレータ	 * 操作順は以下の通り	 * 1	2	3	4	 * 5	6	7	8	 * 9	10	11	12
	 * @author yamaharu
	 */
	public class Array2DIterator extends ArrayIterator implements IArray2DIterator 	{		protected var _cols : int;		protected var _rows : int;
				public function Array2DIterator (__array2D : Array2D) 		{			super(__array2D.toArray());			_cols = __array2D.cols;			_rows = __array2D.rows;		}
								public function get cursorX () : int		{			return int(_position % _cols);		}
								public function get cursorY () : int		{			return int(_position / _cols);		}
								public function get size () : int		{			return myArray.length;		}	}
}
