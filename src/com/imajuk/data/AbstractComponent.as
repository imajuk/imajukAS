﻿package com.imajuk.data {
    import flash.events.EventDispatcher;	
    import flash.utils.Dictionary;	    /**     * コンポーネントの抽象クラス.     *      * <p>ここでいう「コンポーネント」とは<i>Composite Pattern</i> におけるComponentを指し、以下のいずれかのオブジェクトを意味します.<br/>     * <ul>     * 	<li> リーフ</li>     * 	<li> リーフを内包するノード</li>     * 	<li> ノードを内包するノード</li>     * </ul>     * ノードは一つ以上のコンポーネントを子供に持ちます.<br/>     * リーフは子供を持たないコンポーネントのことです.<br/>     * つまり、コンポーネントは再帰的なツリー構造を表現することができます.<br/>     * このツリー構造はまた、「コンポジション」とも呼ばれます.</p>     * <p><code>AbstractComponent</code>はコンポジションに関する共通の機能を提供します.</p>     * <p>This is an Abstract class that expresses component.</p>     * <p>'Component' means component in 'Composite Pettern', <br/>     * and means anyone in fllowing objects :     * <ul>     * 	<li>a leaf</li>     * 	<li>a node including a leaf</li>     * 	<li>a node including a node</li>     * </ul>     * A node includes more than one component.<br/>     * A leaf means a component doesn't include component.</br>     * So, component can express a tree structure.<br/>     * This tree structure also called 'Composition'.</p>     * <p><code>AbstractComponent</code> provides common functions about composition in composite structure.</p>     *      * @author	yamaharu     * @see		IComponent     */    public class AbstractComponent extends EventDispatcher implements IComponent     {        public function AbstractComponent() {
        }                //--------------------------------------------------------------------------        //        //  Variables        //        //--------------------------------------------------------------------------                /**         * @private         * collection of child nodes that is IComponent.         * 子ノードを格納する配列         */        protected var children:Array = [];                /**         * @private         * save index with key that uses child node.         * 子ノードをキーにしてインデックスを格納するDictionary         */        protected var childIndex:Dictionary = new Dictionary(true);        //--------------------------------------------------------------------------        //        //  properties        //        //--------------------------------------------------------------------------                /**         * @copy IComponent#numChildren         */        public function get numChildren():int        {            return children.length;        }        /**         * @copy IComponent#iterator         * @see #childIterator         */        public function get iterator():IIterator        {            return new ComponentIterator(this);        }        /**         * @copy IComponent#childIterator         * @see #iterator         */        public function get childIterator():IIterator        {            return new ArrayIterator(children);        }        //--------------------------------------------------------------------------        //        //  Methods: about composition        //        //--------------------------------------------------------------------------                /**         * 子コンポーネントを追加します.         *          * <p>add a child to component.</p>         *          * @param child	追加する子コンポーネント         * 				<p>leaf or node in composite structure.</p>         */        public function add(child:IComponent):void        {            if (child == null)				return;				            childIndex[child] = children.length;            children.push(child);        }        /**         * 指定した子ノードを削除します.         *          * <p>Remove a child component from component.</p>         *          * @param child	削除するコンポーネント         * 				<p>leaf of node will be removed.</p>         */        public function remove(child:IComponent):void        {            children.splice(childIndex[child], 1);            childIndex[child] = null;        }        /**         * 指定したノードがコンポーネントに含まれているかどうかを返します.         *          * <p>Return whether the component is contained in this component.</p>         *          * @param child	コンポーネントに含まれているかどうか調べたいコンポーネント         * 				<p>examined component</p>         */        public function contains(child:IComponent):Boolean        {            return childIndex[child] != null;        }        //--------------------------------------------------------------------------        //        //  Methods: utility        //        //--------------------------------------------------------------------------                /**         * 内包する直下のコンポーネントの任意のプロパティが、全て<code>true</code>かどうかを返します。         *          * <p>returns whether the property of all directly included children is true or not</p>         * @param prppertyName  trueかどうかを調べたい任意のプロパティ名         */        protected function every(prppertyName:String):Boolean        {            var result:Boolean = true;            var i:IIterator = childIterator;            while (i.hasNext())            {                result = result && i.next()[prppertyName];                if (!result)                    return false;            }            return true;        }
        /**         * 内包する直下のコンポーネントの任意のプロパティのいずれかが<code>true</code>かどうかを返します。         *          * <p>returns whether the property of any directly included children is true or not</p>         * @param prppertyName  trueかどうかを調べたい任意のプロパティ名         */        protected function some(propertyName:String):Boolean        {            var result:Boolean = false;            var i:IIterator = childIterator;            while (i.hasNext())            {                result = result || i.next()[propertyName];                if (result)                    return true;            }            return false;        }
        /**         * 内包する直下のコンポーネントの任意のプロパティを設定します。         *          * <p>sete any propery of directly included children.</p>         * @param propertyName  設定したい任意のプロパティ名         * @param value         設定するプロパティの値         */        protected function setPropertyOfChildren(propertyName:String, value:Boolean):void        {            var i:IIterator = childIterator;            while (i.hasNext())            {                i.next()[propertyName] = value;            }        }
        /**         * 内包する全てのコンポーネントを出力します.         *          * <p>Refrectively prints all child component.</p>         *          * @param indent	階層を表現するのに使用する文字列. (まだ未実装です)         * 					<p>パラメータを渡した場合は、その文字が階層を表す文字として出力されます.</br>         * 					通常 '\t' などを使用します.</p>         * 					<p>indent character used representation of hierarchy.</p>         */        public function print(indent:String = null):void        {			//TODO	未実装        }    }
}
