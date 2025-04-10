namespace VideoCableEsc.Forms.Facturacion
{
    partial class frmFormaPago
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
            this.cmbFPago = new System.Windows.Forms.ComboBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.txtNroFact = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.txtMonto = new System.Windows.Forms.TextBox();
            this.rbFacturaX = new System.Windows.Forms.RadioButton();
            this.rbFacturaElectronica = new System.Windows.Forms.RadioButton();
            this.label3 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // cmbFPago
            // 
            this.cmbFPago.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbFPago.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cmbFPago.FormattingEnabled = true;
            this.cmbFPago.Location = new System.Drawing.Point(209, 49);
            this.cmbFPago.Name = "cmbFPago";
            this.cmbFPago.Size = new System.Drawing.Size(191, 24);
            this.cmbFPago.TabIndex = 44;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(95, 50);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(109, 17);
            this.label5.TabIndex = 45;
            this.label5.Text = "Forma de Pago:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(109, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(91, 17);
            this.label1.TabIndex = 46;
            this.label1.Text = "Nro. Factura:";
            // 
            // txtNroFact
            // 
            this.txtNroFact.Enabled = false;
            this.txtNroFact.Location = new System.Drawing.Point(210, 13);
            this.txtNroFact.Name = "txtNroFact";
            this.txtNroFact.Size = new System.Drawing.Size(100, 20);
            this.txtNroFact.TabIndex = 47;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(217, 228);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(86, 38);
            this.button1.TabIndex = 67;
            this.button1.Text = "Registrar";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(98, 87);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(105, 17);
            this.label2.TabIndex = 68;
            this.label2.Text = "Monto a Pagar:";
            // 
            // txtMonto
            // 
            this.txtMonto.Enabled = false;
            this.txtMonto.Location = new System.Drawing.Point(210, 87);
            this.txtMonto.Name = "txtMonto";
            this.txtMonto.Size = new System.Drawing.Size(100, 20);
            this.txtMonto.TabIndex = 69;
            // 
            // rbFacturaX
            // 
            this.rbFacturaX.AutoSize = true;
            this.rbFacturaX.Location = new System.Drawing.Point(8, 12);
            this.rbFacturaX.Name = "rbFacturaX";
            this.rbFacturaX.Size = new System.Drawing.Size(71, 17);
            this.rbFacturaX.TabIndex = 70;
            this.rbFacturaX.TabStop = true;
            this.rbFacturaX.Text = "Factura X";
            this.rbFacturaX.UseVisualStyleBackColor = true;
            // 
            // rbFacturaElectronica
            // 
            this.rbFacturaElectronica.AutoSize = true;
            this.rbFacturaElectronica.Location = new System.Drawing.Point(107, 12);
            this.rbFacturaElectronica.Name = "rbFacturaElectronica";
            this.rbFacturaElectronica.Size = new System.Drawing.Size(117, 17);
            this.rbFacturaElectronica.TabIndex = 71;
            this.rbFacturaElectronica.TabStop = true;
            this.rbFacturaElectronica.Text = "Factura Electrónica";
            this.rbFacturaElectronica.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(88, 129);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(112, 17);
            this.label3.TabIndex = 72;
            this.label3.Text = "Tipo de Factura:";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbFacturaElectronica);
            this.groupBox1.Controls.Add(this.rbFacturaX);
            this.groupBox1.Location = new System.Drawing.Point(209, 117);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(231, 37);
            this.groupBox1.TabIndex = 73;
            this.groupBox1.TabStop = false;
            // 
            // frmFormaPago
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(543, 302);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtMonto);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.txtNroFact);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cmbFPago);
            this.Controls.Add(this.label5);
            this.Name = "frmFormaPago";
            this.Text = "frmFormaPago";
            this.Load += new System.EventHandler(this.frmFormaPago_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cmbFPago;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtNroFact;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtMonto;
        private System.Windows.Forms.RadioButton rbFacturaX;
        private System.Windows.Forms.RadioButton rbFacturaElectronica;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.GroupBox groupBox1;
    }
}