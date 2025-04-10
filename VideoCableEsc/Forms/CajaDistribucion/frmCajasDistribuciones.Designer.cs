namespace VideoCableEsc.Forms.CajaDistribucion
{
    partial class frmCajasDistribuciones
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
            this.label1 = new System.Windows.Forms.Label();
            this.txtCaja = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.sgPymeBaseDataSet = new VideoCableEsc.SgPymeBaseDataSet();
            this.cajasDistribucionesBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.cajasDistribucionesTableAdapter = new VideoCableEsc.SgPymeBaseDataSetTableAdapters.CajasDistribucionesTableAdapter();
            this.CrearCajaDistribucion = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.btnDarBaja = new System.Windows.Forms.Button();
            this.listCD = new System.Windows.Forms.ListView();
            ((System.ComponentModel.ISupportInitialize)(this.sgPymeBaseDataSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.cajasDistribucionesBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(134, 37);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(31, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Caja:";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // txtCaja
            // 
            this.txtCaja.Location = new System.Drawing.Point(181, 37);
            this.txtCaja.Name = "txtCaja";
            this.txtCaja.Size = new System.Drawing.Size(208, 20);
            this.txtCaja.TabIndex = 2;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(411, 37);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 3;
            this.button1.Text = "Buscar";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // sgPymeBaseDataSet
            // 
            this.sgPymeBaseDataSet.DataSetName = "SgPymeBaseDataSet";
            this.sgPymeBaseDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // cajasDistribucionesBindingSource
            // 
            this.cajasDistribucionesBindingSource.DataMember = "CajasDistribuciones";
            this.cajasDistribucionesBindingSource.DataSource = this.sgPymeBaseDataSet;
            // 
            // cajasDistribucionesTableAdapter
            // 
            this.cajasDistribucionesTableAdapter.ClearBeforeFill = true;
            // 
            // CrearCajaDistribucion
            // 
            this.CrearCajaDistribucion.Location = new System.Drawing.Point(223, 372);
            this.CrearCajaDistribucion.Name = "CrearCajaDistribucion";
            this.CrearCajaDistribucion.Size = new System.Drawing.Size(75, 23);
            this.CrearCajaDistribucion.TabIndex = 5;
            this.CrearCajaDistribucion.Text = "Crear";
            this.CrearCajaDistribucion.UseVisualStyleBackColor = true;
            this.CrearCajaDistribucion.Click += new System.EventHandler(this.CrearCajaDistribucion_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(353, 372);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 6;
            this.button3.Text = "Editar";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // btnDarBaja
            // 
            this.btnDarBaja.Location = new System.Drawing.Point(485, 372);
            this.btnDarBaja.Name = "btnDarBaja";
            this.btnDarBaja.Size = new System.Drawing.Size(75, 23);
            this.btnDarBaja.TabIndex = 7;
            this.btnDarBaja.Text = "Dar de Baja";
            this.btnDarBaja.UseVisualStyleBackColor = true;
            this.btnDarBaja.Click += new System.EventHandler(this.button4_Click);
            // 
            // listCD
            // 
            this.listCD.FullRowSelect = true;
            this.listCD.GridLines = true;
            this.listCD.HideSelection = false;
            this.listCD.Location = new System.Drawing.Point(50, 94);
            this.listCD.MultiSelect = false;
            this.listCD.Name = "listCD";
            this.listCD.Size = new System.Drawing.Size(716, 260);
            this.listCD.TabIndex = 8;
            this.listCD.UseCompatibleStateImageBehavior = false;
            this.listCD.View = System.Windows.Forms.View.Details;
            // 
            // frmCajasDistribuciones
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.listCD);
            this.Controls.Add(this.btnDarBaja);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.CrearCajaDistribucion);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.txtCaja);
            this.Controls.Add(this.label1);
            this.Name = "frmCajasDistribuciones";
            this.Text = "frmCajasDistribuciones";
            this.Load += new System.EventHandler(this.frmCajasDistribuciones_Load);
            ((System.ComponentModel.ISupportInitialize)(this.sgPymeBaseDataSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.cajasDistribucionesBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtCaja;
        private System.Windows.Forms.Button button1;
        private SgPymeBaseDataSet sgPymeBaseDataSet;
        private System.Windows.Forms.BindingSource cajasDistribucionesBindingSource;
        private SgPymeBaseDataSetTableAdapters.CajasDistribucionesTableAdapter cajasDistribucionesTableAdapter;
        private System.Windows.Forms.Button CrearCajaDistribucion;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button btnDarBaja;
        private System.Windows.Forms.ListView listCD;
    }
}