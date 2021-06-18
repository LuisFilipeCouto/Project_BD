using System;

namespace Final_Project
{
    public class StoreSoftware
    {
        private int _ID;
        private char _Software_Type;
        private string _Official_Name;
        private decimal _Price;
        private DateTime _Release_Date;
        private string _Publisher;
        private string _Age_Rating;
        private string _Current_Version;
        private string _Game_Type;
        private string _SupportedOS;
        private string _Brief_Description;

        public StoreSoftware() : base()
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

        public decimal Price
        {
            get { return _Price; }
            set { _Price = Math.Round(value, 2); }
        }

        public DateTime Release_Date
        {
            get { return _Release_Date; }
            set { _Release_Date = value; }
        }

        public string Publisher
        {
            get { return _Publisher; }
            set { _Publisher = value; }
        }

        public string Age_Rating
        {
            get { return _Age_Rating; }
            set { _Age_Rating = value; }
        }

        public string Current_Version
        {
            get { return _Current_Version; }
            set { _Current_Version = value; }
        }

        public string Game_Type
        {
            get { return _Game_Type; }
            set { _Game_Type = value; }
        }

        public string SupportedOS
        {
            get { return _SupportedOS; }
            set { _SupportedOS = value; }
        }

        public string Brief_Description 
        {
            get { return _Brief_Description; }
            set { _Brief_Description = value; }
        }

        public override string ToString()
        {
            return _Official_Name + "    [" + Publisher + "]";
        }
    }
}
