package com.imajuk.ropes
{
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.motion.BetweenThread;
    import com.imajuk.ropes.effects.Circuit;
    import com.imajuk.ropes.effects.Effect;
    import com.imajuk.ropes.effects.Unlace;
    import com.imajuk.ropes.models.Model;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.ropes.shapes.RopeMixier;
    import com.imajuk.ropes.shapes.RopeShapeUtils;
    import com.imajuk.ropes.shapes.RopeShapes;
    import com.imajuk.threads.ThreadUtil;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.easing.Expo;
    import org.libspark.thread.Thread;

    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;




    /**
     * @author shinyamaharu
     */
    public class Rope extends Sprite
    {
        public var id : String;
        protected var model : Model;
        protected var effect : Effect;
        protected var unlace : Unlace;
        protected var ropeThread : RopeThread;
        protected var playing : Boolean;
        protected var tm : uint;

        public function Rope(asset : Sprite, id : String = "")
        {
            this.id = id;
            // 引数assetはダミー
            asset;

            init();
        }

        override public function toString() : String
        {
            return "Rope[" + id + "]";
        }

        public function init() : void
        {
            visible = false;
            alpha = 0;

            mouseEnabled = false;
            mouseChildren = false;
        }

        public function show(a : Number = 1) : Thread
        {
            visible = true;
            return new BetweenThread(BetweenAS3.to(this, {alpha:a}, 1, Expo.easeInOut));
        }

        public function hide() : Thread
        {
            return new BetweenThread(BetweenAS3.to(this, {alpha:0}, .5, Expo.easeOut));
        }

        public function build(amount : int, closed : Boolean, ...guideNames) : void
        {
            model = new Model(new RopeMixier());

            var shapes : RopeShapes = new RopeShapes();
            guideNames.forEach(function(targetName : String, ...param) : void
            {
                shapes.add(RopeShapeUtils.createShapeFromMC(AssetFactory.create(targetName) as MovieClip, 20, "cursor", targetName, false));
            });

            model.initialize(shapes, amount, closed);

            unlace = new Unlace(model);
            var circuit : Circuit = new Circuit(model.shape);
            effect = new Effect(circuit, unlace);
        }

        /**
         * @param rope          コピー元のロープ
         * @param guideNames    追加分のガイド
         */
        public function copyFrom(rope : Rope, ...guideNames) : void
        {
            var shapes : RopeShapes = new RopeShapes();
            guideNames.forEach(function(targetName : String, ...param) : void
            {
                shapes.add(RopeShapeUtils.createShapeFromMC(AssetFactory.create(targetName) as MovieClip, 20, "cursor", targetName, false));
            });

            model = rope.model;
            model.shapes = shapes;

            effect = rope.effect;
            unlace = effect.getEffect(Unlace);
        }

        public function start() : void
        {
            if (playing)
                return;

            cacheAsBitmap = false;
            ropeThread = new RopeThread(Vector.<IRopeShape>([model]), this as Shape, null, effect);
            ropeThread.start();
            playing = true;
        }

        public function stop() : void
        {
            if (!playing)
                return;

            ThreadUtil.interrupt(ropeThread);
            ropeThread = null;
            cacheAsBitmap = true;
            playing = false;
        }

        public function change(type : int, delay : Number = 0, duration : Number = 0) : void
        {
            throw new Error("abstract");
        }
    }
}
