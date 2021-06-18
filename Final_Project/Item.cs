using System;
using System.Collections.Generic;
using System.Text;

namespace Final_Project
{
    class Item
    {
        private string _Name;
        private string _UUID;
        private int _Rarity;
        private decimal _Market_Value;
        private string _Category;
        private string _OriginGame;
        private bool _CanBeSold;
        private char _ForSale;
        private int _OwnerID;
        private string _OwnerEmail;
        private string _OwnerFname;
        private string _OwnerLname;

        public Item() : base()
        {
        }

        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }

        public string UUID {
            get { return _UUID; }
            set { _UUID = value; }
        }

        public int Rarity {
            get { return _Rarity; }
            set { _Rarity = value; }
        }

        public decimal Market_Value
        {
            get { return _Market_Value; }
            set { _Market_Value = value; }
        }
        
        public string Category
        {
            get { return _Category; }
            set { _Category = value; }
        }
        
        public string OriginGame
        {
            get { return _OriginGame; }
            set { _OriginGame = value; }
        }

        public bool CanBeSold
        {
            get { return _CanBeSold; }
            set { _CanBeSold = value; }
        }

        public char ForSale
        {
            get { return _ForSale; }
            set { _ForSale = value; }
        }

        public int OwnerID
        {
            get { return _OwnerID; }
            set { _OwnerID = value; }
        }

        public string OwnerEmail
        {
            get { return _OwnerEmail; }
            set { _OwnerEmail = value; }
        }

        public string OwnerFname
        {
            get { return _OwnerFname; }
            set { _OwnerFname = value; }
        }

        public string OwnerLname
        {
            get { return _OwnerLname; }
            set { _OwnerLname = value; }
        }

        public override string ToString()
        {
            return _Name + " --> " + _UUID;
        }
    }
}
