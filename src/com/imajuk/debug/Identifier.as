package com.imajuk.debug
{
    import flash.utils.Dictionary;

    /**
     * 任意のオブジェクトと識別子を紐づけるユーティリティ.
     * オブジェクトの同一性をチェックしたいがそのオブジェクトが識別子を持たない場合が多々ある.
     * このクラスはオブジェクトと識別子を紐づける.
     * @author imajuk
     */
    public class Identifier
    {
        private static var objects : Dictionary = new Dictionary(true);
        private static var id : int = 1;

        public static function register(o : *) : int
        {
            if (objects[o]) throw new Error("register " + o + " was failed. it's already registered");
            return objects[o] = id++;
        }

        public static function getID(o : *) : int
        {
            return objects[o];
        }
    }
}
