package com.imajuk.behaviors 
{
    import com.imajuk.motion.MatrixTweenHelper;

    import flash.geom.Matrix;

    /**
     * @author shin.yamaharu
     */
    public class MatrixBehavior extends AbstractButtonBehavior implements IButtonBehavior 
    {
        private var _onMatrix : Matrix;
        private var _offMatrix : Matrix;
        private var _matrixTarget : Object;

        /**
         * コンストラクタ
         * 
         * 通常、このタイプのボタンを生成したい場合はFlatColorButtonインスタンスを生成し、
         * このクラスを直接インスタンス化する必要はありません。
         * ただし、新しいviewを作るのではなく、既存のviewにビヘイビアを追加してボタンとして機能させたい場合は
         * クラスはこのクラスを直接インスタンス化し、ButtonThreadに渡します.
         * @param colorTarget  DisplayObjectまたは名前のString
         * 
         * @see FlatColorButton
         * @see ColorlizeBehavior
         */
        public function MatrixBehavior(
                            onMatrix : Matrix,
                            offMatrix : Matrix = null,
                            matrixTarget : Object = null
                        )                 
        {
            super();
            
            _onMatrix = onMatrix;
            _offMatrix = offMatrix;
            _matrixTarget = matrixTarget;
        }
        
        public function toString() : String 
        {
            return "MatrixBehavior[" + [_target?_target.name:"has no target still", _onMatrix, _offMatrix] + "]";
        }
        
        override public function initialize(behaviorSubject:*, amount:Number) : IButtonBehavior
        {
            _target = resolveTarget(behaviorSubject, _matrixTarget);
            _offMatrix = _offMatrix || _target.transform.matrix.clone();
            
            proxy = prepareProxy(amount);
            onObj = {amount:1};
            offObj = {amount:0};
            
            
            return this;
        }
        
        public static function create(
                            onMatrix : Matrix,
                            offMatrix : Matrix = null,
                            matrixTarget : Object = null
                        ) : IButtonBehavior
        {
            return new MatrixBehavior(onMatrix, offMatrix, matrixTarget);
        }
        
        override public function clone() : IButtonBehavior
        {
            return new MatrixBehavior(_onMatrix, _offMatrix, _matrixTarget);
        }

        private function prepareProxy(amount:Number) : MatrixTweenHelper 
        {
//            var amount : Number = (proxy) ? proxy.amount : 0;
            return new MatrixTweenHelper(_target, _onMatrix, _offMatrix, amount);
        }
    }
}
