package com.imajuk.service 
{
    import flash.net.URLRequest;    
    
    import com.imajuk.service.AssetLocation;    

    /**
     * 外部アセットの場所を定義したXMLをパースするができるAssetLocationです.
     * AssetLocationの機能に加え、XMLをパースする際の基本的なルールを定義できます.
     * PreloadAssetThreadは、このインスタンスを要求します.
     * 
     * //データロケーションが定義されたXMLをロード
     * //データロケーションが定義されたXMLのURI
     * var dataLocationURI:String = Umi10TopModel.DATA_LOCATION;
     * //Phase1（データロケーションが定義されたXMLのロード）のAssetBinder
     * var assetBinder:AssetBinder = new AssetBinder()
     *                                      .add(dataLocationURI);
     * //Phase2（アセットのロード）のAssetBinder
     * var assetBinder2:AssetLocationParser =
     *  new AssetLocationParser(function():XML{return XML(assetBinder.getContentByURI(dataLocationURI));})
     *      .locationAttributeIs("src")
     *      .urlPrefixIs("path")
     *          .assemble("front").thenSet(model.setImagesFront)
     *          .assemble("back").thenSet(model.setImagesBack)
     *          .assemble("over").thenSet(model.setImagesOver)
     *          .assemble("charactors").thenSet(model.setCharactorDomain)
     *          .assemble("navigation").thenSet(view.createNavgation)
     *          .assemble("frontPanel").thenSet(view.createFrontPanel);
     *
     * var t:Thread = new PreloadAssetThread(assetBinder, assetBinder2, view.progress);
     * t.start();
     * 
     * @author yamaharu
     */
    public class AssetLocationParser extends AssetLocation
    {
        private var rules:Array = [];
        private var locAttribute:String;
        private var prefix:String;
        private var xmlRegistry:Function;

        /**
         * コンストラクタ
         * @param   xmlRegistry パースするXMLを返すクロージャ<br>
         *          パースするXMLがコンストラクタ呼び出し時には存在しない可能性を考慮し、
         *          クロージャによる遅延評価を利用します.
         */
        public function AssetLocationParser(xmlRegistry:Function)         
        {
            this.xmlRegistry = xmlRegistry;
        }
        
        //ルールに定義されたアトリビュートを持つノードから、URLRequestsを生成する
        public function parse():AssetLocation
        {
            var xml:XML = XML(xmlRegistry());
            
            for each (var attribute : XML in xml.descendants()["@" + locAttribute])             {
                var node:XML = attribute.parent();
                var parent:XML = node.parent();
                var prefixStr:String = parent["@" + prefix];
                var src:String = String(node["@" + locAttribute]);
                rules.forEach(function(r:Rule, ...param):void
                {
                    if(r.id == node.name())
                        add(new URLRequest(prefixStr + src), r.callBack);                });            }
            return this;
        }

        /**
         * 指定された名前を持つXMLノードから、データロケーションが定義された文字列を集めます。
         * また、データロケーションからデータがロードされた際に、データをsetterに渡すことができます.
         * これは、このメソッドの後に.thenSet(setter)と続ける事で指定できます.
         */
        public function assemble(id:String):Rule
        {
            var rule:Rule = new Rule(id, this);
            rules.push(rule); 
            return rule;
        }

        public function locationAttributeIs(value:String):AssetLocationParser
        {
            locAttribute = value;
            return this;
        }

        public function prefixAttributeIs(value:String):AssetLocationParser
        {
            prefix = value;
            return this;
        }
        
    }
}

import com.imajuk.service.AssetLocationParser;

class Rule
{
    private var _id:String;
    private var _owner:AssetLocationParser;
    private var _callBack:Function;

    public function Rule(id:String, owner:AssetLocationParser)
    {
        _id = id;
        _owner = owner;
    }

    public function thenSet(closure:Function):AssetLocationParser
    {
        _callBack = closure;
        return _owner;
    }

    internal function get id():String
    {
        return _id;
    }

    internal function get callBack():Function
    {
        return _callBack;
    }
}