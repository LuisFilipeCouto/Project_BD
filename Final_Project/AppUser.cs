using System;


namespace Final_Project
{
    class AppUser
    {
        private int _ID;
        private string _Email;
        private string _Fname;
        private string _Lname;
        private DateTime _Birthdate;
        private string _Sex;
        private string _Street;
        private string _Postcode;
        private string _City;
        private string _Country;
        private decimal _Balance;

        public AppUser() : base()
        {
        }

        public int ID
        {
            get { return _ID; }
            set { _ID = value; }
        }

        public string Email
        {
            get { return _Email; }
            set { _Email = value; }
        }

        public string Fname
        {
            get { return _Fname; }
            set { _Fname = value; }
        }

        public string Lname
        {
            get { return _Lname; }
            set { _Lname = value; }
        }

        public DateTime Birthdate
        {
            get { return _Birthdate; }
            set { _Birthdate = value; }
        }

        public string Sex
        {
            get { return _Sex; }
            set { _Sex = value; }
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

        public decimal Balance
        {
            get { return _Balance; }
            set { _Balance = Math.Round(value, 2); }
        }

        public override string ToString()
        {
            return _Fname + " " + _Lname + "    [" + _Email + "]";
        }
    }
}
