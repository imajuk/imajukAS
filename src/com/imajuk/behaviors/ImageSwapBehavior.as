package com.imajuk.behaviors 
{



    /**
     * オーバーレイしたDisplayObjectの表示状態を切り替えることによって
     * ロールオーバを表現するボタンビヘイビアです.
     * 
     * @author shin.yamaharu
     */
    public class ImageSwapBehavior extends AbstractButtonBehavior implements IButtonBehavior 
    {
        private var onTarget : *;
        private var offTarget : *;

        /**
         * コンストラクタ
		 * 
		 * 通常、このタイプのボタンを生成したい場合はImageSwapButtonインスタンスを生成し、
	     * このクラスを直接インスタンス化する必要はありません。
	     * ただし、新しいviewを作るのではなく、既存のviewにビヘイビアを追加してボタンとして機能させたい場合は
	     * クラスはこのクラスを直接インスタンス化し、ButtonThreadに渡します.
	     * 
	     * @see ImageSwapButton
	     * @see ButtonThread
		 */
        public function ImageSwapBehavior(
        					onTarget : *,         					offTarget : * = null
        				)         
        {
            super();
            
            this.onTarget = onTarget;
            this.offTarget = offTarget;
        }
        
        override public function clone() : IButtonBehavior
        {
            return new ImageSwapBehavior(onTarget, offTarget);
        }
        
        public static function create(
                            onTarget : *, 
                            offTarget : * = null
                            ): IButtonBehavior
        {
            return new ImageSwapBehavior(onTarget, offTarget);
        }
        
        override public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            _target = resolveTarget(behaviorSubject, onTarget);
                
            _target.alpha = 0;
            
            proxy = _target;
            proxy_invert = (offTarget) ? resolveTarget(behaviorSubject, offTarget) : null;
            onObj = {alpha:1};
            offObj = {alpha:0};
            
            return this;
        }
    }
}
