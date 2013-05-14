package com.imajuk.data 
{
	import com.imajuk.data.CircleIterator;	

	import flash.geom.Rectangle;
	import flash.geom.Point;

	import com.imajuk.data.Grid2DCell;
	import com.imajuk.data.IArray2DIterator;
	import com.imajuk.data.IGrid;	
	/**
	 * @author yamaharu
	 */
	public class Grid2D implements IGrid
	{
		protected var _cells : Array2D;
		protected var _width : Number;
		protected var _height : Number;
		protected var _marginH : Number;
		protected var _marginV : Number;
		protected var _relativeMargin : Boolean;
		protected var _cellWidth : Number;
		protected var _cellHeight : Number;

		public function Grid2D (
								__cols : int,
								__rows : int,
								__width : Number,
								__height : Number,
								__marginH : Number = 0,
								__marginV : Number = 0,
								__relativeMargin : Boolean = false
								)
		{
			_cells = new Array2D(__cols, __rows);
			_width = __width;
			_height = __height;
			_marginH = __marginH;
			_marginV = __marginV;
			_relativeMargin = __relativeMargin;
			setupCell();
		}

		
		
		//---------------------------------------------------------------------------------getter/setter
		public function toString () : String 
		{
			return "Grid2D[cols=" + cols + ", rows=" + rows + ", mh=" + _marginH + ", mv=" + _marginV + ", size=" + [ _width, _height ] + "]";
		}

		
		
		public function get cols () : int
		{
			return _cells.cols;
		}

		
		
		public function get rows () : int
		{
			return _cells.rows;
		}

		
		
		public function get width () : Number
		{
			return _width;
		}

		
		
		public function get height () : Number
		{
			return _height;
		}

		
		
		public function get cellWidth () : Number
		{
			return _cellWidth;
		}

		
		
		public function get cellHeight () : Number
		{
			return _cellHeight;
		}

		
		
		public function get marginH () : Number
		{
			return _marginH;
		}

		
		
		public function get marginV () : Number
		{
			return _marginV;
		}

		
		
		public function iterator () : IArray2DIterator
		{
			return _cells.iterator();
		}

		
		
		public function reverseIterator () : IArray2DIterator
		{
			return _cells.reverseIterator();
		}

		
		
		/**
		 * 左上のセルから右下のセルを結ぶ対角線上のセルを走査するイテレータを返す
		 * ■■□□□□□□□□□□□
		 * □□■■■□□□□□□□□
		 * □□□□□■■■□□□□□
		 * □□□□□□□□■■■□□
		 * □□□□□□□□□□□■■
		 */
		public function diagonalIterator () : IArray2DIterator
		{
			return _cells.diagonalIterator();
		}

		
		
		public function u_r_Iterator () : IArray2DIterator
		{
			return _cells.u_r_Iterator();
		}

		
		
		public function circleIterator (__distance : Number) : IArray2DIterator
		{
			return new CircleIterator(_cells, this, __distance);
		}

		
		
		public function aroundHalfIterator () : IArray2DIterator
		{
			return _cells.aroundHalfIterator();
		}

		
		
		public function getInfoByIndex (__idx : Number) : Grid2DCell
		{
			return _cells.toArray()[__idx];
		}

		
		
		public function get size () : int
		{
			return _cells.size;
		}

		
		
		public function getColElement (__x : int) : Array
		{
			return _cells.getColElement(__x);
		}

		
		
		public function getRowElement (__y : int) : Array
		{
			return _cells.getRowElement(__y);
		}

		
		
		/**
		 * 指定した座標が含まれるセルのインデックスを返します。
		 * 座標がセルの境界線上の場合は、正の位置のセルを返します。
		 * 座標が外縁を含む境界外の場合は、延長したセルのインデックスを返します。
		 * たとえば、サイズが1x1でセルが10x5に分割されたグリッドで、座標（1,1）を指定した場合はPoint(10,6)を返します
		 * @param __x	グリッド上のx座標
		 * @param __y	グリッド上のy座標
		 * @return		セルのインデックスを含むPoint。
		 */
		public function getCellIndex2DByCordinate (__x : Number, __y : Number) : Point
		{
			__x /= width;			__y /= height;
			var idxX : Number = cols * int(__x * 1000) * 0.001;
			var idxY : Number = rows * int(__y * 1000) * 0.001;
			idxX = (__x < 0) ? - (int(idxX * - 1) + 1) : int(idxX); 
			idxY = (__y < 0) ? - (int(idxY * - 1) + 1) : int(idxY); 
			return new Point(idxX, idxY);
		}

		
		
		public function getPositionByIndex (__linerIndex : int) : Point
		{
			var x : int = __linerIndex % cols;
			x = (x == - 1) ? 0 : x;
			var y : int = __linerIndex / cols;
			return new Point(x, y);
		}

		
		
		public function getIndexByPosition (__x : int, __y : int) : int
		{
			return _cells.getIndexByPosition(__x, __y);
		}

		
		
		//---------------------------------------------------------------------------------command
		
		/**
		 * セルのサイズから全体の長さを計算する
		 * @param __separation		分割数
		 * @param __cellSize		セルのサイズ
		 * @param __margin			セル間のマージン
		 * @param __relativeMargin	マージンが相対値かどうか。trueをわたすとマージン値がセルサイズに対する相対値となる。
		 */
		public static function calcLength (__separation : int, __cellSize : Number, __margin : Number, __relativeMargin : Boolean) : Number
		{
			var m : Number = (__relativeMargin) ? __cellSize * __margin * 0.01 : __margin;
			return __separation * __cellSize + m * (__separation - 1);
		}

		
		
		/**
		 * セルのサイズを計算する
		 * @param	全体の長さ
		 * @param	分割数
		 * @param	セル間のマージン
		 * @param	マージンが相対値かどうか
		 */
		static public function calcCelSize (__length : Number, __separation : int, __margin : Number, __relativeMargin : Boolean) : Number
		{
			if(__relativeMargin)
			{
				return __length * 1000 / ((__separation + (__margin * 0.01 * (__separation - 1))) * 1000);
			}
			else
			{
				return (__length - ((__separation - 1) * __margin)) / __separation;
			}
		}

		
		
		public function getInfo (__col : int, __row : int) : Grid2DCell
		{
			return (__col >= cols || __row >= rows) ? null : _cells.getElement(__col, __row);
		}

		
		
		public function clone () : IGrid
		{
			var g : IGrid = new Grid2D(cols, rows, cellWidth * cols, cellHeight * rows, _marginH, _marginV, _relativeMargin);
			var i : IIterator = g.iterator();
			while(i.hasNext())
			{
				var idx : int = i.position;
				var c : Grid2DCell = i.next();
				c.data = getInfoByIndex(idx).data;
			} 
			return g;
		}

		
		
		public function map (__mapiterator : IArray2DIterator) : IGrid
		{
			var g : Grid2D = clone() as Grid2D;
			g._cells = _cells.map(__mapiterator);
			return g;
		}

		
		
		public function equals (__g : Grid2D) : Boolean
		{
			var i : IArray2DIterator = iterator();
			while(i.hasNext())
			{
				var x : int = i.cursorX;
				var y : int = i.cursorY;
				var c : Grid2DCell = i.next() as Grid2DCell;
				if(! (c.cellInfo.equals(__g.getInfo(x, y).cellInfo))) return false;
			}
			return true;
		}

		
		
		public function appendCols (__cols : int) : void
		{
			_cells.appendCols(__cols);
			fillEmptyCell();
		}

		
		
		public function appendRows (__rows : int) : void
		{
			_cells.appendRows(__rows);
			fillEmptyCell();
		}

		
		
		public function shiftRight (__value : int = 1, __repeat : Boolean = false) : void
		{
			_cells = _cells.shiftRight(__value, __repeat);
		}

		
		
		public function shiftLeft (__value : int = 1, __repeat : Boolean = false) : void
		{
			_cells = _cells.shiftLeft(__value, __repeat);
		}

		
		
		public function shiftUp (__value : int = 1, __repeat : Boolean = false) : void
		{
			_cells = _cells.shiftUp(__value, __repeat);
		}

		
		
		public function shiftDown (__value : int = 1, __repeat : Boolean = false, __startCols : int = 0, __colsLength : int = 0) : void
		{
			if(__colsLength > 0)
			{
				var splice : Array2D = _cells.spliceCols(__startCols, __colsLength);
				splice = splice.shiftDown(__value, __repeat);
				_cells = _cells.concat(splice);
			}
			else
			{				_cells = _cells.shiftDown(__value, __repeat);
			}
		}

		
		
		public function print () : void
		{
			var s : String = "";
			var i : IArray2DIterator = _cells.iterator();
			while(i.hasNext())
			{
				var x : int = i.cursorX;
				if(x % cols == 0) s += "\n";
				s += i.next() + "\t\t";
			}
			trace(s);
		}

		
		
		//---------------------------------------------------------------------------------private
		private function setupCell () : void
		{
			var i : IArray2DIterator = iterator();
			var w : Number = calcCelSize(_width, _cells.cols, _marginH, _relativeMargin);
			var h : Number = calcCelSize(_height, _cells.rows, _marginV, _relativeMargin);
			while(i.hasNext())
			{
				var x : int = i.cursorX;
				var y : int = i.cursorY;
				var r : Rectangle = createCellInfo(x, y, w, h);				_cells.setElement(x, y, new Grid2DCell(x, y, r)); 
				i.next();
			}
			
			_cellWidth = w;
			_cellHeight = h;
		}

		
		
		private function createCellInfo (x : int, y : int, w : Number, h : Number) : Rectangle
		{
			var mw : Number = (_relativeMargin) ? w * _marginH * 0.01 : _marginH;
			var mh : Number = (_relativeMargin) ? h * _marginV * 0.01 : _marginV;
			var rx : Number = (w + mw) * 1000 * x * 0.001;
			var ry : Number = (h + mh) * 1000 * y * 0.001;
			return new Rectangle(rx, ry, w, h);
		}

		
		
		private function fillEmptyCell () : void
		{
			var i : IArray2DIterator = _cells.iterator();
			while(i.hasNext())
			{
				var x : int = i.cursorX;				var y : int = i.cursorY;
				var cell : Grid2DCell = i.next();
				if(! cell)
				{
					_cells.setElement(x, y, new Grid2DCell(x, y, createCellInfo(x, y, cellWidth, cellHeight)));							}
			}
		}

		
		
		public function removeRow (__remove : int) : void		{
			_cells.removeRow(__remove);
		}

		
		
		public function removeCol (__remove : int) : void
		{
			_cells.removeCol(__remove);
		}
	}
}
