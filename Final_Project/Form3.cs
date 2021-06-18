using System;
using System.Data;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Final_Project
{
    public partial class Form3 : Form
    {
        private SqlConnection cn;
        private static string connectionString;
        private int currentSoftware;

        public Form3(string connection)
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

        private void Form3_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();

            currentSoftware = 0;
            ClearFields();
            HideOptionalInfo();
            LockRemoveEdit();
            HideEditPrice();
            HideAddSoftware();
            HideAddNewGamePrice();
            listBox2.Visible = false;
            label3.Visible = false;

            LoadStoreContent();
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            buttonAdicionarAutorizacao.Enabled = false;
            buttonRemoverAutorizacao.Enabled = false;
            ClearFields();
            ClearFields2();
            LoadLists();
            LoadStoreContent();
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [GERIR LOJA]
        /// </summary>
        private void LoadStoreContent()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBox1.Items.Clear();
            LoadStoreGames();
            LoadStoreTools();
        }

        private void LoadContentCanBeAddedToStore()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBox2.Items.Clear();
            LoadGamesNotInStore();
            LoadToolsNotInStore();
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
                listBox1.Items.Add(game);
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
                listBox1.Items.Add(game);
            }
            cn.Close();
        }

        private void LoadGamesNotInStore()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_Games_Can_Add_Store", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware game = new StoreSoftware();
                game.ID = (int)reader["ID"];
                game.Software_Type = char.Parse(reader["Software_Type"].ToString());
                game.Official_Name = reader["Official_Name"].ToString();
                game.Release_Date = (DateTime)reader["Release_Date"];
                game.Publisher = reader["Publisher"].ToString();
                game.Age_Rating = reader["Age_Rating"].ToString();
                game.Game_Type = reader["Type"].ToString();
                game.SupportedOS = reader["Supported_OS"].ToString();
                game.Brief_Description = reader["Brief_Description"].ToString();
                listBox2.Items.Add(game);
            }
            cn.Close();
        }

        private void LoadToolsNotInStore()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_Tools_Can_Add_Store", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware game = new StoreSoftware();
                game.ID = (int)reader["ID"];
                game.Software_Type = char.Parse(reader["Software_Type"].ToString());
                game.Official_Name = reader["Official_Name"].ToString();
                game.Release_Date = (DateTime)reader["Release_Date"];
                game.Publisher = reader["Publisher"].ToString();
                game.Current_Version = reader["Current_Version"].ToString();
                game.SupportedOS = reader["Supported_OS"].ToString();
                game.Brief_Description = reader["Brief_Description"].ToString();
                listBox2.Items.Add(game);
            }
            cn.Close();
        }

        private void ShowSoftwareOnStore()
        {
            if (listBox1.Items.Count == 0 | currentSoftware < 0)
            {
                return;
            }

            StoreSoftware soft = (StoreSoftware)listBox1.Items[currentSoftware]; 

            textBoxID.Text = soft.ID.ToString();
            textBoxNome.Text = soft.Official_Name.ToString();
            textBoxPreco.Text = soft.Price.ToString();
            textBoxPublicadora.Text = soft.Publisher.ToString();
            textBoxOS.Text = soft.SupportedOS.ToString();
            textBoxDescricao.Text = soft.Brief_Description.ToString();
            string[] dateLanc = soft.Release_Date.ToString().Split(' ');
            textBoxDataLancamento.Text = dateLanc[0];

            if (soft.Software_Type == 'G')
            {
                HideToolInfo();
                ShowGameInfo();
                textBoxTipo.Text = "Jogo";
                textBoxIdade.Text = soft.Age_Rating.ToString();
                textBoxTipoJogo.Text = soft.Game_Type.ToString();
            }
            else
            {
                HideGameInfo();
                ShowToolInfo();
                textBoxTipo.Text = "Aplicação";
                textBoxVersao.Text = soft.Current_Version.ToString();
                
            }
        }

        private void ShowSoftwareCanBeAdded()
        {
            if (listBox2.Items.Count == 0 | currentSoftware < 0)
            {
                return;
            }

            StoreSoftware soft = (StoreSoftware)listBox2.Items[currentSoftware];

            textBoxID.Text = soft.ID.ToString();
            textBoxNome.Text = soft.Official_Name;
            textBoxPreco.Text = soft.Price.ToString();
            textBoxPublicadora.Text = soft.Publisher.ToString();
            textBoxOS.Text = soft.SupportedOS.ToString();
            textBoxDescricao.Text = soft.Brief_Description.ToString();
            string[] dateLanc = soft.Release_Date.ToString().Split(' ');
            textBoxDataLancamento.Text = dateLanc[0];

            if (soft.Software_Type == 'G')
            {
                HideToolInfo();
                ShowGameInfo();
                textBoxTipo.Text = "Jogo";
                textBoxIdade.Text = soft.Age_Rating.ToString();
                textBoxTipoJogo.Text = soft.Game_Type.ToString();
            }
            else
            {
                HideGameInfo();
                ShowToolInfo();
                textBoxTipo.Text = "Aplicação";
                textBoxVersao.Text = soft.Current_Version.ToString();

            }
        }

        private int RemoveSoftwareFromStore(int Software_ID)
        {
            if (!VerifySGBDConnection()) {
                return 0;
            } 

            SqlCommand cmd = new SqlCommand("proj.removeStoreSoftware", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Software_ID;
            
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao remover software da loja - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int EditPrice(int Software_ID, string New_Price)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.editSoftwarePrice", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Software_ID;
            cmd.Parameters.Add("@New_Price", SqlDbType.Decimal).Value = New_Price;

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

        private int AddSoftwareToStore(int Software_ID, string Sell_Price)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.addStore_Software", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Software_ID;
            cmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = Sell_Price;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao adicionar Software à loja - OPERAÇÃO CANCELADA!\nInsira preço de venda inteiro/decimal positivo, com casas decimais separadas por virgula","Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox1.SelectedIndex >= 0)
            {
                currentSoftware = listBox1.SelectedIndex;
                UnlockRemoveEdit();
                UnlockAddSoftware();
                ShowSoftwareOnStore();

            }

            if(listBox1.Items.Count == 0)
            {
                ClearFields();
                HideOptionalInfo();
                LockRemoveEdit();
                LockAddSoftware();
            }
        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox2.SelectedIndex >= 0)
            {
                currentSoftware = listBox2.SelectedIndex;
                UnlockRemoveEdit();
                UnlockAddSoftware();
                ShowAddNewGamePrice();
                ShowSoftwareCanBeAdded();
                textBoxPrecoJogoNovo.Clear();
            }

            if (listBox2.Items.Count == 0)
            {
                ClearFields();
                HideOptionalInfo();
                LockAddSoftware();
            }
        }

        private void buttonAdicionar_Click(object sender, EventArgs e)
        {
            ClearFields();
            listBox1.Items.Clear();
            listBox1.Visible = false;
            listBox2.Visible = true;
            HideOptionalInfo();
            HideEditPrice();
            HideRemoveEdit();
            ShowAddSoftware();
            LockAddSoftware();
            buttonAdicionar.Visible = false;
            textBoxPrecoJogoNovo.Visible = true;
            textBoxPrecoJogoNovo.Enabled = false;
            labelPrecoJogoNovo.Visible = true;
            label1.Visible = false;
            label3.Visible = true;

            LoadContentCanBeAddedToStore();
        }

        private void buttonRemover_Click(object sender, EventArgs e)
        {
            if(RemoveSoftwareFromStore(((StoreSoftware)listBox1.SelectedItem).ID) == 1) {
                MessageBox.Show("Software removido da loja com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBox1.Items.RemoveAt(listBox1.SelectedIndex);
                ClearFields();
                HideOptionalInfo();
                LockRemoveEdit();
            }

            else
            {
                listBox1.SelectedIndex = currentSoftware;
            }
        }

        private void buttonEditar_Click(object sender, EventArgs e)
        {
            currentSoftware = listBox1.SelectedIndex;
            buttonRemover.Enabled = false;
            buttonAdicionar.Enabled = false;
            textBoxNovoPreco.Enabled = true;
            buttonEditar.Visible = false;
            ShowEditPrice();
        }

        private void buttonOk_Click(object sender, EventArgs e)
        {
            if(EditPrice(((StoreSoftware)listBox1.SelectedItem).ID, textBoxNovoPreco.Text) == 1)
            {
                MessageBox.Show("Preço alterado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                HideEditPrice();
                buttonAdicionar.Enabled = true;
                buttonEditar.Visible = true;
                textBoxNovoPreco.Clear();
                ClearFields();
                LoadStoreContent();
                listBox1.SelectedIndex = currentSoftware;
            }

            else
            {
                HideEditPrice();
                buttonAdicionar.Enabled = true;
                buttonEditar.Visible = true;
                textBoxNovoPreco.Clear();
                ClearFields();
                LoadStoreContent();
                listBox1.SelectedIndex = currentSoftware;
            }
        }

        private void buttonCancel_Click(object sender, EventArgs e)
        {
            HideEditPrice();
            textBoxNovoPreco.Clear();
            buttonAdicionar.Enabled = true;
            buttonEditar.Visible = true;
            ClearFields();
            LoadStoreContent();
            listBox1.SelectedIndex = currentSoftware;
        }

        private void buttonExit_Click(object sender, EventArgs e)
        {
            ClearFields();
            HideAddSoftware();
            HideAddNewGamePrice();
            LoadStoreContent();
            ShowRemoveEdit();
            buttonAdicionar.Visible = true;
            LockRemoveEdit();
            listBox2.Visible = false;
            listBox1.Visible = true;
            label1.Visible = true;
            label3.Visible = false;
        }

        private void buttonConfirmarAdd_Click(object sender, EventArgs e)
        {
            if (AddSoftwareToStore(((StoreSoftware)listBox2.SelectedItem).ID, textBoxPrecoJogoNovo.Text) == 1)
            {
                MessageBox.Show("Software adicionado à loja com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBox2.Items.Clear();
                textBoxPrecoJogoNovo.Clear();
                ClearFields();
                HideAddNewGamePrice();
                HideOptionalInfo();
                LockAddSoftware();
                LoadContentCanBeAddedToStore();
            }
            else
            {
                textBoxPrecoJogoNovo.Clear();
                listBox2.SelectedIndex = currentSoftware;
            }
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [GERIR LISTA DE AUTORIZACAO]
        /// </summary>
        private void LoadLists()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBox3.Items.Clear();
            listBox4.Items.Clear();
            LoadAuthorized();
            LoadNotAuthorized();
            listBox3.Sorted = true;
            listBox4.Sorted = true;
        }
        
        private void LoadAuthorized()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_All_Allowed_Publishers", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Publisher pub = new Publisher();
                pub.NIPC = reader["NIPC"].ToString();
                pub.Name = reader["Publisher"].ToString();
                pub.Street = reader["Street"].ToString();
                pub.Postcode = reader["Postcode"].ToString();
                pub.City = reader["City"].ToString();
                pub.Country = reader["Country"].ToString();
                pub.Foundation_Date = (DateTime)reader["Foundation_Date"];
                listBox3.Items.Add(pub);
            }
            cn.Close();
        }

        private void LoadNotAuthorized()
        {

            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_All_NotAllowed_Publishers");
            cmd.Connection = cn;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Publisher pub = new Publisher();
                pub.NIPC = reader["NIPC"].ToString();
                pub.Name = reader["Publisher"].ToString();
                pub.Street = reader["Street"].ToString();
                pub.Postcode = reader["Postcode"].ToString();
                pub.City = reader["City"].ToString();
                pub.Country = reader["Country"].ToString();
                pub.Foundation_Date = (DateTime)reader["Foundation_Date"];
                listBox4.Items.Add(pub);
            }
            cn.Close();
        }

        private void ShowAllowedPublisher()
        {
            if (listBox3.Items.Count == 0 | currentSoftware < 0)
            {
                return;
            }

            Publisher pub = (Publisher)listBox3.Items[currentSoftware];

            textBoxNIPC.Text = pub.NIPC.ToString();
            textBoxPub_Nome.Text = pub.Name.ToString();
            textBoxRua.Text = pub.Street.ToString();
            textBoxCodigoPostal.Text = pub.Postcode.ToString();
            textBoxCidade.Text = pub.City.ToString();
            textBoxPais.Text = pub.Country.ToString();

            string[] dateFund = pub.Foundation_Date.ToString().Split(' ');
            textBoxDataFundacao.Text = dateFund[0];

            textBoxPermitida.Text = "SIM";
        }

        private void ShowNotAllowedPublisher()
        {
            if (listBox4.Items.Count == 0 | currentSoftware < 0)
            {
                return;
            }

            Publisher pub = (Publisher)listBox4.Items[currentSoftware];

            textBoxNIPC.Text = pub.NIPC.ToString();
            textBoxPub_Nome.Text = pub.Name.ToString();
            textBoxRua.Text = pub.Street.ToString();
            textBoxCodigoPostal.Text = pub.Postcode.ToString();
            textBoxCidade.Text = pub.City.ToString();
            textBoxPais.Text = pub.Country.ToString();

            string[] dateFund = pub.Foundation_Date.ToString().Split(' ');
            textBoxDataFundacao.Text = dateFund[0];

            textBoxPermitida.Text = "NÃO";
        }

        private int RemovePublisherFromList(string Publisher_NIPC)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.removeAuthorizationList", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.Char).Value = Publisher_NIPC;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao remover publicadora da lista de autorização - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int AddPublisherToList(string Publisher_NIPC)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.addAuthorizationList", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.Char).Value = Publisher_NIPC;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception) 
            { 
                MessageBox.Show("Erro ao adicionar publicadora à lista de autorização - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void listBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox3.SelectedIndex >= 0)
            {
                listBox4.ClearSelected();
                currentSoftware = listBox3.SelectedIndex;
                buttonRemoverAutorizacao.Enabled = true;
                buttonAdicionarAutorizacao.Enabled = false;
                ShowAllowedPublisher();
            }

            if (listBox3.Items.Count == 0)
            {
                ClearFields2();
                buttonRemoverAutorizacao.Enabled = false;
            }
        }

        private void listBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox4.SelectedIndex >= 0)
            {
                listBox3.ClearSelected();
                currentSoftware = listBox4.SelectedIndex;
                buttonRemoverAutorizacao.Enabled = false;
                buttonAdicionarAutorizacao.Enabled = true;
                ShowNotAllowedPublisher();
            }

            if (listBox4.Items.Count == 0)
            {
                ClearFields2();
                buttonAdicionarAutorizacao.Enabled = false;
            }
        }

        private void buttonRemoverAutorizacao_Click(object sender, EventArgs e)
        {
            if (RemovePublisherFromList(((Publisher)listBox3.SelectedItem).NIPC) == 1)
            {
                buttonRemoverAutorizacao.Enabled = false;
                ClearFields2();
                listBox4.Items.Clear();
                listBox3.Items.Clear();
                LoadNotAuthorized();
                LoadAuthorized();
                LoadContentCanBeAddedToStore();
            }
            else
            {
                listBox3.SelectedIndex = currentSoftware;
            }
        }

        private void buttonAdicionarAutorizacao_Click(object sender, EventArgs e)
        {
            if (AddPublisherToList(((Publisher)listBox4.SelectedItem).NIPC) == 1)
            {
                buttonAdicionarAutorizacao.Enabled = false;
                ClearFields2();
                listBox4.Items.Clear();
                listBox3.Items.Clear();
                LoadNotAuthorized();
                LoadAuthorized();
                LoadContentCanBeAddedToStore();
            }
            else
            {
                listBox4.SelectedIndex = currentSoftware;
            }
        }


        /// <summary>
        /// FUNÇOES AUXILIARES
        /// </summary>
        private void ClearFields()
        {
            textBoxID.Clear();
            textBoxTipo.Clear();
            textBoxNome.Clear();
            textBoxPreco.Clear();
            textBoxDataLancamento.Clear();
            textBoxPublicadora.Clear();
            textBoxOS.Clear();
            textBoxDescricao.Clear();
            textBoxVersao.Clear();
            textBoxIdade.Clear();
            textBoxTipoJogo.Clear();
        }

        private void ClearFields2()
        {
            textBoxNIPC.Clear();
            textBoxPub_Nome.Clear();
            textBoxRua.Clear();
            textBoxCodigoPostal.Clear();
            textBoxCidade.Clear();
            textBoxPais.Clear();
            textBoxDataFundacao.Clear();
            textBoxPermitida.Clear();
        }

        private void HideOptionalInfo()
        {
            textBoxVersao.Visible = false;
            textBoxIdade.Visible = false;
            textBoxTipoJogo.Visible = false;
            labelVersao.Visible = false;
            labelAge.Visible = false;
            labelTipoJogo.Visible = false;
        }

        private void ShowToolInfo()
        {
            textBoxVersao.Visible = true;
            labelVersao.Visible = true;
        }

        private void ShowGameInfo()
        {
            textBoxIdade.Visible = true;
            textBoxTipoJogo.Visible = true;
            labelAge.Visible = true;
            labelTipoJogo.Visible = true;
        }

        private void HideToolInfo()
        {
            textBoxVersao.Visible = false;
            labelVersao.Visible = false;
        }

        private void HideGameInfo()
        {
            textBoxIdade.Visible = false;
            textBoxTipoJogo.Visible = false;
            labelAge.Visible = false;
            labelTipoJogo.Visible = false;
        }

        private void LockRemoveEdit()
        {
            buttonRemover.Enabled = false;
            buttonEditar.Enabled = false;
        }

        private void UnlockRemoveEdit()
        {
            buttonRemover.Enabled = true;
            buttonEditar.Enabled = true;
        }

        private void ShowRemoveEdit()
        {
            buttonRemover.Visible = true;
            buttonEditar.Visible = true;
        }

        private void HideRemoveEdit()
        {
            buttonRemover.Visible = false;
            buttonEditar.Visible = false;
        }

        private void ShowEditPrice()
        {
            listBox1.Enabled = false;
            buttonConfirmar.Visible = true;
            buttonCancelar.Visible = true;
            labelNovoPreco.Visible = true;
            textBoxNovoPreco.Visible = true;
            textBoxNovoPreco.ReadOnly = false;
        }

        private void HideEditPrice()
        {
            listBox1.Enabled = true;
            buttonConfirmar.Visible = false;
            buttonCancelar.Visible = false;
            labelNovoPreco.Visible = false;
            textBoxNovoPreco.Visible = false;
            textBoxNovoPreco.ReadOnly = true;
        }

        private void HideAddSoftware()
        {
            buttonConfirmarAdd.Visible = false;
            buttonExit.Visible = false;
        }

        private void ShowAddSoftware()
        {
            buttonConfirmarAdd.Visible = true;
            buttonExit.Visible = true;
        }

        private void LockAddSoftware()
        {
            buttonConfirmarAdd.Enabled = false;
        }

        private void UnlockAddSoftware()
        {
            buttonConfirmarAdd.Enabled = true;
        }

        private void HideAddNewGamePrice()
        {
            textBoxPrecoJogoNovo.Visible = false;
            labelPrecoJogoNovo.Visible = false;
        }

        private void ShowAddNewGamePrice()
        {
            textBoxPrecoJogoNovo.Visible = true;
            labelPrecoJogoNovo.Visible = true;
            textBoxPrecoJogoNovo.Enabled = true;
            textBoxPrecoJogoNovo.ReadOnly = false;

        }
    }
}
