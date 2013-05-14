package com.imajuk.graphics
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.logs.Logger;

    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.assertTrue;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
		use namespace test;	use namespace before;	use namespace after;		internal class Align_DC_Level1_Test extends Sprite	{		private var displayObject:Sprite;        private var coordinateSpaceTarget:DisplayObjectContainer;        		before function setup () : void		{			AlignTestUtil.initialize();            /**             * テスト用Sprite             * 自身の原点からランダムな位置に50x100の矩形が描画されている.             */            displayObject = AlignTestUtil.getTestView();		}
		
		//--------------------------------------------------------------------------
        //
        //  Align with DocumentClass's child
        //  cordinateSpace : DocumentClass
        //  guide          : DocumentClass
        //
        //--------------------------------------------------------------------------
//        test function level1_TL():void
//        {            
//        	Logger.release("level1_TL");
//        	
//            coordinateSpaceTarget = AlignTestUtil.fillColor(DocumentClass.container.addChild(new Sprite()) as DisplayObjectContainer, 400, 300);
//            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
//            AlignTestUtil.placeRandomPos(coordinateSpaceTarget, coordinateSpaceTarget.parent);
//            
//                                    
//            Align.align(displayObject, Align.TopLeft);
//            assertTrue(AlignCalc.testTL());
//        }		//--------------------------------------------------------------------------
        //
        //  Align with DocumentClass's child
        //  cordinateSpace : DocumentClass's child
        //  guide          : DocumentClass's child
        //
        //--------------------------------------------------------------------------
        //------------------------------------------
        //  target is on cordinateSpace's level 1
        //------------------------------------------
        test function local_T_Container1() : void
        {
            Logger.release("local_T_Container1");

            //ターゲットがおかれる座標系
            var container : DisplayObjectContainer = DocumentClass.container.addChild(new Sprite()) as DisplayObjectContainer;
            coordinateSpaceTarget = AlignTestUtil.fillColor(container, 400, 300);

            //ターゲットを配置
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
            //座標系オブジェクトをランダムに配置
            AlignTestUtil.placeRandomPos(coordinateSpaceTarget);

            Align.align(displayObject, Align.Top).along(coordinateSpaceTarget);
            assertTrue(AlignCalc.testT_local(coordinateSpaceTarget, displayObject));
        }

        test function local_TL_Container1():void
        {
            var container:DisplayObjectContainer = DocumentClass.container.addChild(new Sprite()) as DisplayObjectContainer;
            coordinateSpaceTarget = AlignTestUtil.fillColor(container, 400, 300);
            
            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
            AlignTestUtil.placeRandomPos(coordinateSpaceTarget);
                            
            Align.align(displayObject, Align.TopLeft).along(coordinateSpaceTarget);
            assertTrue(AlignCalc.testTL_local(coordinateSpaceTarget));
        }
//
//        test function local_TR_Container1():void
//        {
//            var container:DisplayObjectContainer = DocumentClass.container.addChild(new Sprite()) as DisplayObjectContainer;
//            coordinateSpaceTarget = AlignTestUtil.fillColor(container, 400, 300);
//            
//            AlignTestUtil.testSpriteIn(coordinateSpaceTarget);
//            AlignTestUtil.placeRandomPos(coordinateSpaceTarget, coordinateSpaceTarget.parent);
//                            
//            Align.align(displayObject, Align.TopRight).along(coordinateSpaceTarget);
//            assertTrue(AlignCalc.testTR_local(coordinateSpaceTarget));
//        }
//
//        //------------------------------------------
//        //  target is on cordinateSpace's level 2
//        //------------------------------------------
//        test function local_T_Container2():void
//        {
//            var container:DisplayObjectContainer = DocumentClass.container.addChild(new Sprite()) as DisplayObjectContainer;
//            coordinateSpaceTarget = AlignTestUtil.fillColor(container, 400, 300);
//            var container2:DisplayObjectContainer = coordinateSpaceTarget.addChild(new Sprite()) as DisplayObjectContainer;
//            container2 = AlignTestUtil.fillColor(container2, 200, 200);
//            container2.x = 400;
//            AlignTestUtil.testSpriteIn(container2);
//            AlignTestUtil.placeRandomPos(coordinateSpaceTarget, coordinateSpaceTarget.parent);
//                            
//            Align.align(displayObject, Align.Top).along(coordinateSpaceTarget);
//            assertTrue(AlignCalc.testT_local(coordinateSpaceTarget, displayObject,container2));
//        }
//
//        test function local_TL_Container2():void
//        {
//            var container:DisplayObjectContainer = DocumentClass.container.addChild(new Sprite()) as DisplayObjectContainer;
//            coordinateSpaceTarget = AlignTestUtil.fillColor(container, 400, 300);
//            var container2:DisplayObjectContainer = coordinateSpaceTarget.addChild(new Sprite()) as DisplayObjectContainer;
//            container2 = AlignTestUtil.fillColor(container2, 200, 200);
//            AlignTestUtil.testSpriteIn(container2);
//            AlignTestUtil.placeRandomPos(coordinateSpaceTarget, coordinateSpaceTarget.parent);
//            AlignTestUtil.placeRandomPos(container2, container2.parent);
//                            
//            Align.align(displayObject, Align.TopLeft).along(coordinateSpaceTarget);
//            assertTrue(AlignCalc.testTL_local(coordinateSpaceTarget));
//        }		after function teardown () : void		{
//			AlignTestUtil.tearDown(coordinateSpaceTarget);		}	}}