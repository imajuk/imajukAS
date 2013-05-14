package com.imajuk.ui.combobox 
{
/**
     * @author shin.yamaharu
     */
    public class TabDemiliterParser 
    {
        public static function parse(text:String):XML
        {
        	var data:XML = <root></root>;
                    
            var lines:Array = text.split("\n");
            lines.forEach(function(line:String, ...param):void
            {
                var node:Array = line.split("\t");
                
                var provinceName:String = node[0];
                var cityName:String = node[1];
                var storeName:String = node[2];
                
                var storeNode:String    = "<store name='"    + storeName    + "' />";
                var cityNode:String     = "<city name='"     + cityName     + "'>" + storeNode + "</city>";
                var provinceNode:String = "<province name='" + provinceName + "'>" + cityNode + "</province>";
                
                var targetProvince:XMLList = data.province.(@name == provinceName);
                if (targetProvince.length() == 0)
                {
                    data.appendChild(new XML(provinceNode));
                }
                else
                {
                    var targetCity:XMLList = targetProvince.city.(@name == cityName);
                    if (targetCity.length() == 0)
                    {
                        targetProvince.appendChild(new XML(cityNode));
                    }        
                    else
                    {
                        var targetStore:XMLList = targetCity.store.(@name == storeName);
                        if (targetStore.length() == 0)
                        {
                            targetCity.appendChild(new XML(storeNode));
                        }       
                        else
                        {
                            throw new Error("データの重複"); 
                        }
                    
                    }
                }
            });
            
            return data;
        }
    }
}
