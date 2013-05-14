package com.imajuk.ropes.debug
{
    import com.imajuk.ropes.models.APoint;
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.text.TextField;



    /**
     * @author shinyamaharu
     */
    public class UIPointThread extends Thread
    {
        private var timeline : Sprite;
        private var uiControls : Array;
        private var uiAnchor : Array;
        private var model : IRopeShape;
        private var uiOrigins : Array;

        public function UIPointThread(model : IRopeShape, timeline : Sprite)
        {
            super();

            this.model = model;
            this.timeline = timeline;
            
            var desc:Sprite = timeline.addChild(new Sprite()) as Sprite,
                tf:TextField;
            desc.addChild(new UIPoint(new Point(), 0xff430c, false, 2));
            tf = desc.addChild(new TextField()) as TextField;
            tf.text = "... original point";
            tf.x = 10;
            tf.y = -8;
            desc.addChild(new UIPoint(new Point(), 0xf2d32c, false, 2)).y = 20;
            tf = desc.addChild(new TextField()) as TextField;
            tf.text = "... control point";
            tf.x = 10;
            tf.y = 11;
            desc.addChild(new UIPoint(new Point(), 0x3c3e95, false, 3)).y = 40;
            tf = desc.addChild(new TextField()) as TextField;
            tf.text = "... anchor point";
            tf.x = 10;
            tf.y = 31;
            desc.x = 700;
            desc.y = 500;
        }

        override protected function run() : void
        {
            uiOrigins = model.getControlPoints().map(function(cp : ControlPoint, ...param) : DisplayObject
            {
                return timeline.addChild(new UIPoint(new Point(cp.initX, cp.initY), 0xff430c, false, 2));
            });
            
            uiControls = model.getControlPoints().map(function(cp : ControlPoint, ...param) : DisplayObject
            {
//                return timeline.addChild(new UIPoint(cp, 0xf2d32c, false, 2));
                return timeline.addChild(new UIPoint(cp, 0xf2d32c, false, 2, cp.id%10==0));
            });

            uiAnchor = model.getAnchorPoints().map(function(ap : APoint, ...param) : DisplayObject
            {
                return timeline.addChild(new UIPoint(ap, 0x3c3e95, true, 3));
            });

            update();
        }

        private function update() : void
        {
            updateUIControles();
            updateAnchor();

            next(update);
        }

        private function updateUIControles() : void
        {
            uiControls.forEach(function(uip : UIPoint, ...param) : void
            {
                uip.update();
            });
        }

        private function updateAnchor() : void
        {
            uiAnchor.forEach(function(uip : UIPoint, ...param) : void
            {
                uip.update();
            });
        }

        override protected function finalize() : void
        {
        }
    }
}
