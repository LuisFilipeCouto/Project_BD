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
    public partial class Form6 : Form
    {

        private SqlConnection cn;
        private static string connectionString;
        private static int AppUser_ID;
        private int currentSoftware;
        private int softwareToBuy;
        private int currentFriend;
        private int currentNonFriend;
        private int currentWishList;
        private int currentInvItem;
        private int currentMarketItem;
        private static Form6 _instance;

        public Form6(string connection, int ID)
        {
            InitializeComponent();
            connectionString = connection;
            AppUser_ID = ID;
            _instance = this;
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

        private void Form6_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();

            ClearFields();
            ClearPurchaseFields();
            LoadLibrary();
            LoadUserInfo();
            HidePurchaseControls();
            HidePurchaseInfo();
            buttonDevolver.Visible = false;
        }

        private void LoadUserInfo()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            textBoxID.Text = AppUser_ID.ToString();

            SqlCommand cmdEmail = new SqlCommand("SELECT Email FROM proj.AppUser WHERE ID=@ID", cn);
            cmdEmail.Parameters.Add("@ID", SqlDbType.Int).Value = AppUser_ID;
            textBoxEmail.Text = cmdEmail.ExecuteScalar().ToString();

            SqlCommand cmdFname = new SqlCommand("SELECT Fname FROM proj.AppUser WHERE ID=@ID", cn);
            cmdFname.Parameters.Add("@ID", SqlDbType.Int).Value = AppUser_ID;
            string Fname = cmdFname.ExecuteScalar().ToString();

            SqlCommand cmdLname = new SqlCommand("SELECT Fname FROM proj.AppUser WHERE ID=@ID", cn);
            cmdLname.Parameters.Add("@ID", SqlDbType.Int).Value = AppUser_ID;
            string Lname = cmdLname.ExecuteScalar().ToString();

            textBoxNome.Text = Fname + " " + Lname;

            SqlCommand cmdBalance = new SqlCommand("SELECT Balance FROM proj.AppUser WHERE ID=@ID", cn);
            cmdBalance.Parameters.Add("@ID", SqlDbType.Int).Value = AppUser_ID;
            textBoxSaldo.Text = Math.Round(Decimal.Parse(cmdBalance.ExecuteScalar().ToString()), 2).ToString();
            textBoxDesejoSaldo.Text = textBoxSaldo.Text;
            textBoxInventarioSaldo.Text = textBoxSaldo.Text;
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTransactionHistory();
            LoadFriends();
            LoadWishList();
            LoadInventory();
            LoadLibrary();
            buttonRemoverListaDesejos.Enabled = false;
            buttonComprarListaDesejos.Enabled = false;
            buttonInventarioComprar.Enabled = true;
            buttonMercadoCancelar.Visible = false; ;
            buttonMercadoComprar.Visible = false;
            textBoxMercadoPreco.Visible = false;
            labelMercadoPreco.Visible = false;
        }

        private void linkLabelAddSaldo_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form7 F7 = new Form7(connectionString, AppUser_ID);
            F7.Show();
        }

        private void linkLabelDesejoAddSaldo_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form7 F7 = new Form7(connectionString, AppUser_ID);
            F7.Show();
        }

        private void linkLabelInventarioAddSaldo_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            Form7 F7 = new Form7(connectionString, AppUser_ID);
            F7.Show();
        }

        private void buttonListaJogosVenda_Click(object sender, EventArgs e)
        {
            Form8 F8 = new Form8(connectionString, AppUser_ID);
            F8.Show();
        }

        public static void ResetWallet()
        {
            _instance.LoadUserInfo();
        }

        public static void ResetInventory()
        {
            _instance.LoadInventory();
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [BIBLIOTECA]
        /// </summary>
        private void LoadStoreContent()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBoxLoja.ClearSelected();
            LoadStoreGames();
            LoadStoreTools();
        }

        private void LoadStoreGames()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_All_Store_Games", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware game = new StoreSoftware();
                game.ID = (int)reader["ID"];
                game.Software_Type = char.Parse(reader["Software_Type"].ToString());
                game.Official_Name = reader["Official_Name"].ToString();
                game.Price = (decimal)reader["Price"];
                game.Release_Date = (DateTime)reader["Release_Date"];
                game.Publisher = reader["Publisher"].ToString();
                game.Age_Rating = reader["Age_Rating"].ToString();
                game.Game_Type = reader["Type"].ToString();
                game.SupportedOS = reader["Supported_OS"].ToString();
                game.Brief_Description = reader["Brief_Description"].ToString();
                listBoxLoja.Items.Add(game);
            }
            cn.Close();
        }

        private void LoadStoreTools()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_All_Store_Tools", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware game = new StoreSoftware();
                game.ID = (int)reader["ID"];
                game.Software_Type = char.Parse(reader["Software_Type"].ToString());
                game.Official_Name = reader["Official_Name"].ToString();
                game.Price = (decimal)reader["Price"];
                game.Release_Date = (DateTime)reader["Release_Date"];
                game.Publisher = reader["Publisher"].ToString();
                game.Current_Version = reader["Current_Version"].ToString();
                game.SupportedOS = reader["Supported_OS"].ToString();
                game.Brief_Description = reader["Brief_Description"].ToString();
                listBoxLoja.Items.Add(game);
            }
            cn.Close();
        }

        private void ShowSoftwareOnStore()
        {
            if (listBoxLoja.Items.Count == 0 | softwareToBuy < 0)
            {
                return;
            }

            StoreSoftware soft = (StoreSoftware)listBoxLoja.Items[softwareToBuy];

            textBox1.Text = soft.ID.ToString();
            textBox3.Text = soft.Official_Name.ToString();
            textBox4.Text = soft.Price.ToString();
            textBox5.Text = soft.Publisher.ToString();
            textBox7.Text = soft.SupportedOS.ToString();
            textBox8.Text = soft.Brief_Description.ToString();
            string[] dateLanc = soft.Release_Date.ToString().Split(' ');
            textBox6.Text = dateLanc[0];

            if (soft.Software_Type == 'G')
            {
                HideToolInfo();
                ShowGameInfo();
                textBox2.Text = "Jogo";
                textBox10.Text = soft.Age_Rating.ToString();
                textBox11.Text = soft.Game_Type.ToString();
            }
            else
            {
                HideGameInfo();
                ShowToolInfo();
                textBox2.Text = "Aplicação";
                textBox9.Text = soft.Current_Version.ToString();

            }
        }

        private void LoadLibrary()
        {
            listBoxBiblioteca.Items.Clear();
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getOwnedSoftwareByUserID(@ID)", cn);
            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                LibrarySoftware soft = new LibrarySoftware();
                soft.ID = (int)reader["ID"];
                soft.Official_Name = reader["Official_Name"].ToString();
                soft.Software_Type = char.Parse(reader["Type_of_Software"].ToString());
                soft.SupportedOS = reader["Supported_OS"].ToString();
                soft.Release_Date = (DateTime)reader["Release_Date"];
                soft.SKU = reader["SKU"].ToString();
                listBoxBiblioteca.Items.Add(soft);
            }
            cn.Close();
        }

        private void ShowLibrary()
        {
            if (listBoxBiblioteca.Items.Count == 0 | currentSoftware < 0)
            {
                return;
            }

            LibrarySoftware soft = (LibrarySoftware)listBoxBiblioteca.Items[currentSoftware];

            textBoxSoftID.Text = soft.ID.ToString();
            textBoxSoftNome.Text = soft.Official_Name.ToString();
            textBoxOS.Text = soft.SupportedOS.ToString();
            string[] dateLanc = soft.Release_Date.ToString().Split(' ');
            textBoxDataLancamento.Text = dateLanc[0];
            textBoxSKU.Text = soft.SKU.ToString();

            if (soft.Software_Type == 'G')
            {
                textBoxTipo.Text = "Jogo";
            }
            else
            { 
                textBoxTipo.Text = "Aplicação";
            }
        }
   
        private string PurchaseDate(string SKU)
        {
            if (!VerifySGBDConnection())
            {
                return "";
            }

            SqlCommand dt = new SqlCommand("SELECT Finalize_Date FROM proj.Purchases WHERE SKU=@SKU", cn);
            dt.Parameters.Add("@SKU", SqlDbType.NVarChar).Value = SKU;
            string purchasedate = dt.ExecuteScalar().ToString();
            cn.Close();

            return purchasedate;
        }

        private int PurchaseSoftware(int Soft_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.buySoftware", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Soft_ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao comprar. Verifique se tem saldo suficiente", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int ReturnSoftware(string SKU)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.returnSoftware", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@Software_SKU", SqlDbType.NVarChar).Value = SKU;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao devolver. Operação Cancelada!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void listBoxBiblioteca_SelectedIndexChanged(object sender, EventArgs e)
        {
            buttonDevolver.Visible = true;
            buttonDevolver.Enabled = false;

            if (listBoxBiblioteca.SelectedIndex >= 0)
            {
                currentSoftware = listBoxBiblioteca.SelectedIndex;
                ClearFields();
                ShowLibrary();
                textBoxTempoCompra.Text = ((int)(DateTime.Now - Convert.ToDateTime(PurchaseDate(((LibrarySoftware)listBoxBiblioteca.SelectedItem).SKU))).Days).ToString() + " dias";

                string[] timePassed = textBoxTempoCompra.Text.Split(" ");
                if(int.Parse(timePassed[0]) < 3) // Se tempo passado apos compra do software não ultrapassar 3 dias
                {
                    buttonDevolver.Enabled = true;
                }
            }

            if (listBoxBiblioteca.Items.Count == 0)
            {
                ClearFields();
            }
        }

        private void buttonComprarSoftware_Click(object sender, EventArgs e)
        {
            ClearFields();
            HideLibraryInfo();
            ShowPurchaseControls();
            ShowPurchaseInfo();
            LoadStoreContent();
            ShowSoftwareOnStore();
            buttonComprar.Enabled = false;
            buttonDesejar.Enabled = false;
            softwareToBuy = -1;
            ClearPurchaseFields();
        }

        private void listBoxLoja_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxLoja.SelectedIndex >= 0)
            {
                softwareToBuy = listBoxLoja.SelectedIndex;
                ShowSoftwareOnStore();
                buttonComprar.Enabled = true;
                buttonDesejar.Enabled = true;

            }

            if (listBoxLoja.Items.Count == 0)
            {
                ClearPurchaseFields();
            }
        }

        private void buttonCancelarCompra_Click(object sender, EventArgs e)
        {
            ClearPurchaseFields();
            ClearFields();
            HidePurchaseControls();
            HidePurchaseInfo();
            listBoxBiblioteca.Items.Clear();
            LoadLibrary();
            ShowLibraryInfo();
            buttonDevolver.Enabled = false;
            listBoxBiblioteca.SelectedIndex = -1;
            listBoxLoja.SelectedIndex = -1;
            currentSoftware = listBoxBiblioteca.SelectedIndex;
            softwareToBuy= listBoxLoja.SelectedIndex;
        }

        private void buttonComprar_Click(object sender, EventArgs e)
        {
            if (PurchaseSoftware(((StoreSoftware)listBoxLoja.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Software adicionado á biblioteca do utilizador!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearPurchaseFields();
                listBoxLoja.Items.Clear();
                textBoxSaldo.Clear();
                LoadUserInfo();
                LoadStoreContent();
                LoadLibrary();
                buttonComprar.Enabled = false;
                buttonDesejar.Enabled = false;
                listBoxLoja.SelectedIndex = -1;
                softwareToBuy = listBoxLoja.SelectedIndex;
            }
            else
            {
                listBoxLoja.SelectedIndex = softwareToBuy;
            }
        }

        private void buttonDevolver_Click(object sender, EventArgs e)
        {
            if (ReturnSoftware(((LibrarySoftware)listBoxBiblioteca.SelectedItem).SKU) == 1)
            {
                MessageBox.Show("Software devolvido com sucesso. O montante correspondente foi devolvido á sua carteira!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearFields();
                listBoxBiblioteca.Items.Clear();
                textBoxSaldo.Clear();
                LoadUserInfo();
                LoadLibrary();
                buttonComprar.Enabled = false;
                buttonDevolver.Enabled = false;
                listBoxBiblioteca.SelectedIndex = -1;
                currentSoftware = listBoxBiblioteca.SelectedIndex;
            }
            else
            {
                listBoxBiblioteca.SelectedIndex = currentSoftware;
            }
        }

        private void buttonDesejar_Click(object sender, EventArgs e)
        {
            if (AddWishList(((StoreSoftware)listBoxLoja.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Software adicionado á lista de desejos do utilizador!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearPurchaseFields();
                buttonComprar.Enabled = false;
                buttonDesejar.Enabled = false;
                listBoxLoja.SelectedIndex = -1;
                softwareToBuy = listBoxLoja.SelectedIndex;
            }
            else
            {
                listBoxLoja.SelectedIndex = softwareToBuy;
            }
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [LISTA DE DESEJOS]
        /// </summary>
        /// 
        private void LoadWishList()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBoxListaDesejos.Items.Clear();
            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getWishlistByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware soft = new StoreSoftware();
                soft.ID = (int)reader["ID"];
                soft.Software_Type = char.Parse(reader["Type_of_Software"].ToString());
                soft.Official_Name = reader["Official_Name"].ToString();
                soft.Price = (decimal)reader["Price"];
                soft.Publisher = reader["Publisher"].ToString();
                soft.Release_Date = (DateTime)reader["Release_Date"];
                soft.SupportedOS = reader["Supported_OS"].ToString();
                listBoxListaDesejos.Items.Add(soft);
            }
            cn.Close();
        }

        private void ShowSoftwareOnWishList()
        {
            if (listBoxListaDesejos.Items.Count == 0 | currentWishList < 0)
            {
                return;
            }

            StoreSoftware soft = (StoreSoftware)listBoxListaDesejos.Items[currentWishList];

            textBoxDesejoID.Text = soft.ID.ToString();
            textBoxDesejoNome.Text = soft.Official_Name.ToString();
            textBoxDesejoPreco.Text = soft.Price.ToString();
            textBoxDesejoPublicadora.Text = soft.Publisher.ToString();
            textBoxDesejoOS.Text = soft.SupportedOS.ToString();
            string[] dateLanc = soft.Release_Date.ToString().Split(' ');
            textBoxDesejoData.Text = dateLanc[0];

            if (soft.Software_Type == 'G') { 
                textBoxDesejoTipo.Text = "Jogo";
            }

            else
            {
                textBoxDesejoTipo.Text = "Aplicação";
            }
        }

        private int RemoveWishList(int Soft_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.removeWishList", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@Software_ID", SqlDbType.NVarChar).Value = Soft_ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao remover Software da lista de desejos. Operação Cancelada!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int AddWishList(int Soft_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.addWishList", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@Software_ID", SqlDbType.NVarChar).Value = Soft_ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao adicionar Software à sua lista de desejos. Verifique se o software já se encontra nesta!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void listBoxListaDesejos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxListaDesejos.SelectedIndex >= 0)
            {
                ClearWishListFields();
                currentWishList = listBoxListaDesejos.SelectedIndex;
                buttonRemoverListaDesejos.Enabled = true;
                buttonComprarListaDesejos.Enabled = true;
                ShowSoftwareOnWishList();
            }

            if (listBoxListaDesejos.Items.Count == 0)
            {
                ClearWishListFields();
                buttonRemoverListaDesejos.Enabled = false;
                buttonComprarListaDesejos.Enabled = false;
                currentWishList = -1;
            }
        }

        private void buttonRemoverListaDesejos_Click(object sender, EventArgs e)
        {

            if (RemoveWishList(((StoreSoftware)listBoxListaDesejos.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Software removido da lista com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxListaDesejos.Items.Clear();
                ClearWishListFields();
                LoadWishList();
                buttonRemoverListaDesejos.Enabled = false;
                buttonComprarListaDesejos.Enabled = false;
                listBoxListaDesejos.SelectedIndex = -1;
                currentWishList = listBoxListaDesejos.SelectedIndex;
            }
            else
            {
                listBoxListaDesejos.SelectedIndex = currentWishList;
            }
        }

        private void buttonComprarListaDesejos_Click(object sender, EventArgs e)
        {
            if (PurchaseSoftware(((StoreSoftware)listBoxListaDesejos.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Software adicionado á biblioteca do utilizador!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxListaDesejos.Items.Clear();
                ClearWishListFields();
                LoadWishList();
                LoadUserInfo();
                buttonRemoverListaDesejos.Enabled = false;
                buttonComprarListaDesejos.Enabled = false;
                listBoxListaDesejos.SelectedIndex = -1;
                currentWishList = listBoxListaDesejos.SelectedIndex;
            }
            else
            {
                listBoxListaDesejos.SelectedIndex = currentWishList;
            }
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [LISTA DE AMIGOS]
        /// </summary>
        private void LoadFriends()
        {
            listBoxNaoAmigos.Items.Clear();
            listBoxAmigos.Items.Clear();
            LoadFriendsList();
            LoadNotFriendsList();
            buttonRemoverAmigo.Enabled = false;
            buttonAdicionarAmigo.Enabled = false;
            buttonProcurarNaoAmigos.Enabled = false;
        }

        private void LoadFriendsList()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getFriendsListByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                AppUser appuser = new AppUser();
                appuser.ID = (int)reader["ID"];
                appuser.Email = reader["Email"].ToString();
                appuser.Fname = reader["Fname"].ToString();
                appuser.Lname = reader["Lname"].ToString();
                listBoxAmigos.Items.Add(appuser);
            }
            cn.Close();
        }

        private void LoadNotFriendsList()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getNotFriendsWithByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                AppUser appuser = new AppUser();
                appuser.ID = (int)reader["ID"];
                appuser.Email = reader["Email"].ToString();
                appuser.Fname = reader["Fname"].ToString();
                appuser.Lname = reader["Lname"].ToString();
                listBoxNaoAmigos.Items.Add(appuser);
            }
            cn.Close();
        }

        private int RemoveFriend(int ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.removeFriend", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID1", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@AppUser_ID2", SqlDbType.Int).Value = ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao remover amigo. Operação Cancelada!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int AddFriend(int ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.addFriend", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID1", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@AppUser_ID2", SqlDbType.Int).Value = ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao remover amigo. Operação Cancelada!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void FindNonFriend(string src)
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBoxNaoAmigos.Items.Clear();
            SqlCommand cmd = new SqlCommand("proj.searchNonFriend", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@StringFind", SqlDbType.NVarChar).Value = src;

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                AppUser appuser = new AppUser();
                appuser.ID = (int)reader["ID"];
                appuser.Email = reader["Email"].ToString();
                appuser.Fname = reader["Fname"].ToString();
                appuser.Lname = reader["Lname"].ToString();
                listBoxNaoAmigos.Items.Add(appuser);
            }
            cn.Close();
        }

        private void listBoxAmigos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxAmigos.SelectedIndex >= 0)
            {
                currentFriend = listBoxAmigos.SelectedIndex;
                buttonRemoverAmigo.Enabled = true;
                buttonAdicionarAmigo.Enabled = false;
                listBoxNaoAmigos.SelectedIndex = -1;
            }

            if (listBoxAmigos.Items.Count == 0)
            {
                buttonRemoverAmigo.Enabled = false;
                currentFriend = -1;
            }
        }

        private void listBoxNaoAmigos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxNaoAmigos.SelectedIndex >= 0)
            {
                currentNonFriend = listBoxNaoAmigos.SelectedIndex;
                buttonAdicionarAmigo.Enabled = true;
                buttonRemoverAmigo.Enabled = false;
                listBoxAmigos.SelectedIndex = -1;
            }

            if (listBoxNaoAmigos.Items.Count == 0)
            {
                buttonAdicionarAmigo.Enabled = false;
                currentNonFriend = -1;
    }
        }

        private void buttonRemoverAmigo_Click(object sender, EventArgs e)
        {
            if (RemoveFriend(((AppUser)listBoxAmigos.SelectedItem).ID) == 1)
            {
                listBoxAmigos.Items.Clear();
                listBoxNaoAmigos.Items.Clear();
                LoadFriends();
                buttonRemoverAmigo.Enabled = false;
                listBoxAmigos.SelectedIndex = -1;
            }
            else
            {
                listBoxAmigos.SelectedIndex = currentFriend;
            }
        }

        private void buttonAdicionarAmigo_Click(object sender, EventArgs e)
        {
            if (AddFriend(((AppUser)listBoxNaoAmigos.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Amigo adicionado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxAmigos.Items.Clear();
                listBoxNaoAmigos.Items.Clear();
                LoadFriends();
                buttonAdicionarAmigo.Enabled = false;
                listBoxNaoAmigos.SelectedIndex = -1;
            }
            else
            {
                listBoxNaoAmigos.SelectedIndex = currentNonFriend;
            }
        }

        private void textBoxProcurarNaoAmigos_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(textBoxProcurarNaoAmigos.Text))
            {
                buttonProcurarNaoAmigos.Enabled = true;
            }
            else
            {
                buttonProcurarNaoAmigos.Enabled = false;
            }
        }

        private void buttonProcurarNaoAmigos_Click(object sender, EventArgs e)
        {
            FindNonFriend(textBoxProcurarNaoAmigos.Text);
        }

        private void buttonLimpar_Click(object sender, EventArgs e)
        {
            textBoxProcurarNaoAmigos.Clear();
            listBoxNaoAmigos.Items.Clear();
            LoadNotFriendsList();
            buttonProcurarNaoAmigos.Enabled = false;
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [INVENTARIO]
        /// </summary>
        private void LoadInventory() { 
            listBoxInventario.Items.Clear();
            ClearInventoryFields();
            LoadInventoryItems();
            buttonInventarioVender.Enabled = false;
            buttonInventarioComprar.Enabled = false;
            buttonInventarioVender.Visible = true;
            buttonInventarioComprar.Visible = true;
            listBoxMercado.Visible = false;
            listBoxInventario.Visible = true;
            labelMercado.Visible = false;
            labelInventario.Visible = true;
            textBoxInventarioVenda.Visible = true;
            textBoxInventarioValor.Visible = true;
            labelInventarioVenda.Visible = true;
            labelInventarioValor.Visible = true;
            textBoxInventarioNoMercado.Visible = true;
            labelInventarioEstado.Visible = true;
        }

        private void LoadMarket()
        {
            ClearInventoryFields();
            listBoxMercado.Items.Clear();
            LoadMarketItems();
            buttonInventarioVender.Visible = false;
            buttonInventarioComprar.Visible = false;
            buttonMercadoComprar.Visible = true;
            buttonMercadoComprar.Enabled = false;
            buttonMercadoCancelar.Visible = true;
            listBoxInventario.Visible = false;
            labelInventario.Visible = false;
            labelInventarioEstado.Visible = false;
            textBoxInventarioNoMercado.Visible = false;
            listBoxMercado.Visible = true;
            labelMercado.Visible = true;
        }

        private void LoadInventoryItems()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getInventoryByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Item itm = new Item();
                itm.UUID = reader["Item_UUID"].ToString();
                itm.Name = reader["Item_Name"].ToString();


                if (reader["Market_Value"] != DBNull.Value)
                {
                   itm.Market_Value = (decimal)reader["Market_Value"];
                }

                itm.Category = reader["Category"].ToString();
                itm.Rarity = (int)reader["Rarity"];
                itm.CanBeSold = (bool)reader["CanBeSold"];
                itm.OriginGame = reader["Origin_Game"].ToString();
                itm.ForSale = reader["ForSale"].ToString()[0];
                listBoxInventario.Items.Add(itm);
            }
            cn.Close();
        }

        private void LoadMarketItems()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getMarketByUserID(@AppUser_ID)", cn);
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
                listBoxMercado.Items.Add(itm);
            }
            cn.Close();
        }

        private void ShowInventory()
        {
            if (listBoxInventario.Items.Count == 0 | currentInvItem < 0)
            {
                return;
            }

            Item itm = (Item)listBoxInventario.Items[currentInvItem];

            textBoxInventarioUUID.Text = itm.UUID.ToString();
            textBoxInventarioNome.Text = itm.Name.ToString();
            textBoxInventarioCategoria.Text = itm.Category.ToString();
            textBoxInventarioRaridade.Text = itm.Rarity.ToString();
            textBoxInventarioOrigem.Text = itm.OriginGame.ToString(); ;

            if(itm.CanBeSold)
            {
                textBoxInventarioValor.Visible = true;
                textBoxInventarioNoMercado.Visible = true;
                textBoxInventarioVenda.Text = "SIM";
                textBoxInventarioValor.Text = Math.Round((decimal)itm.Market_Value, 2).ToString();
                labelInventarioValor.Visible = true;
                labelInventarioEstado.Visible = true;

            }

            else
            {
                textBoxInventarioVenda.Text = "NÃO";
                textBoxInventarioValor.Visible = false;
                textBoxInventarioNoMercado.Visible = false;
                labelInventarioValor.Visible = false;
                labelInventarioEstado.Visible = false;

            }

            if(itm.ForSale == 'Y')
            {
                textBoxInventarioNoMercado.Text = "SIM";
            }
            else
            {
                textBoxInventarioNoMercado.Text = "NÃO";
            }
        }

        private void ShowMarket()
        {
            if (listBoxMercado.Items.Count == 0 | currentMarketItem < 0)
            {
                return;
            }

            Item itm = (Item)listBoxMercado.Items[currentMarketItem];

            textBoxInventarioUUID.Text = itm.UUID.ToString();
            textBoxInventarioNome.Text = itm.Name.ToString();
            textBoxInventarioCategoria.Text = itm.Category.ToString();
            textBoxInventarioRaridade.Text = itm.Rarity.ToString();
            textBoxInventarioOrigem.Text = itm.OriginGame.ToString();
            textBoxMercadoPreco.Text = Math.Round((decimal)itm.Market_Value, 2).ToString();
        }

        private int PurchaseItem(string UUID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.buyMarketItem", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Buyer_ID", SqlDbType.Int).Value = AppUser_ID;
            cmd.Parameters.Add("@Item_UUID", SqlDbType.NVarChar).Value = UUID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao comprar item. Verifique se tem saldo suficiente!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int SellItem(string UUID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.sellMarketItem", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Item_UUID", SqlDbType.NVarChar).Value = UUID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao vender item. Verifique se este já se encontra á venda!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void listBoxInventario_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxInventario.SelectedIndex >= 0)
            {
                ClearInventoryFields();
                currentInvItem = listBoxInventario.SelectedIndex;
                buttonInventarioComprar.Enabled = true;
                
                ShowInventory();

                if(((Item)listBoxInventario.SelectedItem).CanBeSold)
                {
                    buttonInventarioVender.Enabled = true;
                }

                else
                {
                    buttonInventarioVender.Enabled = false;
                }
            }

            if (listBoxInventario.Items.Count == 0)
            {
                ClearInventoryFields();
                buttonInventarioVender.Enabled = false;
                currentInvItem = -1;
            }
        }

        private void buttonInventarioComprar_Click(object sender, EventArgs e)
        {
            LoadMarket();
            textBoxInventarioNoMercado.Visible = false;
            textBoxInventarioVenda.Visible = false;
            textBoxInventarioValor.Visible = false;
            labelInventarioVenda.Visible = false;
            labelInventarioEstado.Visible = false;
            labelInventarioValor.Visible = false;
            buttonListaJogosVenda.Visible = false;
            textBoxMercadoPreco.Visible = true;
            labelMercadoPreco.Visible = true;
        }

        private void listBoxMercado_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxMercado.SelectedIndex >= 0)
            {
                ClearInventoryFields();
                currentMarketItem = listBoxMercado.SelectedIndex;
                buttonMercadoComprar.Enabled = true;
                ShowMarket();
            }

            if (listBoxMercado.Items.Count == 0)
            {
                ClearInventoryFields();
                buttonMercadoComprar.Enabled = false;
                currentMarketItem = -1;
            }
        }

        private void buttonMercadoCancelar_Click(object sender, EventArgs e)
        {
            LoadInventory();
            buttonMercadoComprar.Visible = false;
            buttonMercadoCancelar.Visible = false;
            labelMercadoPreco.Visible = false;
            textBoxMercadoPreco.Visible = false;
            buttonListaJogosVenda.Visible = true;
            buttonInventarioComprar.Enabled = true;
        }

        private void buttonMercadoComprar_Click(object sender, EventArgs e)
        {
            if (PurchaseItem(((Item)listBoxMercado.SelectedItem).UUID) == 1)
            {
                MessageBox.Show("Item comprado com sucesso. Foi adicionado ao seu inventario!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxMercado.Items.Clear();
                listBoxInventario.Items.Clear();
                LoadInventory();
                LoadMarket();
                LoadUserInfo();
                labelMercadoPreco.Visible = false;
                buttonMercadoComprar.Enabled = false;
                textBoxInventarioVenda.Visible = false;
                textBoxInventarioValor.Visible = false;
                labelInventarioValor.Visible = false;
                labelInventarioVenda.Visible = false;
                labelMercadoPreco.Visible = true;
                buttonListaJogosVenda.Visible = false;
                listBoxMercado.SelectedIndex = -1;
            }
            else
            {
                listBoxMercado.SelectedIndex = currentMarketItem;
            }
        }

        private void buttonInventarioVender_Click(object sender, EventArgs e)
        {
            if (SellItem(((Item)listBoxInventario.SelectedItem).UUID) == 1)
            {
                MessageBox.Show("Item posto á venda com sucesso! Se alguém o comprar, irá receber o montante na sua carteira", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxInventario.Items.Clear();
                LoadInventory();
                listBoxInventario.SelectedIndex = -1;
                buttonInventarioComprar.Enabled = true;
            }
            else
            {
                listBoxInventario.SelectedIndex = currentInvItem;
            }
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [HISTORICO DE TRANSAÇÕES]
        /// </summary>
        private void LoadTransactionHistory() 
        {
            listBoxDevolucoes.Items.Clear();
            listBoxAquisicoes.Items.Clear();
            LoadPurchases();
            LoadPurchaseReturns();
        } 

        private void LoadPurchases()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getPurchasesByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Transaction pur = new Transaction();
                pur.Software_ID = (int)reader["Software_ID"];
                pur.SKU = reader["SKU"].ToString();
                pur.Date = (DateTime)reader["Finalize_Date"];
                pur.Cost = (decimal)reader["Cost"];
                listBoxAquisicoes.Items.Add(pur);
            }
            cn.Close();
        }

        private void LoadPurchaseReturns()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getPurchaseReturnsByUserID(@AppUser_ID)", cn);
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = AppUser_ID;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Transaction pur = new Transaction();
                pur.Software_ID = (int)reader["Software_ID"];
                pur.SKU = reader["SKU"].ToString();
                pur.Date = (DateTime)reader["Return_Date"];
                pur.Cost = (decimal)reader["Cost"];
                listBoxDevolucoes.Items.Add(pur);
            }
            cn.Close();
        }


        /// <summary>
        /// FUNÇOES AUXILIARES
        /// </summary>
        private void ClearFields()
        {
            textBoxSoftID.Clear();
            textBoxTipo.Clear();
            textBoxSoftNome.Clear();
            textBoxDataLancamento.Clear();
            textBoxOS.Clear();
            textBoxSKU.Clear();
            textBoxTempoCompra.Clear();
        }

        private void ClearPurchaseFields()
        {
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Clear();
            textBox4.Clear();
            textBox5.Clear();
            textBox6.Clear();
            textBox7.Clear();
            textBox8.Clear();
            textBox9.Clear();
            textBox10.Clear();
            textBox11.Clear();
        }

        private void ClearWishListFields()
        {
            textBoxDesejoID.Clear();
            textBoxDesejoNome.Clear();
            textBoxDesejoPreco.Clear();
            textBoxDesejoOS.Clear();
            textBoxDesejoData.Clear();
            textBoxDesejoPublicadora.Clear();
            textBoxDesejoTipo.Clear();
         }

        private void ClearInventoryFields()
        {
            textBoxInventarioUUID.Clear();
            textBoxInventarioNome.Clear();
            textBoxInventarioCategoria.Clear();
            textBoxInventarioRaridade.Clear();
            textBoxInventarioOrigem.Clear();
            textBoxInventarioVenda.Clear();
            textBoxInventarioValor.Clear();
            textBoxInventarioNoMercado.Clear();
            textBoxMercadoPreco.Clear();
        }

        private void ShowToolInfo()
        {
            textBox9.Visible = true;
            label9.Visible = true;
        }

        private void ShowGameInfo()
        {
            textBox10.Visible = true;
            textBox11.Visible = true;
            label10.Visible = true;
            label11.Visible = true;
        }

        private void HideToolInfo()
        {
            textBox9.Visible = false;
            label9.Visible = false;
        }

        private void HideGameInfo()
        {
            textBox10.Visible = false;
            textBox11.Visible = false;
            label10.Visible = false;
            label11.Visible = false;
        }

        private void HideLibraryInfo()
        {
            textBoxSoftID.Visible = false;
            textBoxTipo.Visible = false;
            textBoxSoftNome.Visible = false;
            textBoxDataLancamento.Visible = false;
            textBoxOS.Visible = false;
            textBoxSKU.Visible = false;
            textBoxTempoCompra.Visible = false;

            labelSoftID.Visible = false;
            labelTipo.Visible = false;
            labelSoftNome.Visible = false;
            labelDataLancamento.Visible = false;
            labelOS.Visible = false;
            labelSKU.Visible = false;
            labelTempoCompra.Visible = false;
            labelBiblioteca.Visible = false;

            buttonComprarSoftware.Visible = false;
            buttonDevolver.Visible = false;

            listBoxBiblioteca.Visible = false;

        }

        private void ShowLibraryInfo()
        {
            textBoxSoftID.Visible = true;
            textBoxTipo.Visible = true;
            textBoxSoftNome.Visible = true;
            textBoxDataLancamento.Visible = true;
            textBoxOS.Visible = true;
            textBoxSKU.Visible = true;
            textBoxTempoCompra.Visible = true;

            labelSoftID.Visible = true;
            labelTipo.Visible = true;
            labelSoftNome.Visible = true;
            labelDataLancamento.Visible = true;
            labelOS.Visible = true;
            labelSKU.Visible = true;
            labelTempoCompra.Visible = true;
            labelBiblioteca.Visible = true;

            buttonComprarSoftware.Visible = true;
            buttonDevolver.Visible = true;

            listBoxBiblioteca.Visible = true;
        }

        private void HidePurchaseControls()
        {
            labelPodeComprar.Visible = false;
            buttonComprar.Visible = false;
            buttonCancelarCompra.Visible = false;
            buttonDesejar.Visible = false;
            listBoxLoja.Visible = false;
        }

        private void ShowPurchaseControls()
        {
            labelPodeComprar.Visible = true;
            buttonComprar.Visible = true;
            buttonCancelarCompra.Visible = true;
            buttonDesejar.Visible = true;
            listBoxLoja.Visible = true;
        }

        private void HidePurchaseInfo()
        {
            textBox1.Visible = false;
            textBox2.Visible = false;
            textBox3.Visible = false;
            textBox4.Visible = false;
            textBox5.Visible = false;
            textBox6.Visible = false;
            textBox7.Visible = false;
            textBox8.Visible = false;
            textBox9.Visible = false;
            textBox10.Visible = false;
            textBox11.Visible = false;

            label1.Visible = false;
            label2.Visible = false;
            label3.Visible = false;
            label4.Visible = false;
            label5.Visible = false;
            label6.Visible = false;
            label7.Visible = false;
            label8.Visible = false;
            label9.Visible = false;
            label10.Visible = false;
            label11.Visible = false;
        }

        private void ShowPurchaseInfo()
        {
            textBox1.Visible = true;
            textBox2.Visible = true;
            textBox3.Visible = true;
            textBox4.Visible = true;
            textBox5.Visible = true;
            textBox6.Visible = true;
            textBox7.Visible = true;
            textBox8.Visible = true;
            textBox9.Visible = true;
            textBox10.Visible = true;
            textBox11.Visible = true;

            label1.Visible = true;
            label2.Visible = true;
            label3.Visible = true;
            label4.Visible = true;
            label5.Visible = true;
            label6.Visible = true;
            label7.Visible = true;
            label8.Visible = true;
            label9.Visible = true;
            label10.Visible = true;
            label11.Visible = true;
        }      
    }
}
