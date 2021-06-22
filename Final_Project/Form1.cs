using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Final_Project
{
    public partial class Form1 : Form
    {
        private readonly string connectionString = "data source = tcp:mednat.ieeta.pt\\SQLSERVER,8101; initial catalog = p1g6; uid = p1g6; password = AveiroPortugal123-";

        public Form1()
        {
            InitializeComponent();
        }

        private void ShowStatistics(object sender, EventArgs e)
        {
            Form2 F2 = new Form2(connectionString);
            F2.Show();
        }

        private void ManageStore(object sender, EventArgs e)
        {
            Form3 F3 = new Form3(connectionString);
            F3.Show();
        }

        private void ManageUsers(object sender, EventArgs e)
        {
            Form4 F4 = new Form4(connectionString);
            F4.Show();
        }

        private void ManagePublisherandSoftware(object sender, EventArgs e)
        {
            Form5 F5 = new Form5(connectionString);
            F5.Show();
        }

        private void ManageItems(object sender, EventArgs e)
        {
            Form9 F9 = new Form9(connectionString);
            F9.Show();
        }
    }
}

