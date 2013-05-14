package
com.imajuk.ui.bezier{
    import com.imajuk.drawing.AnchorPoint;
    import com.imajuk.utils.MathUtil;

    import flash.display.Sprite;

    /**
     * @author shin.yamaharu
     */
    public class UIAnchorPointHandle extends Sprite
    {
        public var ap : AnchorPoint;
        private var isRight : Boolean;
        private var uiap : UIAnchorPoint;

        public function UIAnchorPointHandle(ap : AnchorPoint, isRight : Boolean, uiap : UIAnchorPoint)
        {
            this.uiap = uiap;
            this.ap = ap;
            this.isRight = isRight;

            graphics.beginFill(0, .5);
            graphics.drawCircle(0, 0, 10);
            graphics.endFill();

            alpha = 0;
            buttonMode = true;
        }

        public function set handleLength(value : Number) : void
        {
            ap.rightHandleLength = value;
            ap.lefthandleLength = value;
        }

        public function rotate(a : Number) : void
        {
            ap.rotate(MathUtil.getAngleDiff(ap.vector.angle, a + ((isRight) ? -Math.PI * .5 : Math.PI * .5)));
        }

        public function reset() : void
        {
            x = isRight ? ap.rightHandle.x - uiap.x : ap.leftHandle.x - uiap.x;
            y = isRight ? ap.rightHandle.y - uiap.y : ap.leftHandle.y - uiap.y;
        }
    }
}
