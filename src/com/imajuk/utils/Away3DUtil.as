package com.imajuk.utils
{
    import away3d.core.base.Object3D;
    import away3d.containers.ObjectContainer3D;
    /**
     * @author imajuk
     */
    public class Away3DUtil
    {
        public static function dumpChildren(o3d : ObjectContainer3D, ...properties) : String
        {
            var traceChild : Function = 
                function(d:Object3D, depth:int, ...properties):void
                {
                    var tab : String = "",
                        props : String = "";
                        
                    for (var j : int = 0; j < depth; j++) tab += "\t";
                    
                    if (properties.length > 0)
                    {
                        properties.forEach(function(p:String, ...param):void
                        {
                            var r:* =
                                (function(o:*, a:Array, i:int=0) : *
                                {
                                    var v:* = a[i];
                                    if (o.hasOwnProperty(v))
                                    {
                                        if (i == a.length-1)
                                            return o[v];
                                        else
                                            return arguments.callee(o[v], a, ++i);
                                    }
                                    return null;
                                })(d, p.split("."));
                            props += p + ": " + r + " ";
                        });
                    }

                    try
                    {
                        trace(tab, d, d.name, props);
                        //TODO 深度表示
//                        trace(tab, globalDepth++, getGlobalDepth(d), d, d.name, props);
                    }
                    catch(e:Error)
                    {
                        trace(e);
                    }
                };
            
            var traceChildren:Function = 
                function (co:ObjectContainer3D, depth:int):String
                {
                    traceChild.apply(this, [co, depth].concat(properties));
                    
                    var s:String = "";
                    for (var i:int = 0;i < co.numChildren; i++) 
                    {
                        var child:Object3D = co.getChildAt(i);
                        if (child is ObjectContainer3D)
                            traceChildren(child as ObjectContainer3D, depth + 1);
                        else
                            traceChild.apply(this, [child, depth + 1].concat(properties));
                    }
                    
                    return s;
                };
                
            return traceChildren(o3d, 0);
        }
    }
}
