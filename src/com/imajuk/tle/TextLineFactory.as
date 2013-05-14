package com.imajuk.tle
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.engine.BreakOpportunity;
    import flash.text.engine.DigitCase;
    import flash.text.engine.DigitWidth;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.Kerning;
    import flash.text.engine.LigatureLevel;
    import flash.text.engine.LineJustification;
    import flash.text.engine.SpaceJustifier;
    import flash.text.engine.TextBaseline;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextJustifier;
    import flash.text.engine.TextLine;
    import flash.text.engine.TextRotation;
    import flash.text.engine.TypographicCase;

    /**
     * @author imajuk
     */
    public class TextLineFactory
    {
    	
        private static const DEFAULT_JUSTIFIER : TextJustifier = 
            new SpaceJustifier("ja", LineJustification.ALL_BUT_LAST, true);
            
        private static const DEFAULT_FORMAT : ElementFormat = 
            new ElementFormat(
                    null, 
                    
                    //size and color
                    0, 0xFFFFFF, 1,
                    
                    //rotation 
                    TextRotation.ROTATE_0,
                     
                    //baseline
                    TextBaseline.ROMAN, TextBaseline.USE_DOMINANT_BASELINE, 0,
                    
                    //kerning 
                    Kerning.ON, 0, 0,
                    
                    //locale 
                    "ja", BreakOpportunity.ANY,
                    
                    //digit 
                    DigitCase.DEFAULT, DigitWidth.DEFAULT,
                    
                    //misc 
                    LigatureLevel.COMMON, 
                    TypographicCase.DEFAULT
                );

        private static function createTextBlock(
                                    description : FontDescription, 
                                    text : String, 
                                    fontColor : uint, 
                                    fontSize : int, 
                                    kerning:Number = 0,
                                    justify : Boolean = false
                                ) : TextBlock
        {

            // setting of Font
            var format:ElementFormat = DEFAULT_FORMAT.clone();
            format.fontDescription = description;
            format.fontSize = fontSize;
            format.color = fontColor;
            format.trackingRight = kerning;

            // setting of Block
            var textBlock : TextBlock = new TextBlock();
            textBlock.baselineFontDescription = description;
            textBlock.baselineZero = TextBaseline.ASCENT;
            if (justify)
                textBlock.textJustifier = DEFAULT_JUSTIFIER;
            textBlock.baselineFontSize = fontSize;
            textBlock.content = new TextElement(text, format);

            return textBlock;
        }

        public static function createTextLines(
                                    boxWidth : int,
                                    description : FontDescription, 
                                    fontSize : int, 
                                    text : String, 
                                    kerning:Number = 0,
                                    fontColor : uint = 0xFFFFFF, 
                                    justify : Boolean = true 
                                ) : Array
        {
            var created : Array = [];

            var textBlock : TextBlock = TextLineFactory.createTextBlock(description, text, fontColor, fontSize, kerning, justify);
            var textLine : TextLine = textBlock.createTextLine(null, boxWidth);
            while (textLine)
            {
                created.push(textLine);
                textLine = textBlock.createTextLine(textLine, boxWidth);
            }

            return created;
        }

        public static function createFillText(
                                    box : Rectangle, 
                                    font : FontDescription, 
                                    text : String, 
                                    kerning : Number,
                                    leading : Number = 1,
                                    fontColor : uint = 0xFFFFFF, 
                                    justify : Boolean = true 
                                ) : Array
        {
        	if (leading <= 0)
        	   throw new Error("leading sholud be larger than 0.");
        	   
        	var cursor:Point = new Point(box.x, box.y);
        	var boxWidth:Number = box.width;
        	var boxHeight:Number = box.height;
        	var limit:Number = box.y + boxHeight;
        	var floorSpace:int = boxWidth * boxHeight;
        	var space:Number = floorSpace / text.length;
            var fontSize : int = Math.sqrt(space) * .5;
        	
        	var a:Array;
        	var b:Array;
        	while(cursor.y <= limit)
        	{
        		cursor.y = box.y;
                b = a;
                a = createTextLines(boxWidth, font, fontSize, text, kerning, fontColor, justify);
                a.forEach(
                    function(tl:TextLine, idx:int, ...param) : void
                    {
                    	tl.x = cursor.x;
                    	tl.y = cursor.y;
                    	cursor.y += tl.textHeight * ((idx == a.length - 1) ? 1 : leading);
                    }
                );
                fontSize ++;
        	}
        	
        	if (!b)
        	   b = a;
        	   
        	return b;
        }
    }
}
