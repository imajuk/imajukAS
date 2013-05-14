package com.imajuk.data
{
    import com.imajuk.logs.Logger;

    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.*;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;

    import flash.display.Sprite;

    use namespace test;
    use namespace before;
    use namespace after;

    internal class LinkListTest extends Sprite
    {
        before function setup() : void
        {
        }

        test function empty() : void
        {
            Logger.release("empty");

            var list : LinkList = new LinkList();

            // 最初は空
            testEmpty(list);
        }

        private function testEmpty(list : LinkList) : void
        {
            assertEquals(null, list.first);
            assertEquals(null, list.last);
            assertEquals(0, list.length);
        }

        test function push() : void
        {
            Logger.release("push");

            var list : LinkList = new LinkList();

            var node : LinkListNode;
            node = list.push("A");
            assertEquals("A", node.data);
            assertSame(node, list.first);
            assertSame(node, list.last);
            assertEquals(1, list.length);
            testEdge(list);

            list.push("B");
            assertEquals("A", list.first.data);
            assertEquals("B", list.last.data);
            assertEquals("AB", dump(list));
            assertEquals("BA", dump2(list));
            assertEquals(2, list.length);
            testEdge(list);
        }

        private function testEdge(list : LinkList) : void
        {
            assertEquals(null, list.first.prev);
            assertEquals(null, list.last.next);
        }

        test function unShift() : void
        {
            Logger.release("unShift");

            var list : LinkList = new LinkList();

            var node : LinkListNode;
            node = list.unshift("A");
            assertEquals("A", node.data);
            assertSame(node, list.first);
            assertSame(node, list.last);
            testEdge(list);
            assertEquals(1, list.length);

            node = list.unshift("B");
            assertEquals("B", node.data);
            assertSame(node, list.first);
            assertEquals("BA", dump(list));
            assertEquals("AB", dump2(list));
            testEdge(list);
            assertEquals(2, list.length);
        }

        test function addNext() : void
        {
            Logger.release("addNext");

            var list : LinkList = new LinkList();

            var nodeA : LinkListNode = list.push("A");
            var nodeB : LinkListNode = list.push("B");

            var node : LinkListNode;

            // AXBC
            node = list.addNext(nodeA, "X");
            assertEquals("X", node.data);
            node = list.addNext(nodeB, "Y");
            assertEquals("Y", node.data);
            assertEquals("A", list.first.data);
            assertEquals("Y", list.last.data);
            assertEquals(4, list.length);
            assertEquals("AXBY", dump(list));
            assertEquals("YBXA", dump2(list));
        }

        test function addPrevious() : void
        {
            Logger.release("addPrevious");

            var list : LinkList = new LinkList();

            var nodeA : LinkListNode = list.push("A");
            var nodeB : LinkListNode = list.push("B");

            var node : LinkListNode;

            node = list.addPrevious(nodeB, "X");
            assertEquals("X", node.data);
            node = list.addPrevious(nodeA, "Y");
            assertEquals("Y", node.data);
            assertEquals("Y", list.first.data);
            assertEquals("B", list.last.data);
            assertEquals(4, list.length);
            assertEquals("YAXB", dump(list));
            assertEquals("BXAY", dump2(list));
        }

        test function remove() : void
        {
            Logger.release("remove");

            var list : LinkList = new LinkList();

            var nodeA : LinkListNode = list.push("A");
            var nodeB : LinkListNode = list.push("B");
            var nodeC : LinkListNode = list.push("C");

            var node : LinkListNode;

            // ABC
            node = list.remove(nodeB);
            assertEquals("B", node.data);
            assertSame(nodeA, list.last.prev);
            assertEquals(2, list.length);
            testEdge(list);
            
            node = list.remove(nodeC);
            assertEquals("C", node.data);
            assertEquals(1, list.length);
            testEdge(list);

            node = list.remove(nodeA);
            assertEquals("A", node.data);
            testEmpty(list);
        }

        private function dump(list : LinkList) : String
        {
            var node : LinkListNode;
            var s : String = "";
            node = list.first;
            while (node)
            {
                s += node.data;
                node = node.next;
            }
            return s;
        }
        
        private function dump2(list : LinkList) : String
        {
            var node : LinkListNode;
            var s : String = "";
            node = list.last;
            while (node)
            {
                s += node.data;
                node = node.prev;
            }
            return s;
        }

        test function pop() : void
        {
            Logger.release("pop");

            var list : LinkList = new LinkList();

            list.push("A");
            list.push("B");

            var node : LinkListNode;
            node = list.pop();
            assertEquals("B", node.data);
            assertSame(list.first, list.last);
            assertEquals("A", list.first.data);
            assertEquals(null, list.first.next);
            testEdge(list);
            assertEquals(null, list.last.prev);
            assertEquals(1, list.length);
            node = list.pop();
            assertEquals("A", node.data);
            assertEquals(null, list.first);
            assertEquals(null, list.last);
            assertEquals(0, list.length);
        }

        test function shift() : void
        {
            Logger.release("shift");

            var list : LinkList = new LinkList();

            list.push("A");
            list.push("B");
            list.shift();
            assertEquals("B", list.first.data);
            assertEquals("B", list.last.data);
            assertEquals(1, list.length);
            list.shift();
            assertEquals(null, list.first);
            assertEquals(null, list.last);
            assertEquals(0, list.length);
        }

        test function iterate() : void
        {
            Logger.release("iterate");

            var list : LinkList = new LinkList();
            list.push("A");
            list.push("B");
            list.push("C");

            var s : String;
            var node : LinkListNode;

            s = "";
            node = list.first;
            while (node)
            {
                s += node.data;
                node = node.next;
            }

            assertEquals("ABC", s);

            s = "";
            node = list.last;
            while (node)
            {
                s += node.data;
                node = node.prev;
            }

            assertEquals("CBA", s);
        }

        test function createFromArray() : void
        {
            var list : LinkList = LinkList.fromArray(["A", "B", "C"]);

            var s : String;
            var node : LinkListNode;

            s = "";
            node = list.first;
            while (node)
            {
                s += node.data;
                node = node.next;
            }

            assertEquals("ABC", s);
        }

        after function teardown() : void
        {
        }
    }
}