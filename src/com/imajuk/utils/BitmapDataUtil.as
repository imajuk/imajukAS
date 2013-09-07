package com.imajuk.utils 
{
    import com.imajuk.geom.Segment;

    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.Stage;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

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
                //getColorBoundsRectにはbugがあるっぽい.
                //1pxだけ色のついたbitmapに適用するとr: (x=0, y=0, w=0, h=0)が返る.
                if (r.x == 0 && r.y == 0 && r.width==0 && r.height == 0 && bitmapData.getPixel32(0, 0) != 0)
                    r = new Rectangle(0, 0, 1, 1);
                var b : BitmapData = new BitmapData(r.width, r.height, true, 0);
                b.copyPixels(bitmapData, r, new Point());
        	}
        	catch(e:Error)
            {
                return bitmapData;
        	}
            return b;
        }

        private static function trimTransparent2(bitmapData : BitmapData) : Object
        {
            try
            {
                var r : Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
                //getColorBoundsRectにはbugがあるっぽい.
                //1pxだけ色のついたbitmapに適用するとr: (x=0, y=0, w=0, h=0)が返る.
                if (r.x == 0 && r.y == 0 && r.width==0 && r.height == 0 && bitmapData.getPixel32(0, 0) != 0)
                    r = new Rectangle(0, 0, 1, 1);
                var b : BitmapData = new BitmapData(r.width, r.height, true, 0);
                b.copyPixels(bitmapData, r, new Point());
            }
            catch(e:Error)
            {
                return bitmapData;
            }
            return {bitmap:b, rect:r};
        }
        
        /**
         * ビットマップデータに与えられた線分を描画する
         * ただし水平か垂直の線分のみ.水平垂直でない場合はエラー
         */
        public static function drawLinefromSegment(bitmapview : BitmapData, seg : Segment, color : uint) : void
        {
            if (seg.begin.equals(seg.end)) throw new Error('segment has same points as "begin" and "end".');
            var isHolizonal:Boolean = seg.begin.y == seg.end.y;
            var isVertical:Boolean = seg.begin.x == seg.end.x; 
            
            //水平・垂直判定
            if (!isHolizonal && !isVertical) 
                throw new Error('segment is not vertical or holizonal.'+'isHolizonal: '
                    + 'seg: ' + (seg) 
                    + (isHolizonal)+'isVertical: ' 
                    + (isVertical));
            
            var current:int, dest:int, direction:int;
            if (isHolizonal)
            {
                current   = seg.begin.x;
                dest      = seg.end.x;
            }
            else
            {
                current   = seg.begin.y;
                dest      = seg.end.y;
            }
            direction = (current < dest) ? 1 : -1;
            
            while(true)
            {
                if (isHolizonal)
                    setPixel(bitmapview, current, seg.begin.y, color);
                else
                    setPixel(bitmapview, seg.begin.x, current, color);
                
                if (current == dest) break;
                current += direction;
            }
        }

        /**
         * 水平方向に(塗りつぶしながら)走査し、塗り潰しの境界を探す
         * @param b             対象となるBitmapData
         * @param empty_color   塗りつぶし対象となる色
         * @param p             起点
         * @param direction     右方向（1）または左方向(-1)
         * @param alsoFill      塗りつぶしながら走査するか(true)、塗りつぶさないで走査するか(false)
         * @param fillColor     塗りつぶしの色
         * @return 塗りつぶしの境界
         */
        public static function scanLine(b:BitmapData, empty_color:uint,  p : Point, direction : Number, alsoFill : Boolean, fillColor:uint = 0) : int
        {
            if (p.x >= b.width) return b.width-1;
            
            var c:uint = getPixel(b, p.x, p.y);
            if ( c != empty_color && c != fillColor) throw new Error('seed point is not empty color.');
            
            p = p.clone();
            var result : int = p.x;
            do
            {
                if (alsoFill) setPixel(b, p.x, p.y, fillColor);
                result = p.x;
                p.x += direction;
                c = getPixel(b, p.x, p.y); 
            }
            while (c == empty_color && p.x < b.width);
            
            return result;
        }
        
        //描画した水平線Hの上側の線分を左から走査して、"塗り潰すべきピクセルが横に連続している部分"を全て探し、それぞれの最も右側の座標をバッファに格納する
        public static function findAllBorders(b:BitmapData, h : Segment, empty_color:uint) : Array
        {
            var px : int = h.begin.x;
            var py : int = h.begin.y;
            var temp : int = -1;
            var result : Array = [];
            var c : uint;
            var find : int = 0;
            while (px <= h.end.x)
            {
                c = getPixel(b, px, py);
                if (c == empty_color)
                {
                    temp = px;
                    result[find] = temp;
                }
                else if (temp != -1)
                {
                    result[find] = temp;
                    find++;
                    temp = -1;
                }

                px++;
            }
            
            return result;
        }

        public static function fillByScanLine(b : BitmapData, startingPoint : Point, emptyColor : uint) : EventDispatcher
        {
            return new Painter(b, startingPoint, emptyColor);
        }

        public static function trim(b : BitmapData, trimWidth : int, trimHeight : int) : BitmapData
        {
            if (b.width <= trimWidth && b.height <= trimHeight) return b;
            const b2:BitmapData = new BitmapData(trimWidth, trimHeight, b.transparent, 0);
            b2.copyPixels(b, b2.rect, new Point());
            return b2;
        }

        public static function getPixel(b : BitmapData, px : Number, py : Number) : uint
        {
            const f : Function = b.transparent ? b.getPixel32 : b.getPixel;
            return f(px, py);
        }

        public static function setPixel(b : BitmapData, px : Number, py : Number, color:uint) : uint
        {
            const f : Function = b.transparent ? b.setPixel32 : b.setPixel;
            return f(px, py, color);
        }

        /**
         * bitmap1とbitmap2を比較しbitmap1がbitmap2のどのエッジにヒットしているかを返す.
         * 透明のピクセルは考慮しない.
         * 
         * @param b1    bitmap1
         * @param b1Loc bitmap1の座標
         * @param b2    bitmap2
         * @param b2Loc bitmap2の座標
         * @return  ヒット状態を表す文字列
         *          NO_HIT 両bitmapがヒットしていない
         *          　　　W 両bitmapが完全に重なっている
         *               T bitmap2の上辺でヒット
         *               B bitmap2の下辺でヒット
         *               L bitmap2の左辺でヒット
         *               R bitmap2の右辺でヒット
         *              TL bitmap2の左上角でヒット
         *              BL bitmap2の左下角でヒット
         *              TR bitmap2の右上角でヒット
         *              BR bitmap2の右下角でヒット
         *               
         */
        public static function hitTest(b1 : BitmapData, b1Loc : Point, b2 : BitmapData, b2Loc : Point) : String
        {
            const rect1 : Rectangle = b1.rect, rect2 : Rectangle = b2.rect;
            rect1.x = b1Loc.x;
            rect1.y = b1Loc.y;
            rect2.x = b2Loc.x;
            rect2.y = b2Loc.y;

            //両bitmapが完全に重なっている
            if (rect1.equals(rect2)) return 'W';
            
            const diff : Rectangle = rect1.intersection(rect2),
                     w : int       = diff.width, 
                     h : int       = diff.height;
                     
            //両bitmapがヒットしていない
            if (w == 0 && h == 0) return 'NO_HIT';

            const isContaine : Boolean = rect2.containsRect(rect1);
            var result : String = '';
            if (isContaine)
            {
                const alignTopEdge      : Boolean = diff.y == rect2.y;
                const alignAtBottomEdge : Boolean = diff.y + (diff.height - 1) == rect2.y + (rect2.height - 1);
                const alignLeftEdge     : Boolean = diff.x == rect2.x;
                const alignRightEdge    : Boolean = diff.x + (diff.width - 1) == rect2.x + (rect2.width - 1);
                if (w == h)
                {
                    if (alignTopEdge)      result += 'T';
                    if (alignAtBottomEdge) result += 'B';
                    if (alignLeftEdge)     result += 'L';
                    if (alignRightEdge)    result += 'R';
                }
                else if (w > h)
                {
                    if (alignTopEdge)           result += 'T';
                    else if (alignAtBottomEdge) result += 'B';
                    else if (alignLeftEdge)     result += 'L';
                    else if (alignRightEdge)    result += 'R';
                }
                else
                {
                    if (alignLeftEdge)          result += 'L';
                    else if (alignRightEdge)    result += 'R';
                    else if (alignTopEdge)      result += 'T';
                    else if (alignAtBottomEdge) result += 'B';
                }
            }
            else
            {
                if (w >= h)
                {
                    if (diff.y <= b2Loc.y) result += 'T';
                    else result += 'B';
                }
                if (w <= h)
                {
                    if (diff.x <= b2Loc.x) result += 'L';
                    else result += 'R';
                }
            }
            
            return result;
        }

        /**
         * bitmap1とbitmap2を比較しbitmap1がbitmap2のどのエッジにヒットしているかを返す.
         * bitmap1の透明のピクセルを考慮する.
         * 
         * @param b1    bitmap1
         * @param b1Loc bitmap1の座標
         * @param b2    bitmap2
         * @param b2Loc bitmap2の座標
         * @return  ヒット状態を表す文字列
         *          NO_HIT 両bitmapがヒットしていない
         *          　　　W 両bitmapが完全に重なっている
         *               T bitmap2の上辺でヒット
         *               B bitmap2の下辺でヒット
         *               L bitmap2の左辺でヒット
         *               R bitmap2の右辺でヒット
         *              TL bitmap2の左上角でヒット
         *              BL bitmap2の左下角でヒット
         *              TR bitmap2の右上角でヒット
         *              BR bitmap2の右下角でヒット
         *               
         */
        public static function hitTest2(b1 : BitmapData, b1Loc : Point, b2 : BitmapData, b2Loc : Point) :String
        {
            if (!b1.transparent) throw new Error('b1 is not transparent bitmap');
            
            var rect1 : Rectangle = b1.rect, rect2 : Rectangle = b2.rect;
            rect1.x = b1Loc.x;
            rect1.y = b1Loc.y;
            rect2.x = b2Loc.x;
            rect2.y = b2Loc.y;
            
            const diff : Rectangle = rect1.intersection(rect2),
                     w : int = diff.width, 
                     h : int = diff.height;
            
            
            if (w == 0 && h == 0) return 'NO_HIT';
            var isTrans:Boolean = true;
            for (var py : int = diff.y; py < diff.y + h; py++)
                for (var px : int = diff.x; px < diff.x + w; px++)
                    isTrans = isTrans && b1.getPixel32(px, py) == 0;
            if (isTrans) return 'NO_HIT';
            
            var temp : BitmapData = new BitmapData(diff.width, diff.height, true, 0);
            temp.copyPixels(b1, new Rectangle(diff.x, diff.y, w, h), new Point());
            var o:Object = trimTransparent2(temp);
            temp = o.bitmap;
            var r : Rectangle = o.rect;
            b1Loc.x = diff.x + r.x;
            b1Loc.y = diff.y + r.y;
            
            return hitTest(temp, b1Loc, b2, b2Loc);
            
//            var result : String = '';
//            if (w >= h)
//            {
//                if (b1Loc.y < b2Loc.y) result += 'T';
//                else result += 'B';
//            }
//            if (w <= h)
//            {
//                if (b1Loc.x > b2Loc.x) result += 'R';
//                else result += 'L';
//            }
//            return result;
        }

        


    }
}
import com.imajuk.geom.Segment;
import com.imajuk.utils .BitmapDataUtil;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.utils.clearInterval;
import flash.utils.setInterval;

class Painter extends EventDispatcher
{
    private var buffer : Array;
    private var b : BitmapData;
    private var emptyColor : uint;

    public function Painter(target : BitmapData, startPoint : Point, emptyColor : uint)
    {
        b = target;
        buffer = [startPoint];
        this.emptyColor = emptyColor;
        const i : int = setInterval(function() : void
        {
            for (var j : int = 0; j < 100; j++)
            {
                if (scanlineFill())
                {
                    clearInterval(i);
                    dispatchEvent(new Event(Event.COMPLETE));
                    break;
                }
            }
        }, 1);
    }
    
    private function scanlineFill() : Boolean
    {
        if (buffer.length == 0) return true;
        
        const p     : Point = buffer.shift(),
              color : uint = 0xFF0000ff;
        
        //左右方向に塗りつぶしながら走査し、塗り潰しの境界を探す
        var l:int = BitmapDataUtil.scanLine(b, emptyColor, p, -1, true, color);
        var r:int = BitmapDataUtil.scanLine(b, emptyColor, p,  1, true, color);
        
        //描画した水平線Hの上側の線分を左から走査して、"塗り潰すべきピクセルが横に連続している部分"を全て探し、それぞれの最も右側の座標をバッファに格納する
        BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(l, p.y - 1), new Point(r, p.y - 1)), emptyColor)
        .forEach(function(r:int, ...param) : void
        {
            buffer.push(new Point(r, p.y - 1));
        });
        // 描画した水平線Hの下側の線分を左から走査して、"塗り潰すべきピクセルが横に連続している部分"を全て探し、それぞれの最も右側の座標をバッファに格納する
        BitmapDataUtil.findAllBorders(b, Segment.createFromPoint(new Point(l, p.y + 1), new Point(r, p.y + 1)), emptyColor)
        .forEach(function(r : int, ...param) : void
        {
            buffer.push(new Point(r, p.y + 1));
        });
        
        return false;
    }    
}
