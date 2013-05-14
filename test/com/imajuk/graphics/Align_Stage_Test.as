package com.imajuk.graphics
{
    import com.imajuk.utils.StageReference;

    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.*;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
	use namespace test;	use namespace before;	use namespace after;		internal class Align_Stage_Test extends Sprite	{		private var displayObject:Sprite;
		private var coordinateSpaceTarget:DisplayObjectContainer;				before function setup () : void		{			AlignTestUtil.initialize();            /**             * テスト用Sprite             * 自身の原点からランダムな位置に50x100の矩形が描画されている.             */            displayObject = AlignTestUtil.getTestView();		}		//--------------------------------------------------------------------------
        //
        //  Align with Stage
        //  cordinateSpace : Stage
        //  guide          : cordinateSpace
        //
        //--------------------------------------------------------------------------
        //------------------------------------------
        //  target is on Stage
        //------------------------------------------
        test function alongGlobal_T():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.Top);
            assertTrue(AlignCalc.testT());
            
            Align.align(displayObject, Align.Top).withOffsetH(10);
            assertTrue(AlignCalc.testT(10));

            Align.align(displayObject, Align.Top).withOffsetV(10);
            assertTrue(AlignCalc.testT(0, 10));
        }

        test function alongGlobal_TL():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.TopLeft);
            assertTrue(AlignCalc.testTL());
            
            Align.align(displayObject, Align.TopLeft).withOffsetH(10);
            assertTrue(AlignCalc.testTL(10));
            
            Align.align(displayObject, Align.TopLeft).withOffsetV(10);
            assertTrue(AlignCalc.testTL(0, 10));
        }

        test function alongGlobal_TR():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                                    
            Align.align(displayObject, Align.TopRight);
            assertTrue(AlignCalc.testTR());
            
            Align.align(displayObject, Align.TopRight).withOffsetH(10);
            assertTrue(AlignCalc.testTR(10));
            
            Align.align(displayObject, Align.TopRight).withOffsetV(10);
            assertTrue(AlignCalc.testTR(0, 10));
        }

        test function alongGlobal_B():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.Bottom);
            assertTrue(AlignCalc.testB());
            
            Align.align(displayObject, Align.Bottom).withOffsetH(10);
            assertTrue(AlignCalc.testB(10));

            Align.align(displayObject, Align.Bottom).withOffsetV(10);
            assertTrue(AlignCalc.testB(0, 10));
        }

        test function alongGlobal_BL():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.BottomLeft);
            assertTrue(AlignCalc.testBL());
            
            Align.align(displayObject, Align.BottomLeft).withOffsetH(10);
            assertTrue(AlignCalc.testBL(10));

            Align.align(displayObject, Align.BottomLeft).withOffsetV(10);
            assertTrue(AlignCalc.testBL(0, 10));
        }

        test function alongGlobal_BR():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.BottomRight);
            assertTrue(AlignCalc.testBR());
            
            Align.align(displayObject, Align.BottomRight).withOffsetH(10);
            assertTrue(AlignCalc.testBR(10));

            Align.align(displayObject, Align.BottomRight).withOffsetV(10);
            assertTrue(AlignCalc.testBR(0, 10));
        }

        test function alongGlobal_Left():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.Left);
            assertTrue(AlignCalc.testCL());
            
            Align.align(displayObject, Align.Left).withOffsetH(10);
            assertTrue(AlignCalc.testCL(10));

            Align.align(displayObject, Align.Left).withOffsetV(10);
            assertTrue(AlignCalc.testCL(0, 10));
        }

        test function alongGlobal_Center():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.Center);
            assertTrue(AlignCalc.testC());
            
            Align.align(displayObject, Align.Center).withOffsetH(10);
            assertTrue(AlignCalc.testC(10));

            Align.align(displayObject, Align.Center).withOffsetV(10);
            assertTrue(AlignCalc.testC(0, 10));
        }

        test function alongGlobal_Right():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(StageReference.stage);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                        
            Align.align(displayObject, Align.Right);
            assertTrue(AlignCalc.testCR());
            
            Align.align(displayObject, Align.Right).withOffsetH(10);
            assertTrue(AlignCalc.testCR(10));

            Align.align(displayObject, Align.Right).withOffsetV(10);
            assertTrue(AlignCalc.testCR(0, 10));
        }		after function teardown () : void		{
			AlignTestUtil.tearDown(coordinateSpaceTarget);		}	}}