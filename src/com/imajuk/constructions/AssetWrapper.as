package com.imajuk.constructions 
{
    import com.imajuk.interfaces.IDisplayObjectWrapper;
    import com.imajuk.logs.Logger;
    import com.imajuk.utils.DisplayObjectUtil;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;


    /**
     * @author shinyamaharu
     */
    public class AssetWrapper 
    {
        /**
    	 * DisplayObjectを任意のIDisplayObjectWrapperでラップして返します.
    	 * ラップされたDisplayObjectの座標と表示状態はリセットされ、IDisplayObjectWrapperが引き継ぎます.
    	 * このメソッドを利用することでアセットをIDisplayObjectWrapperに置き換えることができます.
         * 
         * @param klass	   このクラスでDisplayObjectをラップします.
         * 				   このクラスはIDisplayObjectWrapperでなければなりません.
         * @param param	   ラップするクラスに渡すパラメータです.
         *                 IDisplayObjectWrapperのコンストラクタは、通常第1引数にラップするDisplayObjectを受けます.
         */
        public static function wrapAsDisplayObject(
	        						klass : Class,
	        						...param
        						) : DisplayObject
        {
            var parent:DisplayObjectContainer = param[0].parent;
            
            //ラッパーになるインスタンスを生成
            try
            {
                var wrapper : DisplayObject = InstanceFactory.newInstance(klass, param) as DisplayObject;
            }
            catch(e:Error)
            {
            	trace(klass + "のインスタンス化に失敗しました.");
            	Logger.error(e, "AssetWrapper");
            }
            
            if (!(wrapper is DisplayObject))
            	throw new Error(klass + "でラップを試みましたが失敗しました." + klass + "はDisplayObjectではありません.");
            	
            if (!(wrapper is IDisplayObjectWrapper))
        		throw new Error(klass + "でラップを試みましたが失敗しました." + klass + "はIDisplayObjectWrapperではありません.");
        	
            //アセットを取得
            var asset : DisplayObject = IDisplayObjectWrapper(wrapper).asset;
            if (!asset)
        		throw new Error(klass + "でラップを試みましたが失敗しました.assetプロパティが正しく実装されていません.");
            var x:Number = asset.x;
            var y:Number = asset.y;
            
            asset.x = 0;
            asset.y = 0;
            
            //ラッパーとアセットの座標を入れ替える.
            wrapper.x = x;
            wrapper.y = y;
            
            //アセットがコンテナに配置されていた場合はラッパーと置き換える
            if (parent)
                parent.addChild(wrapper);
        	
            return wrapper;
        }
        
        /**
    	 * DisplayObjectを任意のオブジェクトでラップして返します.
    	 * このメソッドを利用することでアセットを任意のオブジェクトに置き換えることができます.
    	 * ラップオブジェクトがDisplayObjectの場合はwrapAsDisplayObject()を使用してください.
    	 * コンテナに含まれる複数のアセットを一括してラップしたい場合は、
    	 * wrapByName()またはwrapAsDisplayObjectByName()を使用してください.
    	 * 
    	 * @param klass					このクラスでDisplayObjectをラップします.
    	 * 								このクラスのインスタンス生成時、コンストラクタの第1匹数にアセットが渡されます.
    	 * @param param					ラップするクラスに渡すパラメータです.
    	 * 								第1匹数にラップ対象となるDisplayObjectが自動的に含まれます
    	 */
        public static function wrapObject(
	        						klass : Class,
	        						...param
        						) : *
        {
            return InstanceFactory.newInstance(klass, param);
        }

        /**
         * コンテナに含まれる複数のDisplayObjectを任意のIDisplayObjectWrapperでラップし、配列として返します.
         * ラップされたDisplayObjectの座標と表示状態はリセットされ、IDisplayObjectWrapperが引き継ぎます.
         * nameが指定された場合その文字列が名前に含まれる子供のみを対象とします.
         * 例えばコンテナに、名前に"btn"を含む3つのボタンアセットが配置されている場合、
         * nameに"btn"を渡す事で3つのボタンアセットをIDisplayObjectWrapperに置き換えることができます.
         * 
         * @param container				ラップしたいDisplayObjectが含まれるコンテナ
         * @param name					ラップ対象になるになるDisplayObjectをこの名前でフィルタします
         * @param setIndex				trueを指定すると、ラップインスタンスにユニークなインデックスをセットします.
         * 								このインデックスはklassのidプロパティに渡されます. 
         * 								インデックスをセットする場合は
         * @param klass					このクラスでDisplayObjectをラップします.
         * 								このクラスはIDisplayObjectWrapperでなければなりません.
         * 								このクラスのインスタンス生成時、コンストラクタの第1匹数にアセットが渡されます.
         * @param param					ラップするクラスに渡すパラメータです.
         * 								第1匹数にラップ対象となるDisplayObjectが自動的に含まれます
         */
        public static function wrapAsDisplayObjectByName(
                                    container:DisplayObjectContainer,
                                    name:String,
                                    setIndex:Boolean,
                                    klass:Class,
                                    ...param
                                    ):Array
        {
            param = [ true, container, name, setIndex, klass ].concat(param);
            return internal_wrapByName.apply(AssetWrapper, param);
        }

        /**
         * DisplayObjectを任意のObjectでラップし、配列として返します.
         * 第2匹数で指定した文字列が名前に含まれるコンテナの子供のみを対象とします.
         * 例えばコンテナに、名前に"btn"を含む3つのボタンアセットが配置されている場合、
         * このメソッドを利用することでボタンアセットを任意のオブジェクトに置き換えることができます.
         * ラップオブジェクトがDisplayObjectの場合はwrapAsDisplayObjectByName()を使用してください.
         * 
         * @param container				ラップしたいDisplayObjectが含まれるコンテナ
         * @param name					ラップ対象になるになるDisplayObjectをこの名前でフィルタします
         * @param setIndex				trueを指定すると、ラップインスタンスにユニークなインデックスをセットします.
         * 								このインデックスはklassのコンストラクタの第2匹数に渡されます.
         * @param klass					このクラスでDisplayObjectをラップします.
         * 								このクラスのインスタンス生成時、コンストラクタの第1匹数にアセットが渡されます.
         * @param param					ラップするクラスに渡すパラメータです.
         * 								第1匹数にラップ対象となるアセットが自動的に含まれます
         */
        public static function wrapByName(
        							container:DisplayObjectContainer,
                                    name:String,
                                    setIndex:Boolean,
                                    klass:Class,
                                    ...param
                               ) : Array
        {
            param = [ false, container, name, setIndex, klass ].concat(param);
            return internal_wrapByName.apply(AssetWrapper, param);
        }
        
        private static function internal_wrapByName(
        							asDisplayObject:Boolean,
        							container:DisplayObjectContainer,
                                    name:String,
                                    setIndex:Boolean,
                                    klass:Class,
                                    ...param
                                 ) : Array
        {
            var btns:Array = [];
            
            btns = DisplayObjectUtil
                    .getAllChildrenByName(container, name)
                    .map(
                        function(btnAsset:DisplayObject, idx:int, ...p):*
                        {
							var instance:*;
							if(asDisplayObject)
							{
								instance = 
//	                               container.addChild(
	                            			wrapAsDisplayObject.apply(
		                        				AssetWrapper,
		                        				[klass,btnAsset].concat(param)
		                        			);
//		                        		);
							}
							else
							{
								instance = 
								    wrapObject.apply(
		                        				AssetWrapper,
		                        				[klass,btnAsset].concat(param)
		                        			);
							}
							
							if (setIndex)
							     instance.id = idx;
							     
							return instance;
                        			
                        });
                        
            if (btns.length == 0)
                Logger.warning(container + "に" + name + "という文字列を名前に含むDisplayObjectが存在しませんでした.");
                
            return btns;
        }
    }
}
