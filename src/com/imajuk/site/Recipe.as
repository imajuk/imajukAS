package com.imajuk.site
{
    /**
     * アセットレシピおよびステートレシピのルートノード名を定義します.
     * <p>
     * アセットレシピおよびステートレシピのノード名にはそれぞれ
     * <code>Recipe.ASSET</code>、<code>Recipe.STATE</code>を指定します.<br/>
     * 以下はアセットレシピの例です.<br/>
     * <code>appdomain</code>属性はアセットをどのアプリケーションドメインにロードするか指定できます.
     * 有効な値は"current"または無指定です.無指定の場合は新しいアプリケーションドメインにロードされます.
     * </p>
     * <listing version="3.0">
     * &lt;{Recipe.ASSET}&gt;<br/>
     *     &nbsp;&nbsp;&nbsp;&nbsp;&lt;{Reference.NOTHING}        src=&quot;assets/header.swf&quot;  /&gt;<br/>
     *     &nbsp;&nbsp;&nbsp;&nbsp;&lt;{new Reference(Top)}       src=&quot;assets/top.swf&quot;  appdomain=&quot;current&quot;   /&gt;<br/>
     * &lt;/{Recipe.ASSET}&gt;
     * </listing>
     * 
     * @see Application#start()
     * 
     * @author imajuk
     */
    public class Recipe
    {
        private static const NAME_SPACE : String = "xmlns:sophieAS3='http://www.imajuk.com/ns/sophieAS3'";
        
        public static const STATE : String = "sophieAS3:StateRecipe "+ NAME_SPACE;
        public static const ASSET : String = "sophieAS3:AssetRecipe "+ NAME_SPACE;
    }
}
