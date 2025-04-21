namespace VideoCableEsc
{
    partial class frmPrincipal
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmPrincipal));
            this.panelMenu = new System.Windows.Forms.Panel();
            this.btnSetting = new System.Windows.Forms.Button();
            this.btnCajas = new System.Windows.Forms.Button();
            this.pnlSubMenuReporte = new System.Windows.Forms.Panel();
            this.btnConsVentas = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.Reportes = new System.Windows.Forms.Button();
            this.pnlSubmenuFact = new System.Windows.Forms.Panel();
            this.btnConsultaFV = new System.Windows.Forms.Button();
            this.btnFacturaX = new System.Windows.Forms.Button();
            this.btnFactura = new System.Windows.Forms.Button();
            this.btnServicios = new System.Windows.Forms.Button();
            this.pnlSubMenuClientes = new System.Windows.Forms.Panel();
            this.btnFibraOptica = new System.Windows.Forms.Button();
            this.btnVideoCable = new System.Windows.Forms.Button();
            this.btnCliente = new System.Windows.Forms.Button();
            this.btnIndex = new System.Windows.Forms.Button();
            this.panelLogo = new System.Windows.Forms.Panel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.btnMinimize = new System.Windows.Forms.PictureBox();
            this.btnClose = new System.Windows.Forms.PictureBox();
            this.panelTitleBar = new System.Windows.Forms.Panel();
            this.lblTittle = new System.Windows.Forms.Label();
            this.horaFecha = new System.Windows.Forms.Timer(this.components);
            this.lblHora = new System.Windows.Forms.Label();
            this.lblFecha = new System.Windows.Forms.Label();
            this.panelDesktop = new System.Windows.Forms.Panel();
            this.panelMenu.SuspendLayout();
            this.pnlSubMenuReporte.SuspendLayout();
            this.pnlSubmenuFact.SuspendLayout();
            this.pnlSubMenuClientes.SuspendLayout();
            this.panelLogo.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnMinimize)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnClose)).BeginInit();
            this.panelTitleBar.SuspendLayout();
            this.panelDesktop.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelMenu
            // 
            this.panelMenu.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(51)))), ((int)(((byte)(51)))), ((int)(((byte)(76)))));
            this.panelMenu.Controls.Add(this.btnSetting);
            this.panelMenu.Controls.Add(this.btnCajas);
            this.panelMenu.Controls.Add(this.pnlSubMenuReporte);
            this.panelMenu.Controls.Add(this.Reportes);
            this.panelMenu.Controls.Add(this.pnlSubmenuFact);
            this.panelMenu.Controls.Add(this.btnFactura);
            this.panelMenu.Controls.Add(this.btnServicios);
            this.panelMenu.Controls.Add(this.pnlSubMenuClientes);
            this.panelMenu.Controls.Add(this.btnCliente);
            this.panelMenu.Controls.Add(this.btnIndex);
            this.panelMenu.Controls.Add(this.panelLogo);
            resources.ApplyResources(this.panelMenu, "panelMenu");
            this.panelMenu.Name = "panelMenu";
            // 
            // btnSetting
            // 
            resources.ApplyResources(this.btnSetting, "btnSetting");
            this.btnSetting.FlatAppearance.BorderSize = 0;
            this.btnSetting.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnSetting.Name = "btnSetting";
            this.btnSetting.UseVisualStyleBackColor = true;
            this.btnSetting.Click += new System.EventHandler(this.btnSetting_Click);
            // 
            // btnCajas
            // 
            resources.ApplyResources(this.btnCajas, "btnCajas");
            this.btnCajas.FlatAppearance.BorderSize = 0;
            this.btnCajas.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnCajas.Name = "btnCajas";
            this.btnCajas.UseVisualStyleBackColor = true;
            this.btnCajas.Click += new System.EventHandler(this.btnCajas_Click);
            // 
            // pnlSubMenuReporte
            // 
            this.pnlSubMenuReporte.Controls.Add(this.btnConsVentas);
            this.pnlSubMenuReporte.Controls.Add(this.button3);
            resources.ApplyResources(this.pnlSubMenuReporte, "pnlSubMenuReporte");
            this.pnlSubMenuReporte.Name = "pnlSubMenuReporte";
            // 
            // btnConsVentas
            // 
            resources.ApplyResources(this.btnConsVentas, "btnConsVentas");
            this.btnConsVentas.FlatAppearance.BorderSize = 0;
            this.btnConsVentas.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnConsVentas.Name = "btnConsVentas";
            this.btnConsVentas.UseVisualStyleBackColor = true;
            this.btnConsVentas.Click += new System.EventHandler(this.btnConsVentas_Click);
            // 
            // button3
            // 
            resources.ApplyResources(this.button3, "button3");
            this.button3.FlatAppearance.BorderSize = 0;
            this.button3.ForeColor = System.Drawing.Color.Gainsboro;
            this.button3.Name = "button3";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // Reportes
            // 
            resources.ApplyResources(this.Reportes, "Reportes");
            this.Reportes.FlatAppearance.BorderSize = 0;
            this.Reportes.ForeColor = System.Drawing.Color.Gainsboro;
            this.Reportes.Name = "Reportes";
            this.Reportes.UseVisualStyleBackColor = true;
            this.Reportes.Click += new System.EventHandler(this.Reportes_Click);
            // 
            // pnlSubmenuFact
            // 
            this.pnlSubmenuFact.Controls.Add(this.btnConsultaFV);
            this.pnlSubmenuFact.Controls.Add(this.btnFacturaX);
            resources.ApplyResources(this.pnlSubmenuFact, "pnlSubmenuFact");
            this.pnlSubmenuFact.Name = "pnlSubmenuFact";
            // 
            // btnConsultaFV
            // 
            resources.ApplyResources(this.btnConsultaFV, "btnConsultaFV");
            this.btnConsultaFV.FlatAppearance.BorderSize = 0;
            this.btnConsultaFV.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnConsultaFV.Name = "btnConsultaFV";
            this.btnConsultaFV.UseVisualStyleBackColor = true;
            this.btnConsultaFV.Click += new System.EventHandler(this.btnConsultaFV_Click);
            // 
            // btnFacturaX
            // 
            resources.ApplyResources(this.btnFacturaX, "btnFacturaX");
            this.btnFacturaX.FlatAppearance.BorderSize = 0;
            this.btnFacturaX.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnFacturaX.Name = "btnFacturaX";
            this.btnFacturaX.UseVisualStyleBackColor = true;
            this.btnFacturaX.Click += new System.EventHandler(this.btnFacturaX_Click);
            // 
            // btnFactura
            // 
            resources.ApplyResources(this.btnFactura, "btnFactura");
            this.btnFactura.FlatAppearance.BorderSize = 0;
            this.btnFactura.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnFactura.Name = "btnFactura";
            this.btnFactura.UseVisualStyleBackColor = true;
            this.btnFactura.Click += new System.EventHandler(this.btnFactura_Click);
            // 
            // btnServicios
            // 
            resources.ApplyResources(this.btnServicios, "btnServicios");
            this.btnServicios.FlatAppearance.BorderSize = 0;
            this.btnServicios.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnServicios.Name = "btnServicios";
            this.btnServicios.UseVisualStyleBackColor = true;
            this.btnServicios.Click += new System.EventHandler(this.btnServicios_Click);
            // 
            // pnlSubMenuClientes
            // 
            this.pnlSubMenuClientes.Controls.Add(this.btnFibraOptica);
            this.pnlSubMenuClientes.Controls.Add(this.btnVideoCable);
            resources.ApplyResources(this.pnlSubMenuClientes, "pnlSubMenuClientes");
            this.pnlSubMenuClientes.Name = "pnlSubMenuClientes";
            // 
            // btnFibraOptica
            // 
            resources.ApplyResources(this.btnFibraOptica, "btnFibraOptica");
            this.btnFibraOptica.FlatAppearance.BorderSize = 0;
            this.btnFibraOptica.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnFibraOptica.Name = "btnFibraOptica";
            this.btnFibraOptica.UseVisualStyleBackColor = true;
            this.btnFibraOptica.Click += new System.EventHandler(this.btnFibraOptica_Click);
            // 
            // btnVideoCable
            // 
            resources.ApplyResources(this.btnVideoCable, "btnVideoCable");
            this.btnVideoCable.FlatAppearance.BorderSize = 0;
            this.btnVideoCable.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnVideoCable.Name = "btnVideoCable";
            this.btnVideoCable.UseVisualStyleBackColor = true;
            this.btnVideoCable.Click += new System.EventHandler(this.btnVideoCable_Click);
            // 
            // btnCliente
            // 
            resources.ApplyResources(this.btnCliente, "btnCliente");
            this.btnCliente.FlatAppearance.BorderSize = 0;
            this.btnCliente.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnCliente.Name = "btnCliente";
            this.btnCliente.UseVisualStyleBackColor = true;
            this.btnCliente.Click += new System.EventHandler(this.btnCliente_Click);
            // 
            // btnIndex
            // 
            resources.ApplyResources(this.btnIndex, "btnIndex");
            this.btnIndex.FlatAppearance.BorderSize = 0;
            this.btnIndex.ForeColor = System.Drawing.Color.Gainsboro;
            this.btnIndex.Name = "btnIndex";
            this.btnIndex.UseVisualStyleBackColor = true;
            this.btnIndex.Click += new System.EventHandler(this.btnIndex_Click);
            // 
            // panelLogo
            // 
            this.panelLogo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(39)))), ((int)(((byte)(39)))), ((int)(((byte)(58)))));
            this.panelLogo.Controls.Add(this.pictureBox1);
            resources.ApplyResources(this.panelLogo, "panelLogo");
            this.panelLogo.Name = "panelLogo";
            // 
            // pictureBox1
            // 
            resources.ApplyResources(this.pictureBox1, "pictureBox1");
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.TabStop = false;
            this.pictureBox1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.pictureBox1_MouseDown);
            // 
            // btnMinimize
            // 
            resources.ApplyResources(this.btnMinimize, "btnMinimize");
            this.btnMinimize.Name = "btnMinimize";
            this.btnMinimize.TabStop = false;
            this.btnMinimize.Click += new System.EventHandler(this.btnMinimize_Click);
            // 
            // btnClose
            // 
            resources.ApplyResources(this.btnClose, "btnClose");
            this.btnClose.Name = "btnClose";
            this.btnClose.TabStop = false;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // panelTitleBar
            // 
            this.panelTitleBar.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(150)))), ((int)(((byte)(136)))));
            this.panelTitleBar.Controls.Add(this.btnMinimize);
            this.panelTitleBar.Controls.Add(this.lblTittle);
            this.panelTitleBar.Controls.Add(this.btnClose);
            resources.ApplyResources(this.panelTitleBar, "panelTitleBar");
            this.panelTitleBar.Name = "panelTitleBar";
            this.panelTitleBar.MouseDown += new System.Windows.Forms.MouseEventHandler(this.panelTitleBar_MouseDown);
            // 
            // lblTittle
            // 
            resources.ApplyResources(this.lblTittle, "lblTittle");
            this.lblTittle.ForeColor = System.Drawing.Color.White;
            this.lblTittle.Name = "lblTittle";
            // 
            // horaFecha
            // 
            this.horaFecha.Enabled = true;
            this.horaFecha.Tick += new System.EventHandler(this.horaFecha_Tick);
            // 
            // lblHora
            // 
            resources.ApplyResources(this.lblHora, "lblHora");
            this.lblHora.ForeColor = System.Drawing.Color.DodgerBlue;
            this.lblHora.Name = "lblHora";
            // 
            // lblFecha
            // 
            resources.ApplyResources(this.lblFecha, "lblFecha");
            this.lblFecha.ForeColor = System.Drawing.Color.SlateGray;
            this.lblFecha.Name = "lblFecha";
            // 
            // panelDesktop
            // 
            this.panelDesktop.Controls.Add(this.lblFecha);
            this.panelDesktop.Controls.Add(this.lblHora);
            resources.ApplyResources(this.panelDesktop, "panelDesktop");
            this.panelDesktop.Name = "panelDesktop";
            // 
            // frmPrincipal
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.panelTitleBar);
            this.Controls.Add(this.panelDesktop);
            this.Controls.Add(this.panelMenu);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "frmPrincipal";
            this.panelMenu.ResumeLayout(false);
            this.pnlSubMenuReporte.ResumeLayout(false);
            this.pnlSubmenuFact.ResumeLayout(false);
            this.pnlSubMenuClientes.ResumeLayout(false);
            this.panelLogo.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnMinimize)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.btnClose)).EndInit();
            this.panelTitleBar.ResumeLayout(false);
            this.panelTitleBar.PerformLayout();
            this.panelDesktop.ResumeLayout(false);
            this.panelDesktop.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panelMenu;
        private System.Windows.Forms.Button btnServicios;
        private System.Windows.Forms.Button btnCliente;
        private System.Windows.Forms.Panel panelLogo;
        private System.Windows.Forms.Button btnFactura;
        private System.Windows.Forms.Button btnSetting;
        private System.Windows.Forms.PictureBox btnMinimize;
        private System.Windows.Forms.PictureBox btnClose;
        private System.Windows.Forms.Panel panelTitleBar;
        public System.Windows.Forms.Label lblTittle;
        private System.Windows.Forms.Button btnIndex;
        private System.Windows.Forms.Timer horaFecha;
        private System.Windows.Forms.Panel pnlSubmenuFact;
        private System.Windows.Forms.Button btnConsultaFV;
        private System.Windows.Forms.Button btnFacturaX;
        private System.Windows.Forms.Button Reportes;
        private System.Windows.Forms.Panel pnlSubMenuReporte;
        private System.Windows.Forms.Button btnConsVentas;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Panel pnlSubMenuClientes;
        private System.Windows.Forms.Button btnFibraOptica;
        private System.Windows.Forms.Button btnVideoCable;
        private System.Windows.Forms.Button btnCajas;
        private System.Windows.Forms.Label lblHora;
        private System.Windows.Forms.Label lblFecha;
        public System.Windows.Forms.Panel panelDesktop;
        private System.Windows.Forms.PictureBox pictureBox1;
    }
}