namespace VideoCableEsc.Forms.Cliente
{
    partial class frmFibraOptica
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
            this.checkHabilitar = new System.Windows.Forms.CheckBox();
            this.cmbEstados = new System.Windows.Forms.ComboBox();
            this.btnBuscar = new System.Windows.Forms.Button();
            this.txtCliente = new System.Windows.Forms.TextBox();
            this.lblBuscar = new System.Windows.Forms.Label();
            this.listCliente = new System.Windows.Forms.ListView();
            this.btnFacturasClientes = new System.Windows.Forms.Button();
            this.btnEstados = new System.Windows.Forms.Button();
            this.btnEditar = new System.Windows.Forms.Button();
            this.btnNuevoCliente = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.cmbFibra = new System.Windows.Forms.ComboBox();
            this.txtTotalActivo = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.btnConsultaDeuda = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // checkHabilitar
            // 
            this.checkHabilitar.AutoSize = true;
            this.checkHabilitar.Location = new System.Drawing.Point(728, 159);
            this.checkHabilitar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkHabilitar.Name = "checkHabilitar";
            this.checkHabilitar.Size = new System.Drawing.Size(72, 20);
            this.checkHabilitar.TabIndex = 56;
            this.checkHabilitar.Text = "Estado";
            this.checkHabilitar.UseVisualStyleBackColor = true;
            this.checkHabilitar.CheckedChanged += new System.EventHandler(this.checkHabilitar_CheckedChanged);
            // 
            // cmbEstados
            // 
            this.cmbEstados.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEstados.Enabled = false;
            this.cmbEstados.FormattingEnabled = true;
            this.cmbEstados.Location = new System.Drawing.Point(815, 156);
            this.cmbEstados.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cmbEstados.Name = "cmbEstados";
            this.cmbEstados.Size = new System.Drawing.Size(165, 24);
            this.cmbEstados.TabIndex = 55;
            // 
            // btnBuscar
            // 
            this.btnBuscar.Location = new System.Drawing.Point(1128, 151);
            this.btnBuscar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnBuscar.Name = "btnBuscar";
            this.btnBuscar.Size = new System.Drawing.Size(108, 37);
            this.btnBuscar.TabIndex = 54;
            this.btnBuscar.Text = "Buscar";
            this.btnBuscar.UseVisualStyleBackColor = true;
            this.btnBuscar.Click += new System.EventHandler(this.btnBuscar_Click);
            this.btnBuscar.KeyDown += new System.Windows.Forms.KeyEventHandler(this.btnBuscar_KeyDown);
            // 
            // txtCliente
            // 
            this.txtCliente.Location = new System.Drawing.Point(223, 158);
            this.txtCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.txtCliente.Name = "txtCliente";
            this.txtCliente.Size = new System.Drawing.Size(424, 22);
            this.txtCliente.TabIndex = 53;
            // 
            // lblBuscar
            // 
            this.lblBuscar.AutoSize = true;
            this.lblBuscar.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblBuscar.Location = new System.Drawing.Point(108, 158);
            this.lblBuscar.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblBuscar.Name = "lblBuscar";
            this.lblBuscar.Size = new System.Drawing.Size(75, 23);
            this.lblBuscar.TabIndex = 52;
            this.lblBuscar.Text = "Cliente:";
            // 
            // listCliente
            // 
            this.listCliente.FullRowSelect = true;
            this.listCliente.GridLines = true;
            this.listCliente.HideSelection = false;
            this.listCliente.Location = new System.Drawing.Point(16, 246);
            this.listCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.listCliente.MultiSelect = false;
            this.listCliente.Name = "listCliente";
            this.listCliente.Size = new System.Drawing.Size(1447, 493);
            this.listCliente.TabIndex = 57;
            this.listCliente.UseCompatibleStateImageBehavior = false;
            this.listCliente.View = System.Windows.Forms.View.Details;
            this.listCliente.ItemSelectionChanged += new System.Windows.Forms.ListViewItemSelectionChangedEventHandler(this.listCliente_ItemSelectionChanged);
            this.listCliente.MouseClick += new System.Windows.Forms.MouseEventHandler(this.listCliente_MouseClick);
            this.listCliente.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.listCliente_MouseDoubleClick);
            // 
            // btnFacturasClientes
            // 
            this.btnFacturasClientes.Enabled = false;
            this.btnFacturasClientes.Location = new System.Drawing.Point(933, 772);
            this.btnFacturasClientes.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnFacturasClientes.Name = "btnFacturasClientes";
            this.btnFacturasClientes.Size = new System.Drawing.Size(108, 46);
            this.btnFacturasClientes.TabIndex = 61;
            this.btnFacturasClientes.Text = "Facturas";
            this.btnFacturasClientes.UseVisualStyleBackColor = true;
            this.btnFacturasClientes.Visible = false;
            this.btnFacturasClientes.Click += new System.EventHandler(this.btnFacturasClientes_Click);
            // 
            // btnEstados
            // 
            this.btnEstados.Enabled = false;
            this.btnEstados.Location = new System.Drawing.Point(673, 772);
            this.btnEstados.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnEstados.Name = "btnEstados";
            this.btnEstados.Size = new System.Drawing.Size(108, 46);
            this.btnEstados.TabIndex = 60;
            this.btnEstados.Text = "Estados";
            this.btnEstados.UseVisualStyleBackColor = true;
            this.btnEstados.Click += new System.EventHandler(this.btnEstados_Click);
            // 
            // btnEditar
            // 
            this.btnEditar.Enabled = false;
            this.btnEditar.Location = new System.Drawing.Point(540, 772);
            this.btnEditar.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnEditar.Name = "btnEditar";
            this.btnEditar.Size = new System.Drawing.Size(108, 46);
            this.btnEditar.TabIndex = 59;
            this.btnEditar.Text = "Editar";
            this.btnEditar.UseVisualStyleBackColor = true;
            this.btnEditar.Click += new System.EventHandler(this.btnEditar_Click);
            // 
            // btnNuevoCliente
            // 
            this.btnNuevoCliente.Location = new System.Drawing.Point(399, 772);
            this.btnNuevoCliente.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnNuevoCliente.Name = "btnNuevoCliente";
            this.btnNuevoCliente.Size = new System.Drawing.Size(108, 46);
            this.btnNuevoCliente.TabIndex = 58;
            this.btnNuevoCliente.Text = "Nuevo";
            this.btnNuevoCliente.UseVisualStyleBackColor = true;
            this.btnNuevoCliente.Click += new System.EventHandler(this.btnNuevoCliente_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Cambria", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(63, 197);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(121, 23);
            this.label1.TabIndex = 62;
            this.label1.Text = "Fibra Óptica:";
            // 
            // cmbFibra
            // 
            this.cmbFibra.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbFibra.FormattingEnabled = true;
            this.cmbFibra.Items.AddRange(new object[] {
            "Todo",
            "Internet",
            "Internet + TV"});
            this.cmbFibra.Location = new System.Drawing.Point(223, 201);
            this.cmbFibra.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cmbFibra.Name = "cmbFibra";
            this.cmbFibra.Size = new System.Drawing.Size(255, 24);
            this.cmbFibra.TabIndex = 63;
            // 
            // txtTotalActivo
            // 
            this.txtTotalActivo.Enabled = false;
            this.txtTotalActivo.Location = new System.Drawing.Point(1363, 779);
            this.txtTotalActivo.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.txtTotalActivo.Name = "txtTotalActivo";
            this.txtTotalActivo.Size = new System.Drawing.Size(100, 22);
            this.txtTotalActivo.TabIndex = 75;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(1245, 784);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(87, 16);
            this.label2.TabIndex = 74;
            this.label2.Text = "Total activos:";
            // 
            // btnConsultaDeuda
            // 
            this.btnConsultaDeuda.Enabled = false;
            this.btnConsultaDeuda.Location = new System.Drawing.Point(803, 772);
            this.btnConsultaDeuda.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnConsultaDeuda.Name = "btnConsultaDeuda";
            this.btnConsultaDeuda.Size = new System.Drawing.Size(108, 46);
            this.btnConsultaDeuda.TabIndex = 76;
            this.btnConsultaDeuda.Text = "Saldo Pendiente";
            this.btnConsultaDeuda.UseVisualStyleBackColor = true;
            this.btnConsultaDeuda.Click += new System.EventHandler(this.btnConsultaDeuda_Click);
            // 
            // frmFibraOptica
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1653, 832);
            this.Controls.Add(this.btnConsultaDeuda);
            this.Controls.Add(this.txtTotalActivo);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.cmbFibra);
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
            this.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.Name = "frmFibraOptica";
            this.Text = "Fibra Óptica";
            this.Load += new System.EventHandler(this.frmFibraOptica_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.frmFibraOptica_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.CheckBox checkHabilitar;
        private System.Windows.Forms.ComboBox cmbEstados;
        private System.Windows.Forms.Button btnBuscar;
        private System.Windows.Forms.TextBox txtCliente;
        private System.Windows.Forms.Label lblBuscar;
        private System.Windows.Forms.ListView listCliente;
        private System.Windows.Forms.Button btnFacturasClientes;
        private System.Windows.Forms.Button btnEstados;
        private System.Windows.Forms.Button btnEditar;
        private System.Windows.Forms.Button btnNuevoCliente;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cmbFibra;
        private System.Windows.Forms.TextBox txtTotalActivo;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnConsultaDeuda;
    }
}