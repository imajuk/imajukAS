package com.imajuk.services
{
    import fl.controls.TextInput;

    import com.bit101.components.PushButton;
    import com.imajuk.service.SNS;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    /**
     * @author imajuk
     */
    public class Sample_SNS extends Sprite
    {
        public function Sample_SNS()
        {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
            var sns  : Array = [SNS.RENREN, SNS.KAIXIN, SNS.DOUBAN, SNS.SINA, SNS.QQ, SNS.MSN],
                ta   : TextInput,
                dest : String = "http://wonderfl.net",
                pic  : String = "https://www.kayac.com/img/contact/img_wonderfl.jpg",
                that : Sprite = this;

            sns.forEach(function(sn : String, idx : int, ...param) : void
            {
                new PushButton(that, 270, 10 + idx * 20, sn, function() : void
                {
					SNS.open(sn, ta.text, dest, pic, dest);
                });
                
            }, this);
			
			ta = addChild(new TextInput()) as TextInput;
			ta.width = 250;
			ta.height = 100;
			ta.x = 10;
			ta.y = 10;
			ta.text = "你好世界！";
        }
    }
}
