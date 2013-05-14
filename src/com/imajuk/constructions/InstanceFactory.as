package com.imajuk.constructions
{
    /**
     * @author imajuk
     */
    public class InstanceFactory
    {
    	public static function newInstance(klass:Class, param:Array):Object
        {
            switch (param.length) 
            {
                case 0:
                    return new klass();
                case 1:
                    return new klass(param[0]);
                case 2:
                    return new klass(param[0], param[1]);
                case 3:
                    return new klass(param[0], param[1], param[2]);
                case 4:
                    return new klass(param[0], param[1], param[2], param[3]);
                case 5:
                    return new klass(param[0], param[1], param[2], param[3], param[4]);
                case 6:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5]);
                case 7:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5], param[6]);
                case 8:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7]);
                case 9:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7], param[8]);
                case 10:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7], param[8], param[9]);
                case 11:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7], param[8], param[9], param[10]);
                case 12:
                    return new klass(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7], param[8], param[9], param[10], param[11]);
                
                default:                         
                    throw new Error("too much parameters!");
            }
            return null;
        }
    }
}
