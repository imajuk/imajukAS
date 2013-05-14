package com.imajuk.data
{
    /**
     * @author imajuk
     */
    public class LinkListNode
    {
        public var data : *;
        public var next : LinkListNode;
        public var prev : LinkListNode;

        public function LinkListNode(data : *)
        {
            this.data = data;
        }

        public function toString() : String
        {
            return "LinkListNode[" + data + "]";
        }

    }
}
