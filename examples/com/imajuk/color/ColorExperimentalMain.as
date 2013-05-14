package com.imajuk.color
{
    import com.bit101.components.Component;
    import com.bit101.components.HUISlider;
    import com.bit101.components.Panel;
    import com.bit101.components.PushButton;
    import com.bit101.utils.MinimalConfigurator;
    import com.imajuk.constructions.DocumentClass;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.DisplayObject;
    import flash.display.StageQuality;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Point;

    /**
     * 1・alphaはColorTransformのショートカットなのか？
     * @author shinyamaharu
     */
    public class ColorExperimentalMain extends DocumentClass
    {
        [Embed (source="test.png")]
        private var test : Class;
        private var r0 : HUISlider;
        private var g0 : HUISlider;
        private var b0 : HUISlider;
        private var a0 : HUISlider;
        private var r1 : HUISlider;
        private var g1 : HUISlider;
        private var b1 : HUISlider;
        private var a1 : HUISlider;
        private var shape2 : DisplayObject;
        private var reset : PushButton;
        private var config : MinimalConfigurator;
        private var input_w : int;
        private var input_h : int;
        private var crb : Bitmap;
        private var cgb : Bitmap;
        private var cbb : Bitmap;
        private var cab : Bitmap;

        public function ColorExperimentalMain()
        {
            super(StageQuality.HIGH);
        }

        override protected function start() : void
        {
            var o : * = new test();
            input_w = o.width;
            input_h = o.height;
            var src : BitmapData = new BitmapData(input_w, input_h, true, 0);
            src.draw(o);


            shape2 = addChild(new Bitmap(src));
            shape2.x = shape2.y = 2;

            var xml : XML = <comps>
                <HBox>
                    <VBox alignment="center">
                        <Label text="INPUT" />
                        <Panel id="input" width="104" height="104" />
                    </VBox>
                    <VBox>
                        <Label text="CHANNELS    x   multipler" />
                        <HBox>
                            <Panel id="cr" width="52" height="52" />
                            <HUISlider id="r0" label="X"   minimum="-1" maximum="1" value="1" />
                            <Label text="+" />
                            <HUISlider id="r1" label="   "   minimum="-255" maximum="255" value="0" />
                            <Label text="=" />
                        </HBox>
                        <HBox>
                            <Panel id="cg" width="52" height="52" />
                            <HUISlider id="g0" label="X" minimum="-1" maximum="1" value="1" />
                            <Label text="+" />
                            <HUISlider id="g1" label="   " minimum="-255" maximum="255" value="0" />
                            <Label text="=" />
                        </HBox>
                        <HBox>
                            <Panel id="cb" width="52" height="52" />
                            <HUISlider id="b0" label="X"  minimum="-1" maximum="1" value="1" />
                            <Label text="+" />
                            <HUISlider id="b1" label="   "  minimum="-255" maximum="255" value="0" />
                            <Label text="=" />
                        </HBox>
                        <HBox>
                            <Panel id="ca" width="52" height="52" />
                            <HUISlider id="a0" label="X" minimum="-1" maximum="1" value="1" />
                            <Label text="+" />
                            <HUISlider id="a1" label="   " minimum="-255" maximum="255" value="0" />
                            <Label text="=" />
                        </HBox>
                    </VBox>
                    <VBox>
                        <Label text="CHANNELS" />
                        <HBox>
                            <Panel id="cr2" width="52" height="52" />
                        </HBox>
                        <HBox>
                            <Panel id="cg2" width="52" height="52" />
                        </HBox>
                        <HBox>
                            <Panel id="cb2" width="52" height="52" />
                        </HBox>
                        <HBox>
                            <Panel id="ca2" width="52" height="52" />
                        </HBox>
                    </VBox>
                    <VBox alignment="center">
                        <Label text="OUTPUT" />
                        <Panel id="output" width="104" height="104" />
                    </VBox>
                    <PushButton id="reset" label="reset" />
                </HBox>
            </comps>;

            Component.initStage(stage);
            config = new MinimalConfigurator(this);
            config.parseXML(xml);

            drawMultipled(src);


            r0 = config.getCompById("r0") as HUISlider;
            g0 = config.getCompById("g0") as HUISlider;
            b0 = config.getCompById("b0") as HUISlider;
            a0 = config.getCompById("a0") as HUISlider;
            r1 = config.getCompById("r1") as HUISlider;
            g1 = config.getCompById("g1") as HUISlider;
            b1 = config.getCompById("b1") as HUISlider;
            a1 = config.getCompById("a1") as HUISlider;
            reset = config.getCompById("reset") as PushButton;

            var a : Array = [r0, r1, g0, g1, b0, b1, a0, a1];
            a.forEach(function(c : Component, ...param) : void
            {
                c.addEventListener(Event.CHANGE, function() : void
                {
                    applyCT();
                    var src : BitmapData = new BitmapData(input_w, input_h, true, 0);
                    src.draw(shape2, shape2.transform.matrix, shape2.transform.colorTransform);
                    drawMultipled(src);
                });
            });
            reset.addEventListener(MouseEvent.CLICK, function() : void
            {
                shape2.transform.colorTransform = new ColorTransform();
                showCT();
                drawMultipled(src);
            });

            var input : Bitmap = new Bitmap(src);
            input.x = input.y = 2;
            Panel(config.getCompById("input")).addRawChild(input);
            Panel(config.getCompById("output")).addRawChild(shape2);
            
            crb = getPreviewBMP(.5);          
            Panel(config.getCompById("cr")).addRawChild(drawChannel(src, BitmapDataChannel.RED, getPreviewBMP(.5)));
            Panel(config.getCompById("cr2")).addRawChild(crb);
            
            cgb = getPreviewBMP(.5);          
            Panel(config.getCompById("cg")).addRawChild(drawChannel(src, BitmapDataChannel.GREEN, getPreviewBMP(.5)));
            Panel(config.getCompById("cg2")).addRawChild(cgb);  
            cbb = getPreviewBMP(.5);          
            
            Panel(config.getCompById("cb")).addRawChild(drawChannel(src, BitmapDataChannel.BLUE, getPreviewBMP(.5)));
            Panel(config.getCompById("cb2")).addRawChild(cbb);  

            cab = getPreviewBMP(.5);          
            Panel(config.getCompById("ca")).addRawChild(drawChannel(src, BitmapDataChannel.ALPHA, getPreviewBMP(.5)));
            Panel(config.getCompById("ca2")).addRawChild(cab);  
            drawMultipled(src);
        };

        private function getPreviewBMP(scale:Number) : Bitmap
        {
            var b:Bitmap = new Bitmap();
            b.x = b.y = 2;
            b.scaleX = b.scaleY = scale;
            return b;
        }

        private function drawMultipled(src : BitmapData) : void
        {
            if (crb && cgb && cbb && cab)
            {
                drawChannel(src, BitmapDataChannel.RED, crb);
                drawChannel(src, BitmapDataChannel.GREEN, cgb);
                drawChannel(src, BitmapDataChannel.BLUE, cbb);
                drawChannel(src, BitmapDataChannel.ALPHA, cab);
            }
        }

        private function drawChannel(src : BitmapData, channel : uint, target:Bitmap) : Bitmap
        {
            var bd : BitmapData = new BitmapData(src.width, src.height, true, 0);
            if (channel == BitmapDataChannel.ALPHA)
                bd.fillRect(bd.rect, 0x00FFFFFF);
            else
                bd.fillRect(bd.rect, 0xFF000000);
            
            bd.copyChannel(src, src.rect, new Point(), channel, channel);
            target.bitmapData = bd;
            
            return target;
        }

        private function showCT() : void
        {
            var ct : ColorTransform = shape2.transform.colorTransform;
            r0.value = ct.redMultiplier;
            r1.value = ct.redOffset;
            b0.value = ct.blueMultiplier;
            b1.value = ct.blueOffset;
            g0.value = ct.greenMultiplier;
            g1.value = ct.greenOffset;
            a0.value = ct.alphaMultiplier;
            a1.value = ct.alphaOffset;
        }

        private function applyCT(...param) : void
        {
            var ct : ColorTransform = new ColorTransform(r0.value, g0.value, b0.value, a0.value, r1.value, g1.value, b1.value, a1.value);
            shape2.transform.colorTransform = ct;
        }
    }
}
