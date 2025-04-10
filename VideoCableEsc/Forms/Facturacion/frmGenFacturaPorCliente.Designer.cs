namespace VideoCableEsc.Forms.Facturacion
{
    partial class frmGenFacturaPorCliente
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmGenFacturaPorCliente));
            this.btnListadoCli = new System.Windows.Forms.PictureBox();
            this.btnBuscarCli = new System.Windows.Forms.PictureBox();
            this.txtNroCli = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.lblCliente = new System.Windows.Forms.Label();
            this.cbmServicio = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.lvFacturas = new System.Windows.Forms.ListView();
            this.btnConsultarFacturas = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.dtFecha = new System.Windows.Forms.DateTimePicker();
            this.btnRegistrarPago = new System.Windows.Forms.Button();
            this.btnLimpiar = new System.Windows.Forms.Button();
            this.progressBar1 = new System.Windows.Forms.ProgressBar();
            this.VerFacturaPdf = new System.Windows.Forms.Button();
            this.btnEditarPrecio = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.btnListadoCli)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnBuscarCli)).BeginInit();
            this.SuspendLayout();
            // 
            // btnListadoCli
            // 
            this.btnListadoCli.Image = ((System.Drawing.Image)(resources.GetObject("btnListadoCli.Image")));
            this.btnListadoCli.InitialImage = ((System.Drawing.Image)(resources.GetObject("btnListadoCli.InitialImage")));
            this.btnListadoCli.Location = new System.Drawing.Point(555, 164);
            this.btnListadoCli.Margin = new System.Windows.Forms.Padding(4);
            this.btnListadoCli.Name = "btnListadoCli";
            this.btnListadoCli.Size = new System.Drawing.Size(31, 28);
            this.btnListadoCli.TabIndex = 40;
            this.btnListadoCli.TabStop = false;
            this.btnListadoCli.Click += new System.EventHandler(this.btnListadoCli_Click);
            // 
            // btnBuscarCli
            // 
            this.btnBuscarCli.Image = ((System.Drawing.Image)(resources.GetObject("btnBuscarCli.Image")));
            this.btnBuscarCli.InitialImage = ((System.Drawing.Image)(resources.GetObject("btnBuscarCli.InitialImage")));
            this.btnBuscarCli.Location = new System.Drawing.Point(516, 164);
            this.btnBuscarCli.Margin = new System.Windows.Forms.Padding(4);
            this.btnBuscarCli.Name = "btnBuscarCli";
            this.btnBuscarCli.Size = new System.Drawing.Size(31, 28);
            this.btnBuscarCli.TabIndex = 39;
            this.btnBuscarCli.TabStop = false;
            this.btnBuscarCli.Click += new System.EventHandler(this.btnBuscarCli_Click);
            // 
            // txtNroCli
            // 
            this.txtNroCli.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtNroCli.Location = new System.Drawing.Point(419, 164);
            this.txtNroCli.Margin = new System.Windows.Forms.Padding(4);
            this.txtNroCli.MaxLength = 8;
            this.txtNroCli.Name = "txtNroCli";
            this.txtNroCli.Size = new System.Drawing.Size(89, 26);
            this.txtNroCli.TabIndex = 37;
            this.txtNroCli.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtNroCli_KeyDown);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(333, 172);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(66, 20);
            this.label4.TabIndex = 38;
            this.label4.Text = "Cliente:";
            // 
            // lblCliente
            // 
            this.lblCliente.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCliente.Location = new System.Drawing.Point(612, 164);
            this.lblCliente.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCliente.Name = "lblCliente";
            this.lblCliente.Size = new System.Drawing.Size(817, 26);
            this.lblCliente.TabIndex = 41;
            this.lblCliente.Text = "Nombre del Cliente";
            // 
            // cbmServicio
            // 
            this.cbmServicio.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbmServicio.Enabled = false;
            this.cbmServicio.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbmServicio.FormattingEnabled = true;
            this.cbmServicio.Location = new System.Drawing.Point(419, 208);
            this.cbmServicio.Margin = new System.Windows.Forms.Padding(4);
            this.cbmServicio.Name = "cbmServicio";
            this.cbmServicio.Size = new System.Drawing.Size(353, 28);
            this.cbmServicio.TabIndex = 44;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(328, 215);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(74, 20);
            this.label1.TabIndex = 45;
            this.label1.Text = "Servicio:";
            // 
            // lvFacturas
            // 
            this.lvFacturas.FullRowSelect = true;
            this.lvFacturas.GridLines = true;
            this.lvFacturas.HideSelection = false;
            this.lvFacturas.Location = new System.Drawing.Point(221, 289);
            this.lvFacturas.Margin = new System.Windows.Forms.Padding(4);
            this.lvFacturas.MultiSelect = false;
            this.lvFacturas.Name = "lvFacturas";
            this.lvFacturas.Size = new System.Drawing.Size(1208, 404);
            this.lvFacturas.TabIndex = 60;
            this.lvFacturas.UseCompatibleStateImageBehavior = false;
            this.lvFacturas.View = System.Windows.Forms.View.Details;
            this.lvFacturas.SelectedIndexChanged += new System.EventHandler(this.lvFacturas_SelectedIndexChanged);
            // 
            // btnConsultarFacturas
            // 
            this.btnConsultarFacturas.Location = new System.Drawing.Point(616, 727);
            this.btnConsultarFacturas.Margin = new System.Windows.Forms.Padding(4);
            this.btnConsultarFacturas.Name = "btnConsultarFacturas";
            this.btnConsultarFacturas.Size = new System.Drawing.Size(115, 47);
            this.btnConsultarFacturas.TabIndex = 61;
            this.btnConsultarFacturas.Text = "Generar";
            this.btnConsultarFacturas.UseVisualStyleBackColor = true;
            this.btnConsultarFacturas.Click += new System.EventHandler(this.btnConsultarFacturas_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(217, 252);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(178, 20);
            this.label2.TabIndex = 62;
            this.label2.Text = "Fecha Última Emisión:";
            // 
            // dtFecha
            // 
            this.dtFecha.Enabled = false;
            this.dtFecha.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.dtFecha.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dtFecha.Location = new System.Drawing.Point(419, 249);
            this.dtFecha.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dtFecha.Name = "dtFecha";
            this.dtFecha.Size = new System.Drawing.Size(144, 26);
            this.dtFecha.TabIndex = 63;
            // 
            // btnRegistrarPago
            // 
            this.btnRegistrarPago.Enabled = false;
            this.btnRegistrarPago.Location = new System.Drawing.Point(759, 727);
            this.btnRegistrarPago.Margin = new System.Windows.Forms.Padding(4);
            this.btnRegistrarPago.Name = "btnRegistrarPago";
            this.btnRegistrarPago.Size = new System.Drawing.Size(115, 47);
            this.btnRegistrarPago.TabIndex = 66;
            this.btnRegistrarPago.Text = "Registrar Pago";
            this.btnRegistrarPago.UseVisualStyleBackColor = true;
            this.btnRegistrarPago.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnLimpiar
            // 
            this.btnLimpiar.Location = new System.Drawing.Point(1037, 727);
            this.btnLimpiar.Margin = new System.Windows.Forms.Padding(4);
            this.btnLimpiar.Name = "btnLimpiar";
            this.btnLimpiar.Size = new System.Drawing.Size(115, 47);
            this.btnLimpiar.TabIndex = 67;
            this.btnLimpiar.Text = "Limpiar";
            this.btnLimpiar.UseVisualStyleBackColor = true;
            this.btnLimpiar.Click += new System.EventHandler(this.btnLimpiar_Click);
            // 
            // progressBar1
            // 
            this.progressBar1.Location = new System.Drawing.Point(516, 124);
            this.progressBar1.Name = "progressBar1";
            this.progressBar1.Size = new System.Drawing.Size(417, 33);
            this.progressBar1.Style = System.Windows.Forms.ProgressBarStyle.Marquee;
            this.progressBar1.TabIndex = 68;
            this.progressBar1.Visible = false;
            // 
            // VerFacturaPdf
            // 
            this.VerFacturaPdf.Enabled = false;
            this.VerFacturaPdf.Location = new System.Drawing.Point(895, 727);
            this.VerFacturaPdf.Margin = new System.Windows.Forms.Padding(4);
            this.VerFacturaPdf.Name = "VerFacturaPdf";
            this.VerFacturaPdf.Size = new System.Drawing.Size(115, 47);
            this.VerFacturaPdf.TabIndex = 69;
            this.VerFacturaPdf.Text = "Ver Factura PDF";
            this.VerFacturaPdf.UseVisualStyleBackColor = true;
            this.VerFacturaPdf.Click += new System.EventHandler(this.VerFacturaPdf_Click);
            // 
            // btnEditarPrecio
            // 
            this.btnEditarPrecio.Enabled = false;
            this.btnEditarPrecio.Location = new System.Drawing.Point(1314, 727);
            this.btnEditarPrecio.Margin = new System.Windows.Forms.Padding(4);
            this.btnEditarPrecio.Name = "btnEditarPrecio";
            this.btnEditarPrecio.Size = new System.Drawing.Size(115, 47);
            this.btnEditarPrecio.TabIndex = 70;
            this.btnEditarPrecio.Text = "Editar";
            this.btnEditarPrecio.UseVisualStyleBackColor = true;
            this.btnEditarPrecio.Visible = false;
            this.btnEditarPrecio.Click += new System.EventHandler(this.btnEditarPrecio_Click);
            // 
            // frmGenFacturaPorCliente
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1595, 815);
            this.Controls.Add(this.btnEditarPrecio);
            this.Controls.Add(this.VerFacturaPdf);
            this.Controls.Add(this.progressBar1);
            this.Controls.Add(this.btnLimpiar);
            this.Controls.Add(this.btnRegistrarPago);
            this.Controls.Add(this.dtFecha);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnConsultarFacturas);
            this.Controls.Add(this.lvFacturas);
            this.Controls.Add(this.cbmServicio);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lblCliente);
            this.Controls.Add(this.btnListadoCli);
            this.Controls.Add(this.btnBuscarCli);
            this.Controls.Add(this.txtNroCli);
            this.Controls.Add(this.label4);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "frmGenFacturaPorCliente";
            this.Text = "Facturas Por Cliente";
            this.Load += new System.EventHandler(this.frmGenFacturaPorCliente_Load);
            ((System.ComponentModel.ISupportInitialize)(this.btnListadoCli)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnBuscarCli)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        internal System.Windows.Forms.PictureBox btnListadoCli;
        internal System.Windows.Forms.PictureBox btnBuscarCli;
        private System.Windows.Forms.TextBox txtNroCli;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label lblCliente;
        private System.Windows.Forms.ComboBox cbmServicio;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ListView lvFacturas;
        private System.Windows.Forms.Button btnConsultarFacturas;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DateTimePicker dtFecha;
        private System.Windows.Forms.Button btnRegistrarPago;
        private System.Windows.Forms.Button btnLimpiar;
        private System.Windows.Forms.ProgressBar progressBar1;
        private System.Windows.Forms.Button VerFacturaPdf;
        private System.Windows.Forms.Button btnEditarPrecio;
    }
}