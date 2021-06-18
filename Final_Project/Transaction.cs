using System;

namespace Final_Project
{
    public class Transaction
    {
        private int _Software_ID;
        private string _SKU;
        private DateTime _Date;
        private decimal _Cost;

        public Transaction() : base()
        {
        }

        public int Software_ID
        {
            get { return _Software_ID; }
            set { _Software_ID = value; }
        }

        public string SKU
        {
            get { return _SKU; }
            set { _SKU = value; }
        }

        public DateTime Date
        {
            get { return _Date; }
            set { _Date = value; }
        }

        public decimal Cost
        {
            get { return Math.Round(_Cost, 2); }
            set { _Cost = value; }
        }

        private string CleanDate(DateTime date)
        {
            string[] dt = date.ToString().Split(" ");
            return dt[0];
        }

        public override string ToString()
        {
            return "SOFTWARE_ID: " + Software_ID + " --> SKU: " + _SKU + " --> DATE: " + CleanDate(_Date) + " --> VALOR: " + Math.Round(_Cost, 2);
        }
    }
}