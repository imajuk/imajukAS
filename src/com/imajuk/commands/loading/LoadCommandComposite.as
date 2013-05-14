package com.imajuk.commands.loading {
    import com.imajuk.commands.CommandComponent;
    import com.imajuk.commands.CommandComposite;
    import com.imajuk.commands.IAsynchronousCommand;
    import com.imajuk.data.IComponent;
    import com.imajuk.data.IIterator;
    import com.imajuk.interfaces.IDisposable;
    import com.imajuk.interfaces.IProgess;

    import flash.events.IEventDispatcher;    /**     * <code>CommandLeaf</code>を内包するための<code>CommandComposite</code>です.     *      * <p><code>CommandComposite</code>を特化した具象<code>CommandComposite</code>で、<br/>     * <code>LoadCommand</code>を保持する<code>CommandLeaf</code>を内包するためのコンポジットを実装しています.</p>     *      * @author	yamaharu     * @see		CommandComposite     * @see 	LoadCommand     */    public class LoadCommandComposite extends CommandComposite implements IAsynchronousCommand, IComponent, ILoadComponent, IDisposable, IProgess
    {    	//--------------------------------------------------------------------------    	//    	//  implementation of IProgessComponent    	//    	//--------------------------------------------------------------------------        public function get value() : Number
        {
            var sum : Number = 0;
            children.forEach(function(c : IProgess, ...param) : void
            {
                sum += c.value;
            });
            return sum;
        };        public function set value(value : Number) : void
        {            //do anything
        };        public function get total() : Number        {        	var sum : Number = 0;            children.forEach(function(c : IProgess, ...param) : void            {                sum += c.total;            });            return sum;        }        public function set total(value : Number) : void
        {
        };                public function get percent() : Number        {            var sum : Number = 0,                r   : Number;            children.forEach(function(c : IProgess, ...param) : void            {                sum += c.percent;            });            r = sum / children.length;            return isNaN(r) ? 0 : r;
        };

        
        //--------------------------------------------------------------------------        //        //  implementation of ILoadComponent        //        //--------------------------------------------------------------------------        /**         * @copy ILoadable#waitInitialize         */        public function get waitInitialize():Boolean        {            var result:Boolean = true;            var i:IIterator = childIterator;            while(i.hasNext())            {                result = ILoadComponent(i.next()).waitInitialize && result;                if(!result)                    return false;            }            return true;        }        public function set waitInitialize(value:Boolean):void        {            var i:IIterator = childIterator;            while(i.hasNext())            {                ILoadComponent(i.next()).waitInitialize = value;            }        }                //--------------------------------------------------------------------------        //        //  implementation of IDisposable        //        //--------------------------------------------------------------------------        public function dispose() : void        {        	var i:IIterator = childIterator;            while(i.hasNext())            {                IDisposable(i.next()).dispose();            }        }        //--------------------------------------------------------------------------        //        //  Overridden methods        //        //--------------------------------------------------------------------------        /**         * 直下の子コンポーネントとして<code>CommandComponent</code>を追加します.         *          * <p>add <code>CommandComponent</code> as directly child.</p>         *          * @param child	<code>CommandComponent</code>         */        override public function add(child:IComponent):void        {            if (!(child is CommandComponent))            	return;            	            super.add(child);                        LoadCommandUtil.relayCommonEvent(IEventDispatcher(child), this);
        }
    }
}
