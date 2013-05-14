package com.imajuk.render2D.plugins.tile
{
    import com.imajuk.render2D.plugins.tile.AbstractNode;

    /**
     * @author imajuk
     */
    public class AbstractTileNode extends AbstractNode
    {
        protected var _cols : int;
        protected var _rows : int;

        public function AbstractTileNode(sx : Number, sy : Number, cols : int, rows : int)
        {
            super(sx, sy);
            
            _rows = rows;
            _cols = cols;
        }
        
        override public function toString() : String 
        {
            return "AbstractTileNode " + ["id:" + _id, " cols_rows:" + _cols + "_" + _rows];
        }
    }
}
