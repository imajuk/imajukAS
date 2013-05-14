package com.imajuk.geom{	import flash.display.*;
	import org.libspark.as3unit.after;	import org.libspark.as3unit.assert.*;	import org.libspark.as3unit.before;	import org.libspark.as3unit.test;	use namespace test;	use namespace before;	use namespace after;	internal class CircleTest extends Sprite	{		before function setupSample () : void		{		}
		
		
		
		test function size () : void		{			var c : Circle = new Circle(1, 2, 0.2);			assertEquals(0.2, c.radius);			assertEquals(0.4, c.size);			assertEquals(0.4, c.width);			assertEquals(0.4, c.height);						/**			 * セッターによる変更			 */			c.radius = 0.3;			assertEquals(0.3, c.radius);			assertEquals(0.6, c.size);			assertEquals(0.6, c.width);			assertEquals(0.6, c.height);						c.size = 0.8;			assertEquals(0.4, c.radius);			assertEquals(0.8, c.size);			assertEquals(0.8, c.width);			assertEquals(0.8, c.height);		}
		
		
		
		test function equals () : void		{			var c : Circle = new Circle(1, 2, 0.2);			var c2 : Circle = new Circle(1, 2, 0.2);			assertTrue(c.equals(c2));			assertFalse(c == c2);						//異なる座標			assertFalse(c.equals(new Circle(1.1, 2, 0.2)));						//異なるサイズ			assertFalse(c.equals(new Circle(1, 2, 0.21)));									//異なるIGeomとの比較			assertFalse(c.equals(new Rect(1, 2, 0.2, 0.2)));			assertFalse(c.equals(new Doughnut(1, 2, 0.2, 0.1)));		}
		
		
		
		test function clone () : void		{			var c : Circle = new Circle(1, 2, 0.2);			var c2 : Circle = c.clone() as Circle;			assertFalse(c2 == null);			assertTrue(c2 is Circle);			assertFalse(c == c2);						assertTrue(c.equals(c2));					}
		
		
		
		test function containsPoint () : void		{			var c : Circle = new Circle(1, 2, 0.2);			assertTrue(c.containsPoint(new Point2D(1, 2)));					assertTrue(c.containsPoint(new Point2D(1 + 0.2, 2)));					assertFalse(c.containsPoint(new Point2D(1 + 0.2, 2), false));			assertFalse(c.containsPoint(new Point2D(1 + 0.2 + 0.01, 2)));				}
		
		
		
		after function teardownSample () : void		{		}	}}