package com.imajuk.utils{	import org.libspark.as3unit.after;
	import org.libspark.as3unit.assert.*;
	import org.libspark.as3unit.before;
	import org.libspark.as3unit.test;	use namespace test;	use namespace before;	use namespace after;		public class ObjectUtilTest	{		before function setupSample () : void		{		}
		
        test function clone():void        {            var src:Object = {id:1};            var copy:Object = ObjectUtil.clone(src);            //値がコピーされているかチェック            assertEquals(true , src["id"] == copy["id"]);            //違う参照になっているかチェック            src["id"] = 2;            assertEquals(false, src["id"] == copy["id"]);                        //参照もcloneされているかチェック            var nest:Object = {obj:{id:1}};            var copyNest:Object = ObjectUtil.clone(nest);            assertEquals(nest["obj"].id, copyNest["obj"].id);            assertNotSame(nest["obj"], copyNest["obj"]);                                    //参照の参照もcloneされているかチェック            var nestNestObject:Object = {id:1};            var nestNestObject2:Object = {obj:nestNestObject};            var nestNestObject3:Object = {obj2:nestNestObject2};            var copyNestNestObject:Object = ObjectUtil.clone(nestNestObject3);            assertEquals(nestNestObject3["obj2"].obj.id, copyNestNestObject["obj2"].obj.id);            assertNotSame(nestNestObject3["obj2"].obj, copyNestNestObject["obj2"].obj);         }		
		test function target():void		{			var o : Object = {str:"ID", ary:[0,["a","b","c"],{aryObj1:true, aryObj2:false}], obj:{hoge:true, foo:["f","o","o"], fuga:new Date()}};			//        	ObjectUtil.dump(o);
			assertEquals(o, o);							} 
		
		
		
		after function teardownSample () : void		{		}	}}