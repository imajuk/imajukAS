package com.imajuk.ropes
{
    import com.bit101.components.CheckBox;
    import com.bit101.components.HRangeSlider;
    import com.bit101.components.HUISlider;
    import com.bit101.components.PushButton;
    import com.imajuk.constructions.AppDomainRegistry;
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.data.ArrayIterator;
    import com.imajuk.data.IIterator;
    import com.imajuk.ropes.RopeThread;
    import com.imajuk.ropes.debug.DrawGuideThread;
    import com.imajuk.ropes.debug.UIPointThread;
    import com.imajuk.ropes.effects.Circuit;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.effects.Noise;
    import com.imajuk.ropes.effects.Unlace;
    import com.imajuk.ropes.models.Model;
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
        private var model : Model;
        private var effect : Effect;
        private var ma : Array;
        private var frms : Array;

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
            ma   = [       300,       700,       700,       700,           350,         350];
            frms.forEach(function(targetName : String, ...param) : void
            {
            	var guide:MovieClip = AssetFactory.create(targetName) as MovieClip;
                shapes.add(RopeShapeUtils.createShapeFromMC(guide, 150, "cursor", "JAPAN", false));
            });

            var mixier : RopeMixier = new RopeMixier();
            this.model = new Model(mixier);
//            model.closed = true;
            model.initialize(shapes, 150);
            
//            Logger.show(Logger.INFO);
//            Logger.info(0, "test");
//            trace(model.amount);
//            model.amount ++;
//            trace(model.amount, chk(), model.guidePoints.length);
//            model.amount = 310;
//            trace(model.amount, chk(), model.guidePoints.length);

            next(debug);
        }

//        private function chk() : int
//        {
//        	var c:int;
//        	var cp:ControlPoint = model.guidePoints[0];
//        	while(cp)
//        	{
//        		c++;
//        		cp = cp.next;
//        	}
//        	return c;
//        }

        private function debug() : void
        {
            new UIPointThread(model, guideLayer).start();
            new DrawGuideThread(guideLayer, model).start();

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
            }).selected = false;
            
            //=================================
            // points
            //=================================
            var ps:HUISlider = new HUISlider(timeline, 60, 15, "points", function(e : Event) : void
            {
            	model.amount = int(ps.value);
            });
            ps.width = 600;
            ps.minimum = 3;
            ps.maximum = 1000;
            ps.value = model.amount;


            //=================================
            // change
            //=================================
            var i:IIterator;
            i = new ArrayIterator(frms);
            new PushButton(timeline, 10, 40, "change", function() : void
            {
            	var next:String;
            	if (i.hasNext())
            	{
            		next = i.next();
            	}
            	else
            	{
                    i = new ArrayIterator(frms);
            		next = i.next();
            	}
            	var j:int = i.position-1;
            	ps.value = int(ma[j]);
            	model.amount = ps.value;
            	trace(j, next, int(ma[j]), model.amount);
                model.change(j);
            });


            var unlace : Unlace = new Unlace(model);
            var circuit : Circuit = new Circuit(model.shape);
            var noise : Noise = new Noise(model);

            effect.add(circuit);

            //=================================
            // Unlace
            //=================================
            new CheckBox(timeline, 10, 80, "unlace", function(e : Event) : void
            {
                if (CheckBox(e.target).selected)
                    effect.add(unlace);
                else
                    effect.remove(unlace);

            }).selected = false;
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


            // =================================
            // run on motion guide
            // =================================
            new CheckBox(timeline, 10, 100, "circuit", function(e : Event) : void
            {
                if (CheckBox(e.target).selected)
                    effect.add(circuit);
                else
                    effect.remove(circuit);

            }).selected = true;
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
            new RopeThread(Vector.<IRopeShape>([model]), drawLayer, null, effect).start();
        }

        override protected function finalize() : void
        {
        }
    }
}
