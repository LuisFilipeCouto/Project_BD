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
    public partial class Form9 : Form
    {
        private SqlConnection cn;
        private static string connectionString;
        private int currentItem;

        public Form9(string connection)
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

        private void Form9_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();
            LoadItems();
            buttonApagarItem.Enabled = false;
            buttonEditarItem.Enabled = false;
            buttonConfirmar.Visible = false;
            buttonCancelar.Visible = false;
            buttonConfirmarCriar.Visible = false;
            buttonCancelarCriar.Visible = false;
            buttonProcurarItem.Enabled = false;
            comboBoxCategoria.Visible = false;
            comboBoxJogoOriginario.Visible = false;
            comboBoxRaridade.Visible = false;
            labelGerado.Visible = false;
        }

        private void LoadItems()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_All_Items", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Item itm = new Item();
                itm.UUID = reader["UUID"].ToString();
                itm.Name = reader["Item_Name"].ToString();
                itm.Rarity = (int)reader["Rarity"];

                if (!DBNull.Value.Equals(reader["Market_Value"]))
                {
                    itm.Market_Value = Math.Round((decimal)reader["Market_Value"], 2);
                }
                else
                {
                    itm.Market_Value = 0;
                }

                itm.Category = reader["Category_Name"].ToString();
                itm.OriginGame = reader["Game_ID"].ToString();
                itm.CanBeSold = (bool)reader["CanBeSold"];
                itm.ForSale = Convert.ToChar(reader["ForSale"]);
                itm.OwnerID = (int)reader["ID"];
                itm.OwnerEmail = reader["Email"].ToString();
                itm.OwnerFname = reader["Fname"].ToString();
                itm.OwnerLname = reader["Lname"].ToString();
                listBoxItens.Items.Add(itm);
            }
            cn.Close();
        }

        private void LoadCategoriesToComboBox()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            comboBoxCategoria.Items.Clear();

            SqlCommand cmd = new SqlCommand("SELECT ID, Category_Name FROM proj.Item_Category", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                comboBoxCategoria.Items.Add(reader["ID"].ToString() + " - " + reader["Category_Name"].ToString());
            }
            cn.Close();
        }

        private void LoadGamesToComboBox()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            comboBoxJogoOriginario.Items.Clear();

            SqlCommand cmd = new SqlCommand("SELECT Software_ID, Official_Name FROM proj.Game INNER JOIN proj.Software ON proj.Game.Software_ID=proj.Software.ID", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                comboBoxJogoOriginario.Items.Add(reader["Software_ID"].ToString() + " - " + reader["Official_Name"].ToString());
            }
            cn.Close();
        }

        private void ShowItems()
        {
            if (listBoxItens.Items.Count == 0 | currentItem < 0)
            {
                return;
            }

            Item itm = (Item)listBoxItens.Items[currentItem];

            textBoxUUID.Text = itm.UUID;
            textBoxNomeItem.Text = itm.Name;
            textboxRaridade.Text = itm.Rarity.ToString();
            textBoxValorMercado.Text = itm.Market_Value.ToString();
            textBoxCategoria.Text = itm.Category;
            textBoxJogoOriginario.Text = itm.OriginGame;

            if (itm.CanBeSold)
            {
                textBoxPodeVender.Text = "SIM";
            }
            else
            {
                textBoxPodeVender.Text = "NÃO";
            }

            if (itm.ForSale == 'Y')
            {
                textBoxColocadoMercado.Text = "SIM";
            }
            else
            {
                textBoxColocadoMercado.Text = "NÃO";
            }

            textBoxID.Text = itm.OwnerID.ToString();
            textBoxEmail.Text = itm.OwnerEmail.ToString();
            textBoxPrimeiroNome.Text = itm.OwnerFname.ToString();
            textBoxUltimoNome.Text = itm.OwnerLname.ToString();
        }

        private int GetRandomUserID()
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.searchRandomUserID", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@User_ID", SqlDbType.Int);
            cmd.Parameters["@User_ID"].Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            int ID = (int)cmd.Parameters["@User_ID"].Value;

            return ID;
        }

        private int DeleteItem(string UUID, int ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.deleteItem", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@UUID", SqlDbType.NVarChar).Value = UUID;
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao remover item. Operação Cancelada!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int CreateItem(string Item_Name, int Rarity, string Market_Value, int Category, int Origin_Game, int AppUser_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Item_Name) || string.IsNullOrEmpty(Rarity.ToString()) || string.IsNullOrEmpty(Market_Value) || string.IsNullOrEmpty(Category.ToString()) || string.IsNullOrEmpty(AppUser_ID.ToString()))
            {
                MessageBox.Show("Por favor não deixe campos em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.createItem", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Item_Name", SqlDbType.Char).Value = Item_Name;
            cmd.Parameters.Add("@Rarity", SqlDbType.NVarChar).Value = Rarity;
            cmd.Parameters.Add("@Market_Value", SqlDbType.Decimal).Value = Market_Value;
            cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = Category;
            cmd.Parameters.Add("@Game_ID", SqlDbType.NVarChar).Value = Origin_Game;
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.NVarChar).Value = AppUser_ID;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao editar preço do Software - OPERAÇÃO CANCELADA!\nInsira valor inteiro/decimal positivo, com casas decimais separadas por virgula", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private int EditItem(string UUID, string Item_Name, int Rarity, string Market_Value, int Category, int Origin_Game, int AppUser_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Item_Name) || string.IsNullOrEmpty(Rarity.ToString()) || string.IsNullOrEmpty(Market_Value) || string.IsNullOrEmpty(Category.ToString()) || string.IsNullOrEmpty(Origin_Game.ToString()))
            {
                MessageBox.Show("Por favor não deixe campos em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.editItem", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@UUID", SqlDbType.NVarChar).Value = UUID;
            cmd.Parameters.Add("@Item_Name", SqlDbType.Char).Value = Item_Name;
            cmd.Parameters.Add("@Rarity", SqlDbType.NVarChar).Value = Rarity;
            cmd.Parameters.Add("@Market_Value", SqlDbType.Decimal).Value = Market_Value;
            cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = Category;
            cmd.Parameters.Add("@Game_ID", SqlDbType.NVarChar).Value = Origin_Game;
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.NVarChar).Value = AppUser_ID;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            catch (Exception ex)
            {
                //"Erro ao editar Item - OPERAÇÃO CANCELADA!"
                MessageBox.Show(ex.ToString(), "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private void FindItem(string src)
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBoxItens.Items.Clear();
            SqlCommand cmd = new SqlCommand("proj.searchItem", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@StringFind", SqlDbType.NVarChar).Value = src;

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Item itm = new Item();
                itm.UUID = reader["UUID"].ToString();
                itm.Name = reader["Item_Name"].ToString();
                itm.Rarity = (int)reader["Rarity"];

                if (!DBNull.Value.Equals(reader["Market_Value"]))
                {
                    itm.Market_Value = (decimal)reader["Market_Value"];
                }
                else
                {
                    itm.Market_Value = 0;
                }
                itm.Category = reader["Category_Name"].ToString();
                itm.OriginGame = reader["Game_ID"].ToString();
                itm.CanBeSold = (bool)reader["CanBeSold"];
                itm.ForSale = Convert.ToChar(reader["ForSale"]);
                itm.OwnerID = (int)reader["ID"];
                itm.OwnerEmail = reader["Email"].ToString();
                itm.OwnerFname = reader["Fname"].ToString();
                itm.OwnerLname = reader["Lname"].ToString();
                listBoxItens.Items.Add(itm);
            }
            cn.Close();
        }

        private void listBoxItens_SelectedIndexChanged(object sender, EventArgs e)
        {

            if (listBoxItens.SelectedIndex >= 0)
            {
                currentItem = listBoxItens.SelectedIndex;
                buttonApagarItem.Enabled = true;
                buttonEditarItem.Enabled = true;
                ClearItemFields();
                ShowItems();
            }
            if (listBoxItens.Items.Count == 0)
            {
                    ClearItemFields();
            }
        }

        private void buttonApagarItem_Click(object sender, EventArgs e)
        {
            if (DeleteItem(((Item)listBoxItens.SelectedItem).UUID, ((Item)listBoxItens.SelectedItem).OwnerID) == 1)
            {
                MessageBox.Show("Item apagado! Foi removido do inventario do dono e o respetivo montante foi adicionado á sua conta", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxItens.Items.Clear();
                ClearItemFields();
                LoadItems();
                buttonApagarItem.Enabled = false;
                buttonEditarItem.Enabled = false;
                listBoxItens.SelectedIndex = -1;
            }
            else
            {
                listBoxItens.SelectedIndex = currentItem;
            }
        }

        private void buttonCriarItem_Click(object sender, EventArgs e)
        {
            ClearItemFields();
            LoadCategoriesToComboBox();
            LoadGamesToComboBox();
            LoadRarityBox();
            HideSearch();
            HideUserInfo();
            StartCreate();
        }

        private void buttonCancelarCriar_Click(object sender, EventArgs e)
        {
            ClearItemFields();
            ShowSearch();
            ShowUserInfo();
            StopCreate();
            buttonEditarItem.Enabled = false;
            buttonApagarItem.Enabled = false;
            comboBoxRaridade.Items.Clear();
            listBoxItens.SelectedIndex = -1;
        }

        private void buttonConfirmarCriar_Click(object sender, EventArgs e)
        {
            string[] rar = comboBoxRaridade.Text.Split(" - ");
            string[] cat = comboBoxCategoria.Text.Split(" - ");
            string[] orgame = comboBoxJogoOriginario.Text.Split(" - ");

            if (CreateItem(textBoxNomeItem.Text, Convert.ToInt32(rar[0]), textBoxValorMercado.Text, Convert.ToInt32(cat[0]), Convert.ToInt32(orgame[0]), GetRandomUserID()) == 1)
            {
                MessageBox.Show("Item criada com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearItemFields();
                listBoxItens.Items.Clear();
                comboBoxRaridade.Items.Clear();
                LoadItems();
                ShowSearch();
                ShowUserInfo();
                StopCreate();
            }
        }

        private void textBoxProcurarItem_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(textBoxProcurarItem.Text))
            {
                buttonProcurarItem.Enabled = true;
            }
            else
            {
                buttonProcurarItem.Enabled = false;
            }
        }

        private void buttonProcurarItem_Click(object sender, EventArgs e)
        {
            FindItem(textBoxProcurarItem.Text);
        }

        private void buttonLimparItem_Click(object sender, EventArgs e)
        {
            ClearItemFields();
            textBoxProcurarItem.Clear();
            listBoxItens.Items.Clear();
            LoadItems();
            buttonProcurarItem.Enabled = false;
            buttonApagarItem.Enabled = false;
            buttonEditarItem.Enabled = false;
        }

        private void buttonEditarItem_Click(object sender, EventArgs e)
        {
            LoadCategoriesToComboBox();
            LoadGamesToComboBox();
            LoadRarityBox();
            HideSearch();
            HideUserInfo();
            StartEdit();
        }

        private void buttonCancelar_Click(object sender, EventArgs e)
        {
            ClearItemFields();
            ShowSearch();
            ShowUserInfo();
            StopEdit();
            comboBoxRaridade.Items.Clear();
        }

        private void buttonConfirmar_Click(object sender, EventArgs e)
        {
            string[] rar = comboBoxRaridade.Text.Split(" - ");
            string[] cat = comboBoxCategoria.Text.Split(" - ");
            string[] orgame = comboBoxJogoOriginario.Text.Split(" - ");

            if (EditItem(((Item)listBoxItens.SelectedItem).UUID, textBoxNomeItem.Text, Convert.ToInt32(rar[0]), textBoxValorMercado.Text, Convert.ToInt32(cat[0]), Convert.ToInt32(orgame[0]), Convert.ToInt32(((Item)listBoxItens.SelectedItem).OwnerID)) == 1)
            {
                MessageBox.Show("Item alterado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearItemFields();
                ShowSearch();
                ShowUserInfo();
                StopEdit();
                comboBoxRaridade.Items.Clear();
                listBoxItens.Items.Clear();
                LoadItems();
                listBoxItens.SelectedIndex = currentItem;
                ShowItems();
            }

            else
            {
                listBoxItens.SelectedIndex = currentItem;
            }
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [BIBLIOTECA]
        /// </summary>
        private void LoadRarityBox()
        {
            comboBoxRaridade.Items.Add(0);
            comboBoxRaridade.Items.Add(1);
            comboBoxRaridade.Items.Add(2);
            comboBoxRaridade.Items.Add(4);
            comboBoxRaridade.Items.Add(5);
        }

        private void ClearItemFields()
        {
            textBoxUUID.Clear();
            textBoxNomeItem.Clear();
            textboxRaridade.Clear();
            textBoxValorMercado.Clear();
            textBoxCategoria.Clear();
            textBoxJogoOriginario.Clear();
            textBoxPodeVender.Clear();
            textBoxColocadoMercado.Clear();
            textBoxID.Clear();
            textBoxEmail.Clear();
            textBoxPrimeiroNome.Clear();
            textBoxUltimoNome.Clear();
        }

        private void HideSearch()
        {
            textBoxProcurarItem.Visible = false;
            buttonProcurarItem.Visible = false;
            buttonLimparItem.Visible = false;
        }

        private void ShowSearch()
        {
            textBoxProcurarItem.Visible = true;
            buttonProcurarItem.Visible = true;
            buttonLimparItem.Visible = true;
        }
        
        private void HideUserInfo()
        {
            labelID.Visible = false;
            labelEmail.Visible = false;
            labelPrimeiroNome.Visible = false;
            labelUltimoNome.Visible = false;
            textBoxID.Visible = false;
            textBoxEmail.Visible = false;
            textBoxPrimeiroNome.Visible = false;
            textBoxUltimoNome.Visible = false;
        }

        private void ShowUserInfo()
        {
            labelID.Visible = true;
            labelEmail.Visible = true;
            labelPrimeiroNome.Visible = true;
            labelUltimoNome.Visible = true;
            textBoxID.Visible = true;
            textBoxEmail.Visible = true;
            textBoxPrimeiroNome.Visible = true;
            textBoxUltimoNome.Visible = true;
        }

        private void StartCreate()
        {
            listBoxItens.Visible = false;
            comboBoxCategoria.Visible = true;
            comboBoxJogoOriginario.Visible = true;
            comboBoxRaridade.Visible = true;
            buttonApagarItem.Visible = false;
            buttonCriarItem.Visible = false;
            buttonEditarItem.Visible = false;
            buttonConfirmarCriar.Visible = true;
            buttonCancelarCriar.Visible = true;
            textBoxUUID.Enabled = false;
            textBoxCategoria.Enabled = false;
            textboxRaridade.Enabled = false;
            textBoxJogoOriginario.Enabled = false;
            textBoxNomeItem.ReadOnly = false;
            textBoxValorMercado.ReadOnly = false;
            textBoxPodeVender.Visible = false;
            textBoxColocadoMercado.Visible = false;
            labelGerado.Visible = true;
            labelPodeVender.Visible = false;
            labelColocadoMercado.Visible = false;
            labelItens.Visible = false;
        }

        private void StopCreate()
        {
            listBoxItens.Visible = true;
            comboBoxCategoria.Visible = false;
            comboBoxJogoOriginario.Visible = false;
            comboBoxRaridade.Visible = false;
            buttonApagarItem.Visible = true;
            buttonCriarItem.Visible = true;
            buttonEditarItem.Visible = true;
            buttonConfirmarCriar.Visible = false;
            buttonCancelarCriar.Visible = false;
            textBoxUUID.Enabled = true;
            textBoxCategoria.Enabled = true;
            textboxRaridade.Enabled = true;
            textBoxJogoOriginario.Enabled = true;
            textBoxNomeItem.ReadOnly = true;
            textBoxValorMercado.ReadOnly = true;
            textBoxPodeVender.Visible = true;
            textBoxColocadoMercado.Visible = true;
            labelGerado.Visible = false;
            labelPodeVender.Visible = true;
            labelColocadoMercado.Visible = true;
            labelItens.Visible = true;
        }

        private void StartEdit()
        {
            listBoxItens.Enabled = false;
            comboBoxCategoria.Visible = true;
            comboBoxJogoOriginario.Visible = true;
            comboBoxRaridade.Visible = true;
            buttonApagarItem.Visible = false;
            buttonCriarItem.Visible = false;
            buttonEditarItem.Visible = false;
            buttonConfirmar.Visible = true;
            buttonCancelar.Visible = true;
            textBoxUUID.Enabled = false;
            textBoxCategoria.Enabled = false;
            textboxRaridade.Enabled = false;
            textBoxJogoOriginario.Enabled = false;
            textBoxNomeItem.ReadOnly = false;
            textBoxValorMercado.ReadOnly = false;
            textBoxPodeVender.Visible = false;
            textBoxColocadoMercado.Visible = false;
            labelPodeVender.Visible = false;
            labelColocadoMercado.Visible = false;
            labelItens.Visible = false;
        }

        private void StopEdit()
        {
            listBoxItens.Enabled = true;
            comboBoxCategoria.Visible = false;
            comboBoxJogoOriginario.Visible = false;
            comboBoxRaridade.Visible = false;
            buttonApagarItem.Visible = true;
            buttonCriarItem.Visible = true;
            buttonEditarItem.Visible = true;
            buttonConfirmar.Visible = false;
            buttonCancelar.Visible = false;
            textBoxUUID.Enabled = true;
            textBoxCategoria.Enabled = true;
            textboxRaridade.Enabled = true;
            textBoxJogoOriginario.Enabled = true;
            textBoxNomeItem.ReadOnly = true;
            textBoxValorMercado.ReadOnly = true;
            textBoxPodeVender.Visible = true;
            textBoxColocadoMercado.Visible = true;
            labelPodeVender.Visible = true;
            labelColocadoMercado.Visible = true;
            labelItens.Visible = true;
        }
    }
}
