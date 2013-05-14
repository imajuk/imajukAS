package com.imajuk.data
{
    /**
     * 双方向リンクリスト
     * @author imajuk
     */
    public class LinkList
    {
        private var _last : LinkListNode;
        private var _first : LinkListNode;
        private var _length : uint;

        public function get first() : LinkListNode
        {
            return _first;
        }

        public function get last() : LinkListNode
        {
            return _last;
        }

        public function get length() : uint
        {
            return _length;
        }

        public function push(data : *) : LinkListNode
        {
            return addNext(_last, data);
        }
        
        public function unshift(data : *) : LinkListNode
        {
        	return addPrevious(_first, data);
        }

        public function shift() : LinkListNode
        {
            return remove(_first);
        }

        public function pop() : LinkListNode
        {
            return remove(_last);
        }

        public static function fromArray(array : Array) : LinkList
        {
            var list : LinkList = new LinkList();
            var l : int = array.length;
            for (var i : int = 0; i < l; i++)
            {
                list.push(array[i]);
            }
            return list;
        }

        public function addNext(target : LinkListNode, data : *) : LinkListNode
        {
            var node : LinkListNode = new LinkListNode(data);
            if (_length++ == 0)
            {
                _first = _last = node;
                return node;
            }
            
            if (target == _last)
                _last = node;
            else
                target.next.prev = node;
            node.next = target.next;
            node.prev = target;
            target.next = node;

            return node;
        }

        public function addPrevious(target : LinkListNode, data : *) : LinkListNode
        {
            var node : LinkListNode = new LinkListNode(data);
            if (_length++ == 0)
            {
            	_first = _last = node;
            	return node;
            }
            
            if (target == _first)
                _first = node;
            else
                target.prev.next = node;
            node.next = target;
            node.prev = target.prev;
            target.prev = node;
            
            return node;
        }

        public function remove(target : LinkListNode) : LinkListNode
        {
        	if (target == null)
        	   return null;
        	
            if (_length == 0)
                return target;

            if (_length == 1)
            {
                _first = _last = null;
            }
            else
            {
                if (target == _first)
                    _first = target.next;
                else
                    target.prev.next = target.next;

                if (target == _last)
                    _last = target.prev;
                else
                    target.next.prev = target.prev;
            }
            _length--;
            return target;
        }

        public function dump() : void
        {
        	var node:LinkListNode = _first;
        	while(node)
        	{
        		trace(node.data);
        		node = node.next;
        	}
        }

        public function clone() : LinkList
        {
        	var c:LinkList = new LinkList();
        	var n:LinkListNode = _first;
        	while(n)
        	{
        		c.push(n.data);
        		n = n.next;
        	}
            return c;
        }

        public function concat(list : LinkList) : LinkList
        {
        	var c:LinkList = clone();
        	var node:LinkListNode = list._first;
            while(node)
            {
            	c.push(node.data);
                node = node.next;
            }
            return c;
        }

        public function toArray() : Array
        {
        	var a:Array = [];
        	var node:LinkListNode = _first;
            while(node)
            {
                a.push(node.data);
                node = node.next;
            }
            return a;
        }

        public function insert(node : LinkListNode, data : *) : void
        {
        	var n:LinkListNode = new LinkListNode(data);
        	n.prev = node;
        	n.next = node.next;
        	node.next = n;
        	
        	_length ++;
        }

        public function map(f : Function) : LinkList
        {
            var l:LinkList = new LinkList(),
                n:LinkListNode = first;
            while(n)
            {
                l.push(f(n.data));
                n = n.next;
            }
            return l;
        }

        public function filter(f : Function) : LinkList
        {
            var l : LinkList = new LinkList(),
            n : LinkListNode = first;
            while (n)
            {
                var o:* = n.data;
                if (f(o)) l.push(o);
                n = n.next;
            }
            return l;
        }
    }
}
