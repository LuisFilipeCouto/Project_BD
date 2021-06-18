using System;
using System.Text.RegularExpressions;

namespace Final_Project
{
    class Publisher
    {
        private string _NIPC;
        private string _Name;
        private string _Street;
        private string _Postcode;
        private string _City;
        private string _Country;
        private DateTime _Foundation_Date;
        private bool _IsAllowed;

        public Publisher() : base()
        {
        }

        public string NIPC
        {
            get { return _NIPC; }
            set
            {
                if (!Regex.IsMatch(value, @"^\d+$") || value.Length != 9)
                {
                    throw new Exception("NIPC must be a 9 digit input");
                }
                _NIPC = value;
            }
        }

        public string Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        public string Street
        {
            get { return _Street; }
            set { _Street = value; }
        }

        public string Postcode
        {
            get { return _Postcode; }
            set { _Postcode = value; }
        }

        public string City
        {
            get { return _City; }
            set { _City = value; }
        }

        public string Country
        {
            get { return _Country; }
            set { _Country = value; }
        }

        public DateTime Foundation_Date
        {
            get { return _Foundation_Date; }
            set { _Foundation_Date = value; }
        }

        public bool IsAllowed
        {
            get { return _IsAllowed; }
            set { _IsAllowed = value; }
        }

        public override string ToString()
        {
            return _NIPC + " - " + _Name;
        }
    }
}
