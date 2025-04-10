namespace VideoCableEsc.Forms.Facturacion
{
    partial class frmConsFactura
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmConsFactura));
            this.listFact = new System.Windows.Forms.ListView();
            this.btnBuscar = new System.Windows.Forms.Button();
            this.dtpFechaHastaFact = new System.Windows.Forms.DateTimePicker();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.dtpFechaDesdeFact = new System.Windows.Forms.DateTimePicker();
            this.txtClienteFactura = new System.Windows.Forms.TextBox();
            this.btnComprobanteX = new System.Windows.Forms.Button();
            this.btnFacturaElectronica = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.btnGenerarFacturas = new System.Windows.Forms.Button();
            this.VerFacturaPdf = new System.Windows.Forms.Button();
            this.checkHabilitar = new System.Windows.Forms.CheckBox();
            this.btnEditarPrecio = new System.Windows.Forms.Button();
            this.btnVolver = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // listFact
            // 
            this.listFact.FullRowSelect = true;
            this.listFact.GridLines = true;
            this.listFact.HideSelection = false;
            this.listFact.Location = new System.Drawing.Point(12, 173);
            this.listFact.MultiSelect = false;
            this.listFact.Name = "listFact";
            this.listFact.Size = new System.Drawing.Size(1059, 447);
            this.listFact.TabIndex = 2;
            this.listFact.UseCompatibleStateImageBehavior = false;
            this.listFact.View = System.Windows.Forms.View.Details;
            this.listFact.SelectedIndexChanged += new System.EventHandler(this.listFact_SelectedIndexChanged);
            // 
            // btnBuscar
            // 
            this.btnBuscar.Image = ((System.Drawing.Image)(resources.GetObject("btnBuscar.Image")));
            this.btnBuscar.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnBuscar.Location = new System.Drawing.Point(723, 137);
            this.btnBuscar.Name = "btnBuscar";
            this.btnBuscar.Size = new System.Drawing.Size(75, 21);
            this.btnBuscar.TabIndex = 49;
            this.btnBuscar.Text = "Buscar";
            this.btnBuscar.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnBuscar.UseVisualStyleBackColor = true;
            this.btnBuscar.Click += new System.EventHandler(this.btnBuscar_Click);
            // 
            // dtpFechaHastaFact
            // 
            this.dtpFechaHastaFact.Enabled = false;
            this.dtpFechaHastaFact.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dtpFechaHastaFact.Location = new System.Drawing.Point(494, 136);
            this.dtpFechaHastaFact.Name = "dtpFechaHastaFact";
            this.dtpFechaHastaFact.Size = new System.Drawing.Size(105, 20);
            this.dtpFechaHastaFact.TabIndex = 48;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(449, 140);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(38, 13);
            this.label3.TabIndex = 47;
            this.label3.Text = "Hasta:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(258, 140);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(41, 13);
            this.label4.TabIndex = 46;
            this.label4.Text = "Desde:";
            // 
            // dtpFechaDesdeFact
            // 
            this.dtpFechaDesdeFact.Enabled = false;
            this.dtpFechaDesdeFact.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dtpFechaDesdeFact.Location = new System.Drawing.Point(303, 136);
            this.dtpFechaDesdeFact.Name = "dtpFechaDesdeFact";
            this.dtpFechaDesdeFact.Size = new System.Drawing.Size(105, 20);
            this.dtpFechaDesdeFact.TabIndex = 45;
            // 
            // txtClienteFactura
            // 
            this.txtClienteFactura.Enabled = false;
            this.txtClienteFactura.Location = new System.Drawing.Point(233, 107);
            this.txtClienteFactura.Name = "txtClienteFactura";
            this.txtClienteFactura.Size = new System.Drawing.Size(565, 20);
            this.txtClienteFactura.TabIndex = 42;
            // 
            // btnComprobanteX
            // 
            this.btnComprobanteX.Location = new System.Drawing.Point(452, 658);
            this.btnComprobanteX.Name = "btnComprobanteX";
            this.btnComprobanteX.Size = new System.Drawing.Size(86, 38);
            this.btnComprobanteX.TabIndex = 50;
            this.btnComprobanteX.Text = "Comprobante X";
            this.btnComprobanteX.UseVisualStyleBackColor = true;
            this.btnComprobanteX.Click += new System.EventHandler(this.btnComprobanteX_Click);
            // 
            // btnFacturaElectronica
            // 
            this.btnFacturaElectronica.Location = new System.Drawing.Point(544, 658);
            this.btnFacturaElectronica.Name = "btnFacturaElectronica";
            this.btnFacturaElectronica.Size = new System.Drawing.Size(86, 38);
            this.btnFacturaElectronica.TabIndex = 51;
            this.btnFacturaElectronica.Text = "Factura Electronica";
            this.btnFacturaElectronica.UseVisualStyleBackColor = true;
            this.btnFacturaElectronica.Click += new System.EventHandler(this.btnFacturaElectronica_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(166, 110);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(55, 17);
            this.label1.TabIndex = 52;
            this.label1.Text = "Cliente:";
            // 
            // btnGenerarFacturas
            // 
            this.btnGenerarFacturas.Location = new System.Drawing.Point(359, 658);
            this.btnGenerarFacturas.Name = "btnGenerarFacturas";
            this.btnGenerarFacturas.Size = new System.Drawing.Size(86, 38);
            this.btnGenerarFacturas.TabIndex = 54;
            this.btnGenerarFacturas.Text = "Generar Facturas";
            this.btnGenerarFacturas.UseVisualStyleBackColor = true;
            this.btnGenerarFacturas.Click += new System.EventHandler(this.btnGenerarFacturas_Click);
            // 
            // VerFacturaPdf
            // 
            this.VerFacturaPdf.Location = new System.Drawing.Point(636, 658);
            this.VerFacturaPdf.Name = "VerFacturaPdf";
            this.VerFacturaPdf.Size = new System.Drawing.Size(86, 38);
            this.VerFacturaPdf.TabIndex = 55;
            this.VerFacturaPdf.Text = "Ver Factura PDF";
            this.VerFacturaPdf.UseVisualStyleBackColor = true;
            this.VerFacturaPdf.Click += new System.EventHandler(this.VerFacturaPdf_Click);
            // 
            // checkHabilitar
            // 
            this.checkHabilitar.AutoSize = true;
            this.checkHabilitar.Location = new System.Drawing.Point(162, 141);
            this.checkHabilitar.Name = "checkHabilitar";
            this.checkHabilitar.Size = new System.Drawing.Size(56, 17);
            this.checkHabilitar.TabIndex = 56;
            this.checkHabilitar.Text = "Fecha";
            this.checkHabilitar.UseVisualStyleBackColor = true;
            this.checkHabilitar.CheckedChanged += new System.EventHandler(this.checkHabilitar_CheckedChanged);
            // 
            // btnEditarPrecio
            // 
            this.btnEditarPrecio.Enabled = false;
            this.btnEditarPrecio.Location = new System.Drawing.Point(985, 658);
            this.btnEditarPrecio.Name = "btnEditarPrecio";
            this.btnEditarPrecio.Size = new System.Drawing.Size(86, 38);
            this.btnEditarPrecio.TabIndex = 57;
            this.btnEditarPrecio.Text = "Editar";
            this.btnEditarPrecio.UseVisualStyleBackColor = true;
            this.btnEditarPrecio.Visible = false;
            this.btnEditarPrecio.Click += new System.EventHandler(this.btnEditarPrecio_Click);
            // 
            // btnVolver
            // 
            this.btnVolver.Location = new System.Drawing.Point(12, 658);
            this.btnVolver.Name = "btnVolver";
            this.btnVolver.Size = new System.Drawing.Size(86, 38);
            this.btnVolver.TabIndex = 58;
            this.btnVolver.Text = "Volver";
            this.btnVolver.UseVisualStyleBackColor = true;
            this.btnVolver.Click += new System.EventHandler(this.btnVolver_Click);
            // 
            // frmConsFactura
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1240, 725);
            this.Controls.Add(this.btnVolver);
            this.Controls.Add(this.btnEditarPrecio);
            this.Controls.Add(this.checkHabilitar);
            this.Controls.Add(this.VerFacturaPdf);
            this.Controls.Add(this.btnGenerarFacturas);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnFacturaElectronica);
            this.Controls.Add(this.btnComprobanteX);
            this.Controls.Add(this.btnBuscar);
            this.Controls.Add(this.dtpFechaHastaFact);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.dtpFechaDesdeFact);
            this.Controls.Add(this.txtClienteFactura);
            this.Controls.Add(this.listFact);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "frmConsFactura";
            this.Text = "Consulta de Facturas";
            this.Load += new System.EventHandler(this.frmConsFactura_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListView listFact;
        private System.Windows.Forms.Button btnBuscar;
        private System.Windows.Forms.DateTimePicker dtpFechaHastaFact;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.DateTimePicker dtpFechaDesdeFact;
        private System.Windows.Forms.TextBox txtClienteFactura;
        private System.Windows.Forms.Button btnComprobanteX;
        private System.Windows.Forms.Button btnFacturaElectronica;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnGenerarFacturas;
        private System.Windows.Forms.Button VerFacturaPdf;
        private System.Windows.Forms.CheckBox checkHabilitar;
        private System.Windows.Forms.Button btnEditarPrecio;
        private System.Windows.Forms.Button btnVolver;
    }
}