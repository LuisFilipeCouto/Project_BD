using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Final_Project
{
    public partial class Form7 : Form
    {
        private SqlConnection cn;
        private static string connectionString;
        private static int AppUser_ID;

        public Form7(string connection, int ID)
        {
            InitializeComponent();
            connectionString = connection;
            AppUser_ID = ID;
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

        private void Form7_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();

            textBoxSaldoAtual.Text = Math.Round(Convert.ToDecimal(GetBalance()), 2).ToString();
            PopulateValuesBox();
            buttonAdicionar.Enabled = false;
        }

        private string GetBalance()
        {
            if (!VerifySGBDConnection())
            {
                return "";
            }

            SqlCommand cmd = new SqlCommand("SELECT Balance FROM proj.AppUser WHERE ID=@ID", cn);
            cmd.Parameters.Add("@ID", SqlDbType.NVarChar).Value = AppUser_ID;
            string UserBalance = cmd.ExecuteScalar().ToString();

            cn.Close();

            return UserBalance;
        }

        private int AddBalance(string value)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.AddBalance", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@Value", SqlDbType.Decimal).Value = Math.Round(Convert.ToDecimal(value), 2);

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao adicionar saldo à Carteira - OPERAÇÃO CANCELADA!\nInsira valor inteiro/decimal positivo, com casas decimais separadas por virgula", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void comboBoxValues_SelectedIndexChanged(object sender, EventArgs e)
        {
            buttonAdicionar.Enabled = true;
        }

        private void buttonCancelar_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void buttonAdicionar_Click(object sender, EventArgs e)
        {
            if (AddBalance(comboBoxValues.SelectedItem.ToString()) == 1)
            {
                MessageBox.Show("Saldo adicionado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                comboBoxValues.SelectedIndex = 0;
                Form6.ResetWallet();

                buttonAdicionar.Enabled = false;
                textBoxSaldoAtual.Text = Math.Round(Convert.ToDecimal(GetBalance()), 2).ToString();

            }
            else
            {
                buttonAdicionar.Enabled = false;
            }
        }


        /// <summary>
        /// FUNÇOES AUXILIARES
        /// </summary>
        private static List<decimal> ValueList()
        {
            List<decimal> values = new List<decimal>();
            values.Add(Convert.ToDecimal(5.00));
            values.Add(Convert.ToDecimal(10.00));
            values.Add(Convert.ToDecimal(25.00));
            values.Add(Convert.ToDecimal(50.00));
            values.Add(Convert.ToDecimal(100.00));
            values.Add(Convert.ToDecimal(250.00));
            values.Add(Convert.ToDecimal(500.00));
            return values;
        }

        private void PopulateValuesBox()
        {
            comboBoxValues.DataSource = ValueList();
        }
    }
}
