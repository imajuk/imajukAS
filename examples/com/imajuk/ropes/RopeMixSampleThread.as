package com.imajuk.ropes
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.HRangeSlider;
    import com.bit101.components.HUISlider;
    import com.bit101.components.PushButton;
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.ropes.debug.DrawGuideThread;
    import com.imajuk.ropes.debug.UIPointThread;
    import com.imajuk.ropes.effects.Circuit;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.effects.Noise;
    import com.imajuk.ropes.effects.Unlace;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.ropes.shapes.RopeMixier;
    import com.imajuk.ropes.shapes.RopeShapeUtils;
    import com.imajuk.ropes.shapes.RopeShapes;
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
    public class RopeMixSampleThread extends Thread
    {
        private var guideLayer : Sprite;
        private var drawLayer : Shape;
        private var effect : Effect;
        private var ma : Array;
        private var frms : Array;
        private var mixier : RopeMixier;
        private var shapeID : int;
        private var unlace : Unlace;
        private var circuit : Circuit;
        private var noise : Noise;

        public function RopeMixSampleThread(guideLayer : Sprite, drawLayer : Shape, effect : Effect)
        {
            super();

            this.guideLayer = guideLayer;
            this.drawLayer = drawLayer;
            this.effect = effect;
        }

        override protected function run() : void
        {
            var a : IAssetLocation = new AssetLocation();
            a.add(new URLRequest("shapes.swf"), function(guide : MovieClip) : void
            {
                AppDomainRegistry.getInstance().resisterAppDomain(guide);
            });

            var t : Thread = new PreLoaderThread(new PreLoader(), a);
            t.start();
            t.join();

            next(initModel);
        }

        private function initModel() : void
        {
            var shapes:RopeShapes = new RopeShapes();
            frms = ["$Frm_JPN", "$Frm_C0", "$Frm_C1", "$Frm_C2", "$Frm_DETAIL", "$Frm_NEWS"];
            ma   = [       150,       700,       700,       700,           350,         350];
            frms.forEach(function(targetName : String, ...param) : void
            {
            	var guide:MovieClip = AssetFactory.create(targetName) as MovieClip;
                shapes.add(RopeShapeUtils.createShapeFromMC(guide, ma[0], "cursor", targetName, false));
            });

            mixier = new RopeMixier();
            mixier.initialize(shapes);
            
            next(debug);
        }

        private function debug() : void
        {
            new UIPointThread(mixier, guideLayer).start();
            new DrawGuideThread(guideLayer, mixier).start();

            next(setupEffect);
        }

        private function setupEffect() : void
        {
            unlace  = new Unlace(mixier);
            circuit = new Circuit(mixier);
            noise   = new Noise(mixier);

            next(createUI);
        }

        private function createUI() : void
        {
            var timeline : Sprite = DocumentClass.container;

            //=================================
            // whther guide is shown
            //=================================
            new CheckBox(timeline, 10, 20, "guide", function(e : Event) : void
            {
                guideLayer.visible = CheckBox(e.target).selected;
            });
            
            //=================================
            // points
            //=================================
            var ps:HUISlider = new HUISlider(timeline, 60, 15, "points", function(e : Event) : void
            {
            	mixier.amount = int(ps.value);
            });
            ps.width = 600;
            ps.minimum = 3;
            ps.maximum = 1000;
            ps.value = mixier.amount;


            //=================================
            // change
            //=================================
            new PushButton(timeline, 10, 40, "change", function() : void
            {
                shapeID++;
                if (shapeID > frms.length-1) shapeID = 0;
            	mixier.amount = ps.value = int(ma[shapeID]);
                mixier.change(shapeID);
            });

            //=================================
            // Unlace
            //=================================
            new CheckBox(timeline, 10, 80, "unlace", function(e : Event) : void
            {
                if (CheckBox(e.target).selected)
                    effect.add(unlace);
                else
                    effect.remove(unlace);

            });
            new HUISlider(timeline, 60, 76, "speed", function(e : Event) : void
            {
                unlace.speed = HUISlider(e.target).value * .001;
            }).value = 30;
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
            range1.highValue = 4;


            //=================================
            // Circuit (run on motion guide)
            //=================================
            new CheckBox(timeline, 10, 100, "circuit", function(e : Event) : void
            {
                if (CheckBox(e.target).selected)
                    effect.add(circuit);
                else
                    effect.remove(circuit);

            });
            new HUISlider(timeline, 60, 96, "speed", function(e : Event) : void
            {
                circuit.speed = HUISlider(e.target).value * .0001;
            }).value = 0;


            //=================================
            // Noise
            //=================================
            new CheckBox(timeline, 10, 130, "noise", function(e : Event) : void
            {
                if (CheckBox(e.target).selected)
                    effect.add(noise);
                else
                    effect.remove(noise);

            });
            var range : HRangeSlider = new HRangeSlider(timeline, 60, 130, function() : void
            {
                noise.min = range.lowValue;
                noise.max = range.highValue;
            });
            range.minimum = 1;
            range.maximum = 100;
            range.highValue = 3;

            next(startRope);
        }

        private function startRope() : void
        {
            new RopeThread(Vector.<IRopeShape>([mixier]), drawLayer, Vector.<RopeRenderer>([new RopeRenderer()]), effect).start();
        }

        override protected function finalize() : void
        {
        }
    }
}
