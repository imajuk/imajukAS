package com.imajuk.ropes
{
    import flash.display.Shape;
    import com.imajuk.ropes.shapes.IRopeShape;
    import fl.motion.easing.Quadratic;

    import com.bit101.components.CheckBox;
    import com.bit101.components.HRangeSlider;
    import com.bit101.components.HUISlider;
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.ropes.RopeRenderer;
    import com.imajuk.ropes.RopeThread;
    import com.imajuk.ropes.debug.DrawGuideThread;
    import com.imajuk.ropes.debug.UIPointThread;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.effects.EffectUtil;
    import com.imajuk.ropes.effects.Scale;
    import com.imajuk.ropes.effects.SoundSpectrum;
    import com.imajuk.ropes.shapes.RopeShape;
    import com.imajuk.ropes.shapes.RopeShapeUtils;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;

    import org.libspark.thread.Thread;

    import flash.display.CapsStyle;
    import flash.display.GradientType;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsStroke;
    import flash.display.IGraphicsFill;
    import flash.display.IGraphicsStroke;
    import flash.display.InterpolationMethod;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.MovieClip;
    import flash.display.SpreadMethod;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.net.URLRequest;


    /**
     * @author shinyamaharu
     */
    public class SoundSpectrumThread extends Thread
    {
        private var guideLayer : Sprite;
        private var drawLayer : Shape;
        private var ropeShape1 : RopeShape;
        private var ropeShape2 : RopeShape;
        private var effect : Effect;
        private var spectrum_onoff : CheckBox;
        private var sound_spectrum1 : SoundSpectrum;
        private var sound_spectrum2 : SoundSpectrum;
        private var scale1 : Scale;
        private var scale2 : Scale;
        private var scale_onoff : CheckBox;
        private var uiLayer : Sprite;

        public function SoundSpectrumThread(guideLayer:Sprite, drawLayer:Shape)
        {
            super();
            
            this.guideLayer = guideLayer;
            this.drawLayer = drawLayer;
            this.effect = new Effect();
        }

        override protected function run() : void
        {
        	var a:IAssetLocation = new AssetLocation();
            a.add(new URLRequest("shapes.swf"), function(s:Sprite) : void
            {
            	AppDomainRegistry.getInstance().resisterAppDomain(s);
                var guide : MovieClip = AssetFactory.create("$Spike") as MovieClip;
                ropeShape1 = RopeShapeUtils.createShapeFromMC(guide, 110, "cursor", "GREEN", false);
                ropeShape2 = RopeShapeUtils.createShapeFromMC(guide, 110, "red", "RED", false);
            });
        	var t:Thread = new PreLoaderThread(new PreLoader(), a);
        	t.start();
        	t.join();
        	
            next(debug);
        }

        private function debug() : void
        {
        	new UIPointThread(ropeShape2, guideLayer).start();
        	new DrawGuideThread(guideLayer, ropeShape2).start();
        	
        	next(createUI);
        }

        private function createUI() : void
        {
            uiLayer = DocumentClass.container.addChild(new Sprite()) as Sprite;
                     
            const      inout : Function = Quadratic.easeInOut,
                         out : Function = Quadratic.easeOut,
                  effectMask : Vector.<Number> = EffectUtil.createMask(
                                [1, 15,    27,   83,     95, 110], 
                                [0,  1,     0,    0,      1,   0], 
                                [  out, inout, null, inout,  out]),
                 effectMask2 : Vector.<Number> = EffectUtil.createMask(
                                [1, 15,    27,   83,     95, 110], 
                                [0,  0,     1,    1,      0,   0], 
                                [  out, inout, null, inout,  out]);
                                
            //------------------------
            // Rope Effects
            //------------------------
            scale1 = new Scale(ropeShape1, new Point(660, 380), 2, 2, .1, 60, Scale.OUT_SIDE, effectMask2);
            scale2 = new Scale(ropeShape2, new Point(660, 420), 2, 2, .1, 60, Scale.OUT_SIDE, effectMask2);
                       
            sound_spectrum1 = new SoundSpectrum(ropeShape1, 1000, 30, 1000/60, .3, false, 0, 11008, effectMask);
            sound_spectrum2 = new SoundSpectrum(ropeShape2, 1000, 30, 1000/60, .3, false, 0, 11008,effectMask);
            sound_spectrum1.onSound = function(peak : Number) : void
            {
                scale1.speed += ((peak * .7+.05) - scale1.speed) * .1;
                scale_speed.value = scale2.speed * 1000; 
                
                peak *= 50;
                peak += 2;
                scale1.max += (peak - scale1.max) * .1;
                scale2.max += (peak - scale2.max) * .1;
                scale_range.highValue = scale2.max;
            };
            sound_spectrum1.onSoundStop = function() : void
            {
                scale1.max = 2;
                scale_range.highValue = scale1.max;
            };
        	
            //------------------------
        	// guide on/off
            //------------------------
        	new CheckBox(uiLayer, 10, 20, "guide", function(e:Event) : void
            {
                guideLayer.visible = CheckBox(e.target).selected;
            }).selected = false;

            //------------------------
            // Sound Spectrum
            //------------------------
            spectrum_onoff = new CheckBox(uiLayer, 10, 40, "sound_spectrum", function(e:Event) : void
            {
                if (CheckBox(e.target).selected)
                {
                   effect.add(sound_spectrum1);
                   effect.add(sound_spectrum2);
                }
                else
                {
                   effect.remove(sound_spectrum1);
                   effect.remove(sound_spectrum2);
                }
                   
            });
            spectrum_onoff.selected = false;
            var sp:HUISlider = new HUISlider(uiLayer, 100, 36, "spectrum_partition", function(e : Event) : void
            {
                sound_spectrum1.spectrum_partition = HUISlider(e.target).value;
            });
            sp.width = 250;
            sp.minimum = 3;
            sp.maximum = 256;
            sp.value = sound_spectrum1.spectrum_partition;
            var size:HUISlider = new HUISlider(uiLayer, 350, 36, "size", function(e : Event) : void
            {
                sound_spectrum1.size = int(HUISlider(e.target).value);
            });
            size.minimum = 0;
            size.maximum = 1000;
            size.value = sound_spectrum1.size;
            var smooth:HUISlider = new HUISlider(uiLayer, 550, 36, "smoothing", function(e : Event) : void
            {
                sound_spectrum1.smoothing = (100-HUISlider(e.target).value)*.01;
                trace('sound_spectrum.smoothing: ' + (sound_spectrum1.smoothing));
            });
            smooth.minimum = 0;
            smooth.maximum = 100;
            smooth.value = 100-sound_spectrum1.smoothing*100;
            

            //=================================
            // Scale
            //=================================
            scale_onoff = new CheckBox(uiLayer, 10, 70, "scale", function(e:Event) : void
            {
                if (CheckBox(e.target).selected)
                {
                   effect.add(scale1);
                   effect.add(scale2);
                }
                else
                {
                   effect.remove(scale1);
                   effect.remove(scale2);
                }
                   
            });
            scale_onoff.selected = false;
            var scale_speed : HUISlider = new HUISlider(uiLayer, 60, 66, "speed", function(e : Event) : void
            {
                scale2.speed = HUISlider(e.target).value * .001;
                trace('scale2.speed: ' + (scale2.speed));
            });
            scale_speed.value = scale2.speed * 1000;
            scale_speed.maximum = 300;
            new HUISlider(uiLayer, 240, 66, "iteration", function(e : Event) : void
            {
                scale2.iteration = int(HUISlider(e.target).value);
            }).value = 60;
            var scale_range : HRangeSlider = new HRangeSlider(uiLayer, 430, 70, function() : void
            {
                scale2.min = scale_range.lowValue; 
                scale2.max = scale_range.highValue;
            });
            scale_range.minimum = 0;
            scale_range.maximum = 50;
            scale_range.lowValue = 2;
            scale_range.highValue = 2;

            
            next(mainLoop);
        }

        private function mainLoop() : void
        {
            var m : Matrix = new Matrix();
            m.createGradientBox(250, 250, 0, 0, 0);
            
            var    gfill : IGraphicsFill   = new GraphicsGradientFill(GradientType.RADIAL, [0xc8bb17, 0xa89b07], [1, 1], [0, 255], m, SpreadMethod.REFLECT, InterpolationMethod.LINEAR_RGB),
                  gfill2 : IGraphicsFill   = new GraphicsGradientFill(GradientType.RADIAL, [0xb869c5, 0x9849a5], [1, 1], [0, 255], m, SpreadMethod.REFLECT, InterpolationMethod.LINEAR_RGB),
                  stroke : IGraphicsStroke = new GraphicsStroke(3, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.ROUND, 3, gfill),
                 stroke2 : IGraphicsStroke = new GraphicsStroke(3, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.ROUND, 3, gfill2),
                renderer : RopeRenderer    = new RopeRenderer(stroke),
               renderer2 : RopeRenderer    = new RopeRenderer(stroke2);
                
            new RopeThread(Vector.<IRopeShape>([ropeShape1, ropeShape2]), drawLayer, Vector.<RopeRenderer>([renderer,renderer2]), effect).start();
            
            next(autoStart);
        }

        private function autoStart() : void
        {
            effect.add(sound_spectrum1);
            effect.add(sound_spectrum2);
            effect.add(scale1);
            effect.add(scale2);

            spectrum_onoff.selected = true;
            scale_onoff.selected = true;
            
//            uiLayer.visible = false;
        }

        override protected function finalize() : void
        {
        }
    }
}
