using System;

namespace Final_Project
{
    public class LibrarySoftware
    {
        private int _ID;
        private char _Software_Type;
        private string _Official_Name;
        private DateTime _Release_Date;
        private string _SupportedOS;
        private string _SKU;
        private decimal _Cost;

        public LibrarySoftware() : base()
        {
        }

        public int ID
        {
            get { return _ID; }
            set { _ID = value; }
        }

        public char Software_Type
        {
            get { return _Software_Type; }
            set { _Software_Type = value; }
        }

        public string Official_Name
        {
            get { return _Official_Name; }
            set { _Official_Name = value; }
        }

        public DateTime Release_Date
        {
            get { return _Release_Date; }
            set { _Release_Date = value; }
        }

        public string SupportedOS
        {
            get { return _SupportedOS; }
            set { _SupportedOS = value; }
        }

        public string SKU
        {
            get { return _SKU; }
            set { _SKU = value; }
        }

        public decimal Cost
        {
            get { return _Cost; }
            set { _Cost = value; }
        }

        public override string ToString()
        {
            return _Software_Type + " - " + _Official_Name;
        }
    }
}