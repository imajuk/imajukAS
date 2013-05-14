package com.imajuk.ropes
{
    import com.imajuk.ropes.RopeRenderer;
    import com.bit101.components.CheckBox;
    import com.bit101.components.HRangeSlider;
    import com.bit101.components.HUISlider;
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.ropes.RopeThread;
    import com.imajuk.ropes.debug.DrawGuideThread;
    import com.imajuk.ropes.debug.UIPointThread;
    import com.imajuk.ropes.effects.Circuit;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.effects.Noise;
    import com.imajuk.ropes.effects.Unlace;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.ropes.shapes.RopeShape;
    import com.imajuk.ropes.shapes.RopeShapeUtils;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;

    import org.libspark.thread.Thread;

    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;


    /**
     * @author shinyamaharu
     */
    public class RopeSampleThread extends Thread
    {
        private var guideLayer : Sprite;
        private var drawLayer : Shape;
        private var ropeShape : RopeShape;
        private var effect : Effect;

        public function RopeSampleThread(guideLayer:Sprite, drawLayer:Shape)
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
                var guide : MovieClip = AssetFactory.create("$Frm_JPN") as MovieClip;
                ropeShape = RopeShapeUtils.createShapeFromMC(guide, 100, "cursor", "JAPAN", false);
            });
        	var t:Thread = new PreLoaderThread(new PreLoader(), a);
        	t.start();
        	t.join();
        	
            next(debug);
        }

        private function debug() : void
        {
        	new UIPointThread(ropeShape, guideLayer).start();
        	new DrawGuideThread(guideLayer, ropeShape).start();
        	
        	next(createUI);
        }

        private function createUI() : void
        {
            //------------------------
            // Rope Effects
            //------------------------
            var unlace : Unlace = new Unlace(ropeShape, 2, 5, .1);
            var circuit : Circuit = new Circuit(ropeShape, .001);
            var noise   : Noise   = new Noise(ropeShape);
            
        	var timeline:Sprite = DocumentClass.container;
        	
        	//=================================
        	// guide on/off
        	//=================================
        	new CheckBox(timeline, 10, 20, "guide", function(e:Event) : void
            {
                guideLayer.visible = CheckBox(e.target).selected;
            }).selected = false;
            
            
            //=================================
            // Unlace
            //=================================
            new CheckBox(timeline, 10, 80, "unlace", function(e:Event) : void
            {
                if (CheckBox(e.target).selected)
                   effect.add(unlace);
                else
                   effect.remove(unlace);
                   
            }).selected = false;
            new HUISlider(timeline, 60, 76, "speed", function(e : Event) : void
            {
                unlace.speed = HUISlider(e.target).value * .001;
                trace('unlace.speed: ' + (unlace.speed));
            }).value = unlace.speed*1000;
            new HUISlider(timeline, 240, 76, "iteration", function(e : Event) : void
            {
                unlace.iteration = int(HUISlider(e.target).value);
            }).value = 40;
            var range1 : HRangeSlider = new HRangeSlider(timeline, 430, 80, function() : void
            {
                unlace.min = range1.lowValue; 
                unlace.max = range1.highValue;
            });
            range1.minimum = 0;
            range1.maximum = 10;
            range1.lowValue = 2;
            range1.highValue = 5;
            
            
            //=================================
            // run on motion guide
            //=================================
            new CheckBox(timeline, 10, 100, "circuit", function(e:Event) : void
            {
                if (CheckBox(e.target).selected)
                   effect.add(circuit);
                else
                   effect.remove(circuit);
                   
            }).selected = false;
            new HUISlider(timeline, 60, 96, "speed", function(e : Event) : void
            {
                circuit.speed = HUISlider(e.target).value * .0001;
                trace('circuit.speed: ' + (circuit.speed));
            }).value = .001;
            
            
            //=================================
            // Noise
            //=================================
            new CheckBox(timeline, 10, 130, "noise", function(e:Event) : void
            {
                if (CheckBox(e.target).selected)
                   effect.add(noise);
                else
                   effect.remove(noise);
                   
            }).selected = false;
            var range : HRangeSlider = new HRangeSlider(timeline, 60, 130, function() : void
            {
            	noise.min = range.lowValue; 
            	noise.max = range.highValue; 
            });
            range.minimum = 1;
            range.maximum = 100;
            range.highValue = 3;
            
            next(mainLoop);
        }

        private function mainLoop() : void
        {
        	new RopeThread(Vector.<IRopeShape>([ropeShape]), drawLayer, Vector.<RopeRenderer>([new RopeRenderer()]), effect).start();
        }

        override protected function finalize() : void
        {
        }
    }
}
