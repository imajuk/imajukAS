package com.imajuk.render2D.basic
{
    import com.imajuk.color.Color;
    import com.imajuk.render2D.plugins.bmptiles.BmpNode;
    import com.imajuk.utils.ArrayUtil;
    import fl.motion.easing.Quadratic;
    import flash.text.TextField;
    import flash.text.TextFormat;


    /**
     * @author yamaharu
     */
    public class CharNode extends BmpNode 
    {
        private static var sute : Array = ["✪","➹","♥"];
        //        private static var sute:Array = ["♥","✪","✿","◆","➹","«","»"];

        public function CharNode(sx : Number, sy : Number, nodeWidth : int, nodeHeight : int, cols : int, rows : int)
        {
            super(sx, sy, nodeWidth, nodeHeight, cols, rows);
            
            //create asset
            var fm : TextFormat = new TextFormat();
            fm.size = Quadratic.easeOut(_id % nodeWidth, 30, 70, nodeWidth);            var hsv : Color = Color.fromHSV(_id * 2 % 360, _id * 4 % 50 + 50, _id % 100);
            fm.color = hsv.rgb;            var tf : TextField = new TextField();
            tf.text = ArrayUtil.selectRandom(sute, 1)[0];
            tf.setTextFormat(fm);            
            canvas.draw(tf, null, null, null, null, true);
        }
    }
}
