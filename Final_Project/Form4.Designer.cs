
namespace Final_Project
{
    partial class Form4
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.labelUtilizadoresRegistados = new System.Windows.Forms.Label();
            this.listBoxUtilizadoresRegistados = new System.Windows.Forms.ListBox();
            this.A = new System.Windows.Forms.Button();
            this.buttonApagarUser = new System.Windows.Forms.Button();
            this.buttonCriarUser = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.labelID = new System.Windows.Forms.Label();
            this.textBoxID = new System.Windows.Forms.TextBox();
            this.labelEmail = new System.Windows.Forms.Label();
            this.textBoxEmail = new System.Windows.Forms.TextBox();
            this.labelPrimeiroNome = new System.Windows.Forms.Label();
            this.textBoxPrimeiroNome = new System.Windows.Forms.TextBox();
            this.labelUltimoNome = new System.Windows.Forms.Label();
            this.textBoxUltimoNome = new System.Windows.Forms.TextBox();
            this.labelDataNascimento = new System.Windows.Forms.Label();
            this.textBoxDataNascimento = new System.Windows.Forms.TextBox();
            this.labelSexo = new System.Windows.Forms.Label();
            this.textBoxSexo = new System.Windows.Forms.TextBox();
            this.labelPais = new System.Windows.Forms.Label();
            this.labelCidade = new System.Windows.Forms.Label();
            this.textBoxPais = new System.Windows.Forms.TextBox();
            this.textBoxCidade = new System.Windows.Forms.TextBox();
            this.labelCodigoPostal = new System.Windows.Forms.Label();
            this.labelRua = new System.Windows.Forms.Label();
            this.textBoxRua = new System.Windows.Forms.TextBox();
            this.textBoxCodigoPostal = new System.Windows.Forms.TextBox();
            this.buttonEditarUser = new System.Windows.Forms.Button();
            this.buttonCancelar = new System.Windows.Forms.Button();
            this.buttonConfirmar = new System.Windows.Forms.Button();
            this.buttonDetalhes = new System.Windows.Forms.Button();
            this.comboBoxSexo = new System.Windows.Forms.ComboBox();
            this.comboBoxPais = new System.Windows.Forms.ComboBox();
            this.buttonConfirmarCriar = new System.Windows.Forms.Button();
            this.buttonCancelarCriar = new System.Windows.Forms.Button();
            this.comboBoxDia = new System.Windows.Forms.ComboBox();
            this.comboBoxMes = new System.Windows.Forms.ComboBox();
            this.comboBoxAno = new System.Windows.Forms.ComboBox();
            this.labelDia = new System.Windows.Forms.Label();
            this.M = new System.Windows.Forms.Label();
            this.labelMes = new System.Windows.Forms.Label();
            this.labelAno = new System.Windows.Forms.Label();
            this.buttonLimpar = new System.Windows.Forms.Button();
            this.buttonProcurar = new System.Windows.Forms.Button();
            this.textBoxProcurar = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // labelUtilizadoresRegistados
            // 
            this.labelUtilizadoresRegistados.AutoSize = true;
            this.labelUtilizadoresRegistados.Font = new System.Drawing.Font("Segoe UI", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.labelUtilizadoresRegistados.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelUtilizadoresRegistados.Location = new System.Drawing.Point(78, 9);
            this.labelUtilizadoresRegistados.Name = "labelUtilizadoresRegistados";
            this.labelUtilizadoresRegistados.Size = new System.Drawing.Size(265, 31);
            this.labelUtilizadoresRegistados.TabIndex = 45;
            this.labelUtilizadoresRegistados.Text = "Utilizadores Registados";
            this.labelUtilizadoresRegistados.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // listBoxUtilizadoresRegistados
            // 
            this.listBoxUtilizadoresRegistados.FormattingEnabled = true;
            this.listBoxUtilizadoresRegistados.ItemHeight = 20;
            this.listBoxUtilizadoresRegistados.Location = new System.Drawing.Point(28, 155);
            this.listBoxUtilizadoresRegistados.Name = "listBoxUtilizadoresRegistados";
            this.listBoxUtilizadoresRegistados.Size = new System.Drawing.Size(392, 524);
            this.listBoxUtilizadoresRegistados.TabIndex = 46;
            this.listBoxUtilizadoresRegistados.SelectedIndexChanged += new System.EventHandler(this.listBoxUtilizadoresRegistados_SelectedIndexChanged);
            // 
            // A
            // 
            this.A.Cursor = System.Windows.Forms.Cursors.Hand;
            this.A.Location = new System.Drawing.Point(118, 735);
            this.A.Name = "A";
            this.A.Size = new System.Drawing.Size(211, 48);
            this.A.TabIndex = 59;
            this.A.Text = "Alterar Preço";
            this.A.UseVisualStyleBackColor = true;
            // 
            // buttonApagarUser
            // 
            this.buttonApagarUser.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonApagarUser.Location = new System.Drawing.Point(108, 685);
            this.buttonApagarUser.Name = "buttonApagarUser";
            this.buttonApagarUser.Size = new System.Drawing.Size(211, 48);
            this.buttonApagarUser.TabIndex = 47;
            this.buttonApagarUser.Text = "Apagar Utilizador";
            this.buttonApagarUser.UseVisualStyleBackColor = true;
            this.buttonApagarUser.Click += new System.EventHandler(this.buttonApagarUser_Click);
            // 
            // buttonCriarUser
            // 
            this.buttonCriarUser.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonCriarUser.Location = new System.Drawing.Point(108, 747);
            this.buttonCriarUser.Name = "buttonCriarUser";
            this.buttonCriarUser.Size = new System.Drawing.Size(211, 48);
            this.buttonCriarUser.TabIndex = 48;
            this.buttonCriarUser.Text = "Criar Utilizador";
            this.buttonCriarUser.UseVisualStyleBackColor = true;
            this.buttonCriarUser.Click += new System.EventHandler(this.buttonCriarUser_Click);
            // 
            // button1
            // 
            this.button1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.button1.Location = new System.Drawing.Point(108, 747);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(211, 48);
            this.button1.TabIndex = 48;
            this.button1.Text = "Apagar Utilizador";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // labelID
            // 
            this.labelID.AutoSize = true;
            this.labelID.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelID.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelID.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelID.Location = new System.Drawing.Point(443, 42);
            this.labelID.Name = "labelID";
            this.labelID.Size = new System.Drawing.Size(28, 23);
            this.labelID.TabIndex = 50;
            this.labelID.Text = "ID";
            this.labelID.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxID
            // 
            this.textBoxID.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxID.Location = new System.Drawing.Point(443, 68);
            this.textBoxID.Name = "textBoxID";
            this.textBoxID.ReadOnly = true;
            this.textBoxID.Size = new System.Drawing.Size(137, 27);
            this.textBoxID.TabIndex = 49;
            // 
            // labelEmail
            // 
            this.labelEmail.AutoSize = true;
            this.labelEmail.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelEmail.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelEmail.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelEmail.Location = new System.Drawing.Point(443, 110);
            this.labelEmail.Name = "labelEmail";
            this.labelEmail.Size = new System.Drawing.Size(54, 23);
            this.labelEmail.TabIndex = 52;
            this.labelEmail.Text = "Email";
            this.labelEmail.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxEmail
            // 
            this.textBoxEmail.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxEmail.Location = new System.Drawing.Point(443, 136);
            this.textBoxEmail.Name = "textBoxEmail";
            this.textBoxEmail.ReadOnly = true;
            this.textBoxEmail.Size = new System.Drawing.Size(394, 27);
            this.textBoxEmail.TabIndex = 51;
            // 
            // labelPrimeiroNome
            // 
            this.labelPrimeiroNome.AutoSize = true;
            this.labelPrimeiroNome.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelPrimeiroNome.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelPrimeiroNome.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelPrimeiroNome.Location = new System.Drawing.Point(443, 187);
            this.labelPrimeiroNome.Name = "labelPrimeiroNome";
            this.labelPrimeiroNome.Size = new System.Drawing.Size(132, 23);
            this.labelPrimeiroNome.TabIndex = 54;
            this.labelPrimeiroNome.Text = "Primeiro Nome";
            this.labelPrimeiroNome.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxPrimeiroNome
            // 
            this.textBoxPrimeiroNome.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxPrimeiroNome.Location = new System.Drawing.Point(443, 213);
            this.textBoxPrimeiroNome.Name = "textBoxPrimeiroNome";
            this.textBoxPrimeiroNome.ReadOnly = true;
            this.textBoxPrimeiroNome.Size = new System.Drawing.Size(325, 27);
            this.textBoxPrimeiroNome.TabIndex = 53;
            // 
            // labelUltimoNome
            // 
            this.labelUltimoNome.AutoSize = true;
            this.labelUltimoNome.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelUltimoNome.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelUltimoNome.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelUltimoNome.Location = new System.Drawing.Point(856, 187);
            this.labelUltimoNome.Name = "labelUltimoNome";
            this.labelUltimoNome.Size = new System.Drawing.Size(116, 23);
            this.labelUltimoNome.TabIndex = 56;
            this.labelUltimoNome.Text = "Ultimo Nome";
            this.labelUltimoNome.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxUltimoNome
            // 
            this.textBoxUltimoNome.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxUltimoNome.Location = new System.Drawing.Point(856, 213);
            this.textBoxUltimoNome.Name = "textBoxUltimoNome";
            this.textBoxUltimoNome.ReadOnly = true;
            this.textBoxUltimoNome.Size = new System.Drawing.Size(325, 27);
            this.textBoxUltimoNome.TabIndex = 55;
            // 
            // labelDataNascimento
            // 
            this.labelDataNascimento.AutoSize = true;
            this.labelDataNascimento.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelDataNascimento.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelDataNascimento.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelDataNascimento.Location = new System.Drawing.Point(443, 265);
            this.labelDataNascimento.Name = "labelDataNascimento";
            this.labelDataNascimento.Size = new System.Drawing.Size(148, 23);
            this.labelDataNascimento.TabIndex = 58;
            this.labelDataNascimento.Text = "Data Nascimento";
            this.labelDataNascimento.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxDataNascimento
            // 
            this.textBoxDataNascimento.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxDataNascimento.Location = new System.Drawing.Point(443, 291);
            this.textBoxDataNascimento.Name = "textBoxDataNascimento";
            this.textBoxDataNascimento.ReadOnly = true;
            this.textBoxDataNascimento.Size = new System.Drawing.Size(137, 27);
            this.textBoxDataNascimento.TabIndex = 57;
            // 
            // labelSexo
            // 
            this.labelSexo.AutoSize = true;
            this.labelSexo.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelSexo.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelSexo.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelSexo.Location = new System.Drawing.Point(443, 345);
            this.labelSexo.Name = "labelSexo";
            this.labelSexo.Size = new System.Drawing.Size(47, 23);
            this.labelSexo.TabIndex = 60;
            this.labelSexo.Text = "Sexo";
            this.labelSexo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxSexo
            // 
            this.textBoxSexo.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxSexo.Location = new System.Drawing.Point(445, 371);
            this.textBoxSexo.Name = "textBoxSexo";
            this.textBoxSexo.ReadOnly = true;
            this.textBoxSexo.Size = new System.Drawing.Size(137, 27);
            this.textBoxSexo.TabIndex = 59;
            // 
            // labelPais
            // 
            this.labelPais.AutoSize = true;
            this.labelPais.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelPais.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelPais.Location = new System.Drawing.Point(443, 627);
            this.labelPais.Name = "labelPais";
            this.labelPais.Size = new System.Drawing.Size(43, 23);
            this.labelPais.TabIndex = 68;
            this.labelPais.Text = "País";
            this.labelPais.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // labelCidade
            // 
            this.labelCidade.AutoSize = true;
            this.labelCidade.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelCidade.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelCidade.Location = new System.Drawing.Point(445, 556);
            this.labelCidade.Name = "labelCidade";
            this.labelCidade.Size = new System.Drawing.Size(65, 23);
            this.labelCidade.TabIndex = 67;
            this.labelCidade.Text = "Cidade";
            this.labelCidade.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxPais
            // 
            this.textBoxPais.Location = new System.Drawing.Point(445, 653);
            this.textBoxPais.Name = "textBoxPais";
            this.textBoxPais.ReadOnly = true;
            this.textBoxPais.Size = new System.Drawing.Size(397, 27);
            this.textBoxPais.TabIndex = 66;
            // 
            // textBoxCidade
            // 
            this.textBoxCidade.Location = new System.Drawing.Point(445, 582);
            this.textBoxCidade.Name = "textBoxCidade";
            this.textBoxCidade.ReadOnly = true;
            this.textBoxCidade.Size = new System.Drawing.Size(397, 27);
            this.textBoxCidade.TabIndex = 65;
            // 
            // labelCodigoPostal
            // 
            this.labelCodigoPostal.AutoSize = true;
            this.labelCodigoPostal.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelCodigoPostal.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelCodigoPostal.Location = new System.Drawing.Point(443, 488);
            this.labelCodigoPostal.Name = "labelCodigoPostal";
            this.labelCodigoPostal.Size = new System.Drawing.Size(120, 23);
            this.labelCodigoPostal.TabIndex = 64;
            this.labelCodigoPostal.Text = "Codigo Postal";
            this.labelCodigoPostal.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // labelRua
            // 
            this.labelRua.AutoSize = true;
            this.labelRua.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelRua.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelRua.Location = new System.Drawing.Point(443, 417);
            this.labelRua.Name = "labelRua";
            this.labelRua.Size = new System.Drawing.Size(41, 23);
            this.labelRua.TabIndex = 63;
            this.labelRua.Text = "Rua";
            this.labelRua.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxRua
            // 
            this.textBoxRua.Location = new System.Drawing.Point(443, 443);
            this.textBoxRua.Name = "textBoxRua";
            this.textBoxRua.ReadOnly = true;
            this.textBoxRua.Size = new System.Drawing.Size(308, 27);
            this.textBoxRua.TabIndex = 62;
            // 
            // textBoxCodigoPostal
            // 
            this.textBoxCodigoPostal.Location = new System.Drawing.Point(445, 514);
            this.textBoxCodigoPostal.Name = "textBoxCodigoPostal";
            this.textBoxCodigoPostal.ReadOnly = true;
            this.textBoxCodigoPostal.Size = new System.Drawing.Size(397, 27);
            this.textBoxCodigoPostal.TabIndex = 61;
            // 
            // buttonEditarUser
            // 
            this.buttonEditarUser.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonEditarUser.Location = new System.Drawing.Point(524, 728);
            this.buttonEditarUser.Name = "buttonEditarUser";
            this.buttonEditarUser.Size = new System.Drawing.Size(211, 48);
            this.buttonEditarUser.TabIndex = 69;
            this.buttonEditarUser.Text = "Editar Utilizador";
            this.buttonEditarUser.UseVisualStyleBackColor = true;
            this.buttonEditarUser.Click += new System.EventHandler(this.buttonEditarUser_Click);
            // 
            // buttonCancelar
            // 
            this.buttonCancelar.Location = new System.Drawing.Point(524, 748);
            this.buttonCancelar.Name = "buttonCancelar";
            this.buttonCancelar.Size = new System.Drawing.Size(211, 47);
            this.buttonCancelar.TabIndex = 71;
            this.buttonCancelar.Text = "Cancelar";
            this.buttonCancelar.UseVisualStyleBackColor = true;
            this.buttonCancelar.Click += new System.EventHandler(this.buttonCancelar_Click);
            // 
            // buttonConfirmar
            // 
            this.buttonConfirmar.Location = new System.Drawing.Point(524, 695);
            this.buttonConfirmar.Name = "buttonConfirmar";
            this.buttonConfirmar.Size = new System.Drawing.Size(211, 47);
            this.buttonConfirmar.TabIndex = 70;
            this.buttonConfirmar.Text = "Confirmar";
            this.buttonConfirmar.UseVisualStyleBackColor = true;
            this.buttonConfirmar.Click += new System.EventHandler(this.buttonConfirmar_Click);
            // 
            // buttonDetalhes
            // 
            this.buttonDetalhes.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonDetalhes.Location = new System.Drawing.Point(970, 704);
            this.buttonDetalhes.Name = "buttonDetalhes";
            this.buttonDetalhes.Size = new System.Drawing.Size(319, 91);
            this.buttonDetalhes.TabIndex = 72;
            this.buttonDetalhes.Text = "Ver Detalhes de Utilizador";
            this.buttonDetalhes.UseVisualStyleBackColor = true;
            this.buttonDetalhes.Click += new System.EventHandler(this.buttonDetalhes_Click);
            // 
            // comboBoxSexo
            // 
            this.comboBoxSexo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxSexo.FormattingEnabled = true;
            this.comboBoxSexo.Location = new System.Drawing.Point(617, 370);
            this.comboBoxSexo.Name = "comboBoxSexo";
            this.comboBoxSexo.Size = new System.Drawing.Size(151, 28);
            this.comboBoxSexo.TabIndex = 73;
            this.comboBoxSexo.SelectedIndexChanged += new System.EventHandler(this.comboBoxSexo_SelectedIndexChanged);
            // 
            // comboBoxPais
            // 
            this.comboBoxPais.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxPais.FormattingEnabled = true;
            this.comboBoxPais.Location = new System.Drawing.Point(856, 653);
            this.comboBoxPais.Name = "comboBoxPais";
            this.comboBoxPais.Size = new System.Drawing.Size(151, 28);
            this.comboBoxPais.TabIndex = 74;
            this.comboBoxPais.SelectedIndexChanged += new System.EventHandler(this.comboBoxPais_SelectedIndexChanged);
            // 
            // buttonConfirmarCriar
            // 
            this.buttonConfirmarCriar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonConfirmarCriar.Location = new System.Drawing.Point(92, 175);
            this.buttonConfirmarCriar.Name = "buttonConfirmarCriar";
            this.buttonConfirmarCriar.Size = new System.Drawing.Size(246, 91);
            this.buttonConfirmarCriar.TabIndex = 75;
            this.buttonConfirmarCriar.Text = "Confirmar";
            this.buttonConfirmarCriar.UseVisualStyleBackColor = true;
            this.buttonConfirmarCriar.Click += new System.EventHandler(this.buttonConfirmarCriar_Click);
            // 
            // buttonCancelarCriar
            // 
            this.buttonCancelarCriar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonCancelarCriar.Location = new System.Drawing.Point(92, 312);
            this.buttonCancelarCriar.Name = "buttonCancelarCriar";
            this.buttonCancelarCriar.Size = new System.Drawing.Size(246, 91);
            this.buttonCancelarCriar.TabIndex = 76;
            this.buttonCancelarCriar.Text = "Cancelar";
            this.buttonCancelarCriar.UseVisualStyleBackColor = true;
            this.buttonCancelarCriar.Click += new System.EventHandler(this.buttonCancelarCriar_Click);
            // 
            // comboBoxDia
            // 
            this.comboBoxDia.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxDia.FormattingEnabled = true;
            this.comboBoxDia.Location = new System.Drawing.Point(443, 290);
            this.comboBoxDia.Name = "comboBoxDia";
            this.comboBoxDia.Size = new System.Drawing.Size(67, 28);
            this.comboBoxDia.TabIndex = 77;
            // 
            // comboBoxMes
            // 
            this.comboBoxMes.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxMes.FormattingEnabled = true;
            this.comboBoxMes.Location = new System.Drawing.Point(516, 290);
            this.comboBoxMes.Name = "comboBoxMes";
            this.comboBoxMes.Size = new System.Drawing.Size(67, 28);
            this.comboBoxMes.TabIndex = 78;
            // 
            // comboBoxAno
            // 
            this.comboBoxAno.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxAno.FormattingEnabled = true;
            this.comboBoxAno.Location = new System.Drawing.Point(589, 290);
            this.comboBoxAno.Name = "comboBoxAno";
            this.comboBoxAno.Size = new System.Drawing.Size(86, 28);
            this.comboBoxAno.TabIndex = 79;
            // 
            // labelDia
            // 
            this.labelDia.AutoSize = true;
            this.labelDia.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelDia.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelDia.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelDia.Location = new System.Drawing.Point(459, 264);
            this.labelDia.Name = "labelDia";
            this.labelDia.Size = new System.Drawing.Size(38, 23);
            this.labelDia.TabIndex = 80;
            this.labelDia.Text = "Dia";
            this.labelDia.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // M
            // 
            this.M.AutoSize = true;
            this.M.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.M.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.M.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.M.Location = new System.Drawing.Point(762, 265);
            this.M.Name = "M";
            this.M.Size = new System.Drawing.Size(38, 23);
            this.M.TabIndex = 81;
            this.M.Text = "Dia";
            this.M.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // labelMes
            // 
            this.labelMes.AutoSize = true;
            this.labelMes.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelMes.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelMes.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelMes.Location = new System.Drawing.Point(524, 264);
            this.labelMes.Name = "labelMes";
            this.labelMes.Size = new System.Drawing.Size(41, 23);
            this.labelMes.TabIndex = 81;
            this.labelMes.Text = "Mes";
            this.labelMes.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // labelAno
            // 
            this.labelAno.AutoSize = true;
            this.labelAno.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelAno.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelAno.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelAno.Location = new System.Drawing.Point(607, 264);
            this.labelAno.Name = "labelAno";
            this.labelAno.Size = new System.Drawing.Size(42, 23);
            this.labelAno.TabIndex = 82;
            this.labelAno.Text = "Ano";
            this.labelAno.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // buttonLimpar
            // 
            this.buttonLimpar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonLimpar.Location = new System.Drawing.Point(225, 82);
            this.buttonLimpar.Name = "buttonLimpar";
            this.buttonLimpar.Size = new System.Drawing.Size(130, 51);
            this.buttonLimpar.TabIndex = 192;
            this.buttonLimpar.Text = "Limpar";
            this.buttonLimpar.UseVisualStyleBackColor = true;
            this.buttonLimpar.Click += new System.EventHandler(this.buttonLimpar_Click);
            // 
            // buttonProcurar
            // 
            this.buttonProcurar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonProcurar.Location = new System.Drawing.Point(78, 82);
            this.buttonProcurar.Name = "buttonProcurar";
            this.buttonProcurar.Size = new System.Drawing.Size(130, 51);
            this.buttonProcurar.TabIndex = 191;
            this.buttonProcurar.Text = "Procurar";
            this.buttonProcurar.UseVisualStyleBackColor = true;
            this.buttonProcurar.Click += new System.EventHandler(this.buttonProcurar_Click);
            // 
            // textBoxProcurar
            // 
            this.textBoxProcurar.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxProcurar.Location = new System.Drawing.Point(78, 49);
            this.textBoxProcurar.Name = "textBoxProcurar";
            this.textBoxProcurar.Size = new System.Drawing.Size(277, 27);
            this.textBoxProcurar.TabIndex = 190;
            this.textBoxProcurar.TextChanged += new System.EventHandler(this.textBoxProcurar_TextChanged);
            // 
            // Form4
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1301, 807);
            this.Controls.Add(this.buttonLimpar);
            this.Controls.Add(this.buttonProcurar);
            this.Controls.Add(this.textBoxProcurar);
            this.Controls.Add(this.labelAno);
            this.Controls.Add(this.labelMes);
            this.Controls.Add(this.labelDia);
            this.Controls.Add(this.comboBoxAno);
            this.Controls.Add(this.comboBoxMes);
            this.Controls.Add(this.comboBoxDia);
            this.Controls.Add(this.buttonCancelarCriar);
            this.Controls.Add(this.buttonConfirmarCriar);
            this.Controls.Add(this.comboBoxPais);
            this.Controls.Add(this.comboBoxSexo);
            this.Controls.Add(this.buttonDetalhes);
            this.Controls.Add(this.buttonCancelar);
            this.Controls.Add(this.buttonConfirmar);
            this.Controls.Add(this.buttonEditarUser);
            this.Controls.Add(this.labelPais);
            this.Controls.Add(this.labelCidade);
            this.Controls.Add(this.textBoxPais);
            this.Controls.Add(this.textBoxCidade);
            this.Controls.Add(this.labelCodigoPostal);
            this.Controls.Add(this.labelRua);
            this.Controls.Add(this.textBoxRua);
            this.Controls.Add(this.textBoxCodigoPostal);
            this.Controls.Add(this.labelSexo);
            this.Controls.Add(this.textBoxSexo);
            this.Controls.Add(this.labelDataNascimento);
            this.Controls.Add(this.textBoxDataNascimento);
            this.Controls.Add(this.labelUltimoNome);
            this.Controls.Add(this.textBoxUltimoNome);
            this.Controls.Add(this.labelPrimeiroNome);
            this.Controls.Add(this.textBoxPrimeiroNome);
            this.Controls.Add(this.labelEmail);
            this.Controls.Add(this.textBoxEmail);
            this.Controls.Add(this.labelID);
            this.Controls.Add(this.textBoxID);
            this.Controls.Add(this.buttonCriarUser);
            this.Controls.Add(this.buttonApagarUser);
            this.Controls.Add(this.listBoxUtilizadoresRegistados);
            this.Controls.Add(this.labelUtilizadoresRegistados);
            this.Name = "Form4";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form4";
            this.Load += new System.EventHandler(this.Form4_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label labelUtilizadoresRegistados;
        private System.Windows.Forms.ListBox listBoxUtilizadoresRegistados;
        private System.Windows.Forms.Button A;
        private System.Windows.Forms.Button buttonApagarUser;
        private System.Windows.Forms.Button buttonCriarUser;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label labelID;
        private System.Windows.Forms.TextBox textBoxID;
        private System.Windows.Forms.Label labelEmail;
        private System.Windows.Forms.TextBox textBoxEmail;
        private System.Windows.Forms.Label labelPrimeiroNome;
        private System.Windows.Forms.TextBox textBoxPrimeiroNome;
        private System.Windows.Forms.Label labelUltimoNome;
        private System.Windows.Forms.TextBox textBoxUltimoNome;
        private System.Windows.Forms.Label labelDataNascimento;
        private System.Windows.Forms.Label labelSexo;
        private System.Windows.Forms.TextBox textBoxSexo;
        private System.Windows.Forms.Label labelPais;
        private System.Windows.Forms.Label labelCidade;
        private System.Windows.Forms.TextBox textBoxPais;
        private System.Windows.Forms.TextBox textBoxCidade;
        private System.Windows.Forms.Label labelCodigoPostal;
        private System.Windows.Forms.Label labelRua;
        private System.Windows.Forms.TextBox textBoxRua;
        private System.Windows.Forms.TextBox textBoxCodigoPostal;
        private System.Windows.Forms.TextBox textBoxDataNascimento;
        private System.Windows.Forms.Button buttonEditarUser;
        private System.Windows.Forms.Button buttonCancelar;
        private System.Windows.Forms.Button buttonConfirmar;
        private System.Windows.Forms.Button buttonDetalhes;
        private System.Windows.Forms.ComboBox comboBoxSexo;
        private System.Windows.Forms.ComboBox comboBoxPais;
        private System.Windows.Forms.Button buttonConfirmarCriar;
        private System.Windows.Forms.Button buttonCancelarCriar;
        private System.Windows.Forms.ComboBox comboBoxDia;
        private System.Windows.Forms.ComboBox comboBoxMes;
        private System.Windows.Forms.ComboBox comboBoxAno;
        private System.Windows.Forms.Label labelDia;
        private System.Windows.Forms.Label M;
        private System.Windows.Forms.Label labelMes;
        private System.Windows.Forms.Label labelAno;
        private System.Windows.Forms.Button buttonLimpar;
        private System.Windows.Forms.Button buttonProcurar;
        private System.Windows.Forms.TextBox textBoxProcurar;
    }
}