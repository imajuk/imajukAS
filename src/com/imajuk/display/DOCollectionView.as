package com.imajuk.display
{
	import com.imajuk.behaviors.BehaviorDetail;
	import com.imajuk.behaviors.IButtonBehavior;
	import com.imajuk.behaviors.TransparentBehavior;
	import com.imajuk.constructions.AssetWrapper;
	import com.imajuk.interfaces.IDisplayObjectWrapper;
	import com.imajuk.utils.DisplayObjectUtil;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;
	import org.libspark.betweenas3.tweens.ITweenGroup;



    /**
     * @author imajuk
     */
    public class DOCollectionView extends Sprite implements IDisplayObjectWrapper
    {
        protected static const NULL_TWEEN : ITween = BetweenAS3.to({a:0}, {a:0}, .1);
        
        //--------------------------------------------------------------------------
        //
        //  Static API
        //
        //--------------------------------------------------------------------------
        public static function create(
                                    imageContainer : Sprite, 
                                    onBehavior     : IButtonBehavior = null, 
                                    offBehavior    : IButtonBehavior = null
                               ) : DOCollectionView
        {
            return AssetWrapper.wrapAsDisplayObject(
                        DOCollectionView, imageContainer, onBehavior, offBehavior
                   ) as DOCollectionView;
        }
       /**
        * trueは遷移時に前回のビューに対してだけoffBehaviorを実行する
        * falseは 遷移時にカレント以外のビューすべてに対してoffBehaviorを実行する
        */
        public var optimized : Boolean = true;
        public var lockTransition : Boolean;
        
        //--------------------------------------------------------------------------
        //
        //  private variables
        //
        //--------------------------------------------------------------------------
        protected var twn_behavior : ITweenGroup;
        protected var imgToOnBehavior  : Dictionary = new Dictionary(true);
        protected var imgToOffBehavior : Dictionary = new Dictionary(true);
        protected var imgs : Array;
        protected var order : Array;
        public var isLock : Boolean;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        public function DOCollectionView(
                            imgContainer : Sprite, 
                            onBehavior   : IButtonBehavior = null, 
                            offBehavior  : IButtonBehavior = null,
                            autoResetVisible : Boolean = true
                        )
        {
            _imgContainer = imgContainer;
            addChild(_imgContainer);
            
            if (autoResetVisible)
                DisplayObjectUtil.invisibleAllChildren(_imgContainer, false);
            
            _behavior_on  = onBehavior  || new TransparentBehavior(1,0);
            _behavior_off = offBehavior || new TransparentBehavior(1,0); 
            
            build();
        }
        //--------------------------------------------------------------------------
        //
        //  API (IDisplayObjectWrapper implementation)
        //
        //--------------------------------------------------------------------------
        protected var _imgContainer : Sprite;
        public function get asset() : DisplayObject
        {
            return _imgContainer;
        }
        
        //--------------------------------------------------------------------------
        //
        //  API (Property)
        //
        //--------------------------------------------------------------------------
        public function get numImages() : int
        {
            return _imgContainer.numChildren;
        }
        protected var _currentIndex : int = -1;
        public function get currentIndex() : int
        {
            return _currentIndex;
        }
        protected var _current : DisplayObject;
        public function get currentImage() : DisplayObject
        {
            return _current;
        }
        protected var _previous : DisplayObject;
        public function get previousImage() : DisplayObject
        {
            return _previous;
        }
        protected var _total : uint;
        public function get total() : uint
        {
            return _total;
        }
        protected var _behavior_on : IButtonBehavior;
        public function set behavior_on(behavior_on : IButtonBehavior) : void
        {
            _behavior_on = behavior_on;
            
            imgToOnBehavior = new Dictionary(true);
            imgToOffBehavior = new Dictionary(true);
            
            build();
        }
        protected var _behavior_off : IButtonBehavior;
        public function set behavior_off(behavior_off : IButtonBehavior) : void
        {
            _behavior_off = behavior_off;

            imgToOnBehavior = new Dictionary(true);
            imgToOffBehavior = new Dictionary(true);
            
            build();
        }        
        public var detail : BehaviorDetail = new BehaviorDetail();
        //--------------------------------------------------------------------------
        //
        //  API (Method)
        //
        //--------------------------------------------------------------------------
        public function build() : void
        {
            //revert order
            if (order)
                order.forEach(function(img:DisplayObject, ...param) : void
                {
                    _imgContainer.addChild(img);
                });
            
            imgs = 
                DisplayObjectUtil.getAllChildren(_imgContainer)
                    .map(
                        function(img : DisplayObject, ...param) : DisplayObject
                        {
                            imgToOnBehavior[img]  = _behavior_on;
                            imgToOffBehavior[img] = _behavior_off;
                            return img;
                        }
                    );
                    
            _total = imgs.length;
            
            if (!order) order = imgs;
        }

        /**
         * @param index -1はすべての要素を非表示
         */
        public function show(index : int) : ITween
        {
            if (lockTransition && isLock) return NULL_TWEEN;
            if (index >= _total) return NULL_TWEEN;
            if (index == _currentIndex) return NULL_TWEEN;
            
            _current = setIndex(index);
            
            return behave();
        }
        
        public function next() : ITween
        {
            if (lockTransition && isLock) return NULL_TWEEN;
            
            _current = incrementIndex();
            return behave();
        }

        public function previous() : ITween
        {
            if (lockTransition && isLock) return NULL_TWEEN;
            
            _current = decrementIndex();
            return behave();
        }

        public function set eachAlpha(value:Number) : void
        {
            forEach(function(img:DisplayObject, ...param) : void
            {
                img.alpha = value;
            });
        }
        //--------------------------------------------------------------------------
        //
        //  Private Methods
        //
        //--------------------------------------------------------------------------
        protected function behave() : ITween
        {
            if (lockTransition && isLock) return NULL_TWEEN;
            isLock = true;

            //------------------------
            // Setup View Depth
            //------------------------
            if (_previous) _imgContainer.addChild(_previous);
            if (_current) _imgContainer.addChild(_current);
                
            //------------------------
            // Initialize Behavior
            //------------------------
            var b_on  : IButtonBehavior  = imgToOnBehavior[_current],
                b_off : IButtonBehavior,
                a     : Array = [];
            
            if (b_on)
            {
                b_on.initialize(_current, 0);
                a.push(b_on.rollOverBehavior(detail));
            }
            
            if (optimized)
            {
                b_off = imgToOffBehavior[_previous];
                if (b_off)
                {
                    b_off.initialize(_previous, 1);
                    a.push(b_off.rollOutBehavior(detail));
                }
                
            }
            else
            {
                DisplayObjectUtil.getAllChildren(_imgContainer).forEach(function(d:DisplayObject, ...param) : void
                {
                    var b_off : IButtonBehavior = imgToOffBehavior[d];
                    if (b_off && d != _current)
                    {
                        b_off.initialize(d, 1);
                        a.push(b_off.rollOutBehavior(detail));
                    }
                });
            }
            
            //------------------------
            // Return Behavior
            //------------------------
            if (twn_behavior) twn_behavior.stop();
            twn_behavior = BetweenAS3.parallelTweens(a);
            twn_behavior.onComplete = function() : void
            {
                isLock = false;
            };
            return twn_behavior;
        }
        

        protected function setIndex(index : int) : DisplayObject
        {
            _currentIndex = index;
            return updateCurrentImage();
        }

        protected function incrementIndex() : DisplayObject
        {
            _currentIndex++;
            validateIndex();
                
            return updateCurrentImage();
        }

        protected function decrementIndex() : DisplayObject
        {
            _currentIndex--;
            validateIndex();
                
            return updateCurrentImage();
        }

        protected function validateIndex() : void
        {
            if (_currentIndex >= _total)
                _currentIndex = 0;
            else if (_currentIndex < 0)
                _currentIndex = _total - 1;
        }
        
        protected function updateCurrentImage() : DisplayObject
        {
            _previous = _current;
            return imgs[_currentIndex];
        }

        protected function forEach(f : Function) : void
        {
            order.forEach(f);
//            DisplayObjectUtil.getAllChildren(_imgContainer).forEach(f);
        }
    }
}
