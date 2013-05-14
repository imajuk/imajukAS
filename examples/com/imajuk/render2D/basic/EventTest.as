package com.imajuk.render2D.basic
{
    import org.libspark.betweenas3.BetweenAS3;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * @author imajuk
     */
    public class EventTest extends Sprite
    {
        private var s : Shape;
        private var tx : Number;
        private var ty : Number;

        public function EventTest()
        {
            s = new Shape();
            s.graphics.beginFill(0);
            s.graphics.drawCircle(0, 0, 10);
            addChild(s);

            stage.addEventListener(Event.ENTER_FRAME, function() : void
            {
                stage.invalidate();
                revert();
            });
            addEventListener(Event.ENTER_FRAME, function() : void
            {
                trace("ENTER");
                trace(s.x, s.y);
            });
            addEventListener(Event.RENDER, function() : void
            {
                trace("RENDER");
                tx = s.x;
                ty = s.y;
                s.x = 100;
                s.y = 100;
            });


            BetweenAS3.repeat(
                BetweenAS3.serial(
                    BetweenAS3.to(s, {x:500, y:500}), 
                    BetweenAS3.to(s, {x:0, y:0})
                ), 100)
            .play();

        }

        private function revert() : void
        {
            trace("Revert");
            s.x = tx;
            s.y = ty;
        }
    }
}
