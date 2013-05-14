package com.imajuk.utils
{
    import flash.text.TextField;

    /**
     * @author imajuk
     */
    public class TextFieldUtil
    {
    	//TODO isHTMLText 未実装
        public static function trimOverflow(tf : TextField, text : String, limitWidth : Number, isHTMLText : Boolean = false) : void
        {
            tf.wordWrap = false;
            tf.multiline = false;

            tf.text = "";

            var i : int = 0;
            while(i < text.length)
            {
                var temp : String = text.substr(i++, 1);
                if (isHTMLText && temp == "<")
                {
                	var r:Array = getTag(text, i - 1); 
                    temp = r[0];
                    i = r[1];
                }
                
                if (isHTMLText)
                    tf.htmlText += temp;
                else
                    tf.appendText(temp);
                
                 
                if (tf.textWidth > limitWidth)
                {
                    var s : String = tf.text;
                    s = s.substr(0, s.length - 1);
                    s += "…";
                    tf.text = s;
                    
                    break;
                }
            }
        }

        // i文字めから始まるhtmlTagを抜き出す
        private static function getTag(text : String, i : int) : Array
        {
            var temp : String = "";
            var s : String = "";
            while(s != ">")
            {
                s = text.substr(i++, 1);
                temp += s;
                if (i >= text.length)
                    break;
            }
            return [temp, i];
        }
    }
}
