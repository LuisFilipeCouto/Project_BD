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
    public partial class Form8 : Form
    {
        private SqlConnection cn;
        private static string connectionString;
        private static int AppUser_ID;
        private int currentItem;

        public Form8(string connection, int ID)
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

        private void Form8_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();
            LoadItemsForSale();
            buttonRetirar.Enabled = false;

        }

        private void LoadItemsForSale()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getItemsForSaleByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Item itm = new Item();
                itm.UUID = reader["Item_UUID"].ToString();
                itm.Name = reader["Item_Name"].ToString();
                itm.Market_Value = (decimal)(reader["Market_Value"]);
                itm.Category = reader["Category"].ToString();
                itm.Rarity = (int)reader["Rarity"];
                itm.OriginGame = reader["Origin_Game"].ToString();
                listBoxItems.Items.Add(itm);
            }
            cn.Close();
        }

        private void ShowItemsForSale()
        {
            if (listBoxItems.Items.Count == 0 | currentItem < 0)
            {
                return;
            }

            Item itm = (Item)listBoxItems.Items[currentItem];

            textBoxInventarioUUID.Text = itm.UUID.ToString();
            textBoxInventarioNome.Text = itm.Name.ToString();
            textBoxInventarioCategoria.Text = itm.Category.ToString();
            textBoxInventarioRaridade.Text = itm.Rarity.ToString();
            textBoxInventarioOrigem.Text = itm.OriginGame.ToString();
            textBoxInventarioValor.Text = Math.Round((decimal)itm.Market_Value, 2).ToString();
        }

        private int RemoveItemFromMarket(string UUID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.removeItemFromMarket", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Item_UUID", SqlDbType.NVarChar).Value = UUID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao retirar item do Mercado", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void listBoxItems_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxItems.SelectedIndex >= 0)
            {
                ClearInventoryFields();
                currentItem = listBoxItems.SelectedIndex;
                ShowItemsForSale();
                buttonRetirar.Enabled = true;
            }

            if (listBoxItems.Items.Count == 0)
            {
                ClearInventoryFields();
                buttonRetirar.Enabled = false;
                currentItem = -1;
            }
        }

        private void buttonRetirar_Click(object sender, EventArgs e)
        {
            if (RemoveItemFromMarket(((Item)listBoxItems.SelectedItem).UUID) == 1)
            {
                MessageBox.Show("Item removido do Mercado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearInventoryFields();
                listBoxItems.Items.Clear();
                LoadItemsForSale();
                listBoxItems.SelectedIndex = -1;
                Form6.ResetInventory();
            }
            else
            {
                listBoxItems.SelectedIndex = currentItem;
            }
        }


        /// <summary>
        /// FUNÇOES AUXILIARES
        /// </summary>
        private void ClearInventoryFields()
        {
            textBoxInventarioUUID.Text = "";
            textBoxInventarioNome.Text = "";
            textBoxInventarioCategoria.Text = "";
            textBoxInventarioRaridade.Text = "";
            textBoxInventarioOrigem.Text = "";
            textBoxInventarioValor.Text = "";
        }        
    }
}
