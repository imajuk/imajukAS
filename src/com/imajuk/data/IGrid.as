package com.imajuk.data 
{
	/**
	 * @author yamaharu
	 */
	public interface IGrid 
	{
		function get cols () : int
		function get rows () : int
		function get size () : int
		function get width () : Number;
		function get height () : Number;
		function get cellWidth () : Number;
		function get cellHeight () : Number;
		
		function getInfo (__col : int, __row : int) : Grid2DCell
		
		function iterator () : IArray2DIterator;
		function reverseIterator () : IArray2DIterator;
		function u_r_Iterator () : IArray2DIterator;
		function circleIterator (__distance : Number) : IArray2DIterator;
		
		function appendCols (__cols : int) : void;
		function appendRows (__rows : int) : void;
		function shiftRight (__value : int = 1, __repeat : Boolean = false) : void
		function shiftLeft (__value : int = 1, __repeat : Boolean = false) : void
		function shiftUp (__value : int = 1, __repeat : Boolean = false) : void
		function shiftDown (__value : int = 1, __repeat : Boolean = false, __x1 : int = 0, __x2 : int = 0) : void
		function removeRow (__remove : int) : void;
		function removeCol (__remove : int) : void;
		
		function clone () : IGrid;		function map (__mapiterator : IArray2DIterator) : IGrid
		function print () : void;
		
		
			}
}
