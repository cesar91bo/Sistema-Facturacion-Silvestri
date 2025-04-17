namespace VideoCableEsc.Forms.Caja
{
    partial class frmRegistroEgreso
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
            this.txtMontoSistema = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.lblAbrir = new System.Windows.Forms.Label();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.dpkFecha = new System.Windows.Forms.DateTimePicker();
            this.lblFecha = new System.Windows.Forms.Label();
            this.btnEgreso = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // txtMontoSistema
            // 
            this.txtMontoSistema.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtMontoSistema.Location = new System.Drawing.Point(319, 181);
            this.txtMontoSistema.MaxLength = 12;
            this.txtMontoSistema.Name = "txtMontoSistema";
            this.txtMontoSistema.Size = new System.Drawing.Size(174, 31);
            this.txtMontoSistema.TabIndex = 17;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(135, 184);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(149, 23);
            this.label1.TabIndex = 16;
            this.label1.Text = "Monto Egreso $:";
            // 
            // lblAbrir
            // 
            this.lblAbrir.AutoSize = true;
            this.lblAbrir.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblAbrir.Location = new System.Drawing.Point(317, 22);
            this.lblAbrir.Name = "lblAbrir";
            this.lblAbrir.Size = new System.Drawing.Size(171, 23);
            this.lblAbrir.TabIndex = 12;
            this.lblAbrir.Text = "Montivo de Egreso";
            // 
            // textBox3
            // 
            this.textBox3.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox3.Location = new System.Drawing.Point(139, 65);
            this.textBox3.MaxLength = 12;
            this.textBox3.Multiline = true;
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(518, 90);
            this.textBox3.TabIndex = 18;
            // 
            // dpkFecha
            // 
            this.dpkFecha.Enabled = false;
            this.dpkFecha.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.dpkFecha.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dpkFecha.Location = new System.Drawing.Point(319, 239);
            this.dpkFecha.Name = "dpkFecha";
            this.dpkFecha.Size = new System.Drawing.Size(174, 31);
            this.dpkFecha.TabIndex = 20;
            // 
            // lblFecha
            // 
            this.lblFecha.AutoSize = true;
            this.lblFecha.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblFecha.Location = new System.Drawing.Point(218, 247);
            this.lblFecha.Name = "lblFecha";
            this.lblFecha.Size = new System.Drawing.Size(65, 23);
            this.lblFecha.TabIndex = 19;
            this.lblFecha.Text = "Fecha:";
            // 
            // btnEgreso
            // 
            this.btnEgreso.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnEgreso.Location = new System.Drawing.Point(321, 327);
            this.btnEgreso.Name = "btnEgreso";
            this.btnEgreso.Size = new System.Drawing.Size(172, 46);
            this.btnEgreso.TabIndex = 21;
            this.btnEgreso.Text = "Guardar";
            this.btnEgreso.UseVisualStyleBackColor = true;
            // 
            // frmRegistroEgreso
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnEgreso);
            this.Controls.Add(this.dpkFecha);
            this.Controls.Add(this.lblFecha);
            this.Controls.Add(this.textBox3);
            this.Controls.Add(this.txtMontoSistema);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lblAbrir);
            this.Name = "frmRegistroEgreso";
            this.Text = "Registro de Egreso";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtMontoSistema;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label lblAbrir;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.DateTimePicker dpkFecha;
        private System.Windows.Forms.Label lblFecha;
        private System.Windows.Forms.Button btnEgreso;
    }
}