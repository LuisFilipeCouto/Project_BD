
namespace Final_Project
{
    partial class Form7
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
            this.buttonCancelar = new System.Windows.Forms.Button();
            this.buttonAdicionar = new System.Windows.Forms.Button();
            this.labelSaldo = new System.Windows.Forms.Label();
            this.labelSaldoAtual = new System.Windows.Forms.Label();
            this.textBoxSaldoAtual = new System.Windows.Forms.TextBox();
            this.comboBoxValues = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // buttonCancelar
            // 
            this.buttonCancelar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonCancelar.Location = new System.Drawing.Point(12, 171);
            this.buttonCancelar.Name = "buttonCancelar";
            this.buttonCancelar.Size = new System.Drawing.Size(188, 62);
            this.buttonCancelar.TabIndex = 115;
            this.buttonCancelar.Text = "Cancelar";
            this.buttonCancelar.UseVisualStyleBackColor = true;
            this.buttonCancelar.Click += new System.EventHandler(this.buttonCancelar_Click);
            // 
            // buttonAdicionar
            // 
            this.buttonAdicionar.Cursor = System.Windows.Forms.Cursors.Hand;
            this.buttonAdicionar.Location = new System.Drawing.Point(235, 171);
            this.buttonAdicionar.Name = "buttonAdicionar";
            this.buttonAdicionar.Size = new System.Drawing.Size(188, 62);
            this.buttonAdicionar.TabIndex = 114;
            this.buttonAdicionar.Text = "Adicionar";
            this.buttonAdicionar.UseVisualStyleBackColor = true;
            this.buttonAdicionar.Click += new System.EventHandler(this.buttonAdicionar_Click);
            // 
            // labelSaldo
            // 
            this.labelSaldo.AutoSize = true;
            this.labelSaldo.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelSaldo.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelSaldo.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelSaldo.Location = new System.Drawing.Point(12, 106);
            this.labelSaldo.Name = "labelSaldo";
            this.labelSaldo.Size = new System.Drawing.Size(188, 23);
            this.labelSaldo.TabIndex = 116;
            this.labelSaldo.Text = "Montante a Adicionar:";
            this.labelSaldo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // labelSaldoAtual
            // 
            this.labelSaldoAtual.AutoSize = true;
            this.labelSaldoAtual.Font = new System.Drawing.Font("Segoe UI", 10.2F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point);
            this.labelSaldoAtual.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.labelSaldoAtual.ImageAlign = System.Drawing.ContentAlignment.TopCenter;
            this.labelSaldoAtual.Location = new System.Drawing.Point(12, 37);
            this.labelSaldoAtual.Name = "labelSaldoAtual";
            this.labelSaldoAtual.Size = new System.Drawing.Size(107, 23);
            this.labelSaldoAtual.TabIndex = 118;
            this.labelSaldoAtual.Text = "Saldo Atual:";
            this.labelSaldoAtual.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBoxSaldoAtual
            // 
            this.textBoxSaldoAtual.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxSaldoAtual.Location = new System.Drawing.Point(125, 37);
            this.textBoxSaldoAtual.Name = "textBoxSaldoAtual";
            this.textBoxSaldoAtual.ReadOnly = true;
            this.textBoxSaldoAtual.Size = new System.Drawing.Size(294, 27);
            this.textBoxSaldoAtual.TabIndex = 119;
            // 
            // comboBoxValues
            // 
            this.comboBoxValues.FormattingEnabled = true;
            this.comboBoxValues.Location = new System.Drawing.Point(207, 106);
            this.comboBoxValues.Name = "comboBoxValues";
            this.comboBoxValues.Size = new System.Drawing.Size(212, 28);
            this.comboBoxValues.TabIndex = 120;
            this.comboBoxValues.SelectedIndexChanged += new System.EventHandler(this.comboBoxValues_SelectedIndexChanged);
            // 
            // Form7
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(435, 255);
            this.Controls.Add(this.comboBoxValues);
            this.Controls.Add(this.textBoxSaldoAtual);
            this.Controls.Add(this.labelSaldoAtual);
            this.Controls.Add(this.labelSaldo);
            this.Controls.Add(this.buttonCancelar);
            this.Controls.Add(this.buttonAdicionar);
            this.Name = "Form7";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form7";
            this.Load += new System.EventHandler(this.Form7_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonCancelar;
        private System.Windows.Forms.Button buttonAdicionar;
        private System.Windows.Forms.Label labelSaldo;
        private System.Windows.Forms.Label labelSaldoAtual;
        private System.Windows.Forms.TextBox textBoxSaldoAtual;
        private System.Windows.Forms.ComboBox comboBoxValues;
    }
}