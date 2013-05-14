package com.imajuk.data
{
	import flash.display.*;

	import org.libspark.as3unit.after;
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.test;
	use namespace test;
	use namespace before;
	use namespace after;
	import com.imajuk.data.Grid2D;

	import flash.geom.Rectangle;

	import com.imajuk.data.Grid2DCell;

	import flash.geom.Point;

	import com.imajuk.data.ReverseIterator;	
	internal class Grid2DTest extends Sprite
	{
		before function setupSample () : void
		{
		}

		
		
		/**
		 * Grid2Dは2次元配列を保持する（列と行）
		 */
		test function gridHasTable () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(4, 3, 50, 50);			assertEquals(4, grid.cols);			assertEquals(3, grid.rows);
			
			grid = new Grid2D(1, 1, 50, 50);
			assertEquals(1, grid.cols);			assertEquals(1, grid.rows);
		}

		
		
		/**
		 * グリッド全体のサイズを保持する
		 */
		test function hasWholeSize () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(4, 3, 100, 50);			assertEquals(100, grid.width);			assertEquals(50, grid.height);
			grid = new Grid2D(1, 1, 100, 50);
			assertEquals(100, grid.width);
			assertEquals(50, grid.height);
		}

		
		
		/**
		 * セルのサイズと個数から全体の長さを返すユーティリティがある
		 */
		test function gridCalcsWholeLength () : void
		{
			var cellSize : Number = 40;
			var cols : int = 9;
			var margin : Number = - 10;
			assertEquals(40 * 9 + 40 * - 0.1 * 8, Grid2D.calcLength(cols, cellSize, margin, true));
			assertEquals(40 * 9 + - 10 * 8, Grid2D.calcLength(cols, cellSize, margin, false));
		}

		
		
		/**
		 * セルのサイズを返すユーティリティがある
		 */
		test function calcCellSize () : void
		{
			var l : Number = 216;
			var sep : int = 5;
			var margin : Number = 0;
			assertEquals(43.2, Grid2D.calcCelSize(l, sep, margin, true));
		}

		
		
		/**
		 * Grid2DはGrid2DInfoのイテレータを返す
		 */
		test function gridReturnsIterator () : void
		{
			//均等分割
			var grid : Grid2D;
			var i : IArray2DIterator;
			var c : int;
			var x : int;
			var y : int;
			var r : *;
			var cellInfo : Grid2DCell;
			grid = new Grid2D(4, 2, 400, 200);
			i = grid.iterator();
			c = 0;
			while(i.hasNext())
			{
				x = i.cursorX;
				y = i.cursorY;
				r = i.next();
				assertTrue(r is Grid2DCell);
				cellInfo = r as Grid2DCell;
				assertEquals(x, cellInfo.indexX);
				assertEquals(y, cellInfo.indexY);
				c ++;
			}
			assertEquals(4 * 2, c);
			
			//1x1のグリッド
			grid = new Grid2D(1, 1, 400, 200);
			i = grid.iterator();
			c = 0;
			while(i.hasNext())
			{
				x = i.cursorX;
				y = i.cursorY;
				r = i.next();
				assertTrue(r is Grid2DCell);
				cellInfo = r as Grid2DCell;
				assertEquals(x, cellInfo.indexX);
				assertEquals(y, cellInfo.indexY);
				c ++;
			}
			assertEquals(1, c);
		}

		
		
		/**
		 * セルのサイズはグリッドの分割数とグリッドのサイズから計算され、
		 * Grid2DCellオブジェクトとしてを2次元配列上に格納される
		 */
		test function gridReturnsGrid2DInfo () : void
		{
			var cellWidth : Number = 100;
			var cellHeight : Number = 80;
			var marginH : Number = 10;
			var marginV : Number = - 5;
			var grid : Grid2D = new Grid2D(4, 2, cellWidth * 4 + marginH * 3, cellHeight * 2 + marginV, marginH, marginV);
			
			
			/**
			 * 格納されたGrid2DCellにイテレータを使ってアクセスする
			 */
			var i : IArray2DIterator = grid.iterator();
			while(i.hasNext())
			{
				var x : int = i.cursorX;
				var y : int = i.cursorY;
				var r : Rectangle = Grid2DCell(i.next()).cellInfo;
				assertEquals((cellWidth + marginH) * x, r.x);
				assertEquals((cellHeight + marginV) * y, r.y);
				assertEquals(100, grid.cellWidth);
				assertEquals(80, grid.cellHeight);
				assertEquals(grid.cellWidth, r.width);
				assertEquals(grid.cellHeight, r.height);
			}
		}

		
		
		/**
		 * 格納されたGrid2DCellにgetInfoを使ってアクセスする
		 */
		test function getInfo () : void
		{
			var cellWidth : Number = 100;
			var cellHeight : Number = 80;
			var marginH : Number = 10;
			var marginV : Number = - 5;
			var grid : Grid2D = new Grid2D(4, 2, cellWidth * 4 + marginH * 3, cellHeight * 2 + marginV, marginH, marginV);
			assertTrue(grid.getInfo(3, 1) is Grid2DCell);
			//領域外
			assertEquals(null, grid.getInfo(4, 1));
		}

		
		
		/**
		 * 格納されたGrid2DCellに通し番号を使ってアクセスする
		 */
		test function getInfoByIndex () : void
		{
			var cellWidth : Number = 100;
			var cellHeight : Number = 80;
			var marginH : Number = 10;
			var marginV : Number = - 5;
			var grid : Grid2D = new Grid2D(4, 2, cellWidth * 4 + marginH * 3, cellHeight * 2 + marginV, marginH, marginV);
			//通し番号で取得
			assertTrue(grid.getInfo(3, 1) is Grid2DCell);
			assertEquals(grid.getInfo(3, 1), grid.getInfoByIndex(7));
			assertEquals(null, grid.getInfoByIndex(8));
		}

		
		
		/**
		 * cloneとequals
		 */
		test function clone () : void
		{
			var grid : Grid2D = new Grid2D(5, 8, 500, 250);
			var grid2 : Grid2D = grid.clone() as Grid2D;
			var grid3 : Grid2D = new Grid2D(5, 4, 500, 250);			assertEquals(grid, grid2);
			assertTrue(grid.equals(grid2));
			assertNotSame(grid, grid2);
			assertFalse(grid.equals(grid3));
			assertEquals(5, grid2.cols);			assertEquals(8, grid2.rows);
			
			var grid4 : Grid2D = new Grid2D(5, 4, 500, 250);
			grid4.getInfo(1, 1).data = "DATA";
			assertEquals("DATA", Grid2D(grid4.clone()).getInfo(1, 1).data);
		}

		
		
		/**
		 * Grid2Dはセル間のマージンを保持する
		 */
		test function gridHasMargin () : void
		{
			var grid : Grid2D = new Grid2D(4, 3, 100, 50);
			assertEquals(0, grid.marginH);
			assertEquals(0, grid.marginV);
			var grid2 : Grid2D = new Grid2D(4, 3, 100, 50, 10, - 5);
			assertEquals(10, grid2.marginH);
			assertEquals(- 5, grid2.marginV);
					
			//マージンには相対値を指定できる
			var grid3 : Grid2D = new Grid2D(10, 5, 455, 216, - 10, 10, true);
			assertEquals(- 10, grid3.marginH);
			assertEquals(10, grid3.marginV);
			assertEquals(50, grid3.cellWidth);
			assertEquals(40, grid3.cellHeight);
					
			//マージンには相対値を指定できる
			var grid4 : Grid2D = new Grid2D(20, 10, 905, 216, - 10, 10, true);
			assertEquals(- 10, grid4.marginH);
			assertEquals(50, grid4.cellWidth);
		}

		
		
		/**
		 * 丸め誤差
		 */
		test function cellPosition () : void
		{
			var grid : Grid2D = new Grid2D(10, 5, 455, 216);
			var r : Rectangle;
			r = grid.getInfo(0, 1).cellInfo;
			assertEquals(43.2, r.y);
			r = grid.getInfo(0, 3).cellInfo;
			assertEquals(129.6, r.y);
		}

		
		
		test function getCellIndex2DByCordinate () : void
		{
			var grid : Grid2D = new Grid2D(10, 5, 1, 1);
			var cIndex : Point;
			
			cIndex = grid.getCellIndex2DByCordinate(0, 0);			assertEquals(0, cIndex.x);
			assertEquals(0, cIndex.y);

			cIndex = grid.getCellIndex2DByCordinate(- 0.09, - 0.19);
			assertEquals(- 1, cIndex.x);
			assertEquals(- 1, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(0.01, 0.01);
			assertEquals(0, cIndex.x);
			assertEquals(0, cIndex.y);

			/**
			 * 境界線上の場合、
			 * 座標が正なら、インデックスは正の方向のインデックスを返す			 * 座標が負なら、インデックスは負の方向のインデックスを返す			 */
			cIndex = grid.getCellIndex2DByCordinate(0.1, 0.2);
			assertEquals(1, cIndex.x);
			assertEquals(1, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(0.2, 0.4);
			assertEquals(2, cIndex.x);
			assertEquals(2, cIndex.y);
			
			//外縁を含む境界外の座標は、延長したセルのインデックスを返す
			cIndex = grid.getCellIndex2DByCordinate(1, 1);
			assertEquals(10, cIndex.x);
			assertEquals(5, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(1.01, 1.01);
			assertEquals(10, cIndex.x);
			assertEquals(5, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(1.1, 1.2);
			assertEquals(11, cIndex.x);
			assertEquals(6, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(- 0.09, - 0.19);
			assertEquals(- 1, cIndex.x);
			assertEquals(- 1, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(- 0.1, - 0.2);
			assertEquals(- 2, cIndex.x);
			assertEquals(- 2, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(- 0.11, - 0.21);
			assertEquals(- 2, cIndex.x);
			assertEquals(- 2, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(- 0.2, - 0.4);
			assertEquals(- 3, cIndex.x);
			assertEquals(- 3, cIndex.y);
			
			cIndex = grid.getCellIndex2DByCordinate(- 0.201, - 0.401);
			assertEquals(- 3, cIndex.x);
			assertEquals(- 3, cIndex.y);
		}

		
		
		test function getPositionByIndex () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(10, 5, 1, 1);
			assertEquals(new Point(), grid.getPositionByIndex(0));			assertEquals(new Point(1, 0), grid.getPositionByIndex(1));			assertEquals(new Point(9, 0), grid.getPositionByIndex(9));			assertEquals(new Point(0, 1), grid.getPositionByIndex(10));			assertEquals(new Point(0, 2), grid.getPositionByIndex(20));			assertEquals(new Point(9, 4), grid.getPositionByIndex(49));		}

		
		
		test function appendCols () : void
		{
			var grid : Grid2D;
			var i : IIterator;
			grid = new Grid2D(3, 2, 30, 20);			assertEquals(3, grid.cols);			assertEquals(6, grid.size);
			
			grid.appendCols(2);
			i = grid.iterator();			assertEquals(5, grid.cols);
			assertEquals(10, grid.size);
			
			assertTrue(grid.getInfo(3, 1) is Grid2DCell);
			assertEquals(new Rectangle(40, 10, 10, 10), grid.getInfo(4, 1).cellInfo);
		}

		
		
		test function appendRows () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(3, 2, 30, 20);
			assertEquals(3, grid.cols);
			assertEquals(6, grid.size);
			
			grid.appendRows(2);
			assertEquals(4, grid.rows);
			assertEquals(12, grid.size);
			
			assertTrue(grid.getInfo(1, 3) is Grid2DCell);			assertEquals(new Rectangle(10, 30, 10, 10), grid.getInfo(1, 3).cellInfo);		}

		
		
		test function shilfRight () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(3, 2, 30, 20);
			
			grid.getInfo(2, 0).data = "2_0";
			grid.shiftRight(1, true);
			assertTrue(grid.getInfo(0, 0) is Grid2DCell);
			assertEquals("2_0", grid.getInfo(0, 0).data);
		}

		
		
		test function shilfDown () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(2, 3, 20, 30);
			
			grid.getInfo(0, 2).data = "0_2";
			grid.shiftDown(1, true);
			assertTrue(grid.getInfo(0, 0) is Grid2DCell);
			assertEquals("0_2", grid.getInfo(0, 0).data);			
			/**
			 * オプションを渡すと、特定の範囲でshiftDown
			 */
			grid = new Grid2D(3, 2, 30, 20);
			grid.getInfo(0, 0).data = "0_0";
			grid.getInfo(1, 0).data = "1_0";			grid.getInfo(1, 1).data = "1_1";
			grid.shiftDown(1, true, 1, 2);			 
			assertEquals("1_1", grid.getInfo(1, 0).data);			assertEquals(3, grid.cols);
		}

		
		
		test function map () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(3, 2, 30, 20);
			grid.getInfo(2, 0).data = "2_0";
			grid = grid.map(grid.u_r_Iterator()) as Grid2D;
			assertEquals("2_0", grid.getInfo(1, 1).data);
			assertEquals(3, grid.cols);			assertEquals(2, grid.rows);
		}

		
		
		test function removeRow () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(3, 4, 30, 20);
			grid.removeRow(2);			assertEquals(2, grid.rows);			grid.removeRow(2);
			assertEquals(1, grid.rows);
		}

		
		
		test function removeCol () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(6, 4, 30, 20);
			grid.removeCol(2);
			assertEquals(4, grid.cols);
			grid.removeCol(3);
			assertEquals(1, grid.cols);
		}

		
		
		test function removAndAppend () : void
		{
			var grid : Grid2D;
			grid = new Grid2D(3, 4, 30, 20);
			
			grid.removeRow(2);
			grid.appendRows(2);
			assertEquals(4, grid.rows);
			
			var i : IArray2DIterator;
			i = grid.iterator();
			while(i.hasNext())
			{
				assertTrue(i.next() is Grid2DCell);
			}
			
			grid.removeCol(1);
			grid.removeRow(2);
			grid.appendCols(1);
			grid.appendRows(2);
			assertEquals(3, grid.cols);			assertEquals(4, grid.rows);
			
			i = grid.iterator();
			while(i.hasNext())
			{
				assertTrue(i.next() is Grid2DCell);
			}
		}

		
		
		test function reverseIterator () : void
		{
			var uniqueGrid : IGrid = new Grid2D(13, 10, 130, 100);
			var reverse : IArray2DIterator = uniqueGrid.reverseIterator();
			assertTrue(reverse is ReverseIterator);
			
			uniqueGrid = uniqueGrid.map(uniqueGrid.reverseIterator());

			assertEquals(130, uniqueGrid.reverseIterator().size);			assertEquals(uniqueGrid.iterator().size, uniqueGrid.reverseIterator().size);
			
			var i : IArray2DIterator = uniqueGrid.reverseIterator();
			while(i.hasNext())
			{
				assertTrue(i.next() is Grid2DCell);
			}
		}

		
		
		test function circleIterator () : void
		{
			var grid : IGrid = new Grid2D(11, 11, 110, 110);
			var cell : Grid2DCell;
			var c : IArray2DIterator;
			var i : IArray2DIterator = grid.iterator();
			while(i.hasNext())
			{				var x : int = i.cursorX;
				var y : int = i.cursorY;
				cell = i.next();
				cell.data = x + "_" + y;
			}
			c = grid.circleIterator(0);
			assertEquals(1, c.size);			cell = c.next();
			assertEquals(5, cell.indexX);
			assertEquals(5, cell.indexY);			assertEquals(10, cell.cellInfo.width);			assertEquals(10, cell.cellInfo.height);			assertEquals("5_5", cell.data);			
			c = grid.circleIterator(10);
			while(c.hasNext())
			{
				cell = c.next();
			}
			assertEquals(4, c.size);
			
			c = grid.circleIterator(20);
			while(c.hasNext())
			{
				cell = c.next();
			}
			assertEquals(8, c.size);
		}

		
		
		after function teardownSample () : void
		{
		}
	}
}