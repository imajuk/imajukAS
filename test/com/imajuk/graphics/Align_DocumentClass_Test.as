package com.imajuk.graphics
{
    import com.imajuk.constructions.DocumentClass;

    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.assertTrue;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;


	use namespace test;	use namespace before;	use namespace after;		internal class Align_DocumentClass_Test extends Sprite	{		private var displayObject:Sprite;        private var coordinateSpaceTarget:DisplayObjectContainer;        		before function setup () : void		{			AlignTestUtil.initialize();            /**             * テスト用Sprite             * 自身の原点からランダムな位置に50x100の矩形が描画されている.             */            displayObject = AlignTestUtil.getTestView();		}
		
		//------------------------------------------
        //  target is on DocumentClass
        //------------------------------------------
        test function alongGlobal_TL_DocumentClass():void
        {
            coordinateSpaceTarget = AlignTestUtil.fillColor(DocumentClass.container);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                                    
            Align.align(displayObject, Align.TopLeft);
            assertTrue(AlignCalc.testTL());
        }

        test function alongGlobal_TR_DocumentClass():void
        {            
            coordinateSpaceTarget = AlignTestUtil.fillColor(DocumentClass.container);
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
                                    
            Align.align(displayObject, Align.TopRight);
            assertTrue(AlignCalc.testTR());
        }		after function teardown () : void		{
			AlignTestUtil.tearDown(coordinateSpaceTarget);		}	}}