package com.imajuk.utils
{
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
    
    internal class DisplayObjectDoctorForSpriteTest extends Sprite
    {
        private var spr : Sprite;
        private var guide : Shape;
        private var st : Stage;
        private var ovr : Sprite;
        
        before function setup () : void
        {
            st = StageReference.stage;
            st.color = 0xFFFFFF;
            
            DODoctor.initialize(st);
            
            
            spr = new Sprite();
            spr.name = "spr";
            spr.graphics.beginFill(0xff0000);
            spr.graphics.drawRect(0, 0, 100, 100);
            spr.graphics.endFill();
            DocumentClass.container.addChild(spr);
            
            
            guide = st.addChild(new Shape()) as Shape;
            guide.graphics.lineStyle(1, 0x00ff00);
            guide.graphics.drawRect(0, 0, DocumentClass.swfWidth, DocumentClass.swfHeight);
        }

        test function no_problem () : void
        {
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
        }

        test function not_in_displaylist () : void
        {
            StageReference.documentClass.removeChild(spr);
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NOT_IN_DISPLAYLIST));
        }

        test function visible_is_false () : void
        {
            spr.visible = false;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.VISIBILITY_FALSE));
        }

        test function alpha_is_zero () : void
        {
            spr.alpha = 0;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.TRANSPARENT));
        }

        test function width_is_zero_sprite () : void
        {
            spr.width = 0;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.ZERO_SIZE));

            spr.width = 2;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
            
            spr.scaleX = 0;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.ZERO_SIZE));

            spr.scaleX = .1;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
        }

        test function height_is_zero_sprite () : void
        {
            spr.x = 50;
            spr.y = 50;
            
            spr.height = 0;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.ZERO_SIZE));

            spr.height = 1;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
            
            spr.scaleY = 0;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.ZERO_SIZE));

            spr.scaleY = .1;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
        }

        test function out_of_stage_left () : void
        {
            spr.x = -100;

            st.align = "";
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
        }    
            
        test function out_of_stage_right () : void
        {
            spr.x = DocumentClass.swfWidth;

            st.align = "";
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));
        }   

        test function out_of_stage_top () : void
        {
            spr.y = -100;

            st.align = "";
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
        }      

        test function out_of_stage_bottom () : void
        {
            spr.y = DocumentClass.swfHeight;

            st.align = "";
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
            
            st.align = StageAlign.TOP_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.TOP_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.BOTTOM_LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.BOTTOM_RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.OUT_OF_STAGE));

            st.align = StageAlign.LEFT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));

            st.align = StageAlign.RIGHT;
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.NO_PROBLEM));
        }
        
        test function same_color_with_background():void
        {
            spr.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
            assertTrue(DODoctor.whyNot(spr).test(DODoctor.BLENDED_INTO_BG));
        }
        
        test function overlap():void
        {
            ovr = new Sprite();
            ovr.name = "ovr";
            ovr.graphics.beginFill(0x00FF00);
            ovr.graphics.drawRect(0, 0, 100, 100);
            ovr.graphics.endFill();
            DocumentClass.container.addChild(ovr);

            assertTrue(DODoctor.whyNot(spr).test(DODoctor.COVERED_BY_OTHER_OBJECT));
        }
        
        test function multiple_output():void
        {
            StageReference.documentClass.removeChild(spr);
            spr.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
            spr.visible = false;
            spr.alpha = 0;
            spr.x = -10000;
            spr.y = -10000;
            spr.width = 0;
            
            DODoctor.whyNot(spr).trace();
            DODoctor.whyNot(spr).console();
//            DODoctor.whyInvisible(spr).alert();
            DODoctor.whyNot(spr).func(function(s:String):void{trace(s);});

            
            assertTrue(true, "mes");
        }

        after function teardown () : void
        {
            st.color = 0xFFFFFF;
            
            if (spr && StageReference.documentClass.contains(spr))
                StageReference.documentClass.removeChild(spr);
            if (ovr && StageReference.documentClass.contains(ovr))
                StageReference.documentClass.removeChild(ovr);
                
            guide.graphics.clear();
        }
    }
}