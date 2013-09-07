package com.imajuk.utils
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    /**
     * @author imajuk
     */
    public class IntersectionInfo
    {
        private var _intersectionBitmap : BitmapData;
        public function get intersectionBitmap() : BitmapData
        {
            return _intersectionBitmap;
        }
        
        private var _alignByTopEdge : Boolean;
        public function get alignByTopEdge() : Boolean
        {
            return _alignByTopEdge;
        }
    
        private var _alignByBottomEdge : Boolean;
        public function get alignByBottomEdge() : Boolean
        {
            return _alignByBottomEdge;
        }
    
        private var _alignByLeftEdge : Boolean;
        public function get alignByLeftEdge() : Boolean
        {
            return _alignByLeftEdge;
        }
    
        private var _alignByRightEdge : Boolean;
        public function get alignByRightEdge() : Boolean
        {
            return _alignByRightEdge;
        }
        
        private var _isContain : Boolean;
        public function get isContain() : Boolean
        {
            return _isContain;
        }
        
        private var _diff : Rectangle;
        public function get rect() : Rectangle
        {
            return _diff;
        }
        
        private var _result : String = '';
        public function get result() : String
        {
            return _result;
        }
    
        public function get isIntersect() : Boolean
        {
            return _result != 'NO_HIT' && _result != 'W';
        }
        
        public function IntersectionInfo(b1 : BitmapData, b1Loc : Point, b2 : BitmapData, b2Loc : Point)
        {
            const rect1 : Rectangle = b1.rect, rect2 : Rectangle = b2.rect;
            rect1.x = b1Loc.x;
            rect1.y = b1Loc.y;
            rect2.x = b2Loc.x;
            rect2.y = b2Loc.y;
            _isContain = rect2.containsRect(rect1);
            
            //両bitmapが完全に重なっている
            if (rect1.equals(rect2))
            {
                _result = 'W';
            }
            else
            {
                const diff : Rectangle = rect1.intersection(rect2),
                         w : int = diff.width,
                         h : int = diff.height;
                         
                //両bitmapがヒットしていない
                if (w == 0 && h == 0)
                {
                    _result = 'NO_HIT';
                }
                else
                {
                    _diff = diff;
                    if (_isContain)
                    {
                        _intersectionBitmap = b1.clone();
                        if (isIncludeOpaquePixel())
                        {
                            _alignByTopEdge    = diff.y == rect2.y;
                            _alignByBottomEdge = diff.y + (diff.height - 1) == rect2.y + (rect2.height - 1);
                            _alignByLeftEdge   = diff.x == rect2.x;
                            _alignByRightEdge  = diff.x + (diff.width - 1) == rect2.x + (rect2.width - 1);
        
                            if (w == h)
                            {
                                if (_alignByTopEdge)      _result += 'T';
                                if (_alignByBottomEdge)   _result += 'B';
                                if (_alignByLeftEdge)     _result += 'L';
                                if (_alignByRightEdge)    _result += 'R';
                            }
                            else if (w > h)
                            {
                                if (_alignByTopEdge)           _result += 'T';
                                else if (_alignByBottomEdge)   _result += 'B';
                                else if (_alignByLeftEdge)     _result += 'L';
                                else if (_alignByRightEdge)    _result += 'R';
                            }
                            else
                            {
                                if (_alignByLeftEdge)          _result += 'L';
                                else if (_alignByRightEdge)    _result += 'R';
                                else if (_alignByTopEdge)      _result += 'T';
                                else if (_alignByBottomEdge)   _result += 'B';
                            }
                        }
                        else
                        {
                            _result = 'NO_HIT';
                        }
                        
                    }
                    else
                    {
                        _intersectionBitmap = new BitmapData(diff.width, diff.height, true, 0);
                        _intersectionBitmap.copyPixels(b1, diff, new Point());
                        
                        if (isIncludeOpaquePixel())
                        {
                            if (w >= h)
                            {
                                if (diff.y <= b2Loc.y) _result += 'T';
                                else _result += 'B';
                            }
                            if (w <= h)
                            {
                                if (diff.x <= b2Loc.x) _result += 'L';
                                else _result += 'R';
                            }
                        }
                        else
                        {
                            _result = 'NO_HIT';
                        }
                    }
                }
            }
        }

        private function isIncludeOpaquePixel() : Boolean
        {
            //ヒットしてる場合は交差しているビットマップに不透明ピクセルが含まれているかどうか調べる
            var colorRect : Rectangle = 
                BitmapDataUtil.getColorBoundsRect(_intersectionBitmap, 0xFF000000, 0x00000000, false);
            //含まれていなければヒットしていない
            if (colorRect.width == 0 && colorRect.height==0)
                return false;
            
            return true;
        }
    }
}
