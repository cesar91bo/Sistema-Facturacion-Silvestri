namespace VideoCableEsc.Forms
{
    partial class frmNuevoCliente
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
            this.lblNuevoCliente = new System.Windows.Forms.Label();
            this.lblNombre = new System.Windows.Forms.Label();
            this.txtNombreApellido = new System.Windows.Forms.TextBox();
            this.txtDireccion = new System.Windows.Forms.TextBox();
            this.lblDirección = new System.Windows.Forms.Label();
            this.btnGuardar = new System.Windows.Forms.Button();
            this.txtCuit2 = new System.Windows.Forms.TextBox();
            this.cmbTipoDoc = new System.Windows.Forms.ComboBox();
            this.txtCuit1 = new System.Windows.Forms.TextBox();
            this.txtNroDoc = new System.Windows.Forms.TextBox();
            this.lblTipoyNDoc = new System.Windows.Forms.Label();
            this.txtCuit0 = new System.Windows.Forms.TextBox();
            this.cmbRegimenImp = new System.Windows.Forms.ComboBox();
            this.lblRegimen = new System.Windows.Forms.Label();
            this.txtNroCli = new System.Windows.Forms.TextBox();
            this.lblCli = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.txtCaja = new System.Windows.Forms.TextBox();
            this.cmbServicios = new System.Windows.Forms.ComboBox();
            this.lblServicios = new System.Windows.Forms.Label();
            this.lblCaja = new System.Windows.Forms.Label();
            this.checkHabilitar = new System.Windows.Forms.CheckBox();
            this.txtTelefono = new System.Windows.Forms.TextBox();
            this.lblTelefono = new System.Windows.Forms.Label();
            this.txtPrecinto = new System.Windows.Forms.TextBox();
            this.lblPrecinto = new System.Windows.Forms.Label();
            this.Error = new System.Windows.Forms.ErrorProvider(this.components);
            this.groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.Error)).BeginInit();
            this.SuspendLayout();
            // 
            // lblNuevoCliente
            // 
            this.lblNuevoCliente.AutoSize = true;
            this.lblNuevoCliente.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblNuevoCliente.Location = new System.Drawing.Point(448, 31);
            this.lblNuevoCliente.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblNuevoCliente.Name = "lblNuevoCliente";
            this.lblNuevoCliente.Size = new System.Drawing.Size(130, 31);
            this.lblNuevoCliente.TabIndex = 0;
            this.lblNuevoCliente.Text = "CLIENTE";
            // 
            // lblNombre
            // 
            this.lblNombre.AutoSize = true;
            this.lblNombre.Location = new System.Drawing.Point(25, 25);
            this.lblNombre.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblNombre.Name = "lblNombre";
            this.lblNombre.Size = new System.Drawing.Size(122, 16);
            this.lblNombre.TabIndex = 1;
            this.lblNombre.Text = "Nombre y Apellido:";
            // 
            // txtNombreApellido
            // 
            this.txtNombreApellido.Location = new System.Drawing.Point(177, 21);
            this.txtNombreApellido.Margin = new System.Windows.Forms.Padding(4);
            this.txtNombreApellido.Name = "txtNombreApellido";
            this.txtNombreApellido.Size = new System.Drawing.Size(319, 22);
            this.txtNombreApellido.TabIndex = 2;
            // 
            // txtDireccion
            // 
            this.txtDireccion.Location = new System.Drawing.Point(177, 51);
            this.txtDireccion.Margin = new System.Windows.Forms.Padding(4);
            this.txtDireccion.Name = "txtDireccion";
            this.txtDireccion.Size = new System.Drawing.Size(319, 22);
            this.txtDireccion.TabIndex = 4;
            // 
            // lblDirección
            // 
            this.lblDirección.AutoSize = true;
            this.lblDirección.Location = new System.Drawing.Point(79, 54);
            this.lblDirección.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblDirección.Name = "lblDirección";
            this.lblDirección.Size = new System.Drawing.Size(67, 16);
            this.lblDirección.TabIndex = 3;
            this.lblDirección.Text = "Dirección:";
            // 
            // btnGuardar
            // 
            this.btnGuardar.Location = new System.Drawing.Point(455, 420);
            this.btnGuardar.Margin = new System.Windows.Forms.Padding(4);
            this.btnGuardar.Name = "btnGuardar";
            this.btnGuardar.Size = new System.Drawing.Size(112, 41);
            this.btnGuardar.TabIndex = 15;
            this.btnGuardar.Text = "Guardar";
            this.btnGuardar.UseVisualStyleBackColor = true;
            this.btnGuardar.Click += new System.EventHandler(this.btnGuardar_Click);
            // 
            // txtCuit2
            // 
            this.txtCuit2.Location = new System.Drawing.Point(374, 145);
            this.txtCuit2.Margin = new System.Windows.Forms.Padding(4);
            this.txtCuit2.MaxLength = 1;
            this.txtCuit2.Name = "txtCuit2";
            this.txtCuit2.Size = new System.Drawing.Size(16, 22);
            this.txtCuit2.TabIndex = 39;
            this.txtCuit2.Visible = false;
            // 
            // cmbTipoDoc
            // 
            this.cmbTipoDoc.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbTipoDoc.FormattingEnabled = true;
            this.cmbTipoDoc.Location = new System.Drawing.Point(177, 113);
            this.cmbTipoDoc.Margin = new System.Windows.Forms.Padding(4);
            this.cmbTipoDoc.Name = "cmbTipoDoc";
            this.cmbTipoDoc.Size = new System.Drawing.Size(213, 24);
            this.cmbTipoDoc.TabIndex = 35;
            this.cmbTipoDoc.SelectedValueChanged += new System.EventHandler(this.cmbTipoDoc_SelectedValueChanged);
            // 
            // txtCuit1
            // 
            this.txtCuit1.Location = new System.Drawing.Point(252, 145);
            this.txtCuit1.Margin = new System.Windows.Forms.Padding(4);
            this.txtCuit1.MaxLength = 8;
            this.txtCuit1.Name = "txtCuit1";
            this.txtCuit1.Size = new System.Drawing.Size(113, 22);
            this.txtCuit1.TabIndex = 38;
            this.txtCuit1.Visible = false;
            // 
            // txtNroDoc
            // 
            this.txtNroDoc.Location = new System.Drawing.Point(213, 145);
            this.txtNroDoc.Margin = new System.Windows.Forms.Padding(4);
            this.txtNroDoc.MaxLength = 11;
            this.txtNroDoc.Name = "txtNroDoc";
            this.txtNroDoc.Size = new System.Drawing.Size(132, 22);
            this.txtNroDoc.TabIndex = 36;
            // 
            // lblTipoyNDoc
            // 
            this.lblTipoyNDoc.AutoSize = true;
            this.lblTipoyNDoc.Location = new System.Drawing.Point(8, 116);
            this.lblTipoyNDoc.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblTipoyNDoc.Name = "lblTipoyNDoc";
            this.lblTipoyNDoc.Size = new System.Drawing.Size(137, 16);
            this.lblTipoyNDoc.TabIndex = 40;
            this.lblTipoyNDoc.Text = "Tipo y N° Documento:";
            // 
            // txtCuit0
            // 
            this.txtCuit0.Location = new System.Drawing.Point(181, 145);
            this.txtCuit0.Margin = new System.Windows.Forms.Padding(4);
            this.txtCuit0.MaxLength = 2;
            this.txtCuit0.Name = "txtCuit0";
            this.txtCuit0.Size = new System.Drawing.Size(29, 22);
            this.txtCuit0.TabIndex = 37;
            this.txtCuit0.Visible = false;
            // 
            // cmbRegimenImp
            // 
            this.cmbRegimenImp.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbRegimenImp.FormattingEnabled = true;
            this.cmbRegimenImp.Location = new System.Drawing.Point(177, 81);
            this.cmbRegimenImp.Margin = new System.Windows.Forms.Padding(4);
            this.cmbRegimenImp.Name = "cmbRegimenImp";
            this.cmbRegimenImp.Size = new System.Drawing.Size(213, 24);
            this.cmbRegimenImp.TabIndex = 41;
            // 
            // lblRegimen
            // 
            this.lblRegimen.AutoSize = true;
            this.lblRegimen.Location = new System.Drawing.Point(16, 85);
            this.lblRegimen.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblRegimen.Name = "lblRegimen";
            this.lblRegimen.Size = new System.Drawing.Size(129, 16);
            this.lblRegimen.TabIndex = 42;
            this.lblRegimen.Text = "Regimen Impositivo:";
            // 
            // txtNroCli
            // 
            this.txtNroCli.Location = new System.Drawing.Point(464, 213);
            this.txtNroCli.Margin = new System.Windows.Forms.Padding(4);
            this.txtNroCli.Name = "txtNroCli";
            this.txtNroCli.ReadOnly = true;
            this.txtNroCli.Size = new System.Drawing.Size(97, 22);
            this.txtNroCli.TabIndex = 44;
            this.txtNroCli.Visible = false;
            // 
            // lblCli
            // 
            this.lblCli.AutoSize = true;
            this.lblCli.Location = new System.Drawing.Point(363, 217);
            this.lblCli.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCli.Name = "lblCli";
            this.lblCli.Size = new System.Drawing.Size(69, 16);
            this.lblCli.TabIndex = 45;
            this.lblCli.Text = "Nº Cliente:";
            this.lblCli.Visible = false;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.txtCaja);
            this.groupBox1.Controls.Add(this.cmbServicios);
            this.groupBox1.Controls.Add(this.lblServicios);
            this.groupBox1.Controls.Add(this.lblCaja);
            this.groupBox1.Controls.Add(this.checkHabilitar);
            this.groupBox1.Controls.Add(this.txtNroCli);
            this.groupBox1.Controls.Add(this.lblCli);
            this.groupBox1.Controls.Add(this.cmbRegimenImp);
            this.groupBox1.Controls.Add(this.lblRegimen);
            this.groupBox1.Controls.Add(this.txtCuit2);
            this.groupBox1.Controls.Add(this.cmbTipoDoc);
            this.groupBox1.Controls.Add(this.txtCuit1);
            this.groupBox1.Controls.Add(this.txtNroDoc);
            this.groupBox1.Controls.Add(this.lblTipoyNDoc);
            this.groupBox1.Controls.Add(this.txtCuit0);
            this.groupBox1.Controls.Add(this.txtTelefono);
            this.groupBox1.Controls.Add(this.lblTelefono);
            this.groupBox1.Controls.Add(this.txtPrecinto);
            this.groupBox1.Controls.Add(this.lblPrecinto);
            this.groupBox1.Controls.Add(this.txtDireccion);
            this.groupBox1.Controls.Add(this.lblDirección);
            this.groupBox1.Controls.Add(this.txtNombreApellido);
            this.groupBox1.Controls.Add(this.lblNombre);
            this.groupBox1.Location = new System.Drawing.Point(16, 89);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(4);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(4);
            this.groupBox1.Size = new System.Drawing.Size(991, 311);
            this.groupBox1.TabIndex = 46;
            this.groupBox1.TabStop = false;
            // 
            // txtCaja
            // 
            this.txtCaja.Location = new System.Drawing.Point(659, 60);
            this.txtCaja.Margin = new System.Windows.Forms.Padding(4);
            this.txtCaja.Name = "txtCaja";
            this.txtCaja.Size = new System.Drawing.Size(52, 22);
            this.txtCaja.TabIndex = 51;
            this.txtCaja.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.txtCaja_KeyPress);
            // 
            // cmbServicios
            // 
            this.cmbServicios.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbServicios.FormattingEnabled = true;
            this.cmbServicios.Location = new System.Drawing.Point(659, 126);
            this.cmbServicios.Margin = new System.Windows.Forms.Padding(4);
            this.cmbServicios.Name = "cmbServicios";
            this.cmbServicios.Size = new System.Drawing.Size(324, 24);
            this.cmbServicios.TabIndex = 49;
            // 
            // lblServicios
            // 
            this.lblServicios.AutoSize = true;
            this.lblServicios.Location = new System.Drawing.Point(562, 129);
            this.lblServicios.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblServicios.Name = "lblServicios";
            this.lblServicios.Size = new System.Drawing.Size(66, 16);
            this.lblServicios.TabIndex = 50;
            this.lblServicios.Text = "Servicios:";
            // 
            // lblCaja
            // 
            this.lblCaja.AutoSize = true;
            this.lblCaja.Location = new System.Drawing.Point(498, 63);
            this.lblCaja.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCaja.Name = "lblCaja";
            this.lblCaja.Size = new System.Drawing.Size(130, 16);
            this.lblCaja.TabIndex = 48;
            this.lblCaja.Text = "Caja de Distribución:";
            // 
            // checkHabilitar
            // 
            this.checkHabilitar.AutoSize = true;
            this.checkHabilitar.Location = new System.Drawing.Point(439, 265);
            this.checkHabilitar.Margin = new System.Windows.Forms.Padding(4);
            this.checkHabilitar.Name = "checkHabilitar";
            this.checkHabilitar.Size = new System.Drawing.Size(123, 20);
            this.checkHabilitar.TabIndex = 46;
            this.checkHabilitar.Text = "Habilitar Cliente";
            this.checkHabilitar.UseVisualStyleBackColor = true;
            this.checkHabilitar.Visible = false;
            this.checkHabilitar.CheckedChanged += new System.EventHandler(this.checkHabilitar_CheckedChanged);
            // 
            // txtTelefono
            // 
            this.txtTelefono.Location = new System.Drawing.Point(659, 26);
            this.txtTelefono.Margin = new System.Windows.Forms.Padding(4);
            this.txtTelefono.Name = "txtTelefono";
            this.txtTelefono.Size = new System.Drawing.Size(324, 22);
            this.txtTelefono.TabIndex = 8;
            // 
            // lblTelefono
            // 
            this.lblTelefono.AutoSize = true;
            this.lblTelefono.Location = new System.Drawing.Point(564, 29);
            this.lblTelefono.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblTelefono.Name = "lblTelefono";
            this.lblTelefono.Size = new System.Drawing.Size(64, 16);
            this.lblTelefono.TabIndex = 7;
            this.lblTelefono.Text = "Teléfono:";
            // 
            // txtPrecinto
            // 
            this.txtPrecinto.Location = new System.Drawing.Point(659, 96);
            this.txtPrecinto.Margin = new System.Windows.Forms.Padding(4);
            this.txtPrecinto.Name = "txtPrecinto";
            this.txtPrecinto.Size = new System.Drawing.Size(52, 22);
            this.txtPrecinto.TabIndex = 6;
            this.txtPrecinto.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.txtPrecinto_KeyPress);
            // 
            // lblPrecinto
            // 
            this.lblPrecinto.AutoSize = true;
            this.lblPrecinto.Location = new System.Drawing.Point(569, 96);
            this.lblPrecinto.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblPrecinto.Name = "lblPrecinto";
            this.lblPrecinto.Size = new System.Drawing.Size(59, 16);
            this.lblPrecinto.TabIndex = 5;
            this.lblPrecinto.Text = "Precinto:";
            // 
            // Error
            // 
            this.Error.ContainerControl = this;
            // 
            // frmNuevoCliente
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1035, 489);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.btnGuardar);
            this.Controls.Add(this.lblNuevoCliente);
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "frmNuevoCliente";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmNuevoCliente";
            this.Load += new System.EventHandler(this.frmNuevoCliente_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.Error)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblNuevoCliente;
        private System.Windows.Forms.Label lblNombre;
        private System.Windows.Forms.TextBox txtNombreApellido;
        private System.Windows.Forms.TextBox txtDireccion;
        private System.Windows.Forms.Label lblDirección;
        private System.Windows.Forms.Button btnGuardar;
        private System.Windows.Forms.TextBox txtCuit2;
        private System.Windows.Forms.ComboBox cmbTipoDoc;
        private System.Windows.Forms.TextBox txtCuit1;
        private System.Windows.Forms.TextBox txtNroDoc;
        private System.Windows.Forms.Label lblTipoyNDoc;
        private System.Windows.Forms.TextBox txtCuit0;
        private System.Windows.Forms.ComboBox cmbRegimenImp;
        private System.Windows.Forms.Label lblRegimen;
        private System.Windows.Forms.TextBox txtNroCli;
        private System.Windows.Forms.Label lblCli;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.ErrorProvider Error;
        private System.Windows.Forms.CheckBox checkHabilitar;
        private System.Windows.Forms.Label lblCaja;
        private System.Windows.Forms.TextBox txtTelefono;
        private System.Windows.Forms.Label lblTelefono;
        private System.Windows.Forms.TextBox txtPrecinto;
        private System.Windows.Forms.Label lblPrecinto;
        private System.Windows.Forms.ComboBox cmbServicios;
        private System.Windows.Forms.Label lblServicios;
        private System.Windows.Forms.TextBox txtCaja;
    }
}