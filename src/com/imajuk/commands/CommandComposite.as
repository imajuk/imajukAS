package com.imajuk.commands 
{
    import com.imajuk.events.AsyncEvent;	

    import flash.events.Event;	

    import com.imajuk.data.IComponent;	
    import com.imajuk.data.IIterator;
    /**
     * コマンドコンポーネントのコンポジット構造におけるノード.
     * 
     * <p>'Composite Pattern'におけるCompositeを表現するクラスです.<br/>
     * 1つ以上の<code>CommandComposite</code>および<code>CommandLeaf</code>を内包することができます.</p>
     * <p>This is composition of CommandComponent, and express 'Composite' in 'Composite Pattern'.<br/>
     * <code>CommandComposite</code> has more than one <code>CommandComposite</code> and <code>CommandLeaf</code></p>
     * 
     * @author	yamaharu
     * @see		IComponent
     * @see		CommandComponent
     * @see		CommandComposite
     * @see		CommandLeaf
     */
    public class CommandComposite extends CommandComponent implements IAsynchronousCommand, IComponent
    {
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         * iterator for sequentionaly execution.
         */
        private var sequencialIterator:IIterator;
        /**
         * @private
         * counter for command completion. 
         */
        private var completeChildren:int = 0;

        //--------------------------------------------------------------------------
        //
        //  Overridden properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * 内包しているコマンドのいずれかが実行中かどうかを返します.
         * 
         * <p>returns whether any included command is executing or not.</p>
         */
        override public function get isExecuting():Boolean
        {
            return some("isExecuting");
        }
        
        /**
         * 内包しているコマンドのいずれかが一時停止中かどうかを返します.
         * 
         * <p>returns whether any included command is executing or not.</p>
         */
        override public function get isPausing():Boolean
        {
            return some("isPausing");
        }

        /**
         * 内包しているすべてのコマンドが、終了しているかどうかを返します.
         * 
         * <p>returns whether command was completed or not.</p>
         */
        override public function get isCompleted():Boolean
        {
            return every("isCompleted");
        }

        /**
         * 内包している子コンポーネントの<code>sequentialChildren</code>および<code>sequential</code>プロパティを再帰的に設定します.
         * 
         * <p>たとえば、コンポジット構造のルートオブジェクトでこのプロパティがtrueに設定されると<br/>
         * ルートが内包している全てのコマンドは逐一実行されるようになります。</p>
         * <p>set 'sequencial' and 'sequentialChildren' property of all child node.<br/>
         * this setter influences all children nodes reflective.
         * for example, if root object in composite structure is setted this property <code>true</code>,
         * all included commands is sequencionaly executing.</p>
         */
        override public function set sequentialChildren(value:Boolean):void
        {
            super.sequentialChildren = value;
            setPropertyOfChildren("sequential", value);
        }

        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * 直下の子コンポーネントが内包している<code>CommandComponent</code>を実行します.
         * 
         * <p><code>sequencial</code>プロパティが<code>true</code>の場合、
         * シーケンシャルに<code>CommandComponent</code>を実行します.<br/>
         * <code>sequencial</code>プロパティが<code>false</code>の場合、
         * パラレルに<code>CommandComponent</code>を実行します.</p>
         * <p>execute directly included <code>CommandComponent</code>.<br/>
         * If <code>sequencial</code> prpperty is <code>true</code>, execute as sequence, 
         * If <code>false</code>, parallel execute.</p>
         */
        override public function execute():ICommand
        {
        	if (sequential && !sequencialIterator)
                sequencialIterator = childIterator;
                
            if (sequential)
				sequentialExecute();
			else
				parallelExecute();
			
			return this;
        }
        /**
         * 直下の子コンポーネントが内包している<code>CommandComponent</code>の実行を一時停止します.
         * 
         * <p><code>sequencial</code>プロパティが<code>true</code>の場合、
         * 現在実行中の<code>CommandComponent</code>を一時停止します.<br/>
         * <code>sequencial</code>プロパティが<code>false</code>の場合、
         * 内包している全ての<code>CommandComponent</code>を実行します.</p>
         * <p>pause execution <code>CommandComponent</code>.<br/>
         * If <code>sequencial</code> prpperty is <code>true</code>, 
         * current executing <code>CommandComponent</code> is paused. 
         * If <code>false</code>, all <code>CommandComponent</code> are paused.</p>
         */
        override public function pause():Boolean
        {
            return callChildMethod("pause");
        }
        /**
         * 直下の子コンポーネントが内包している<code>CommandComponent</code>が一時停止していれば再開します.
         * 
         * <p>if It has paused <code>CommandComponent</code>, resume them.</p>
         */
        override public function resume():Boolean
        {
            return callChildMethod("resume");
        }
        /**
         * 直下の子コンポーネントが内包している<code>CommandComponent</code>を完全に停止します.
         * 
         * <p><code>CommandComponent</code>directly included stop execution.</p>
         */
        override public function stop():Boolean
        {
            return callChildMethod("stop");
        }
        /**
         * 直下の子コンポーネントとして<code>CommandComponent</code>を追加します.
         * 
         * <p>add <code>CommandComponent</code> as directly child.</p>
         * 
         * @param child	component
         */
        override public function add(child:IComponent):void
        {
            //CommandComponent以外は受け付けない
            var childComponent:CommandComponent = child as CommandComponent;
            if (childComponent == null)
				return;
				
            super.add(childComponent);
            //子ノードは親ノードのシーケンシャルプロパティを引き継ぐ
            childComponent.sequential = _sequentialChildren;
            childComponent.sequentialChildren = _sequentialChildren;
            childComponent.addEventListener(AsyncEvent.START, dispatchEvent);
            childComponent.addEventListener(Event.COMPLETE, onCompleteChild);
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: execution
        //
        //--------------------------------------------------------------------------
        
        /**
         * 子要素のメソッドの呼び出し
         */
        private function callChildMethod(methodName:String):Boolean
        {
            if (sequential)
                return callChildMethodSequentialy(methodName);
            else
                return callAllChildrenMethod(methodName);
        }

        /**
         * @private
         * シーケンシャル実行での、メソッドの呼び出し.
         */
        private function callChildMethodSequentialy(methodName:String):Boolean
        {
            if (!_currentChild)
                return false;

            return _currentChild[methodName]();
        }

        /**
         * @private
         * パラレル実行での、メソッドの呼び出し.
         */
        private function callAllChildrenMethod(methodName:String):Boolean
        {
            var i:IIterator = childIterator;
            var result:Boolean = true;
            while (i.hasNext())
            {
                result = CommandComponent(i.next())[methodName]() && result;
            }
            return result;
        }

        /**
         * @private
         * シーケンシャル実行
         * sequential execution
         */
        private function sequentialExecute():Boolean
        {
            if(!sequencialIterator)
                return false;
                
            if (sequencialIterator.hasNext())
                _currentChild = sequencialIterator.next();
                
            return callChildMethodSequentialy("execute");
        }

        /**
         * @private
         * パラレル実行
         * parallel execution
         */
        private function parallelExecute():Boolean
        {
            completeChildren = 0;
            return callAllChildrenMethod("execute");
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: completion
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        private function finish():void
        {
            sequencialIterator = null;
            if(loop)
                execute();
            else
                dispatchEvent(new Event(Event.COMPLETE));
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: utility
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         * return summed value of properties included all children.
         */
//        protected function sumChildren(getter:String):Number
//        {
//            var sum:Number = 0;
//            var i:IIterator = childIterator;
//            while(i.hasNext())
//            {
//                sum += CommandComponent(i.next())[getter];
//            }
//            return sum;
//        }

        //--------------------------------------------------------------------------
        //
        //  Event handlers: child node is complete
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        private function onCompleteChild(event:Event):void
        {
            _currentChild = null;
            if (sequential && !sequentialExecute())
                //シーケンシャル実行で、直下の全てのノードのコマンドが終わったらイベントを投げる
                finish();
            else if (!sequential && ++completeChildren >= numChildren)
                //パラレル実行で、直下の全てのノードのコマンドが終了したらイベントを投げる
                finish();
        }
    }
}