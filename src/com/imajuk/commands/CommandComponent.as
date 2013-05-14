package com.imajuk.commands 
{
    import flash.events.Event;    
    
    import com.imajuk.commands.ILoopable;        import com.imajuk.data.IComponent;	
    import com.imajuk.data.AbstractComponent;	
    /**
     * コマンドコンポーネントの抽象クラス.
     *  
     * <p>ここでいう「コンポーネント」とは<i>Composite Pattern</i> におけるComponentを指します.<br/>
     * コンポーネントに関しては<code>AbstractComponent</code>を参照して下さい.</p>
     * <p><code>CommandComponent</code>のリーフは<code>ICommand</code>オブジェクトを一つ内包したオブジェクトです.<br/>
     * このため、<code>CommandComponent</code>はツリー構造を持ったコマンドを表現することができます.</p>
     * <p><code>CommandComponent</code>はまた、コマンドコンポジションに関する共通の機能を提供します.</p>
     * <p>This is the abstract class of CommandComponent.</p>
     * <p>'Component' means component in 'Composite Pattern', - see also <code>AbstractComponent</code> about component -</p>
     * <p>A leaf in <code>CommandComponent</code> is a object that includes <code>ICommand</code>,<br/>
     * so <code>CommandComponent</code> means expresses tree structure having commands.</p>
     * <p>Also <code>CommandComponent</code> supports common functions about composition of command.</p>
     * 
     * @author	yamaharu
     * @see		AbstractComponent
     * @see		ICommand
     */
    public class CommandComponent extends AbstractComponent implements IAsynchronousCommand, IComponent, ILoopable
    {                
        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //  status of command
        //--------------------------------------------------------------------------
        
        /**
         * 内包しているコマンドのいずれかが実行中かどうかを返します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>returns whether command is executing or not.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function get isExecuting():Boolean
        {
            throw new Error("this is abstract class,so you must implement 'isExecuting' method.");
            return false;
        }

        /**
         * 内包しているコマンドが一時停止中かどうかを返します.
         * 
         * <p>returns whether included command is pausing or not.</p>
         */
        public function get isPausing():Boolean
        {
            throw new Error("this is abstract class,so you must implement 'isPausing' method.");
            return false;
        }

        /**
         * 内包しているすべてのコマンドがすべて終了しているかどうかを返します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>returns whether command was completed or not.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function get isCompleted():Boolean
        {
            throw new Error("this is abstract class,so you must implement 'isCompleted' method.");
            return null;
        }
        
        public function get isComplete():ICommand
        {
            return new EventCommand(this, Event.COMPLETE);
        }

        //--------------------------------------------------------------------------
        //  sequentionaly execution or not
        //--------------------------------------------------------------------------
        
        /**
         * @private
         */
        protected var _sequential:Boolean = false;

        /**
         * 内包するコマンドをシーケンシャル実行するかどうか.
         * 
         * <p><code>true</code>に設定するとシーケンシャル実行,<br/>
         * <code>false</code>に設定するとパラレル実行で、内包するコマンドを実行します.</p>
         * <p>内包するコンポーテントの子要素に対して<code>sequential</code>プロパティを設定したい場合は、<br/>
         * <code>sequentialChildren</code>プロパティを使用します.</p>
         * <p>Specifies whether included command is sequencionaly executing or not.</p>
         * <p>If <code>true</code>, specifies to execute sequentionaly. <br/>
         * If <code>false</code>, specifies to execute parallel. </p>
         * <p>If you want to specify this property of component's children, use <code>sequentialChildren</code>.</p>
         * 
         * @default false
         * @see #sequentialChildren
         */
        public function get sequential():Boolean
        {
            return _sequential;
        }

        public function set sequential(value:Boolean):void
        {
            _sequential = value;
        }

        /**
         * @private
         */
        protected var _sequentialChildren:Boolean = false;

        /**
         * 内包するすべてのコンポーネントをシーケンシャルに実行するかどうか.
         * 
         * <p>このプロパティは、内包するコンポーネントの<code>sequential</code>プロパティ、<br/>
         * および<code>sequentialChildren</code>プロパティを再帰的に設定します.</p>
         * <p>Specifies whether command of child component is sequentionaly executing or not.</p>
         * <p>This property recurrently specifies <code>sequential</code> and <code>sequentialChildren</code> of included component.</p>
         * 
         * @default	false
         */
        public function get sequentialChildren():Boolean
        {
            return _sequentialChildren;
        }

        public function set sequentialChildren(value:Boolean):void
        {
            if (_sequentialChildren == value)
				return;
				
            _sequentialChildren = value;
            sequential = value;
        }

        /**
         * @private
         */
        protected var _currentChild:CommandComponent;

        /**
         * シーケンシャル実行中の<code>CommandComponent</code>を返します
         */
        public function get currentChild():CommandComponent
        {
            if(!isExecuting)
                return null;
            else
                return _currentChild;
        }

        /**
         * @private
         */
        private var _isLooping:Boolean = false;

        /**
         * <code>CommandComponent</code>をループ実行するかどうか.
         * 
         * <p>コンポーネントが<code>CommandComposite</code>か<code>CommandLeaf</code>かによって
         * 振る舞いが変わることに注意して下さい.</p>
         */
        public function get loop():Boolean
        {
            return _isLooping;
        }

        public function set loop(value:Boolean):void
        {
            _isLooping = value;
            
            //この後のループ処理の実装は、サブクラスでなされなければならない.
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: cotrol component
        //
        //--------------------------------------------------------------------------
        
        /**
         * 内包しているコマンドを実行します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>execute included command in component.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function execute():ICommand
        {
            throw new Error("this is abstract class,so you must implement 'execute' method.");
        }

        /**
         * 内包しているコマンドを一時停止します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>pause included command in component.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function pause():Boolean
        {
            throw new Error("this is abstract class,so you must implement 'pause' method.");
        }

        /**
         * 内包しているコマンドを完全に停止します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>stop included command in component.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function stop():Boolean
        {
            throw new Error("this is abstract class,so you must implement 'stop' method.");
        }

		/**
         * 内包している一時停止しているコマンドを再開します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>resume included command in component.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function resume():Boolean
        {
            throw new Error("this is abstract class,so you must implement 'resume' method.");
        }

		/**
         * 内包しているコマンドを、登録された順序とは逆の順序で実行します.
         * 
         * <p>このメソッドは抽象メソッドです.<br/>サブクラスで実装します.</p>
         * <p>reverse included command in component.<br/>
         * this method is abstract method, and implemented in sub class.</p>
         */
        public function reverse():void
        {
            throw new Error("this is abstract class,so you must implement 'reverse' method.");
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: clone component
        //
        //--------------------------------------------------------------------------
        
        /**
         * コマンドコンポーネントを複製します.
         * 
         * <p>内包しているコンポーネントを含め複製します.</p>
         * <p>clone CommandComponent having same component.</p>
         */
        public function clone():ICommand
        {
        	//TODO 未実装
            return null;
        }
    }
}
