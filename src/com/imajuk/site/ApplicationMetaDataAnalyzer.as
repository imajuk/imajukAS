package com.imajuk.site
{
    import flash.utils.describeType;
    /**
     * @author shin.yamaharu
     */
    internal class ApplicationMetaDataAnalyzer
    {
        private var target : *;

        public function ApplicationMetaDataAnalyzer(target : *)
        {
            this.target = target;
        }
    	
        internal function getMetaDataInfo(type : String) : Object
        {
            switch(type)
            {
                case MetaData.INJECT:
                    return getMetaDataInfo_INJECT();
                    break;
                    
                case MetaData.INITIALIED:
                    return getMetaDataInfo_INITIALIZED();
                    break;

                case MetaData.POST_PROCESS:
                    return getMetaDataInfo_POST_PROCESS();
                    break;
            }
            
            return null;
        }

        private function getMetaDataInfo_INJECT() : Array
        {
        	var a:Array = [];
        	
            for each (var metadata : XML in injections)
            {
                var injectableProperty : XML = metadata.parent();
                var propName : String = injectableProperty.@name;
                var type : String = injectableProperty.@type;
                var priority:int = int(metadata.arg.@value);

                //name属性のあるmetaタグは無視する
                if (metadata.child("arg").length() > 0)
                {
                    if (metadata.arg.(@key == "name").length() > 0)
                        continue;
                }  
                
                a.push({propName:propName, type:type, priority:priority});
            }
            
            a.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
            
            return a; 
        }
        
        /**
         * @private
         * for injection
         */
        private var _injections : XMLList;
        private function get injections() : XMLList
        {
            return _injections || (_injections = describeType(target)..metadata.(@name == MetaData.INJECT));
        }

        /**
         * [initialized]としてマークされたメソッドの情報を返す
         */
        private function getMetaDataInfo_INITIALIZED() : Object
        {
        	//=================================
            // 複数の[initialized]タグは許可しない
            //=================================
            if (initialized.length() > 1)
            {
                throw new Error("複数の[initialized]がマークされています.");
            }
            else if (initialized.length() == 1)
            {
                var marked : XML = initialized[0].parent();
                var methodName:String = marked.@name;
                if (marked.name() == "method")
                {
                    var method:Function = target[methodName] as Function;
                    if (method != null)
                    {
                        return {methodName:methodName, method:method};
                    }
                }
            } 
            return null;
        }
        
         private function getMetaDataInfo_POST_PROCESS() : Object
        {
            //=================================
            // 複数の[postProcess]タグは許可しない
            //=================================
            if (postProcess.length() > 1)
            {
                throw new Error("複数の[initialized]がマークされています.");
            }
            else if (postProcess.length() == 1)
            {
                var marked : XML = postProcess[0].parent();
                var methodName:String = marked.@name;
                if (marked.name() == "method")
                {
                    var method:Function = target[methodName] as Function;
                    if (method != null)
                    {
                        return {methodName:methodName, method:method};
                    }
                }
            } 
            return null;
        }
        
        /**
         * @private
         * for progress view
         */
        private var _initialized : XMLList;
        private function get initialized() : XMLList
        {
            return _initialized || (_initialized = describeType(target)..metadata.(@name == MetaData.INITIALIED));
        }

        public function inject(name : String, viewRef : Reference) : void
        {
        	//=================================
            // nameで指定されたinjectionのタイプを置き換える
            //=================================
            for each (var metadata : XML in injections)
            {
                if (metadata.child("arg").length() > 0)
                {
                    var metadataArg : XML = metadata.arg.(@key == "name")[0];
                    if (metadataArg.@value == name)
                    {
                        metadata.parent().@type = viewRef.decode();
                        delete metadata.arg;
                        break;
                    }
                }
            }
        }
        
        private var _postProcess : XMLList;
        private function get postProcess() : XMLList
        {
            return _postProcess || (_postProcess = describeType(target)..metadata.(@name == MetaData.POST_PROCESS));
        }
    }
}
