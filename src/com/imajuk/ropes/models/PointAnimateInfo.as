package com.imajuk.ropes.models
{
    /**
     * IRopeShapeにポイントの位置を問い合わせるためのオブジェクト
     * @author imajuk
     */
    public class PointAnimateInfo
    {
        public var rate : Number = 0;
        public var time : Number = 0;
        public var mix  : Number = 1;
        
        public function toString() : String {
            return "PointAnimateInfo[" + 
                        ' rate: ' + (rate) +
                        ' time: ' + (time) +
                        ' mix: ' + (mix)   + 
                    " ]";
        }
    }
}
