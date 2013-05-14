package com.imajuk.ropes.shapes
{
    import com.imajuk.geom.Segment;
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.APoint;
    import com.imajuk.ropes.models.ControlPoint;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public class RopeShapeUtils
    {
        /**
         * ガイドムービークリップから頂点を抽出しコントロールポイントを生成します.
         * コントロールポイントはRopeShapeに保存される.
         * 
         * @param guide         ロープの形を定義したMovieClip.
         *                      このMovieClip内にあるトラッカーの各フレームの位置からガイドポイントが生成される
         * @param amount        コントロールポイントの生成数               
         * @param targetName    guide内にあるトラッカーの名前
         * @param shapeName     生成されるRopeShapeの名前
         * @param closedPath    閉じたシェイプ（true）か閉じてないシェイプ（false）か
         */
        public static function createShapeFromMC(guide : MovieClip, amount:int, trackerName : String, shapeName : String, closedPath : Boolean) : RopeShape
        {
            var a : Array = createControlPoints(guide, trackerName, amount);

            if (closedPath)
            {
                // 閉じる
                a.push(a[0]);
            }
            
            var s : RopeShape = new RopeShape(a, shapeName);
//            s.id = shapeName;
//            s.guidePoints = a;
//            s.segments = RopeShapeUtils.createSegments(a);
//            s.anchorPoints = RopeShapeUtils.createAnchorsFromControlPoint(a);
//            s.isInitialized = true;

            return s;
        }
        
        /**
         * 直線のRopeShapeを生成します.
         * RopeShapeには直線上に並んだControlPointが生成されます.
         * 生成数は引数で指定した分割数+1です.
         * @param segment       直線を定義するSegmentオブジェクト
         * @param split         分割数
         * @param shapeName     生成されるRopeShapeの名前
         */
        public static function createShapeFromSegment(segment : Segment, split : int, shapeName : String = "") : RopeShape
        {
            var  a : Array = [],
                cp : ControlPoint,
                nx : ControlPoint;

            for (var i : int = split, rate : Number = 1/split, time : Number = 1; i >= 0; i--, time -= rate)
            {
                var p : Point = segment.getValue(time);
                cp = new ControlPoint(i+1, p.x, p.y, i / split);
                cp.next = nx;
                nx = cp;
                a.unshift(cp);
            }
            
            return new RopeShape(a, shapeName);
        }

        private static function createControlPoints(guide : MovieClip, targetName : String, amount:int) : Array
        {
            if (!guide)
                throw new Error("ガイドが渡されませんでした" + guide);

            var d : DisplayObject = guide.getChildByName(targetName);
            if (!d)
                throw new Error("ガイドに" + targetName + "という名前のDisplayObjectは存在しません.");

            const       a : Array = [],
                    total : int = guide.totalFrames - 1;
            
            var rate : Number,
                 frm : int,
                  cp : ControlPoint,
                  nx : ControlPoint;
            
            amount --;
            
            for (var i : int = amount; i >= 0; i--)
            {
                rate = i / amount;
                frm = rate * total + 1;
                guide.gotoAndStop(frm);
                cp = new ControlPoint(i+1, d.x, d.y, rate);
                cp.next = nx;
                nx = cp;
                a.unshift(cp);
            }
            return a;
        }

        /**
         * ガイドポイントからセグメントを生成する
         * 生成数はガイドポイント数-1
         */
        public static function createSegments(controls : Array) : Vector.<IMotionGuide>
        {
            var prev : Point;
            var s : Segment;

            var segments : Vector.<IMotionGuide> = 
                Vector.<IMotionGuide>(controls.map(
                    function(current : ControlPoint, idx : int, ...param) : Segment
                    {
                        if (prev)
                        {
                            // 前の点と結ぶ直線
                            s = Segment.createFromPoint(prev, current, idx - 1);
                        }
                        prev = current;
                        return s;
                    }
                )
            );
            // 先頭のnullを消す
            segments.shift();
            return segments;
        }

        public static function createAnchorsFromControlPoint(cp : Array) : Array
        {
            var prev : Point;
            var center : APoint;
            // =================================
            // ガイドの中点からアンカーポイントを作る
            // =================================
            var a : Array = cp.map(function(current : ControlPoint, ...param) : Point
            {
                if (prev)
                {
                    // 前の点との中点
                    center = new APoint(prev, current);
                    current.ap = center;
                }
                prev = current;
                return center;
            });
            a.shift();
            // =================================
            // リンクを設定
            // =================================
            a.forEach(function(ap : APoint, idx : int, ...param) : void
            {
                ap.id = idx;
                ap.control = cp[idx + 1] || cp[0];

                var nx : APoint = a[idx + 1];
                var pv : APoint = a[idx - 1];

                ap.next = nx;
                ap.prev = pv;
            });

            return a;
        }

        
    }
}
