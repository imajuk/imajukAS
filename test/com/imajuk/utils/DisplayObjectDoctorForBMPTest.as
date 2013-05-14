package com.imajuk.utils
{
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import com.imajuk.constructions.DocumentClass;

    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.*;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.geom.ColorTransform;
    use namespace test;
    use namespace before;
    use namespace after;
    
    internal class DisplayObjectDoctorForBMPTest extends Sprite
    {
        private var bmp : Bitmap;
        private var guide : Shape;
        private var st : Stage;
        private var ovr : Sprite;
        
        before function setup () : void
        {
            st = StageReference.stage;
            st.color = 0xFFFFFF;
            
            DODoctor.initialize(st);
            
            
            bmp = new Bitmap(new BitmapData(100, 100, false, 0));
            bmp.name = "bmp";
            DocumentClass.container.addChild(bmp);
            
            
            guide = st.addChild(new Shape()) as Shape;
            guide.graphics.lineStyle(1, 0x00ff00);
            guide.graphics.drawRect(0, 0, DocumentClass.swfWidth, DocumentClass.swfHeight);
        }

        test function no_problem () : void
        {
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
        }

        test function not_in_displaylist () : void
        {
            StageReference.documentClass.removeChild(bmp);
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NOT_IN_DISPLAYLIST));
        }

        test function visible_is_false () : void
        {
            bmp.visible = false;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.VISIBILITY_FALSE));
        }

        test function alpha_is_zero () : void
        {
            bmp.alpha = 0;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.TRANSPARENT));
        }

        test function width_is_zero_sprite () : void
        {
            bmp.width = 0;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.ZERO_SIZE));

            bmp.width = 2;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
            
            bmp.scaleX = 0;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.ZERO_SIZE));

            bmp.scaleX = .1;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
        }

        test function height_is_zero_sprite () : void
        {
            bmp.x = 50;
            bmp.y = 50;
            
            bmp.height = 0;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.ZERO_SIZE));

            bmp.height = 1;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
            
            bmp.scaleY = 0;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.ZERO_SIZE));

            bmp.scaleY = .1;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
        }

        test function out_of_stage_left () : void
        {
            bmp.x = -100;

            st.align = "";
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
        }    
            
        test function out_of_stage_right () : void
        {
            bmp.x = DocumentClass.swfWidth;

            st.align = "";
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));
        }   

        test function out_of_stage_top () : void
        {
            bmp.y = -100;

            st.align = "";
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
        }      

        test function out_of_stage_bottom () : void
        {
            bmp.y = DocumentClass.swfHeight;

            st.align = "";
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.NO_PROBLEM));
        }
        
        test function same_color_with_background():void
        {
            bmp.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.BLENDED_INTO_BG));
        }
        
        test function overlap():void
        {
            ovr = new Sprite();
            ovr.name = "ovr";
            ovr.graphics.beginFill(0x00FF00);
            ovr.graphics.drawRect(0, 0, 100, 100);
            ovr.graphics.endFill();
            DocumentClass.container.addChild(ovr);

            assertTrue(DODoctor.whyNot(bmp).test(DODoctor.COVERED_BY_OTHER_OBJECT));
        }
        
        test function multiple_output():void
        {
            StageReference.documentClass.removeChild(bmp);
            bmp.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
            bmp.visible = false;
            bmp.alpha = 0;
            bmp.x = -10000;
            bmp.y = -10000;
            bmp.width = 0;
            
            DODoctor.whyNot(bmp).trace();
            DODoctor.whyNot(bmp).console();
//            DODoctor.whyInvisible(spr).alert();
            DODoctor.whyNot(bmp).func(function(s:String):void{trace(s);});

            
            assertTrue(true, "mes");
        }

        after function teardown () : void
        {
            st.color = 0xFFFFFF;
            
            if (bmp && StageReference.documentClass.contains(bmp))
                StageReference.documentClass.removeChild(bmp);
            if (ovr && StageReference.documentClass.contains(ovr))
                StageReference.documentClass.removeChild(ovr);
                
            guide.graphics.clear();
        }
    }
}