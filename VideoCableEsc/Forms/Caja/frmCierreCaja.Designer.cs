namespace VideoCableEsc.Forms.Caja
{
    partial class frmCierreCaja
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
            this.btnAbrirCaja = new System.Windows.Forms.Button();
            this.dpkFecha = new System.Windows.Forms.DateTimePicker();
            this.lblFecha = new System.Windows.Forms.Label();
            this.txtMontoFinal = new System.Windows.Forms.TextBox();
            this.lblAbrir = new System.Windows.Forms.Label();
            this.txtMontoSistema = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtMontoEgresado = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.txtTotalVenta = new System.Windows.Forms.TextBox();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // btnAbrirCaja
            // 
            this.btnAbrirCaja.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnAbrirCaja.Location = new System.Drawing.Point(285, 432);
            this.btnAbrirCaja.Name = "btnAbrirCaja";
            this.btnAbrirCaja.Size = new System.Drawing.Size(179, 46);
            this.btnAbrirCaja.TabIndex = 9;
            this.btnAbrirCaja.Text = "Abrir Caja";
            this.btnAbrirCaja.UseVisualStyleBackColor = true;
            // 
            // dpkFecha
            // 
            this.dpkFecha.Enabled = false;
            this.dpkFecha.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.dpkFecha.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dpkFecha.Location = new System.Drawing.Point(438, 43);
            this.dpkFecha.Name = "dpkFecha";
            this.dpkFecha.Size = new System.Drawing.Size(174, 31);
            this.dpkFecha.TabIndex = 8;
            // 
            // lblFecha
            // 
            this.lblFecha.AutoSize = true;
            this.lblFecha.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblFecha.Location = new System.Drawing.Point(300, 49);
            this.lblFecha.Name = "lblFecha";
            this.lblFecha.Size = new System.Drawing.Size(65, 23);
            this.lblFecha.TabIndex = 7;
            this.lblFecha.Text = "Fecha:";
            // 
            // txtMontoFinal
            // 
            this.txtMontoFinal.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtMontoFinal.Location = new System.Drawing.Point(438, 91);
            this.txtMontoFinal.MaxLength = 12;
            this.txtMontoFinal.Name = "txtMontoFinal";
            this.txtMontoFinal.Size = new System.Drawing.Size(174, 31);
            this.txtMontoFinal.TabIndex = 6;
            // 
            // lblAbrir
            // 
            this.lblAbrir.AutoSize = true;
            this.lblAbrir.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblAbrir.Location = new System.Drawing.Point(161, 94);
            this.lblAbrir.Name = "lblAbrir";
            this.lblAbrir.Size = new System.Drawing.Size(208, 23);
            this.lblAbrir.TabIndex = 5;
            this.lblAbrir.Text = "Monto Final Contado $:";
            // 
            // txtMontoSistema
            // 
            this.txtMontoSistema.Enabled = false;
            this.txtMontoSistema.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtMontoSistema.Location = new System.Drawing.Point(438, 139);
            this.txtMontoSistema.MaxLength = 12;
            this.txtMontoSistema.Name = "txtMontoSistema";
            this.txtMontoSistema.Size = new System.Drawing.Size(174, 31);
            this.txtMontoSistema.TabIndex = 11;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(90, 142);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(279, 23);
            this.label1.TabIndex = 10;
            this.label1.Text = "Monto Calculado Por Sistema $:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(90, 187);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(280, 23);
            this.label2.TabIndex = 12;
            this.label2.Text = "Monto Total Egresado del Día $:";
            // 
            // txtMontoEgresado
            // 
            this.txtMontoEgresado.Enabled = false;
            this.txtMontoEgresado.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtMontoEgresado.Location = new System.Drawing.Point(438, 184);
            this.txtMontoEgresado.MaxLength = 12;
            this.txtMontoEgresado.Name = "txtMontoEgresado";
            this.txtMontoEgresado.Size = new System.Drawing.Size(174, 31);
            this.txtMontoEgresado.TabIndex = 13;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(236, 234);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(134, 23);
            this.label3.TabIndex = 14;
            this.label3.Text = "Total Ventas $:";
            // 
            // txtTotalVenta
            // 
            this.txtTotalVenta.Enabled = false;
            this.txtTotalVenta.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtTotalVenta.Location = new System.Drawing.Point(438, 231);
            this.txtTotalVenta.MaxLength = 12;
            this.txtTotalVenta.Name = "txtTotalVenta";
            this.txtTotalVenta.Size = new System.Drawing.Size(174, 31);
            this.txtTotalVenta.TabIndex = 15;
            // 
            // textBox3
            // 
            this.textBox3.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox3.Location = new System.Drawing.Point(94, 325);
            this.textBox3.MaxLength = 12;
            this.textBox3.Multiline = true;
            this.textBox3.Name = "textBox3";
            this.textBox3.Size = new System.Drawing.Size(518, 90);
            this.textBox3.TabIndex = 16;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(300, 286);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(137, 23);
            this.label4.TabIndex = 17;
            this.label4.Text = "Observaciones";
            // 
            // frmCierreCaja
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(729, 490);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBox3);
            this.Controls.Add(this.txtTotalVenta);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtMontoEgresado);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtMontoSistema);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnAbrirCaja);
            this.Controls.Add(this.dpkFecha);
            this.Controls.Add(this.lblFecha);
            this.Controls.Add(this.txtMontoFinal);
            this.Controls.Add(this.lblAbrir);
            this.Name = "frmCierreCaja";
            this.Text = "frmCierreCaja";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnAbrirCaja;
        private System.Windows.Forms.DateTimePicker dpkFecha;
        private System.Windows.Forms.Label lblFecha;
        private System.Windows.Forms.TextBox txtMontoFinal;
        private System.Windows.Forms.Label lblAbrir;
        private System.Windows.Forms.TextBox txtMontoSistema;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtMontoEgresado;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtTotalVenta;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.Label label4;
    }
}