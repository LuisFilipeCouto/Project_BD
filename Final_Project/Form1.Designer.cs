
namespace Final_Project
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.Statistics = new System.Windows.Forms.Button();
            this.Store = new System.Windows.Forms.Button();
            this.Users = new System.Windows.Forms.Button();
            this.Publishers_Software = new System.Windows.Forms.Button();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.label1 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // Statistics
            // 
            this.Statistics.Cursor = System.Windows.Forms.Cursors.Hand;
            this.Statistics.Location = new System.Drawing.Point(227, 668);
            this.Statistics.Name = "Statistics";
            this.Statistics.Size = new System.Drawing.Size(274, 88);
            this.Statistics.TabIndex = 0;
            this.Statistics.Text = "Mostrar Estatisticas";
            this.Statistics.UseVisualStyleBackColor = true;
            this.Statistics.Click += new System.EventHandler(this.ShowStatistics);
            // 
            // Store
            // 
            this.Store.Cursor = System.Windows.Forms.Cursors.Hand;
            this.Store.Location = new System.Drawing.Point(227, 107);
            this.Store.Name = "Store";
            this.Store.Size = new System.Drawing.Size(274, 88);
            this.Store.TabIndex = 1;
            this.Store.Text = "Gerir Loja";
            this.Store.UseVisualStyleBackColor = true;
            this.Store.Click += new System.EventHandler(this.ManageStore);
            // 
            // Users
            // 
            this.Users.Cursor = System.Windows.Forms.Cursors.Hand;
            this.Users.Location = new System.Drawing.Point(678, 382);
            this.Users.Name = "Users";
            this.Users.Size = new System.Drawing.Size(274, 88);
            this.Users.TabIndex = 2;
            this.Users.Text = "Gerir Utilizadores";
            this.Users.UseVisualStyleBackColor = true;
            this.Users.Click += new System.EventHandler(this.ManageUsers);
            // 
            // Publishers_Software
            // 
            this.Publishers_Software.Cursor = System.Windows.Forms.Cursors.Hand;
            this.Publishers_Software.Location = new System.Drawing.Point(678, 201);
            this.Publishers_Software.Name = "Publishers_Software";
            this.Publishers_Software.Size = new System.Drawing.Size(274, 88);
            this.Publishers_Software.TabIndex = 3;
            this.Publishers_Software.Text = "Gerir Publicadoras-Software";
            this.Publishers_Software.UseVisualStyleBackColor = true;
            this.Publishers_Software.Click += new System.EventHandler(this.ManagePublisherandSoftware);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::Final_Project.Properties.Resources.logotipo;
            this.pictureBox1.Location = new System.Drawing.Point(114, 201);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(500, 461);
            this.pictureBox1.TabIndex = 4;
            this.pictureBox1.TabStop = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 19.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.label1.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.label1.Location = new System.Drawing.Point(73, 27);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(920, 45);
            this.label1.TabIndex = 5;
            this.label1.Text = "Gestão da Plataforma Online de Vendas de Jogos e Aplicações";
            // 
            // button1
            // 
            this.button1.Cursor = System.Windows.Forms.Cursors.Hand;
            this.button1.Location = new System.Drawing.Point(678, 574);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(274, 88);
            this.button1.TabIndex = 6;
            this.button1.Text = "Gerir Items";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.ManageItems);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1083, 768);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.Publishers_Software);
            this.Controls.Add(this.Users);
            this.Controls.Add(this.Store);
            this.Controls.Add(this.Statistics);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Statistics;
        private System.Windows.Forms.Button Store;
        private System.Windows.Forms.Button Users;
        private System.Windows.Forms.Button Publishers_Software;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button button1;
    }
}

