
namespace Final_Project
{
    partial class Form8
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
            this.listBoxItems = new System.Windows.Forms.ListBox();
            this.labelInventarioUUID = new System.Windows.Forms.Label();
            this.textBoxInventarioUUID = new System.Windows.Forms.TextBox();
            this.labelInventarioOrigem = new System.Windows.Forms.Label();
            this.textBoxInventarioOrigem = new System.Windows.Forms.TextBox();
            this.labelInventarioNome = new System.Windows.Forms.Label();
            this.textBoxInventarioNome = new System.Windows.Forms.TextBox();
            this.labelInventarioCategoria = new System.Windows.Forms.Label();
            this.labelInventarioRaridade = new System.Windows.Forms.Label();
            this.textBoxInventarioCategoria = new System.Windows.Forms.TextBox();
            this.textBoxInventarioRaridade = new System.Windows.Forms.TextBox();
            this.textBoxInventarioValor = new System.Windows.Forms.TextBox();
            this.labelInventarioValor = new System.Windows.Forms.Label();
            this.buttonRetirar = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // listBoxItems
            // 
            this.listBoxItems.FormattingEnabled = true;
            this.listBoxItems.ItemHeight = 20;
            this.listBoxItems.Location = new System.Drawing.Point(12, 26);
            this.listBoxItems.Name = "listBoxItems";
            this.listBoxItems.Size = new System.Drawing.Size(470, 524);
            this.listBoxItems.TabIndex = 181;
            this.listBoxItems.SelectedIndexChanged += new System.EventHandler(this.listBoxItems_SelectedIndexChanged);
            // 
            // labelInventarioUUID
            // 
            this.labelInventarioUUID.AutoSize = true;
            this.labelInventarioUUID.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelInventarioUUID.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelInventarioUUID.Location = new System.Drawing.Point(488, 361);
            this.labelInventarioUUID.Name = "labelInventarioUUID";
            this.labelInventarioUUID.Size = new System.Drawing.Size(52, 23);
            this.labelInventarioUUID.TabIndex = 191;
            this.labelInventarioUUID.Text = "UUID";
            this.labelInventarioUUID.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxInventarioUUID
            // 
            this.textBoxInventarioUUID.Location = new System.Drawing.Point(488, 388);
            this.textBoxInventarioUUID.Name = "textBoxInventarioUUID";
            this.textBoxInventarioUUID.ReadOnly = true;
            this.textBoxInventarioUUID.Size = new System.Drawing.Size(418, 27);
            this.textBoxInventarioUUID.TabIndex = 190;
            // 
            // labelInventarioOrigem
            // 
            this.labelInventarioOrigem.AutoSize = true;
            this.labelInventarioOrigem.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelInventarioOrigem.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelInventarioOrigem.Location = new System.Drawing.Point(488, 277);
            this.labelInventarioOrigem.Name = "labelInventarioOrigem";
            this.labelInventarioOrigem.Size = new System.Drawing.Size(135, 23);
            this.labelInventarioOrigem.TabIndex = 189;
            this.labelInventarioOrigem.Text = "Jogo Originário";
            this.labelInventarioOrigem.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxInventarioOrigem
            // 
            this.textBoxInventarioOrigem.Location = new System.Drawing.Point(488, 303);
            this.textBoxInventarioOrigem.Name = "textBoxInventarioOrigem";
            this.textBoxInventarioOrigem.ReadOnly = true;
            this.textBoxInventarioOrigem.Size = new System.Drawing.Size(265, 27);
            this.textBoxInventarioOrigem.TabIndex = 188;
            // 
            // labelInventarioNome
            // 
            this.labelInventarioNome.AutoSize = true;
            this.labelInventarioNome.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelInventarioNome.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelInventarioNome.Location = new System.Drawing.Point(488, 26);
            this.labelInventarioNome.Name = "labelInventarioNome";
            this.labelInventarioNome.Size = new System.Drawing.Size(58, 23);
            this.labelInventarioNome.TabIndex = 187;
            this.labelInventarioNome.Text = "Nome";
            this.labelInventarioNome.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxInventarioNome
            // 
            this.textBoxInventarioNome.Location = new System.Drawing.Point(488, 52);
            this.textBoxInventarioNome.Name = "textBoxInventarioNome";
            this.textBoxInventarioNome.ReadOnly = true;
            this.textBoxInventarioNome.Size = new System.Drawing.Size(265, 27);
            this.textBoxInventarioNome.TabIndex = 186;
            // 
            // labelInventarioCategoria
            // 
            this.labelInventarioCategoria.AutoSize = true;
            this.labelInventarioCategoria.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelInventarioCategoria.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelInventarioCategoria.Location = new System.Drawing.Point(488, 191);
            this.labelInventarioCategoria.Name = "labelInventarioCategoria";
            this.labelInventarioCategoria.Size = new System.Drawing.Size(88, 23);
            this.labelInventarioCategoria.TabIndex = 185;
            this.labelInventarioCategoria.Text = "Categoria";
            this.labelInventarioCategoria.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // labelInventarioRaridade
            // 
            this.labelInventarioRaridade.AutoSize = true;
            this.labelInventarioRaridade.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelInventarioRaridade.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelInventarioRaridade.Location = new System.Drawing.Point(488, 109);
            this.labelInventarioRaridade.Name = "labelInventarioRaridade";
            this.labelInventarioRaridade.Size = new System.Drawing.Size(82, 23);
            this.labelInventarioRaridade.TabIndex = 184;
            this.labelInventarioRaridade.Text = "Raridade";
            this.labelInventarioRaridade.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxInventarioCategoria
            // 
            this.textBoxInventarioCategoria.Location = new System.Drawing.Point(488, 217);
            this.textBoxInventarioCategoria.Name = "textBoxInventarioCategoria";
            this.textBoxInventarioCategoria.ReadOnly = true;
            this.textBoxInventarioCategoria.Size = new System.Drawing.Size(145, 27);
            this.textBoxInventarioCategoria.TabIndex = 183;
            // 
            // textBoxInventarioRaridade
            // 
            this.textBoxInventarioRaridade.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxInventarioRaridade.Location = new System.Drawing.Point(488, 135);
            this.textBoxInventarioRaridade.Name = "textBoxInventarioRaridade";
            this.textBoxInventarioRaridade.ReadOnly = true;
            this.textBoxInventarioRaridade.Size = new System.Drawing.Size(145, 27);
            this.textBoxInventarioRaridade.TabIndex = 182;
            // 
            // textBoxInventarioValor
            // 
            this.textBoxInventarioValor.Location = new System.Drawing.Point(488, 478);
            this.textBoxInventarioValor.Name = "textBoxInventarioValor";
            this.textBoxInventarioValor.ReadOnly = true;
            this.textBoxInventarioValor.Size = new System.Drawing.Size(145, 27);
            this.textBoxInventarioValor.TabIndex = 193;
            // 
            // labelInventarioValor
            // 
            this.labelInventarioValor.AutoSize = true;
            this.labelInventarioValor.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelInventarioValor.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelInventarioValor.Location = new System.Drawing.Point(488, 452);
            this.labelInventarioValor.Name = "labelInventarioValor";
            this.labelInventarioValor.Size = new System.Drawing.Size(151, 23);
            this.labelInventarioValor.TabIndex = 192;
            this.labelInventarioValor.Text = "Valor de Mercado";
            this.labelInventarioValor.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // buttonRetirar
            // 
            this.buttonRetirar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonRetirar.Location = new System.Drawing.Point(12, 556);
            this.buttonRetirar.Name = "buttonRetirar";
            this.buttonRetirar.Size = new System.Drawing.Size(470, 71);
            this.buttonRetirar.TabIndex = 194;
            this.buttonRetirar.Text = "Retirar Item do Mercado";
            this.buttonRetirar.UseVisualStyleBackColor = true;
            this.buttonRetirar.Click += new System.EventHandler(this.buttonRetirar_Click);
            // 
            // Form8
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(919, 641);
            this.Controls.Add(this.buttonRetirar);
            this.Controls.Add(this.textBoxInventarioValor);
            this.Controls.Add(this.labelInventarioValor);
            this.Controls.Add(this.labelInventarioUUID);
            this.Controls.Add(this.textBoxInventarioUUID);
            this.Controls.Add(this.labelInventarioOrigem);
            this.Controls.Add(this.textBoxInventarioOrigem);
            this.Controls.Add(this.labelInventarioNome);
            this.Controls.Add(this.textBoxInventarioNome);
            this.Controls.Add(this.labelInventarioCategoria);
            this.Controls.Add(this.labelInventarioRaridade);
            this.Controls.Add(this.textBoxInventarioCategoria);
            this.Controls.Add(this.textBoxInventarioRaridade);
            this.Controls.Add(this.listBoxItems);
            this.Name = "Form8";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form8";
            this.Load += new System.EventHandler(this.Form8_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox listBoxItems;
        private System.Windows.Forms.Label labelInventarioUUID;
        private System.Windows.Forms.TextBox textBoxInventarioUUID;
        private System.Windows.Forms.Label labelInventarioOrigem;
        private System.Windows.Forms.TextBox textBoxInventarioOrigem;
        private System.Windows.Forms.Label labelInventarioNome;
        private System.Windows.Forms.TextBox textBoxInventarioNome;
        private System.Windows.Forms.Label labelInventarioCategoria;
        private System.Windows.Forms.Label labelInventarioRaridade;
        private System.Windows.Forms.TextBox textBoxInventarioCategoria;
        private System.Windows.Forms.TextBox textBoxInventarioRaridade;
        private System.Windows.Forms.TextBox textBoxInventarioValor;
        private System.Windows.Forms.Label labelInventarioValor;
        private System.Windows.Forms.Button buttonRetirar;
    }
}