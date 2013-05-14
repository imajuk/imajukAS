package com.imajuk.data 
{
	import com.imajuk.data.IArray2DIterator;
	/**
	 * @author yamaharu
	 */
	public class ReverseIterator extends Array2DIterator implements IArray2DIterator 
	{
		public function ReverseIterator (__array2D : Array2D) 
		{
			super(__array2D);
			
			myArray = __array2D.toArray().reverse();
		}

		
		
		
		override public function get cursorX () : int
		{
			return (_position % _cols - (_cols - 1)) * - 1;
		}

		
		
		
		override public function get cursorY () : int
		{
			return (int(_position / _cols) - (_rows - 1)) * - 1;
		}
	}
}
