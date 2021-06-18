using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.Globalization;

namespace Final_Project
{
    public partial class Form4 : Form
    {
        private SqlConnection cn;
        private static string connectionString;
        private int currentSoftware;

        public Form4(string connection)
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

        private void Form4_Load(object sender, System.EventArgs e)
        {
            cn = GetSGBDConnection();
            LoadRegisteredUser();
            HideEdit();
            HideInfo();
            HideAdd();
            buttonProcurar.Enabled = false;
        }

        private void LoadRegisteredUser()
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            SqlCommand cmd = new SqlCommand("SELECT * FROM proj.Show_All_Users", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                AppUser appuser = new AppUser();
                appuser.ID = (int)reader["ID"];
                appuser.Email = reader["Email"].ToString();
                appuser.Fname = reader["Fname"].ToString();
                appuser.Lname = reader["Lname"].ToString();
                appuser.Birthdate = (DateTime)reader["Birthdate"];
                appuser.Sex = reader["Sex"].ToString();
                appuser.Street = reader["Street"].ToString();
                appuser.Postcode = reader["Postcode"].ToString();
                appuser.City = reader["City"].ToString();
                appuser.Country = reader["Country"].ToString();
                appuser.Balance = (decimal)reader["Balance"];
                listBoxUtilizadoresRegistados.Items.Add(appuser);
            }
            cn.Close();
        }

        private void ShowUser()
        {
            if (listBoxUtilizadoresRegistados.Items.Count == 0 | currentSoftware < 0)
            {
                return;
            }

            AppUser appuser = (AppUser)listBoxUtilizadoresRegistados.Items[currentSoftware];

            textBoxID.Text = appuser.ID.ToString();
            textBoxEmail.Text = appuser.Email.ToString();
            textBoxPrimeiroNome.Text = appuser.Fname.ToString();
            textBoxUltimoNome.Text = appuser.Lname.ToString();

            string[] dataNasc = appuser.Birthdate.ToString().Split(' ');
            textBoxDataNascimento.Text = dataNasc[0];

            textBoxRua.Text = appuser.Street.ToString();
            textBoxCodigoPostal.Text = appuser.Postcode.ToString();
            textBoxCidade.Text = appuser.City.ToString();
            textBoxPais.Text = appuser.Country.ToString();

            if (appuser.Sex == "F")
            {
                textBoxSexo.Text = "Feminino";
            }
            else if (appuser.Sex == "M")
            {
                textBoxSexo.Text = "Masculino";
            }
            else
            {
                textBoxSexo.Text = "Não Indicado";
            }
        }

        private int EditUser(int ID, string Email, string Fname, string Lname, string Birthdate, string Sex, string Street, string Postcode, string City, string Country)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            try
            {
                if (UserAge(Convert.ToDateTime(Birthdate), DateTime.Now) < 18)
                {
                    MessageBox.Show("Utilizador tem de ter mais de 18 anos para criar conta!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return 0;
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Por favor introduza uma data valida no formato:\n \t      dd/mm/yyyy", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            if (string.IsNullOrEmpty(Email) || string.IsNullOrEmpty(Fname) || string.IsNullOrEmpty(Lname) || string.IsNullOrEmpty(Street) || string.IsNullOrEmpty(Postcode) || string.IsNullOrEmpty(City) || string.IsNullOrEmpty(Country))
            {
                MessageBox.Show("Por favor não deixe campos em branco", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.editAppUser", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = ID;
            cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Email;
            cmd.Parameters.Add("@Fname", SqlDbType.NVarChar).Value = Fname;
            cmd.Parameters.Add("@Lname", SqlDbType.NVarChar).Value = Lname;
            cmd.Parameters.Add("@Birthdate", SqlDbType.Date).Value = Birthdate;

            if(Sex == "Feminino")
            {
                cmd.Parameters.Add("@Sex", SqlDbType.NVarChar).Value = "F";
            }

            else if (Sex == "Masculino")
            {
                cmd.Parameters.Add("@Sex", SqlDbType.NVarChar).Value = "M";
            }

            else
            {
                cmd.Parameters.Add("@Sex", SqlDbType.NVarChar).Value = " ";
            }
            
            cmd.Parameters.Add("@Street", SqlDbType.NVarChar).Value = Street;
            cmd.Parameters.Add("@Postcode", SqlDbType.NVarChar).Value = Postcode;
            cmd.Parameters.Add("@City", SqlDbType.NVarChar).Value = City;
            cmd.Parameters.Add("@Country", SqlDbType.NVarChar).Value = Country;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao editar dados do Utilizador - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private int CreateUser(string Email, string Fname, string Lname, string bday, string bmonth, string byear, string Sex, string Street, string Postcode, string City, string Country)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            if (string.IsNullOrEmpty(Email) || string.IsNullOrEmpty(Fname) || string.IsNullOrEmpty(Lname) || string.IsNullOrEmpty(Street) || string.IsNullOrEmpty(Postcode) || string.IsNullOrEmpty(City) || string.IsNullOrEmpty(Country))
            {
                MessageBox.Show("Por favor não deixe campos em branco", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            string GenerateBirthdate = bday + "/" + bmonth + "/" + byear;

            try
            {
                if (UserAge(Convert.ToDateTime(GenerateBirthdate), DateTime.Now) < 18)
                {
                    MessageBox.Show("Utilizador tem de ter mais de 18 anos para criar conta!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return 0;
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Por favor introduza uma data valida", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.createAppUser", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = Email;
            cmd.Parameters.Add("@Fname", SqlDbType.NVarChar).Value = Fname;
            cmd.Parameters.Add("@Lname", SqlDbType.NVarChar).Value = Lname;
            cmd.Parameters.Add("@Birthdate", SqlDbType.Date).Value = GenerateBirthdate;

            if (Sex == "Feminino")
            {
                cmd.Parameters.Add("@Sex", SqlDbType.NVarChar).Value = "F";
            }

            else if (Sex == "Masculino")
            {
                cmd.Parameters.Add("@Sex", SqlDbType.NVarChar).Value = "M";
            }

            else
            {
                cmd.Parameters.Add("@Sex", SqlDbType.NVarChar).Value = " ";
            }

            cmd.Parameters.Add("@Street", SqlDbType.NVarChar).Value = Street;
            cmd.Parameters.Add("@Postcode", SqlDbType.NVarChar).Value = Postcode;
            cmd.Parameters.Add("@City", SqlDbType.NVarChar).Value = City;
            cmd.Parameters.Add("@Country", SqlDbType.NVarChar).Value = Country;

            try
            {
                cmd.ExecuteNonQuery();
                cn.Close();

            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao criar Utilizador - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            return 1;
        }

        private int DeleteUser(int ID)
        {
            if (!VerifySGBDConnection())
            {
                return 0;
            }

            SqlCommand cmd = new SqlCommand("proj.deleteAppUser", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@AppUser_ID", SqlDbType.Int).Value = ID;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception)
            {
                MessageBox.Show("Erro ao eliminar utilizador - OPERAÇÃO CANCELADA!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
            finally
            {
                cn.Close();
            }
            return 1;
        }

        private void FindAppUser(string src)
        {
            if (!VerifySGBDConnection())
            {
                return;
            }

            listBoxUtilizadoresRegistados.Items.Clear();
            SqlCommand cmd = new SqlCommand("proj.searchAppUser", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.Add("@StringFind", SqlDbType.NVarChar).Value = src;

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                AppUser appuser = new AppUser();
                appuser.ID = (int)reader["ID"];
                appuser.Email = reader["Email"].ToString();
                appuser.Fname = reader["Fname"].ToString();
                appuser.Lname = reader["Lname"].ToString();
                appuser.Birthdate = (DateTime)reader["Birthdate"];
                appuser.Sex = reader["Sex"].ToString();
                appuser.Street = reader["Street"].ToString();
                appuser.Postcode = reader["Postcode"].ToString();
                appuser.City = reader["City"].ToString();
                appuser.Country = reader["Country"].ToString();
                appuser.Balance = (decimal)reader["Balance"];
                listBoxUtilizadoresRegistados.Items.Add(appuser);
            }
            cn.Close();
        }

        private void listBoxUtilizadoresRegistados_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBoxUtilizadoresRegistados.SelectedIndex >= 0)
            {
                currentSoftware = listBoxUtilizadoresRegistados.SelectedIndex;
                ClearFields();
                ShowInfo();
                ShowUser();

            }

            if (listBoxUtilizadoresRegistados.Items.Count == 0)
            {
                HideEdit();
                HideInfo();
                ClearFields();
            }
        }

        private void buttonEditarUser_Click(object sender, EventArgs e)
        {
            PopulateCountryBox();
            PopulateSexBox();
            ShowEdit();
            StartEdit();
            comboBoxSexo.SelectedIndex = -1;
            comboBoxPais.SelectedIndex = -1;

            if(((AppUser)listBoxUtilizadoresRegistados.SelectedItem).Sex == "F")
            {
                textBoxSexo.Text = "Feminino";
            }

            else if (((AppUser)listBoxUtilizadoresRegistados.SelectedItem).Sex == "M")
            {
                textBoxSexo.Text = "Masculino";
            }

            else
            {
                textBoxSexo.Text = "Não Indicado";
            }

            textBoxPais.Text = ((AppUser)listBoxUtilizadoresRegistados.SelectedItem).Country;
        }

        private void comboBoxSexo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxSexo.SelectedIndex > -1)
            {
                textBoxSexo.Text = comboBoxSexo.SelectedItem.ToString();
            }
        }

        private void comboBoxPais_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxPais.SelectedIndex > -1)
            {
                textBoxPais.Text = comboBoxPais.SelectedItem.ToString();
            }
        }

        private void buttonCancelar_Click(object sender, EventArgs e)
        {
            listBoxUtilizadoresRegistados.Enabled = true;
            LoadRegisteredUser();
            EndEdit();
            HideEdit();
            buttonApagarUser.Visible = true;
            buttonDetalhes.Visible = true;
            buttonEditarUser.Visible = true;
            buttonCriarUser.Visible = true;
            buttonApagarUser.Enabled = true;
            buttonDetalhes.Enabled = true;
            buttonEditarUser.Enabled = true;
            buttonCriarUser.Enabled = true;
            ShowUser();
            listBoxUtilizadoresRegistados.SelectedIndex = currentSoftware;

        }

        private void buttonConfirmar_Click(object sender, EventArgs e)
        {
            if (EditUser(((AppUser)listBoxUtilizadoresRegistados.SelectedItem).ID, textBoxEmail.Text, textBoxPrimeiroNome.Text, textBoxUltimoNome.Text, textBoxDataNascimento.Text, textBoxSexo.Text, textBoxRua.Text, textBoxCodigoPostal.Text, textBoxCidade.Text, textBoxPais.Text ) == 1)
            {
                MessageBox.Show("Utilizador editado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                listBoxUtilizadoresRegistados.Enabled = true;
                listBoxUtilizadoresRegistados.Items.Clear();
                EndEdit();
                HideEdit();
                LoadRegisteredUser();
                ShowUser();
                listBoxUtilizadoresRegistados.SelectedIndex = currentSoftware;
            }
            else
            {
                listBoxUtilizadoresRegistados.SelectedIndex = currentSoftware;
            }
        }
        
        private void buttonCriarUser_Click(object sender, EventArgs e)
        {
            StartAdd();
            PopulateCountryBox();
            PopulateSexBox();
            PopulateDayBox();
            PopulateMonthBox();
            PopulateYearBox();
            HideSearch();
        }

        private void buttonConfirmarCriar_Click(object sender, EventArgs e)
        {
            if (CreateUser(textBoxEmail.Text, textBoxPrimeiroNome.Text, textBoxUltimoNome.Text, comboBoxDia.Text, comboBoxMes.Text, comboBoxAno.Text, textBoxSexo.Text, textBoxRua.Text, textBoxCodigoPostal.Text, textBoxCidade.Text, textBoxPais.Text) == 1)
            {
                MessageBox.Show("Utilizador criado com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                EndAdd();
                listBoxUtilizadoresRegistados.Items.Clear();
                LoadRegisteredUser();
                ShowSearch();
            }
        }

        private void buttonCancelarCriar_Click(object sender, EventArgs e)
        {
            ClearFields();
            LoadRegisteredUser();
            HideAdd();
            HideEdit();
            EndAdd();
            ShowSearch();
            listBoxUtilizadoresRegistados.SelectedIndex = -1;
        }

        private void buttonApagarUser_Click(object sender, EventArgs e)
        {
            if (DeleteUser(((AppUser)listBoxUtilizadoresRegistados.SelectedItem).ID) == 1)
            {
                MessageBox.Show("Utilizador removido com sucesso!", "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);

                listBoxUtilizadoresRegistados.Items.RemoveAt(listBoxUtilizadoresRegistados.SelectedIndex);
                ClearFields();
                HideInfo();
            }
            else
            {
                listBoxUtilizadoresRegistados.SelectedIndex = currentSoftware;
            }
        }

        private void buttonDetalhes_Click(object sender, EventArgs e)
        {
            Form6 F6 = new Form6(connectionString, ((AppUser)listBoxUtilizadoresRegistados.SelectedItem).ID);
            F6.Show();
        }

        private void buttonLimpar_Click(object sender, EventArgs e)
        {
            ClearFields();
            listBoxUtilizadoresRegistados.Items.Clear();
            textBoxProcurar.Clear();
            LoadRegisteredUser();
        }

        private void buttonProcurar_Click(object sender, EventArgs e)
        {
            FindAppUser(textBoxProcurar.Text);
        }

        private void textBoxProcurar_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(textBoxProcurar.Text))
            {
                buttonProcurar.Enabled = true;
            }
            else
            {
                buttonProcurar.Enabled = false;
            }
        }


        /// <summary>
        /// FUNÇOES AUXILIARES
        /// </summary>
        int UserAge(DateTime Birth, DateTime Current)
        {
            return(Current.Year - Birth.Year - 1) + (((Current.Month > Birth.Month) ||  ((Current.Month == Birth.Month) && (Current.Day >= Birth.Day))) ? 1 : 0);
        }

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

        private static List<string> SexList()
        {
            List<string> SexList = new List<string>();
            SexList.Add("Feminino");
            SexList.Add("Masculino");
            SexList.Add("Não Indicar");

            SexList.Sort();
            return SexList;
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

        private void PopulateDayBox()
        {
            comboBoxDia.DataSource = DayList();
        }

        private void PopulateMonthBox()
        {
            comboBoxMes.DataSource = MonthList();
        }

        private void PopulateYearBox()
        {
            comboBoxAno.DataSource = YearList();
        }

        private void PopulateCountryBox()
        {
            comboBoxPais.DataSource = CountryList();
        }

        private void PopulateSexBox()
        {
            comboBoxSexo.DataSource = SexList();
        }

        private void ClearFields()
        {
            textBoxID.Clear();
            textBoxEmail.Clear();
            textBoxPrimeiroNome.Clear();
            textBoxUltimoNome.Clear();
            textBoxDataNascimento.Clear();
            textBoxSexo.Clear();
            textBoxRua.Clear();
            textBoxCodigoPostal.Clear();
            textBoxCidade.Clear();
            textBoxPais.Clear();
        }

        private void StartEdit()
        {
            listBoxUtilizadoresRegistados.Enabled = false;
            labelID.Visible = false;

            textBoxID.Visible = false;
            textBoxEmail.ReadOnly = false;
            textBoxCidade.ReadOnly = false;
            textBoxPrimeiroNome.ReadOnly = false;
            textBoxUltimoNome.ReadOnly = false;
            textBoxDataNascimento.ReadOnly = false;
            textBoxSexo.ReadOnly = true;
            textBoxRua.ReadOnly = false;
            textBoxCodigoPostal.ReadOnly = false;
            textBoxCidade.ReadOnly = false;
            textBoxPais.ReadOnly = true;

            buttonApagarUser.Visible = false;
            buttonDetalhes.Visible = false;
            buttonCriarUser.Visible = false;
            buttonEditarUser.Visible = false;
        }

        private void EndEdit()
        {
            labelID.Visible = true;
            labelID.Visible = true;

            textBoxID.Visible = true;
            textBoxEmail.ReadOnly = true;
            textBoxPrimeiroNome.ReadOnly = true;
            textBoxUltimoNome.ReadOnly = true;
            textBoxDataNascimento.ReadOnly = true;
            textBoxRua.ReadOnly = true;
            textBoxCodigoPostal.ReadOnly = true;
            textBoxCidade.ReadOnly = true;
            textBoxCidade.ReadOnly = true;

            buttonApagarUser.Visible = true;
            buttonDetalhes.Visible = true;
            buttonEditarUser.Visible = true;
            buttonCriarUser.Visible = true;
            buttonApagarUser.Enabled = true;
            buttonDetalhes.Enabled = true;
            buttonEditarUser.Enabled = true;
            buttonCriarUser.Enabled = true;
        }

        private void HideEdit()
        {
            buttonCancelar.Visible = false;
            buttonConfirmar.Visible = false;
            comboBoxPais.Visible = false;
            comboBoxSexo.Visible = false;
        }

        private void ShowEdit()
        {
            buttonCancelar.Visible = true;
            buttonConfirmar.Visible = true;
            comboBoxPais.Visible = true;
            comboBoxSexo.Visible = true;
        }

        private void HideInfo()
        {
            buttonApagarUser.Enabled = false;
            buttonDetalhes.Enabled = false;
            buttonEditarUser.Enabled = false;
        }

        private void ShowInfo()
        {
            buttonApagarUser.Enabled = true;
            buttonDetalhes.Enabled = true;
            buttonEditarUser.Enabled = true;
        }

        private void StartAdd()
        {
            ClearFields();
            listBoxUtilizadoresRegistados.Visible = false;

            buttonDetalhes.Visible = false;
            buttonApagarUser.Visible = false;
            buttonEditarUser.Visible = false;
            buttonCriarUser.Visible = false;
            buttonConfirmarCriar.Visible = true;
            buttonCancelarCriar.Visible = true;

            labelUtilizadoresRegistados.Visible = false;
            labelID.Visible = false;
            labelDia.Visible = true;
            labelMes.Visible = true;
            labelAno.Visible = true;
            labelDataNascimento.Visible = false;

            textBoxSexo.ReadOnly = true;
            textBoxPais.ReadOnly = true;
            
            textBoxID.Visible = false;
            textBoxEmail.ReadOnly = false;
            textBoxCidade.ReadOnly = false;
            textBoxPrimeiroNome.ReadOnly = false;
            textBoxUltimoNome.ReadOnly = false;
            textBoxDataNascimento.Visible = false;
            textBoxRua.ReadOnly = false;
            textBoxCodigoPostal.ReadOnly = false;
            textBoxCidade.ReadOnly = false;

            comboBoxPais.Visible = true;
            comboBoxSexo.Visible = true;
            comboBoxDia.Visible = true;
            comboBoxMes.Visible = true;
            comboBoxAno.Visible = true;
        }

        private void HideAdd()
        {
            buttonCancelarCriar.Visible = false;
            buttonConfirmarCriar.Visible = false;
            comboBoxAno.Visible = false;
            comboBoxMes.Visible = false;
            comboBoxDia.Visible = false;
            labelDia.Visible = false;
            labelMes.Visible = false;
            labelAno.Visible = false;
            comboBoxDia.Visible = false;
            comboBoxMes.Visible = false;
            comboBoxAno.Visible = false;
        }

        private void EndAdd()
        {
            ClearFields();
            listBoxUtilizadoresRegistados.Visible = true;

            buttonDetalhes.Visible = true;
            buttonApagarUser.Visible = true;
            buttonEditarUser.Visible = true;
            buttonCriarUser.Visible = true;
            buttonConfirmarCriar.Visible = false;
            buttonCancelarCriar.Visible = false;
            buttonDetalhes.Enabled = false;
            buttonApagarUser.Enabled = false;
            buttonEditarUser.Enabled = false;
            buttonCriarUser.Enabled = true;

            labelUtilizadoresRegistados.Visible = true;
            labelID.Visible = true;
            labelDia.Visible = false;
            labelMes.Visible = false;
            labelAno.Visible = false;
            labelDataNascimento.Visible = true;

            textBoxID.Visible = true;
            textBoxEmail.ReadOnly = true;
            textBoxCidade.ReadOnly = true;
            textBoxPrimeiroNome.ReadOnly = true;
            textBoxUltimoNome.ReadOnly = true;
            textBoxDataNascimento.Visible = true;
            textBoxRua.ReadOnly = true;
            textBoxCodigoPostal.ReadOnly = true;
            textBoxCidade.ReadOnly = true;

            comboBoxPais.Visible = false;
            comboBoxSexo.Visible = false;
            comboBoxDia.Visible = false;
            comboBoxMes.Visible = false;
            comboBoxAno.Visible = false;
        }

        private void HideSearch()
        {
            textBoxProcurar.Visible = false;
            buttonProcurar.Visible = false;
            buttonLimpar.Visible = false;
        }

        private void ShowSearch()
        {
            textBoxProcurar.Visible = true;
            buttonProcurar.Visible = true;
            buttonLimpar.Visible = true;
        }
    }
}
