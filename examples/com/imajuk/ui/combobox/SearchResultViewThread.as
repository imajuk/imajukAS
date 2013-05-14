package com.imajuk.ui.combobox 
{
    import fl.motion.easing.Exponential;

    import com.imajuk.behaviors.ColorBehavior;
    import com.imajuk.color.Color;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.graphics.Align;
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.ui.buttons.AbstractButton;
    import com.imajuk.ui.buttons.IButton;
    import com.imajuk.ui.buttons.fluent.BehaviorContext;
    import com.imajuk.ui.scroll.Scroll;
    import com.imajuk.ui.window.AbstractWindowContent;
    import com.imajuk.ui.window.IWindowContentBuilder;
    import com.imajuk.utils.StageReference;

    import org.libspark.thread.Thread;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;






    /**
     * @author shin.yamaharu
     */
    public class SearchResultViewThread extends AbstractWindowContent implements IWindowContentBuilder 
    {
        private var result:Sprite;
        private var combo_province:ComboBox;
        private var combo_city:ComboBox;
        private var data:XMLList;
        private var frame : DisplayObject;

        public function SearchResultViewThread(
        					combo_province:ComboBox,
        					combo_city:ComboBox,
        					data:XMLList,
        					frameContainer:Sprite)
        {
            super(frameContainer, "search");
            this.combo_province = combo_province;
            this.combo_city = combo_city;
            this.data = data;
        }
        
        override protected function buildCloseButton() : IButton
        {
        	var closeBtn:IButton = 
                new AbstractButton(AssetFactory.create("$Frame_close"))
                    .context(BehaviorContext.ROLL_OVER_OUT)
                    .behave(ColorBehavior.createTint(Color.fromHSV(0, 0, 100), .5));
                    
            windowAsset.addChild(DisplayObject(closeBtn));
        		
            closeBtn.x = 400;
            closeBtn.y = 4;
            closeBtn.alpha = 0;
        	return closeBtn;
        }
        
        override public function getInitializeContentThread() : Thread
        {
        	result = windowAsset.addChild(new Sprite()) as Sprite;
            result.addChild(new Bitmap(new BitmapData(400, 300, true, 0xBB000000))) as Bitmap;
            result.x = 4;
            result.y = 16;
            result.alpha = 0;
        	
        	frame = windowAsset.getChildByName("frame");
            frame.width = result.width + 20;
            frame.height = 50;
            frame.alpha = 0;    
            
            return new Thread();
        }
        
        override public function getInitializeScrollThread() : Thread
        {
        	var canvasBMP:Bitmap = 
        		new Bitmap(
        			new BitmapData(
        				400,
        				Math.ceil(data.store.length() / 2) * 25 + 85 + 60,
        				true,
        				0
        			)
        		);
        		
            var fm:TextFormat = new TextFormat();
            fm.color = ColorConfig.CREAM.rgb;
            fm.size = 12;
            
            var fm2:TextFormat = new TextFormat();
            fm2.color = 0xd7d7d7;
            fm2.size = 10;
            
            var ix:int = 20;
            var iy:int = 20;
                    
            var fCont:Sprite = AssetFactory.create("$FontContainer") as Sprite;
            var tf:TextField = fCont.getChildByName("tx") as TextField;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.wordWrap = false;
            tf.multiline = false;
                    
            var cols:int = -1;
            
            for each (var store : XML in data.store) 
            {
                //city
                tf.defaultTextFormat = fm;
                tf.text = "";
                tf.appendText(combo_city.data);
                
                fCont.x = ix;
                fCont.y = iy;
                canvasBMP.bitmapData.draw(fCont, fCont.transform.matrix);                
                
                //store
                ix += 40;
                                
                tf.defaultTextFormat = fm2;
                tf.text = "";
                tf.appendText(store.@name);
                fCont.x = ix;
                fCont.y = iy;

                canvasBMP.bitmapData.draw(fCont, fCont.transform.matrix);                
                if (cols % 2 == 0)
                {
                    ix = 20;
                    iy += 25;
                }
                else
                {
                    ix = 200;
                }
                
                cols++;
            }
            
            result.graphics.lineStyle(1, 0x633423);            result.graphics.moveTo(180, 80);
            result.graphics.lineTo(180, 212);
            
            scroll = result.addChild(new Scroll(canvasBMP, 400, 270)) as Scroll;
            scroll.scrollBarSize = 270;
            scroll.bar_bg_margin = 2;
            scroll.container_scrollbar_margin = -10;
            
            return new Thread();
        }
        
        override public function getShowWindowFrameThread() : Thread
        {
            var stw : int = StageReference.stage.stageWidth;
            var bitmap : BitmapData = new BitmapData(stw, 1000, true, 0);
            bitmap.draw(result);
            var r : Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x00000000, false);
            
            //中央に配置
            Align.align(windowAsset, Align.Top).withOffsetV((StageReference.stage.stageHeight - r.height) * .5);
        	windowAsset.alpha = 1;
            
            return new TweensyThread(frame, 0, 1, Exponential.easeInOut, null, {alpha:1, height:r.height + 22});
        }
        
        override public function getShowWindowContentThread() : Thread
        {
            return new TweensyThread(result, 0, 1, Exponential.easeInOut, null, {alpha:1});
        }
    }
}
