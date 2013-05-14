package com.imajuk.utils 
{
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.geom.Matrix;
    import flash.display.BitmapDataChannel;
    import flash.display.BitmapData;
    import flash.geom.Point;

    /**
     * @author shinyamaharu
     */
    public class BitmapDataUtil 
    {
        private static const POINT : Point = new Point();

        /**
         * 現在のStageのサイズをもつBitmapDataを生成して返します.
         * @param 	transparent	BitmapDataが透明かどうか
         * @param 	fillColor	BitmapDataのカラー
         * @return	現在のStageのサイズをもつBitmapData
         */
        public static function getStageSizeBitmap(
        							transparent : Boolean = false,
        							fillColor : uint = 0x00000000
        						) : BitmapData
        {
            var stage : Stage = StageReference.stage;
            return new BitmapData(stage.stageWidth, stage.stageHeight, transparent, fillColor);
        }

        /**
         * あるBitmapDataが任意の矩形内で隙間ができないように収まるための変形マトリクスを返します.
         */
        public static function getScaleToFitRectangle(target : BitmapData, containerWidth : Number, containerHeight : Number) : Matrix
        {
        	//コンテナの比率（width/height）
            var rateCon : Number = containerWidth / containerHeight;
            //ターゲットの比率（width/height）
            var targetWidth:Number = target.width;
            var targetHeight:Number = target.height;
            var rateTar : Number = targetWidth / targetHeight;
            //横再図を基準にフィットさせるかどうか
            var isFitToWidth : Boolean = rateCon > rateTar;
            //スケール
            var s : Number = (isFitToWidth) ? containerWidth / targetWidth : containerHeight / targetHeight;
            
            var ax:Number = (isFitToWidth) ? 0 : (containerWidth - targetWidth * s) * .5;            var ay:Number = (isFitToWidth) ? (containerHeight - targetHeight * s) * .5 : 0;
            return new Matrix(s, 0, 0, s, ax, ay);
        }

        /**
         * ビットマップを別のビットマップで型抜きします。
         * 例えば矩形のビットマップを星形のビットマップで型抜きし、その結果星形の穴があいたビットマップになります。
         * @param target	型抜きするビットマップ
         * @param pattern	型となるビットマップ
         * @param point		型抜きを始める位置（ターゲットビットマップ上の座標）
         */
        public static function knockout(target : BitmapData, pattern : BitmapData, destPoint : Point) : void
        {
            var pw : Number = pattern.width;
            var ph : Number = pattern.height;
            var x : int ;
            var y : int ;
            var col : int = 0;            var row : int = 0;
            var val : uint;
            
            var aChannel : BitmapData = new BitmapData(pw, ph, true, 0);
            aChannel.copyChannel(pattern, pattern.rect, POINT, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            
            while(row < ph)
            {
                y = row + destPoint.y;
                while(col < pw)
                {                    x = col + destPoint.x;
                    val = aChannel.getPixel32(col, row);
                    //強さを反転
                    val = ~val;                    val = uint(val & target.getPixel32(x, y));
                    target.setPixel32(x, y, val);
                    col++;
                }
                col = 0;
                row++;
            }
        }

        public static function trimTransparent(bitmapData : BitmapData) : BitmapData
        {
        	try
        	{
                var r : Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
                var b : BitmapData = new BitmapData(r.width, r.height, true, 0);
                b.copyPixels(bitmapData, r, new Point());
        	}
        	catch(e:Error)
            {
                return bitmapData;
        	}
            return b;
        }
    }
}
