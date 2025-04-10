namespace VideoCableEsc.Forms.Cliente
{
    partial class frmVideoCable
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
            this.btnFacturasClientes = new System.Windows.Forms.Button();
            this.btnEstados = new System.Windows.Forms.Button();
            this.btnEditar = new System.Windows.Forms.Button();
            this.btnNuevoCliente = new System.Windows.Forms.Button();
            this.listCliente = new System.Windows.Forms.ListView();
            this.checkHabilitar = new System.Windows.Forms.CheckBox();
            this.cmbEstados = new System.Windows.Forms.ComboBox();
            this.btnBuscar = new System.Windows.Forms.Button();
            this.txtCliente = new System.Windows.Forms.TextBox();
            this.lblBuscar = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.txtTotalActivo = new System.Windows.Forms.TextBox();
            this.btnConsultaDeuda = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnFacturasClientes
            // 
            this.btnFacturasClientes.Enabled = false;
            this.btnFacturasClientes.Location = new System.Drawing.Point(956, 769);
            this.btnFacturasClientes.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnFacturasClientes.Name = "btnFacturasClientes";
            this.btnFacturasClientes.Size = new System.Drawing.Size(108, 46);
            this.btnFacturasClientes.TabIndex = 71;
            this.btnFacturasClientes.Text = "Facturas";
            this.btnFacturasClientes.UseVisualStyleBackColor = true;
            this.btnFacturasClientes.Visible = false;
            this.btnFacturasClientes.Click += new System.EventHandler(this.btnFacturasClientes_Click);
            // 
            // btnEstados
            // 
            this.btnEstados.Enabled = false;
            this.btnEstados.Location = new System.Drawing.Point(681, 769);
            this.btnEstados.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnEstados.Name = "btnEstados";
            this.btnEstados.Size = new System.Drawing.Size(108, 46);
            this.btnEstados.TabIndex = 70;
            this.btnEstados.Text = "Estados";
            this.btnEstados.UseVisualStyleBackColor = true;
            this.btnEstados.Click += new System.EventHandler(this.btnEstados_Click);
            // 
            // btnEditar
            // 
            this.btnEditar.Enabled = false;
            this.btnEditar.Location = new System.Drawing.Point(548, 769);
            this.btnEditar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnEditar.Name = "btnEditar";
            this.btnEditar.Size = new System.Drawing.Size(108, 46);
            this.btnEditar.TabIndex = 69;
            this.btnEditar.Text = "Editar";
            this.btnEditar.UseVisualStyleBackColor = true;
            this.btnEditar.Click += new System.EventHandler(this.btnEditar_Click);
            // 
            // btnNuevoCliente
            // 
            this.btnNuevoCliente.Location = new System.Drawing.Point(407, 769);
            this.btnNuevoCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnNuevoCliente.Name = "btnNuevoCliente";
            this.btnNuevoCliente.Size = new System.Drawing.Size(108, 46);
            this.btnNuevoCliente.TabIndex = 68;
            this.btnNuevoCliente.Text = "Nuevo";
            this.btnNuevoCliente.UseVisualStyleBackColor = true;
            this.btnNuevoCliente.Click += new System.EventHandler(this.btnNuevoCliente_Click);
            // 
            // listCliente
            // 
            this.listCliente.FullRowSelect = true;
            this.listCliente.GridLines = true;
            this.listCliente.HideSelection = false;
            this.listCliente.Location = new System.Drawing.Point(16, 191);
            this.listCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.listCliente.MultiSelect = false;
            this.listCliente.Name = "listCliente";
            this.listCliente.Size = new System.Drawing.Size(1447, 542);
            this.listCliente.TabIndex = 67;
            this.listCliente.UseCompatibleStateImageBehavior = false;
            this.listCliente.View = System.Windows.Forms.View.Details;
            this.listCliente.ItemSelectionChanged += new System.Windows.Forms.ListViewItemSelectionChangedEventHandler(this.listCliente_ItemSelectionChanged);
            this.listCliente.SelectedIndexChanged += new System.EventHandler(this.listCliente_SelectedIndexChanged);
            this.listCliente.DoubleClick += new System.EventHandler(this.listCliente_DoubleClick);
            // 
            // checkHabilitar
            // 
            this.checkHabilitar.AutoSize = true;
            this.checkHabilitar.Location = new System.Drawing.Point(731, 142);
            this.checkHabilitar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkHabilitar.Name = "checkHabilitar";
            this.checkHabilitar.Size = new System.Drawing.Size(72, 20);
            this.checkHabilitar.TabIndex = 66;
            this.checkHabilitar.Text = "Estado";
            this.checkHabilitar.UseVisualStyleBackColor = true;
            this.checkHabilitar.CheckedChanged += new System.EventHandler(this.checkHabilitar_CheckedChanged);
            // 
            // cmbEstados
            // 
            this.cmbEstados.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEstados.Enabled = false;
            this.cmbEstados.FormattingEnabled = true;
            this.cmbEstados.Location = new System.Drawing.Point(817, 138);
            this.cmbEstados.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cmbEstados.Name = "cmbEstados";
            this.cmbEstados.Size = new System.Drawing.Size(165, 24);
            this.cmbEstados.TabIndex = 65;
            // 
            // btnBuscar
            // 
            this.btnBuscar.Location = new System.Drawing.Point(1131, 133);
            this.btnBuscar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnBuscar.Name = "btnBuscar";
            this.btnBuscar.Size = new System.Drawing.Size(108, 37);
            this.btnBuscar.TabIndex = 64;
            this.btnBuscar.Text = "Buscar";
            this.btnBuscar.UseVisualStyleBackColor = true;
            this.btnBuscar.Click += new System.EventHandler(this.btnBuscar_Click);
            this.btnBuscar.KeyDown += new System.Windows.Forms.KeyEventHandler(this.btnBuscar_KeyDown);
            // 
            // txtCliente
            // 
            this.txtCliente.Location = new System.Drawing.Point(225, 140);
            this.txtCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.txtCliente.Name = "txtCliente";
            this.txtCliente.Size = new System.Drawing.Size(424, 22);
            this.txtCliente.TabIndex = 63;
            // 
            // lblBuscar
            // 
            this.lblBuscar.AutoSize = true;
            this.lblBuscar.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblBuscar.Location = new System.Drawing.Point(111, 140);
            this.lblBuscar.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblBuscar.Name = "lblBuscar";
            this.lblBuscar.Size = new System.Drawing.Size(75, 23);
            this.lblBuscar.TabIndex = 62;
            this.lblBuscar.Text = "Cliente:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(1269, 784);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(87, 16);
            this.label1.TabIndex = 72;
            this.label1.Text = "Total activos:";
            // 
            // txtTotalActivo
            // 
            this.txtTotalActivo.Enabled = false;
            this.txtTotalActivo.Location = new System.Drawing.Point(1363, 782);
            this.txtTotalActivo.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.txtTotalActivo.Name = "txtTotalActivo";
            this.txtTotalActivo.Size = new System.Drawing.Size(100, 22);
            this.txtTotalActivo.TabIndex = 73;
            // 
            // btnConsultaDeuda
            // 
            this.btnConsultaDeuda.Enabled = false;
            this.btnConsultaDeuda.Location = new System.Drawing.Point(817, 769);
            this.btnConsultaDeuda.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnConsultaDeuda.Name = "btnConsultaDeuda";
            this.btnConsultaDeuda.Size = new System.Drawing.Size(108, 46);
            this.btnConsultaDeuda.TabIndex = 74;
            this.btnConsultaDeuda.Text = "Saldo Pendiente";
            this.btnConsultaDeuda.UseVisualStyleBackColor = true;
            this.btnConsultaDeuda.Click += new System.EventHandler(this.btnConsultaDeuda_Click);
            // 
            // frmVideoCable
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1644, 842);
            this.Controls.Add(this.btnConsultaDeuda);
            this.Controls.Add(this.txtTotalActivo);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnFacturasClientes);
            this.Controls.Add(this.btnEstados);
            this.Controls.Add(this.btnEditar);
            this.Controls.Add(this.btnNuevoCliente);
            this.Controls.Add(this.listCliente);
            this.Controls.Add(this.checkHabilitar);
            this.Controls.Add(this.cmbEstados);
            this.Controls.Add(this.btnBuscar);
            this.Controls.Add(this.txtCliente);
            this.Controls.Add(this.lblBuscar);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "frmVideoCable";
            this.Text = "Video Cable";
            this.Load += new System.EventHandler(this.frmVideoCable_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.frmVideoCable_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnFacturasClientes;
        private System.Windows.Forms.Button btnEstados;
        private System.Windows.Forms.Button btnEditar;
        private System.Windows.Forms.Button btnNuevoCliente;
        private System.Windows.Forms.ListView listCliente;
        private System.Windows.Forms.CheckBox checkHabilitar;
        private System.Windows.Forms.ComboBox cmbEstados;
        private System.Windows.Forms.Button btnBuscar;
        private System.Windows.Forms.TextBox txtCliente;
        private System.Windows.Forms.Label lblBuscar;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtTotalActivo;
        private System.Windows.Forms.Button btnConsultaDeuda;
    }
}