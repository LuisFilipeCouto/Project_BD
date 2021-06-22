using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Text;
using System.Windows.Forms;

namespace Final_Project
{
    public partial class Form5 : Form
    {
        private SqlConnection cn;
        private static string connectionString;
        private int currentPublisher;
        private int currentGame;
        private int currentTool;
        private int selectedGamePublisher;
        private int selectedToolPublisher;

        public Form5(string connection)
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

        private void Form5_Load(object sender, EventArgs e)
        {
            cn = GetSGBDConnection();

            currentPublisher = -1;
            ClearPublisherFields();
            LoadPublishers();
            buttonApagarPublicadora.Enabled = false;
            buttonEditarPublicadora.Enabled = false;
            buttonConfirmarCriar.Visible = false;
            buttonCancelarCriar.Visible = false;
            buttonProcurarPublicadora.Enabled = false;
            buttonRemoverJogo.Enabled = false;
            buttonConfirmarAddJogo.Visible = false;
            buttonCancelarAddJogo.Visible = false;
            buttonProcurarJogos.Enabled = false;
            buttonLimparJogos.Enabled = false;
            comboBoxAgeRating.Visible = false;
            comboBoxJogoDia.Visible = false;
            comboBoxJogoMes.Visible = false;
            comboBoxJogoAno.Visible = false;
            labelJogoDia.Visible = false;
            labelJogoMes.Visible = false;
            labelJogoAno.Visible = false;
            checkedListBoxJogoOS.Visible = false;
            checkedListBoxJogoTipo.Visible = false;
            DenyEdit();
        }

        private void LoadPublishersToComboBox()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }
            comboBoxPublicadoraJogos.Items.Clear();
            comboBoxPublicadoraApps.Items.Clear();

            SqlCommand cmd = new SqlCommand("SELECT NIPC, Legal_Name FROM proj.Publisher", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                comboBoxPublicadoraJogos.Items.Add(reader["NIPC"].ToString() + " - " + reader["Legal_Name"].ToString());
                comboBoxPublicadoraApps.Items.Add(reader["NIPC"].ToString() + " - " + reader["Legal_Name"].ToString());
            }
            cn.Close();
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPublishersToComboBox();
            ClearGameFields();
            ClearPublisherFields();
            ClearToolFields();
            listBoxJogos.SelectedIndex = -1;
            listBoxJogos.Items.Clear();
            listBoxApps.SelectedIndex = -1;
            listBoxApps.Items.Clear();
            listBoxPublicadoras.Items.Clear();
            buttonRemoverJogo.Enabled = false;
            buttonRemoverApp.Enabled = false;
            LoadPublishers();
            buttonLimparJogos.Enabled = false;
            buttonLimparApps.Enabled = false;
            buttonProcurarJogos.Enabled = false;
            buttonProcurarApps.Enabled = false;
            buttonEditarJogo.Enabled = false;
            buttonEditarApp.Enabled = false;
            buttonCriarJogo.Enabled = false;
            buttonCriarApp.Enabled = false;
            buttonConfirmarEditarJogo.Visible = false;
            buttonCancelarEditarJogo.Visible = false;
            buttonConfirmarAddApp.Visible = false;
            buttonCancelarAddApp.Visible = false;
            buttonEditarPublicadora.Enabled = false;
            HideToolEdit();
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [GERIR PUBLICADORAS]
        /// </summary>
        private void LoadPublishers()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Publisher", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Publisher pub = new Publisher();
                pub.NIPC = reader["NIPC"].ToString();
                pub.Name = reader["Legal_Name"].ToString();
                pub.Street = reader["Street"].ToString();
                pub.Postcode = reader["Postcode"].ToString();
                pub.City = reader["City"].ToString();
                pub.Country = reader["Country"].ToString();
                pub.Foundation_Date = (DateTime)reader["Found_Date"];
                pub.IsAllowed = (bool)reader["IsAllowed"];
                listBoxPublicadoras.Items.Add(pub);
            }
            cn.Close();
        }

        private void ShowPublisher()
        {
            if (listBoxPublicadoras.Items.Count == 0 | currentPublisher < 0)
            {
                return;
            }

            Publisher pub = (Publisher)listBoxPublicadoras.Items[currentPublisher];

            textBoxNIPC.Text = pub.NIPC.ToString();
            textBoxPub_Nome.Text = pub.Name.ToString();
            textBoxRua.Text = pub.Street.ToString();
            textBoxCodigoPostal.Text = pub.Postcode.ToString();
            textBoxCidade.Text = pub.City.ToString();
            textBoxPais.Text = pub.Country.ToString();
            string[] dateFund = pub.Foundation_Date.ToString().Split(' ');
            textBoxDataFundacao.Text = dateFund[0];
            
            if (pub.IsAllowed)
            {
                textBoxPermitida.Text = "SIM";
            }
            else
            {
                textBoxPermitida.Text = "NÃO";
            }
        }

        private int DeletePublisher(string Publisher_NIPC)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.deletePublisher", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.Char).Value = Publisher_NIPC;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao apagar publicadora - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int EditPublisher(string CurrentNIPC, string NewNIPC, string Legal_Name, string Street, string Postcode, string City, string Country, string IsAllowed)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(CurrentNIPC) || string.IsNullOrEmpty(NewNIPC) || string.IsNullOrEmpty(Legal_Name) || string.IsNullOrEmpty(Street) || string.IsNullOrEmpty(Postcode) || string.IsNullOrEmpty(City) || string.IsNullOrEmpty(Country) || string.IsNullOrEmpty(IsAllowed))
            {
                MessageBox.Show("Por favor não deixe campos em branco", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.editPublisher", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@CurrentNIPC", SqlDbType.Char).Value = CurrentNIPC;
            cmd.Parameters.Add("@NewNIPC", SqlDbType.Char).Value = NewNIPC;
            cmd.Parameters.Add("@Legal_Name", SqlDbType.NVarChar).Value = Legal_Name;
            cmd.Parameters.Add("@Street", SqlDbType.NVarChar).Value = Street;
            cmd.Parameters.Add("@Postcode", SqlDbType.NVarChar).Value = Postcode;
            cmd.Parameters.Add("@City", SqlDbType.NVarChar).Value = City;
            cmd.Parameters.Add("@Country", SqlDbType.NVarChar).Value = Country;

            if(IsAllowed == "SIM")
            {
                cmd.Parameters.Add("@IsAllowed", SqlDbType.Bit).Value = 1;
            }
            else
            {
                cmd.Parameters.Add("@IsAllowed", SqlDbType.Bit).Value = 0;
            }

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            { 
                MessageBox.Show("Erro ao editar dados da Publicadora! Se alterou NIPC, verifique se este é um conjunto de 9 digitos", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private int CreatePublisher(string NIPC, string Legal_Name, string Street, string Postcode, string City, string Country, string Fday, string Fmonth, string Fyear, string IsAllowed)
        {

            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(NIPC) || string.IsNullOrEmpty(NIPC) || string.IsNullOrEmpty(Legal_Name) || string.IsNullOrEmpty(Street) || string.IsNullOrEmpty(Postcode) || string.IsNullOrEmpty(City) || string.IsNullOrEmpty(Country) || string.IsNullOrEmpty(IsAllowed))
            {
                MessageBox.Show("Por favor não deixe campos em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            string GenerateBirthdate = Fday + "/" + Fmonth + "/" + Fyear;

            if (!DateTime.TryParse(GenerateBirthdate, out DateTime Found_Date))
            {
                MessageBox.Show("Por favor introduza uma data valida!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.createPublisher", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@NIPC", SqlDbType.Char).Value = NIPC;
            cmd.Parameters.Add("@Legal_Name", SqlDbType.NVarChar).Value = Legal_Name;
            cmd.Parameters.Add("@Street", SqlDbType.NVarChar).Value = Street;
            cmd.Parameters.Add("@Postcode", SqlDbType.NVarChar).Value = Postcode;
            cmd.Parameters.Add("@City", SqlDbType.NVarChar).Value = City;
            cmd.Parameters.Add("@Country", SqlDbType.NVarChar).Value = Country;
            cmd.Parameters.Add("@Found_Date", SqlDbType.DateTime).Value = Found_Date;

            if (IsAllowed == "SIM")
            {
                cmd.Parameters.Add("@IsAllowed", SqlDbType.Bit).Value = 1;
            }
            else
            {
                cmd.Parameters.Add("@IsAllowed", SqlDbType.Bit).Value = 0;
            }

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao criar Publicadora! Verifique se NIPC é um conjunto de 9 digitos!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private void FindPublisher(string src)
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBoxPublicadoras.Items.Clear();
            SqlCommand cmd = new SqlCommand("proj.searchPublisher", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@StringFind", SqlDbType.NVarChar).Value = src;

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Publisher pub = new Publisher();
                pub.NIPC = reader["NIPC"].ToString();
                pub.Name = reader["Legal_Name"].ToString();
                pub.Street = reader["Street"].ToString();
                pub.Postcode = reader["Postcode"].ToString();
                pub.City = reader["City"].ToString();
                pub.Country = reader["Country"].ToString();
                pub.Foundation_Date = (DateTime)reader["Found_Date"];
                pub.IsAllowed = (bool)reader["IsAllowed"];
                listBoxPublicadoras.Items.Add(pub);
            }
            cn.Close();
        }

        private void listBoxPublicadoras_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxPublicadoras.SelectedIndex >= 0)
            {
                currentPublisher = listBoxPublicadoras.SelectedIndex;
                ShowPublisher();
                buttonApagarPublicadora.Enabled = true;
                buttonEditarPublicadora.Enabled = true;
            }

            if (listBoxPublicadoras.Items.Count == 0)
            {
                ClearPublisherFields();
                currentPublisher = -1; 
                buttonApagarPublicadora.Enabled = false;
                buttonEditarPublicadora.Enabled = false;
            }
        }

        private void buttonApagarPublicadora_Click(object sender, EventArgs e)
        {
            if (DeletePublisher(((Publisher)listBoxPublicadoras.SelectedItem).NIPC) == 1)
            {
                buttonApagarPublicadora.Enabled = false;
                buttonEditarPublicadora.Enabled = false;
                ClearPublisherFields();
                listBoxPublicadoras.Items.Clear();
                LoadPublishers();
            }
            else
            {
                listBoxPublicadoras.SelectedIndex = currentPublisher;
            }
        }

        private void buttonEditarPublicadora_Click(object sender, EventArgs e)
        {
            HideMainButtons();
            HideSearch();
            listBoxPublicadoras.Enabled = false;
            AllowEdit();
            PopulateCountryBox();
            PopulateAllowBox();
        }

        private void comboBoxPais_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxPais.SelectedIndex > -1)
            {
                textBoxPais.Text = comboBoxPais.SelectedItem.ToString();
            }
        }

        private void comboBoxPermitir_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxPermitir.SelectedIndex > -1)
            {
                textBoxPermitida.Text = comboBoxPermitir.SelectedItem.ToString();
            }
        }

        private void buttonCancelar_Click(object sender, EventArgs e)
        {
            listBoxPublicadoras.Items.Clear();
            ShowMainButtons();
            DenyEdit();
            LoadPublishers();
            ShowSearch();
            listBoxPublicadoras.Enabled = true;
            listBoxPublicadoras.SelectedIndex = currentPublisher;
        }

        private void buttonConfirmar_Click(object sender, EventArgs e)
        {
            if (EditPublisher(((Publisher)listBoxPublicadoras.SelectedItem).NIPC, textBoxNIPC.Text, textBoxPub_Nome.Text, textBoxRua.Text, textBoxCodigoPostal.Text, textBoxCidade.Text, comboBoxPais.SelectedItem.ToString(), comboBoxPermitir.SelectedItem.ToString()) == 1)
            {
                MessageBox.Show("Publicadora editada com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxPublicadoras.Enabled = true;
                listBoxPublicadoras.Items.Clear();
                DenyEdit();
                LoadPublishers();
                ShowPublisher();
                listBoxPublicadoras.SelectedIndex = currentPublisher;
                ShowMainButtons();
                ShowSearch();
            }
            else
            {
                ClearPublisherFields();
                ShowPublisher();
                listBoxPublicadoras.SelectedIndex = currentPublisher;
            }
        }

        private void buttonCriarPublicadora_Click(object sender, EventArgs e)
        {
            PopulateCountryBox();
            PopulateAllowBox();
            PopulateDayBox();
            PopulateMonthBox();
            PopulateYearBox();
            HideMainButtons();
            HideSearch();
            ClearPublisherFields();
            AllowCreate();
        }

        private void buttonCancelarCriar_Click(object sender, EventArgs e)
        {
            DenyCreate();
            ShowSearch();
            ShowMainButtons();
            ClearPublisherFields();
            listBoxPublicadoras.SelectedIndex = -1;
        }

        private void buttonConfirmarCriar_Click(object sender, EventArgs e)
        {
            if(CreatePublisher(textBoxNIPC.Text, textBoxPub_Nome.Text, textBoxRua.Text, textBoxCodigoPostal.Text, textBoxCidade.Text, comboBoxPais.Text, comboBoxDia.Text, comboBoxMes.Text, comboBoxAno.Text, comboBoxPermitir.Text) == 1){
                MessageBox.Show("Publicadora criada com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                DenyCreate();
                listBoxPublicadoras.Items.Clear();
                ClearPublisherFields();
                LoadPublishers();
                ShowSearch();
                ShowMainButtons();
            }
        }

        private void textBoxProcurarPublicadora_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(textBoxProcurarPublicadora.Text))
            {
                buttonProcurarPublicadora.Enabled = true;
            }
            else
            {
                buttonProcurarPublicadora.Enabled = false;
            }
        }

        private void buttonProcurarPublicadora_Click(object sender, EventArgs e)
        {
            FindPublisher(textBoxProcurarPublicadora.Text);
        }
        
        private void buttonLimpar_Click(object sender, EventArgs e)
        {
            ClearPublisherFields();
            textBoxProcurarPublicadora.Clear();
            listBoxPublicadoras.Items.Clear();
            LoadPublishers();
            buttonProcurarPublicadora.Enabled = false;
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [GERIR JOGOS]
        /// </summary>
        private void LoadGames()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getGamesByPublisher(@Publisher_NIPC)", cn);
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.Char).Value = selectedGamePublisher;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware game = new StoreSoftware();
                game.ID = (int)reader["ID"];
                game.Official_Name = reader["Official_Name"].ToString();
                game.Publisher = reader["Publisher"].ToString();
                game.Age_Rating = reader["Age_Rating"].ToString();
                game.Game_Type = reader["Type"].ToString();
                game.Release_Date = (DateTime)reader["Release_Date"];
                game.SupportedOS = reader["Supported_OS"].ToString();
                game.Brief_Description = reader["Brief_Description"].ToString();
                listBoxJogos.Items.Add(game);
            }
            cn.Close();
        }
        
        private void ShowGame()
        {
            if (listBoxJogos.Items.Count == 0 | currentGame < 0)
            {
                return;
            }

            StoreSoftware game = (StoreSoftware)listBoxJogos.Items[currentGame];

            textBoxJogoID.Text = game.ID.ToString();
            textBoxJogoNome.Text = game.Official_Name.ToString();
            textBoxJogoPublicadora.Text = game.Publisher.ToString();
            textBoxIdade.Text = game.Age_Rating.ToString();
            textBoxTipoJogo.Text = game.Game_Type.ToString();
            textBoxJogoOS.Text = game.SupportedOS.ToString();
            textBoxJogoDescricao.Text = game.Brief_Description.ToString();

            string[] dateLanc = game.Release_Date.ToString().Split(' ');
            textBoxJogoDataLancamento.Text = dateLanc[0];
        }

        private int DeleteGame(int Soft_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.deleteGame", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Soft_ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao eliminar jogo - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int CreateGame(string Official_Name, string Rday, string Rmonth, string Ryear, string NIPC, string Age_Rating, string Description, string Game_Type, string SupportedOS)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Official_Name) || string.IsNullOrEmpty(NIPC) || string.IsNullOrEmpty(Game_Type) || string.IsNullOrEmpty(SupportedOS))
            {
                MessageBox.Show("Apenas o campo Breve Descrição pode ser deixado em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            string GenerateBirthdate = Rday + "/" + Rmonth + "/" + Ryear;

            if (!DateTime.TryParse(GenerateBirthdate, out DateTime Release_Date))
            {
                MessageBox.Show("Por favor introduza uma data valida!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.createGame", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Official_Name", SqlDbType.NVarChar).Value = Official_Name;
            cmd.Parameters.Add("@Release_Date", SqlDbType.Date).Value = Release_Date;
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.NVarChar).Value = NIPC;
            cmd.Parameters.Add("@Age_Rating", SqlDbType.NVarChar).Value = Age_Rating;
            cmd.Parameters.Add("@Brief_Description", SqlDbType.NVarChar).Value = Description;
            cmd.Parameters.Add("@Game_Type", SqlDbType.NVarChar).Value = Game_Type;
            cmd.Parameters.Add("@SupportedOS", SqlDbType.NVarChar).Value = SupportedOS;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao criar Jogo - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private int EditGame(int Soft_ID, string Official_Name, string Rday, string Rmonth, string Ryear, string Age_Rating, string Description, string Game_Type, string SupportedOS)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Official_Name) || string.IsNullOrEmpty(Game_Type) || string.IsNullOrEmpty(SupportedOS))
            {
                MessageBox.Show("Apenas o campo Breve Descrição pode ser deixado em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            string GenerateBirthdate = Rday + "/" + Rmonth + "/" + Ryear;

            if (!DateTime.TryParse(GenerateBirthdate, out DateTime Release_Date))
            {
                MessageBox.Show("Por favor introduza uma data valida!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.editGame", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Soft_ID;
            cmd.Parameters.Add("@Official_Name", SqlDbType.NVarChar).Value = Official_Name;
            cmd.Parameters.Add("@Release_Date", SqlDbType.Date).Value = Release_Date;
            cmd.Parameters.Add("@Age_Rating", SqlDbType.NVarChar).Value = Age_Rating;
            cmd.Parameters.Add("@Brief_Description", SqlDbType.NVarChar).Value = Description;
            cmd.Parameters.Add("@Game_Type", SqlDbType.NVarChar).Value = Game_Type;
            cmd.Parameters.Add("@SupportedOS", SqlDbType.NVarChar).Value = SupportedOS;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao editar Jogo - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private void FindGame(string src)
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("proj.searchGame", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("Publisher_NIPC", SqlDbType.Int).Value = selectedGamePublisher;
            cmd.Parameters.Add("@StringFind", SqlDbType.NVarChar).Value = src;

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware game = new StoreSoftware();
                game.ID = (int)reader["ID"];
                game.Official_Name = reader["Official_Name"].ToString();
                game.Publisher = reader["Publisher"].ToString();
                game.Age_Rating = reader["Age_Rating"].ToString();
                game.Game_Type = reader["Type"].ToString();
                game.Release_Date = (DateTime)reader["Release_Date"];
                game.SupportedOS = reader["Supported_OS"].ToString();
                game.Brief_Description = reader["Brief_Description"].ToString();
                listBoxJogos.Items.Add(game);
            }
            cn.Close();
        }

        private void listBoxJogos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxJogos.SelectedIndex >= 0)
            {
                buttonRemoverJogo.Enabled = true;
                buttonEditarJogo.Enabled = true;
                currentGame = listBoxJogos.SelectedIndex;
                ShowGame();
            }

            if (listBoxJogos.Items.Count == 0)
            {
                ClearGameFields();
                buttonRemoverJogo.Enabled = false;
                buttonEditarJogo.Enabled = false;

            }
        }

        private void comboBoPublicadoraJogos_SelectedIndexChanged(object sender, EventArgs e)
        {
            ClearGameFields();
            listBoxJogos.Items.Clear();
            string[] info = comboBoxPublicadoraJogos.SelectedItem.ToString().Split(" - ");
            buttonCriarJogo.Enabled = true;
            selectedGamePublisher = Int32.Parse(info[0]);
            LoadGames();
            buttonConfirmarAddJogo.Enabled = true;
            buttonProcurarJogos.Enabled = true;
            buttonLimparJogos.Enabled = true;
        }

        private void buttonRemoverJogo_Click(object sender, EventArgs e)
        {
            if (DeleteGame(((StoreSoftware)listBoxJogos.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Jogo eliminado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxJogos.Items.RemoveAt(listBoxJogos.SelectedIndex);
                ClearGameFields();
                buttonRemoverJogo.Enabled = false;
                buttonEditarJogo.Enabled = false;
            }
            else
            {
                listBoxJogos.SelectedIndex = currentGame;
            }
        }

        private void buttonCriarJogo_Click(object sender, EventArgs e)
        {
            HideSearchGame();
            listBoxJogos.Visible = false;
            buttonRemoverJogo.Visible = false;
            buttonCriarJogo.Visible = false;
            buttonEditarJogo.Visible = false;
            labelListaJogos.Visible = false;
            buttonConfirmarAddJogo.Visible = true;
            buttonCancelarAddJogo.Visible = true;
            textBoxJogoID.Visible = false;
            labelID.Visible = false;
            comboBoxAgeRating.Visible = true;
            comboBoxJogoDia.Visible = true;
            comboBoxJogoMes.Visible = true;
            comboBoxJogoAno.Visible = true;
            labelJogoDia.Visible = true;
            labelJogoMes.Visible = true;
            labelJogoAno.Visible = true;
            textBoxJogoNome.ReadOnly = false;
            textBoxJogoDescricao.ReadOnly = false;
            checkedListBoxJogoOS.Visible = true;
            checkedListBoxJogoTipo.Visible = true;
            ClearGameFields();
            PopulateGameDayBox();
            PopulateGameMonthBox();
            PopulateGameYearBox();
            PopulateAgeRating();

            if(comboBoxPublicadoraJogos.SelectedIndex < 0)
            {
                buttonConfirmarAddJogo.Enabled = false;
            }

            else
            {
                buttonConfirmarAddJogo.Enabled = true;
            }
        }

        private void buttonCancelarAddJogo_Click(object sender, EventArgs e)
        {
            ShowSearchGame();
            listBoxJogos.Visible = true;
            listBoxJogos.SelectedIndex = -1;
            buttonRemoverJogo.Visible = true;
            buttonCriarJogo.Visible = true;
            labelListaJogos.Visible = true;
            buttonConfirmarAddJogo.Visible = false;
            buttonCancelarAddJogo.Visible = false;
            buttonEditarJogo.Visible = true;
            textBoxJogoID.Visible = true;
            labelID.Visible = true;
            comboBoxAgeRating.Visible = false;
            comboBoxJogoDia.Visible = false;
            comboBoxJogoMes.Visible = false;
            comboBoxJogoAno.Visible = false;
            labelJogoDia.Visible = false;
            labelJogoMes.Visible = false;
            labelJogoAno.Visible = false;
            textBoxJogoNome.ReadOnly = true;
            textBoxJogoDescricao.ReadOnly = true;

            for (int i = 0; i < checkedListBoxJogoOS.Items.Count; i++)
            {
                checkedListBoxJogoOS.SetItemChecked(i, false);
            }
            checkedListBoxJogoOS.Visible = false;

            for (int i = 0; i < checkedListBoxJogoTipo.Items.Count; i++)
            {
                checkedListBoxJogoTipo.SetItemChecked(i, false);
            }
            checkedListBoxJogoTipo.Visible = false;
            ClearGameFields();
        }

        private void buttonConfirmarAddJogo_Click(object sender, EventArgs e)
        {
            string typelist = "";
            foreach (var type in checkedListBoxJogoTipo.CheckedItems)
            {
                typelist += type + ",";
            }

            string OSlist = "";
            foreach (var type in checkedListBoxJogoOS.CheckedItems)
            {
                OSlist += type + ",";
            }

            if (CreateGame(textBoxJogoNome.Text, comboBoxJogoDia.Text, comboBoxJogoMes.Text, comboBoxJogoAno.Text, selectedGamePublisher.ToString(), comboBoxAgeRating.Text, textBoxJogoDescricao.Text, typelist, OSlist) == 1)
            {
                MessageBox.Show("Jogo criado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxJogos.Items.Clear();
                listBoxJogos.Visible = true;
                buttonRemoverJogo.Visible = true;
                buttonCriarJogo.Visible = true;
                labelListaJogos.Visible = true;
                buttonConfirmarAddJogo.Visible = false;
                buttonCancelarAddJogo.Visible = false;
                buttonEditarJogo.Visible = true;
                textBoxJogoID.Visible = true;
                labelID.Visible = true;
                comboBoxAgeRating.Visible = false;
                comboBoxJogoDia.Visible = false;
                comboBoxJogoMes.Visible = false;
                comboBoxJogoAno.Visible = false;
                labelJogoDia.Visible = false;
                labelJogoMes.Visible = false;
                labelJogoAno.Visible = false;
                textBoxJogoNome.ReadOnly = true;
                textBoxJogoDescricao.ReadOnly = true;
                checkedListBoxJogoOS.Visible = false;
                checkedListBoxJogoTipo.Visible = false;
                ClearGameFields();
                LoadGames();
                ShowSearchGame();
            }
        }

        private void buttonEditarJogo_Click(object sender, EventArgs e)
        {
            listBoxJogos.Enabled = false;
            HideSearchGame();
            buttonRemoverJogo.Visible = false;
            buttonCriarJogo.Visible = false;
            buttonConfirmarEditarJogo.Visible = true;
            buttonCancelarEditarJogo.Visible = true;
            buttonEditarJogo.Visible = false;
            PopulateAgeRating();
            PopulateGameDayBox();
            PopulateGameMonthBox();
            PopulateGameYearBox();
            comboBoxAgeRating.Visible = true;
            comboBoxJogoMes.Visible = true;
            comboBoxJogoDia.Visible = true;
            comboBoxJogoAno.Visible = true;
            checkedListBoxJogoOS.Visible = true;
            checkedListBoxJogoTipo.Visible = true;
            textBoxJogoNome.ReadOnly = false;
            textBoxJogoDescricao.ReadOnly = false;
        }

        private void buttonCancelarEditarJogo_Click(object sender, EventArgs e)
        {
            listBoxJogos.Enabled = true;
            ShowSearchGame();
            buttonRemoverJogo.Visible = true;
            buttonCriarJogo.Visible = true;
            buttonConfirmarEditarJogo.Visible = false;
            buttonCancelarEditarJogo.Visible = false;
            buttonEditarJogo.Visible = true;
            ClearGameFields();
            ShowGame();
            comboBoxAgeRating.Visible = false;
            comboBoxJogoMes.Visible = false;
            comboBoxJogoDia.Visible = false;
            comboBoxJogoAno.Visible = false;
            checkedListBoxJogoOS.Visible = false;
            checkedListBoxJogoTipo.Visible = false;
            textBoxJogoNome.ReadOnly = true;
            textBoxJogoDescricao.ReadOnly = true;
            checkedListBoxAppOS.Visible = false;
        }

        private void buttonConfirmarEditarJogo_Click(object sender, EventArgs e)
        {
            string typelist = "";
            foreach (var type in checkedListBoxJogoTipo.CheckedItems)
            {
                typelist += type + ",";
            }

            string OSlist = "";
            foreach (var type in checkedListBoxJogoOS.CheckedItems)
            {
                OSlist += type + ",";
            }

            if (EditGame(((StoreSoftware)listBoxJogos.SelectedItem).ID, textBoxJogoNome.Text, comboBoxJogoDia.Text, comboBoxJogoMes.Text, comboBoxJogoAno.Text, comboBoxAgeRating.Text, textBoxJogoDescricao.Text, typelist, OSlist) == 1)
            {
                MessageBox.Show("Jogo editado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxJogos.Items.Clear();
                listBoxJogos.Visible = true;
                listBoxJogos.Enabled = true;
                buttonRemoverJogo.Visible = true;
                buttonCriarJogo.Visible = true;
                labelListaJogos.Visible = true;
                buttonEditarJogo.Visible = true;
                buttonConfirmarEditarJogo.Visible = false;
                buttonCancelarEditarJogo.Visible = false;
                textBoxJogoID.Visible = true;
                labelID.Visible = true;
                comboBoxAgeRating.Visible = false;
                comboBoxJogoDia.Visible = false;
                comboBoxJogoMes.Visible = false;
                comboBoxJogoAno.Visible = false;
                labelJogoDia.Visible = false;
                labelJogoMes.Visible = false;
                labelJogoAno.Visible = false;
                textBoxJogoNome.ReadOnly = true;
                textBoxJogoDescricao.ReadOnly = true;
                checkedListBoxAppOS.Visible = false;
                checkedListBoxJogoOS.Visible = false;
                checkedListBoxJogoTipo.Visible = false;
                ClearGameFields();
                LoadGames();
                ShowSearchGame();
            }

        }

        private void textBoxProcurarJogos_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(textBoxProcurarJogos.Text) && selectedGamePublisher > 0)
            {
                buttonProcurarJogos.Enabled = true;
            }
            else
            {
                buttonProcurarPublicadora.Enabled = false;
            }
        }

        private void buttonProcurarJogos_Click(object sender, EventArgs e)
        {
            listBoxJogos.Items.Clear();
            FindGame(textBoxProcurarJogos.Text);
        }

        private void buttonLimparJogos_Click(object sender, EventArgs e)
        {
            ClearGameFields();
            textBoxProcurarJogos.Clear();
            listBoxJogos.Items.Clear();
            LoadGames();
            buttonRemoverJogo.Enabled = false;
            buttonEditarJogo.Enabled = false;
        }


        /// <summary>
        /// CONJUNTO DE FUNCOES NECESSARIAS PARA [GERIR APLICACOES]
        /// </summary>
        private void LoadTools()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.getToolsByPublisher(@Publisher_NIPC)", cn);
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.Char).Value = selectedToolPublisher;
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware tool = new StoreSoftware();
                tool.ID = (int)reader["ID"];
                tool.Official_Name = reader["Official_Name"].ToString();
                tool.Publisher = reader["Publisher"].ToString();
                tool.Current_Version = reader["Current_Version"].ToString();
                tool.Release_Date = (DateTime)reader["Release_Date"];
                tool.SupportedOS = reader["Supported_OS"].ToString();
                tool.Brief_Description = reader["Brief_Description"].ToString();
                listBoxApps.Items.Add(tool);
            }
            cn.Close();
        }

        private void ShowTool()
        {
            if (listBoxApps.Items.Count == 0 | currentTool < 0)
            {
                return;
            }

            StoreSoftware tool = (StoreSoftware)listBoxApps.Items[currentTool];

            textBoxAppID.Text = tool.ID.ToString();
            textBoxAppNome.Text = tool.Official_Name.ToString();
            textBoxAppPublicadora.Text = tool.Publisher.ToString();
            textBoxVersao.Text = tool.Current_Version.ToString();
            textBoxAppOS.Text = tool.SupportedOS.ToString();
            textBoxAppDescricao.Text = tool.Brief_Description.ToString();

            string[] dateLanc = tool.Release_Date.ToString().Split(' ');
            textBoxAppDataLancamento.Text = dateLanc[0];
        }

        private int DeleteTool(int Soft_ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.deleteTool", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Soft_ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao eliminar Aplicação - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private int EditTool(int Soft_ID, string Official_Name, string Rday, string Rmonth, string Ryear, string Current_Version, string Description, string SupportedOS)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Official_Name) || string.IsNullOrEmpty(SupportedOS))
            {
                MessageBox.Show("Apenas o campo Breve Descrição pode ser deixado em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            string GenerateBirthdate = Rday + "/" + Rmonth + "/" + Ryear;

            if (!DateTime.TryParse(GenerateBirthdate, out DateTime Release_Date))
            {
                MessageBox.Show("Por favor introduza uma data valida!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.editTool", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Software_ID", SqlDbType.Int).Value = Soft_ID;
            cmd.Parameters.Add("@Official_Name", SqlDbType.NVarChar).Value = Official_Name;
            cmd.Parameters.Add("@Release_Date", SqlDbType.Date).Value = Release_Date;
            cmd.Parameters.Add("@Current_Version", SqlDbType.NVarChar).Value = Current_Version;
            cmd.Parameters.Add("@Brief_Description", SqlDbType.NVarChar).Value = Description;
            cmd.Parameters.Add("@SupportedOS", SqlDbType.NVarChar).Value = SupportedOS;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao editar Aplicação - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private int CreateTool(string Official_Name, string Rday, string Rmonth, string Ryear, string NIPC, string Current_Version, string Description, string SupportedOS)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Official_Name) || string.IsNullOrEmpty(NIPC) || string.IsNullOrEmpty(SupportedOS))
            {
                MessageBox.Show("Apenas o campo Breve Descrição pode ser deixado em branco!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            string GenerateBirthdate = Rday + "/" + Rmonth + "/" + Ryear;

            if (!DateTime.TryParse(GenerateBirthdate, out DateTime Release_Date))
            {
                MessageBox.Show("Por favor introduza uma data valida!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.createTool", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Official_Name", SqlDbType.NVarChar).Value = Official_Name;
            cmd.Parameters.Add("@Release_Date", SqlDbType.Date).Value = Release_Date;
            cmd.Parameters.Add("@Publisher_NIPC", SqlDbType.NVarChar).Value = NIPC;
            cmd.Parameters.Add("@Current_Version", SqlDbType.NVarChar).Value = Current_Version;
            cmd.Parameters.Add("@Brief_Description", SqlDbType.NVarChar).Value = Description;
            cmd.Parameters.Add("@SupportedOS", SqlDbType.NVarChar).Value = SupportedOS;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao criar Aplicação - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private void FindTool(string src)
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("proj.searchTool", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("Publisher_NIPC", SqlDbType.Int).Value = selectedToolPublisher;
            cmd.Parameters.Add("@StringFind", SqlDbType.NVarChar).Value = src;

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                StoreSoftware tool = new StoreSoftware();
                tool.ID = (int)reader["ID"];
                tool.Official_Name = reader["Official_Name"].ToString();
                tool.Publisher = reader["Publisher"].ToString();
                tool.Current_Version = reader["Current_Version"].ToString();
                tool.Release_Date = (DateTime)reader["Release_Date"];
                tool.SupportedOS = reader["Supported_OS"].ToString();
                tool.Brief_Description = reader["Brief_Description"].ToString();
                listBoxApps.Items.Add(tool);
            }
            cn.Close();
        }

        private void listBoxApps_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxApps.SelectedIndex >= 0)
            {
                buttonRemoverApp.Enabled = true;
                buttonEditarApp.Enabled = true;
                currentTool= listBoxApps.SelectedIndex;
                ShowTool();
            }

            if (listBoxApps.Items.Count == 0)
            {
                ClearToolFields();
                buttonRemoverApp.Enabled = false;
                buttonEditarApp.Enabled = false;
                buttonEditarApp.Enabled = false;
            }
        }

        private void comboBoxPublicadoraApps_SelectedIndexChanged(object sender, EventArgs e)
        {
            ClearToolFields();
            listBoxApps.Items.Clear();
            string[] info = comboBoxPublicadoraApps.SelectedItem.ToString().Split(" - ");
            buttonCriarApp.Enabled = true;
            selectedToolPublisher = Int32.Parse(info[0]);
            LoadTools();
            buttonConfirmarAddApp.Enabled = true;
            buttonProcurarApps.Enabled = true;
            buttonLimparApps.Enabled = true;
        }

        private void buttonRemoverApp_Click(object sender, EventArgs e)
        {
            if (DeleteTool(((StoreSoftware)listBoxApps.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Aplicação eliminado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxApps.Items.RemoveAt(listBoxApps.SelectedIndex);
                ClearToolFields();
                buttonRemoverApp.Enabled = false;
                buttonEditarApp.Enabled = false;
            }
            else
            {
                listBoxApps.SelectedIndex = currentTool;
            }
        }

        private void buttonEditarApp_Click(object sender, EventArgs e)
        {
            listBoxApps.Enabled = false;
            HideSearchTool();
            buttonRemoverApp.Visible = false;
            buttonCriarApp.Visible = false;
            buttonConfirmarEditarApp.Visible = true;
            buttonCancelarEditarApp.Visible = true;
            buttonEditarApp.Visible = false;
            PopulateVersion();
            PopulateToolDayBox();
            PopulateToolMonthBox();
            PopulateToolYearBox();
            ShowToolEdit();
        }

        private void buttonCancelarEditarApp_Click(object sender, EventArgs e)
        {
            listBoxApps.Enabled = true;
            ShowSearchTool();
            buttonRemoverApp.Visible = true;
            buttonCriarApp.Visible = true;
            buttonConfirmarEditarApp.Visible = false;
            buttonCancelarEditarApp.Visible = false;
            buttonEditarApp.Visible = true;
            ClearToolFields();
            ShowTool();
            HideToolEdit();
        }

        private void buttonConfirmarEditarApp_Click(object sender, EventArgs e)
        {
            string OSlist = "";
            foreach (var type in checkedListBoxAppOS.CheckedItems)
            {
                OSlist += type + ",";
            }

            if (EditTool(((StoreSoftware)listBoxApps.SelectedItem).ID, textBoxAppNome.Text, comboBoxAppDia.Text, comboBoxAppMes.Text, comboBoxAppAno.Text, comboBoxVersao.Text, textBoxAppDescricao.Text, OSlist) == 1)
            {
                MessageBox.Show("Aplicação editada com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxApps.Items.Clear();
                listBoxApps.Visible = true;
                listBoxApps.Enabled = true;
                buttonRemoverApp.Visible = true;
                buttonCriarApp.Visible = true;
                labelListaApps.Visible = true;
                buttonEditarApp.Visible = true;
                buttonConfirmarEditarApp.Visible = false;
                buttonCancelarEditarApp.Visible = false;
                textBoxAppID.Visible = true;
                labelAppID.Visible = true;
                comboBoxVersao.Visible = false;
                comboBoxAppDia.Visible = false;
                comboBoxAppMes.Visible = false;
                comboBoxAppAno.Visible = false;
                labelAppDia.Visible = false;
                labelAppMes.Visible = false;
                labelAppAno.Visible = false;
                textBoxAppNome.ReadOnly = true;
                textBoxAppDescricao.ReadOnly = true;
                checkedListBoxAppOS.Visible = false;
                ClearToolFields();
                LoadTools();
                ShowSearchTool();
            }
        }

        private void buttonCriarApp_Click(object sender, EventArgs e)
        {
            HideSearchTool();
            listBoxApps.Visible = false;
            buttonRemoverApp.Visible = false;
            buttonCriarApp.Visible = false;
            buttonEditarApp.Visible = false;
            labelListaApps.Visible = false;
            buttonConfirmarAddApp.Visible = true;
            buttonCancelarAddApp.Visible = true;
            textBoxAppID.Visible = false;
            labelAppID.Visible = false;
            labelAppAno.Visible = true;
            labelAppDia.Visible = true;
            labelAppMes.Visible = true;
            comboBoxAppAno.Visible = true;
            comboBoxAppMes.Visible = true;
            comboBoxAppDia.Visible = true;
            comboBoxVersao.Visible = true;
            checkedListBoxAppOS.Visible = true;
            textBoxAppNome.ReadOnly = false;
            textBoxAppDescricao.ReadOnly = false;
            ClearToolFields();
            PopulateToolDayBox();
            PopulateToolMonthBox();
            PopulateToolYearBox();
            PopulateVersion();

            if (comboBoxPublicadoraApps.SelectedIndex < 0)
            {
                buttonConfirmarAddApp.Enabled = false;
            }

            else
            {
                buttonConfirmarAddApp.Enabled = true;
            }
        }

        private void buttonCancelarAddApp_Click(object sender, EventArgs e)
        {
            ShowSearchTool();
            listBoxApps.Visible = true;
            listBoxApps.SelectedIndex = -1;
            buttonRemoverApp.Visible = true;
            buttonCriarApp.Visible = true;
            labelListaApps.Visible = true;
            buttonConfirmarAddApp.Visible = false;
            buttonCancelarAddApp.Visible = false;
            buttonEditarApp.Visible = true;
            textBoxAppID.Visible = true;
            labelID.Visible = true;
            buttonConfirmarAddApp.Visible = false;
            buttonCancelarAddApp.Visible = false;
            labelAppAno.Visible = false;
            labelAppDia.Visible = false;
            labelAppMes.Visible = false;
            comboBoxAppAno.Visible = false;
            comboBoxAppMes.Visible = false;
            comboBoxAppDia.Visible = false;
            comboBoxVersao.Visible = false;
            checkedListBoxAppOS.Visible = false;
            textBoxJogoNome.ReadOnly = true;
            textBoxJogoDescricao.ReadOnly = true;

            for (int i = 0; i < checkedListBoxAppOS.Items.Count; i++)
            {
                checkedListBoxAppOS.SetItemChecked(i, false);
            }
            checkedListBoxAppOS.Visible = false;

            ClearToolFields();
        }

        private void buttonConfirmarAddApp_Click(object sender, EventArgs e)
        {
            string OSlist = "";
            foreach (var type in checkedListBoxAppOS.CheckedItems)
            {
                OSlist += type + ",";
            }

            if (CreateTool(textBoxAppNome.Text, comboBoxAppDia.Text, comboBoxAppMes.Text, comboBoxAppAno.Text, selectedToolPublisher.ToString(), comboBoxVersao.Text, textBoxAppDescricao.Text, OSlist) == 1)
            {
                MessageBox.Show("Aplicação criada com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxApps.Items.Clear();
                listBoxApps.Visible = true;
                buttonRemoverApp.Visible = true;
                buttonCriarApp.Visible = true;
                labelListaApps.Visible = true;
                buttonConfirmarAddApp.Visible = false;
                buttonCancelarAddApp.Visible = false;
                buttonEditarApp.Visible = true;
                textBoxAppID.Visible = true;
                labelAppID.Visible = true;
                comboBoxVersao.Visible = false;
                comboBoxAppDia.Visible = false;
                comboBoxAppMes.Visible = false;
                comboBoxAppAno.Visible = false;
                labelAppDia.Visible = false;
                labelAppMes.Visible = false;
                labelAppAno.Visible = false;
                textBoxAppNome.ReadOnly = true;
                textBoxAppDescricao.ReadOnly = true;
                checkedListBoxAppOS.Visible = false;
                ClearToolFields();
                LoadTools();
                ShowSearchTool();
            }
        }

        private void textBoxProcurarApps_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(textBoxProcurarApps.Text) && selectedToolPublisher > 0)
            {
                buttonProcurarApps.Enabled = true;
            }
            else
            {
                buttonProcurarApps.Enabled = false;
            }
        }

        private void buttonProcurarApps_Click(object sender, EventArgs e)
        {
            listBoxApps.Items.Clear();
            FindTool(textBoxProcurarApps.Text);
        }

        private void buttonLimparApps_Click(object sender, EventArgs e)
        {
            ClearToolFields();
            textBoxProcurarApps.Clear();
            listBoxApps.Items.Clear();
            LoadTools();
            buttonRemoverApp.Enabled = false;
            buttonEditarApp.Enabled = false;
        }


        /// <summary>
        /// FUNÇOES AUXILIARES
        /// </summary>
        public static List<string> CountryList()
        {
            List<string> CountryList = new List<string>();
            CultureInfo[] getCountries = CultureInfo.GetCultures(CultureTypes.SpecificCultures);

            foreach (CultureInfo elem in getCountries)
            {
                RegionInfo getRegion = new RegionInfo(elem.LCID);

                if (!CountryList.Contains(getRegion.EnglishName))
                {
                    CountryList.Add(getRegion.EnglishName);
                }
            }

            CountryList.Sort();
            return CountryList;
        }

        private static List<string> YearList()
        {
            List<string> YearList = new List<string>();
            int current = int.Parse(DateTime.Now.Year.ToString());

            for (int i = 1900; i <= current; i++)
            {
                YearList.Add(i.ToString());
            }

            YearList.Sort();
            YearList.Reverse();
            return YearList;
        }

        private static List<string> MonthList()
        {
            List<string> MonthList = new List<string>();
            MonthList.Add("01");
            MonthList.Add("02");
            MonthList.Add("03");
            MonthList.Add("04");
            MonthList.Add("05");
            MonthList.Add("06");
            MonthList.Add("07");
            MonthList.Add("08");
            MonthList.Add("09");
            MonthList.Add("10");
            MonthList.Add("11");
            MonthList.Add("12");

            MonthList.Sort();
            return MonthList;
        }

        private static List<string> DayList()
        {
            List<string> DayList = new List<string>();
            DayList.Add("01");
            DayList.Add("02");
            DayList.Add("03");
            DayList.Add("04");
            DayList.Add("05");
            DayList.Add("06");
            DayList.Add("07");
            DayList.Add("08");
            DayList.Add("09");
            DayList.Add("10");
            DayList.Add("11");
            DayList.Add("12");
            DayList.Add("13");
            DayList.Add("14");
            DayList.Add("15");
            DayList.Add("16");
            DayList.Add("17");
            DayList.Add("18");
            DayList.Add("19");
            DayList.Add("20");
            DayList.Add("21");
            DayList.Add("22");
            DayList.Add("23");
            DayList.Add("24");
            DayList.Add("25");
            DayList.Add("26");
            DayList.Add("27");
            DayList.Add("28");
            DayList.Add("29");
            DayList.Add("30");
            DayList.Add("31");

            DayList.Sort();
            return DayList;
        }

        private static List<string> VersionList()
        {
            List<string> VersionList = new List<string>();

            VersionList.Add("BETA");

            for (int major = 0; major < 11; major++)
            {
                for (int minor = 1; minor < 11; minor++) {

                    for (int fix = 0; fix < 11; fix++)
                    {
                        string currentVersion = major + "." + minor + "." + fix;
                        VersionList.Add(currentVersion);
                    }

                }
            }

            // VersionList.Sort();
            return VersionList;
        }

        private void PopulateDayBox()
        {
            comboBoxDia.DataSource = DayList();
            comboBoxAppDia.DataSource = DayList();
        }

        private void PopulateMonthBox()
        {
            comboBoxMes.DataSource = MonthList();
            comboBoxAppMes.DataSource = MonthList();
        }

        private void PopulateYearBox()
        {
            comboBoxAno.DataSource = YearList();
            comboBoxAppAno.DataSource = YearList();
        }

        private void PopulateCountryBox()
        {
            comboBoxPais.DataSource = CountryList();
        }

        private void PopulateAllowBox()
        {
            List<string> Options = new List<string>();
            Options.Add("SIM");
            Options.Add("NÃO");

            comboBoxPermitir.DataSource = Options;
        }

        private void PopulateGameDayBox()
        {
            comboBoxJogoDia.DataSource = DayList();
        }

        private void PopulateGameMonthBox()
        {
            comboBoxJogoMes.DataSource = MonthList();
        }

        private void PopulateGameYearBox()
        {
            comboBoxJogoAno.DataSource = YearList();
        }

        private void PopulateToolDayBox()
        {
            comboBoxAppDia.DataSource = DayList();
        }

        private void PopulateToolMonthBox()
        {
            comboBoxAppMes.DataSource = MonthList();
        }

        private void PopulateToolYearBox()
        {
            comboBoxAppAno.DataSource = YearList();
        }

        private void PopulateAgeRating()
        {
            List<string> AgeRatings = new List<string>();
            AgeRatings.Add("E");
            AgeRatings.Add("T");
            AgeRatings.Add("M");
            AgeRatings.Add("A");
            AgeRatings.Add("Non-Rated");
            comboBoxAgeRating.DataSource = AgeRatings;
        }

        private void PopulateVersion()
        {
            comboBoxVersao.DataSource = VersionList();
        }

        private void ClearPublisherFields()
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

        private void ClearGameFields()
        {
            textBoxJogoID.Clear();
            textBoxJogoNome.Clear();
            textBoxJogoPublicadora.Clear();
            textBoxIdade.Clear();
            textBoxTipoJogo.Clear();
            textBoxJogoOS.Clear();
            textBoxJogoDescricao.Clear();
            textBoxJogoDataLancamento.Clear();
        }

        private void ClearToolFields()
        {
            textBoxAppID.Clear();
            textBoxAppNome.Clear();
            textBoxAppPublicadora.Clear();
            textBoxVersao.Clear();
            textBoxAppOS.Clear();
            textBoxAppDescricao.Clear();
            textBoxAppDataLancamento.Clear();
        }

        private void HideMainButtons()
        {
            buttonApagarPublicadora.Visible = false;
            buttonCriarPublicadora.Visible = false;
            buttonEditarPublicadora.Visible = false;
            buttonConfirmar.Visible = false;
            buttonCancelar.Visible = false;
        }

        private void ShowMainButtons()
        {
            buttonApagarPublicadora.Visible = true;
            buttonCriarPublicadora.Visible = true;
            buttonEditarPublicadora.Visible = true;
        }

        private void AllowEdit()
        {
            textBoxNIPC.ReadOnly = false;
            textBoxPub_Nome.ReadOnly = false;
            textBoxRua.ReadOnly = false;
            textBoxCodigoPostal.ReadOnly = false;
            textBoxCidade.ReadOnly = false;
            buttonConfirmar.Visible = true;
            buttonCancelar.Visible = true;
            comboBoxPais.Visible = true;
            comboBoxPermitir.Visible = true;
        }

        private void DenyEdit()
        {
            textBoxNIPC.ReadOnly = true;
            textBoxPub_Nome.ReadOnly = true;
            textBoxRua.ReadOnly = true;
            textBoxCodigoPostal.ReadOnly = true;
            textBoxCidade.ReadOnly = true;
            buttonConfirmar.Visible = false;
            buttonCancelar.Visible = false;
            comboBoxPais.Visible = false;
            comboBoxPermitir.Visible = false;
            comboBoxDia.Visible = false;
            comboBoxMes.Visible = false;
            comboBoxAno.Visible = false;
            labelDia.Visible = false;
            labelMes.Visible = false;
            labelAno.Visible = false;
        }

        private void HideSearch()
        {
            textBoxProcurarPublicadora.Visible = false;
            buttonLimpar.Visible = false;
            buttonProcurarPublicadora.Visible = false;
        }

        private void HideSearchGame()
        {
            textBoxProcurarJogos.Visible = false;
            buttonLimparJogos.Visible = false;
            buttonProcurarJogos.Visible = false;
        }

        private void HideSearchTool()
        {
            textBoxProcurarApps.Visible = false;
            buttonLimparApps.Visible = false;
            buttonProcurarApps.Visible = false;
        }

        private void ShowSearch()
        {
            textBoxProcurarPublicadora.Visible = true;
            buttonLimpar.Visible = true;
            buttonProcurarPublicadora.Visible = true;
        }

        private void ShowSearchGame()
        {
            textBoxProcurarJogos.Visible = true;
            buttonLimparJogos.Visible = true;
            buttonProcurarJogos.Visible = true;
        }

        private void ShowSearchTool()
        {
            textBoxProcurarApps.Visible = true;
            buttonLimparApps.Visible = true;
            buttonProcurarApps.Visible = true;
        }

        private void AllowCreate()
        {
            textBoxNIPC.ReadOnly = false;
            textBoxPub_Nome.ReadOnly = false;
            textBoxRua.ReadOnly = false;
            textBoxCodigoPostal.ReadOnly = false;
            textBoxCidade.ReadOnly = false;
            comboBoxPais.Visible = true;
            comboBoxPermitir.Visible = true;
            comboBoxAno.Visible = true;
            comboBoxMes.Visible = true;
            comboBoxDia.Visible = true;
            textBoxDataFundacao.Enabled = false;
            labelAno.Visible = true;
            labelMes.Visible = true;
            labelDia.Visible = true;
            buttonCancelarCriar.Visible = true;
            buttonConfirmarCriar.Visible = true;
            listBoxPublicadoras.Visible = false;
            labelPublicadoras.Visible = false;
        }

        private void DenyCreate()
        {
            textBoxNIPC.ReadOnly = true;
            textBoxPub_Nome.ReadOnly = true;
            textBoxRua.ReadOnly = true;
            textBoxCodigoPostal.ReadOnly = true;
            textBoxCidade.ReadOnly = true;
            textBoxDataFundacao.Enabled = true;
            textBoxCidade.ReadOnly = true;
            comboBoxPais.Visible = false;
            comboBoxPermitir.Visible = false;
            comboBoxAno.Visible = false;
            comboBoxMes.Visible = false;
            comboBoxDia.Visible = false;
            textBoxDataFundacao.Enabled = false;
            labelAno.Visible = false;
            labelMes.Visible = false;
            labelDia.Visible = false;
            buttonCancelarCriar.Visible = false;
            buttonConfirmarCriar.Visible = false;
            listBoxPublicadoras.Visible = true;
            labelPublicadoras.Visible = true;
        }

        private void HideToolEdit()
        {
            buttonConfirmarEditarApp.Visible = false;
            buttonCancelarEditarApp.Visible = false;
            labelAppAno.Visible = false;
            labelAppDia.Visible = false;
            labelAppMes.Visible = false;
            comboBoxAppAno.Visible = false;
            comboBoxAppMes.Visible = false;
            comboBoxAppDia.Visible = false;
            comboBoxVersao.Visible = false;
            checkedListBoxAppOS.Visible = false;
            textBoxJogoNome.ReadOnly = true;
            textBoxJogoDescricao.ReadOnly = true;
        }

        private void ShowToolEdit()
        {
            buttonConfirmarEditarApp.Visible = true;
            buttonCancelarEditarApp.Visible = true;
            labelAppAno.Visible = true;
            labelAppDia.Visible = true;
            labelAppMes.Visible = true;
            comboBoxAppAno.Visible = true;
            comboBoxAppMes.Visible = true;
            comboBoxAppDia.Visible = true;
            comboBoxVersao.Visible = true;
            checkedListBoxAppOS.Visible = true;
            textBoxAppNome.ReadOnly = false;
            textBoxAppDescricao.ReadOnly = false;
        }   
    }
}
