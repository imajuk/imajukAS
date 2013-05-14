package com.imajuk.ropes.shapes
{
    import com.imajuk.constructions.AssetFactory;
    import com.imajuk.ropes.models.Model;
    import com.imajuk.service.AssetLocation;
    import com.imajuk.service.IAssetLocation;
    import com.imajuk.service.PreLoader;
    import com.imajuk.service.PreLoaderThread;
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import org.libspark.thread.Thread;




    /**
     * ガイドからラインを生成する
     * @author shinyamaharu
     */
    public class RopeShapeFactoryThread extends Thread
    {
        private var model : Model;
        private var guideURL : String;
        private var guideContainer : MovieClip;
        private var ropeShapes : RopeShapes;
        private var targets : Array;

        public function RopeShapeFactoryThread(model : Model, guideURL : String, ropeShapes : RopeShapes, ...targets)
        {
            super();
            this.targets = targets;
            this.ropeShapes = ropeShapes;
            this.model = model;
            this.guideURL = guideURL;
        }

        override protected function run() : void
        {
            // =================================
            // モーションガイドの作成
            // =================================
            var a : IAssetLocation = new AssetLocation();
            a.add(new URLRequest(guideURL), function(guide : MovieClip) : void
            {
                guideContainer = guide;
            });

            var t : Thread = new PreLoaderThread(new PreLoader(), a);
            t.start();
            t.join();

            next(createMotionGuide);
        }

        private function createMotionGuide() : void
        {
            targets.forEach(function(targetName : String, ...param) : void
            {
                ropeShapes.add(RopeShapeUtils.createShapeFromMC(AssetFactory.create(targetName) as MovieClip, 200, "cursor", "JAPAN", false));
            });
        }

        override protected function finalize() : void
        {
        }
    }
}
