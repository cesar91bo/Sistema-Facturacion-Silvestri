namespace VideoCableEsc.Forms.Cliente
{
    partial class frmConsultaFacturasClientes
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
            this.listFacturasClientes = new System.Windows.Forms.ListView();
            this.Id = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.FacturaNro = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.FechaFactura = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.MontoFactura = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.EstadoFactura = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.lblTotalDeuda = new System.Windows.Forms.Label();
            this.txtTotalDeuda = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // listFacturasClientes
            // 
            this.listFacturasClientes.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.Id,
            this.FacturaNro,
            this.FechaFactura,
            this.MontoFactura,
            this.EstadoFactura});
            this.listFacturasClientes.HideSelection = false;
            this.listFacturasClientes.Location = new System.Drawing.Point(151, 115);
            this.listFacturasClientes.Name = "listFacturasClientes";
            this.listFacturasClientes.Size = new System.Drawing.Size(428, 112);
            this.listFacturasClientes.TabIndex = 0;
            this.listFacturasClientes.UseCompatibleStateImageBehavior = false;
            this.listFacturasClientes.View = System.Windows.Forms.View.Details;
            // 
            // Id
            // 
            this.Id.Text = "Id";
            this.Id.Width = 38;
            // 
            // FacturaNro
            // 
            this.FacturaNro.Text = "Factura N°";
            this.FacturaNro.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.FacturaNro.Width = 97;
            // 
            // FechaFactura
            // 
            this.FechaFactura.Text = "Fecha";
            this.FechaFactura.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.FechaFactura.Width = 97;
            // 
            // MontoFactura
            // 
            this.MontoFactura.Text = "Monto";
            this.MontoFactura.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.MontoFactura.Width = 91;
            // 
            // EstadoFactura
            // 
            this.EstadoFactura.Text = "Estado";
            this.EstadoFactura.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.EstadoFactura.Width = 97;
            // 
            // lblTotalDeuda
            // 
            this.lblTotalDeuda.AutoSize = true;
            this.lblTotalDeuda.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTotalDeuda.Location = new System.Drawing.Point(148, 230);
            this.lblTotalDeuda.Name = "lblTotalDeuda";
            this.lblTotalDeuda.Size = new System.Drawing.Size(81, 13);
            this.lblTotalDeuda.TabIndex = 1;
            this.lblTotalDeuda.Text = "Total Deuda:";
            // 
            // txtTotalDeuda
            // 
            this.txtTotalDeuda.Enabled = false;
            this.txtTotalDeuda.Location = new System.Drawing.Point(229, 229);
            this.txtTotalDeuda.Name = "txtTotalDeuda";
            this.txtTotalDeuda.Size = new System.Drawing.Size(100, 20);
            this.txtTotalDeuda.TabIndex = 2;
            // 
            // frmConsultaFacturasClientes
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.txtTotalDeuda);
            this.Controls.Add(this.lblTotalDeuda);
            this.Controls.Add(this.listFacturasClientes);
            this.Name = "frmConsultaFacturasClientes";
            this.Text = "frmFacturasClientes";
            this.Load += new System.EventHandler(this.frmConsultaFacturasClientes_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListView listFacturasClientes;
        private System.Windows.Forms.ColumnHeader Id;
        private System.Windows.Forms.ColumnHeader FacturaNro;
        private System.Windows.Forms.ColumnHeader FechaFactura;
        private System.Windows.Forms.ColumnHeader MontoFactura;
        private System.Windows.Forms.ColumnHeader EstadoFactura;
        private System.Windows.Forms.Label lblTotalDeuda;
        private System.Windows.Forms.TextBox txtTotalDeuda;
    }
}