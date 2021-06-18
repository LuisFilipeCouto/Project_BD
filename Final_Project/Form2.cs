using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Final_Project
{
    public partial class Form2 : Form
    {
        private SqlConnection cn;
        private static string connectionString;

        public Form2(string connection)
        {
            InitializeComponent();
            connectionString = connection;
        }

        private SqlConnection GetSGBDConnection()
        {
            return new SqlConnection(connectionString);
        }

        private bool VerifySGBDConnection()
        {
            if (cn == null)
                cn = GetSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();

            LoadGameSales();
            LoadToolSales();
            LoadPublisherSales();
            LoadAverageGamePrice();
            LoadAverageToolPrice();
            LoadMostSupportedOS();
            LoadSexRepresentation();
            LoadUsersByCountry();
            LoadAverageMoneySpent();
            LoadWishedSoftware();
            LoadTotalMoneySpent();
            LoadAverageFriends();
            LoadAverageUserAge();
        }

        private void LoadGameSales()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getGameSales()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView1.DataSource = displayTable;

            dataGridView1.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView1.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void LoadToolSales()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getToolSales()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView2.DataSource = displayTable;

            dataGridView2.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView2.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView2.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void LoadPublisherSales()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getPublisherSales()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView3.DataSource = displayTable;

            dataGridView3.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView3.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView3.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void LoadAverageGamePrice()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT proj.getAverageGamePrice()");
            cmd.Connection = cn;

            textBox1.Text = cmd.ExecuteScalar().ToString();
            textBox1.TextAlign = HorizontalAlignment.Center;
            cn.Close();
        }

        private void LoadAverageToolPrice()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT proj.getAverageToolPrice()");
            cmd.Connection = cn;

            textBox2.Text = cmd.ExecuteScalar().ToString();
            textBox2.TextAlign = HorizontalAlignment.Center;
            cn.Close();
        }

        private void LoadMostSupportedOS()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getMostSupportedOS()");
            cmd.Connection = cn;
            SqlDataReader reader = cmd.ExecuteReader();

            String OS = "";
            while (reader.Read())
            {
                OS += reader["OS_Name"].ToString();

                if (reader.Read()) // Se forem varios OS (varias linhas da tabela), juntar resultados na mesma linha, separados por virgulas
                {
                    OS += ", ";
                }
            }
            textBox3.Text = OS;
            textBox3.TextAlign = HorizontalAlignment.Center;
            cn.Close();
        }

        private void LoadSexRepresentation()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getSexRepresentation()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView4.DataSource = displayTable;

            dataGridView4.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView4.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView4.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void LoadUsersByCountry()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getUsersByCountry()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView5.DataSource = displayTable;

            dataGridView5.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView5.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView5.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;

        }

        private void LoadAverageMoneySpent()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getUserStoreStatistics()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView6.DataSource = displayTable;

            dataGridView6.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView6.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView6.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void LoadWishedSoftware()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            SqlDataAdapter sqldata = new SqlDataAdapter("SELECT * FROM proj.getWishedSoftware()", cn);
            DataTable displayTable = new DataTable();
            sqldata.Fill(displayTable);
            dataGridView7.DataSource = displayTable;

            dataGridView7.DefaultCellStyle.SelectionBackColor = Color.White;
            dataGridView7.DefaultCellStyle.SelectionForeColor = Color.Black;
            dataGridView7.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void LoadTotalMoneySpent()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT proj.getTotalMoneySpent()");
            cmd.Connection = cn;

            textBox4.Text = cmd.ExecuteScalar().ToString();
            textBox4.TextAlign = HorizontalAlignment.Center;
            cn.Close();
        }

        private void LoadAverageFriends()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT proj.getAverageNumberFriends()");
            cmd.Connection = cn;

            textBox5.Text = cmd.ExecuteScalar().ToString();
            textBox5.TextAlign = HorizontalAlignment.Center;
            cn.Close();
        }

        private void LoadAverageUserAge()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT proj.getAverageUserAge()");
            cmd.Connection = cn;

            textBox6.Text = cmd.ExecuteScalar().ToString();
            textBox6.TextAlign = HorizontalAlignment.Center;
            cn.Close();
        }
    }
}
