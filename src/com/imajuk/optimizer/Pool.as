package com.imajuk.optimizer
{
    import com.imajuk.data.LinkList;

    import flash.utils.Dictionary;

    /**
     * @author imajuk
     */
    public class Pool
    {
        private var memo : Dictionary = new Dictionary(true);

        public function deposit(account : String, item : *) : *
        {
            memo[account] = memo[account] || new LinkList();
            return LinkList(memo[account]).push(item).data;
        }

        public function withdraw(account : String) : *
        {
            if (hasAccount(account))
                return LinkList(memo[account]).shift().data;
            else
                return null;
        }

        public function hasAccount(account : String) : Boolean
        {
            return memo[account] && LinkList(memo[account]).length > 0;
        }

        public function count(account : String) : int
        {
        	if (hasAccount(account))
        	   return LinkList(memo[account]).length;
        	else
        	   return 0;
        }

    }
}
