package
com.imajuk.ui.bezier{
    import com.imajuk.drawing.AnchorPoint;

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     * @author shin.yamaharu
     */
    public class UIAnchorPoint extends Sprite
    {
        public var ap : AnchorPoint;
        private var left : UIAnchorPointHandle;
        private var right : UIAnchorPointHandle;

        public function UIAnchorPoint(ap:AnchorPoint)        {
            this.ap = ap;
            left = addChild(new UIAnchorPointHandle(ap, false, this)) as UIAnchorPointHandle;
            right = addChild(new UIAnchorPointHandle(ap, true, this)) as UIAnchorPointHandle;
            

            addEventListener(MouseEvent.MOUSE_DOWN, handleDownHandler);

            graphics.beginFill(0, .5);
            graphics.drawCircle(0, 0, 10);
            graphics.endFill();

            buttonMode = true;
            alpha = 0;

            x = ap.x;
            y = ap.y;
            left.reset();
            right.reset();
        }

        private function handleDownHandler(event : MouseEvent) : void
        {
            var target : Sprite = event.target as Sprite;
            
            var f : Function = (target is UIAnchorPointHandle) ? 
                function() : void
                {
                    var dx : Number = target.x + x - UIAnchorPointHandle(target).ap.x;
                    var dy : Number = target.y + y - UIAnchorPointHandle(target).ap.y;
                    var a : Number = Math.atan2(dy, dx);
                    UIAnchorPointHandle(target).rotate(a);
    
                    dx = Math.abs(dx);
                    dy = Math.abs(dy);
                    UIAnchorPointHandle(target).handleLength = Math.sqrt(dx * dx + dy * dy);
    
                    left.reset();
                    right.reset();
                } : 
                function() : void
                {
                    ap.x = x;
                    ap.y = y;
                    left.reset();
                    right.reset();
                };


            target.startDrag();
            target.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee);
            target.addEventListener(MouseEvent.MOUSE_MOVE, f);
            stage.addEventListener(MouseEvent.MOUSE_UP, function() : void
            {
                target.stopDrag();
                target.removeEventListener(MouseEvent.MOUSE_MOVE, f);
                target.addEventListener(MouseEvent.MOUSE_DOWN, handleDownHandler);
            });
        }

        override public function set x(value:Number):void
        {
            super.x = value;
            ap.x = value;	
        }
        
        override public function set y(value:Number):void
        {
            super.y = value;
            ap.y = value;   
        }
    }
}
