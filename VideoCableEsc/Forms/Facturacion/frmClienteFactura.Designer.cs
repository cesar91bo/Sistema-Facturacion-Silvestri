namespace VideoCableEsc.Forms.Facturacion
{
    partial class frmClienteFactura
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmClienteFactura));
            this.btnConsultarFacturas = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtCliente = new System.Windows.Forms.TextBox();
            this.listCliente = new System.Windows.Forms.ListView();
            this.btnBuscar = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnConsultarFacturas
            // 
            this.btnConsultarFacturas.Location = new System.Drawing.Point(706, 627);
            this.btnConsultarFacturas.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnConsultarFacturas.Name = "btnConsultarFacturas";
            this.btnConsultarFacturas.Size = new System.Drawing.Size(115, 47);
            this.btnConsultarFacturas.TabIndex = 55;
            this.btnConsultarFacturas.Text = "Consultar Facturas";
            this.btnConsultarFacturas.UseVisualStyleBackColor = true;
            this.btnConsultarFacturas.Click += new System.EventHandler(this.btnConsultarFacturas_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(355, 134);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(66, 20);
            this.label1.TabIndex = 57;
            this.label1.Text = "Cliente:";
            // 
            // txtCliente
            // 
            this.txtCliente.Location = new System.Drawing.Point(445, 130);
            this.txtCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.txtCliente.Name = "txtCliente";
            this.txtCliente.Size = new System.Drawing.Size(533, 22);
            this.txtCliente.TabIndex = 56;
            // 
            // listCliente
            // 
            this.listCliente.FullRowSelect = true;
            this.listCliente.GridLines = true;
            this.listCliente.HideSelection = false;
            this.listCliente.Location = new System.Drawing.Point(171, 180);
            this.listCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.listCliente.MultiSelect = false;
            this.listCliente.Name = "listCliente";
            this.listCliente.Size = new System.Drawing.Size(1169, 404);
            this.listCliente.TabIndex = 59;
            this.listCliente.UseCompatibleStateImageBehavior = false;
            this.listCliente.View = System.Windows.Forms.View.Details;
            this.listCliente.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.listCliente_MouseDoubleClick);
            // 
            // btnBuscar
            // 
            this.btnBuscar.Image = ((System.Drawing.Image)(resources.GetObject("btnBuscar.Image")));
            this.btnBuscar.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnBuscar.Location = new System.Drawing.Point(1013, 128);
            this.btnBuscar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnBuscar.Name = "btnBuscar";
            this.btnBuscar.Size = new System.Drawing.Size(100, 26);
            this.btnBuscar.TabIndex = 58;
            this.btnBuscar.Text = "Buscar";
            this.btnBuscar.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnBuscar.UseVisualStyleBackColor = true;
            this.btnBuscar.Click += new System.EventHandler(this.btnBuscar_Click);
            // 
            // frmClienteFactura
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1540, 846);
            this.Controls.Add(this.listCliente);
            this.Controls.Add(this.btnBuscar);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtCliente);
            this.Controls.Add(this.btnConsultarFacturas);
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "frmClienteFactura";
            this.Text = "Consulta de Facturas de Clientes";
            this.Load += new System.EventHandler(this.frmClienteFactura_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnConsultarFacturas;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtCliente;
        private System.Windows.Forms.ListView listCliente;
        private System.Windows.Forms.Button btnBuscar;
    }
}