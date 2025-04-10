namespace VideoCableEsc.FormBase
{
    partial class frmBoxServices
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
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.sgPymeBaseDataSet = new VideoCableEsc.SgPymeBaseDataSet();
            this.cajasDistribucionesBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.cajasDistribucionesTableAdapter = new VideoCableEsc.SgPymeBaseDataSetTableAdapters.CajasDistribucionesTableAdapter();
            this.CrearCajaDistribucion = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.cajaDistribucionIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.descipcionDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.longitudDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.latitudDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fechaUltimaModificacionDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.usuarioUltimaModificacionDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.sgPymeBaseDataSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.cajasDistribucionesBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
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
            //this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(181, 37);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(208, 20);
            this.textBox1.TabIndex = 2;
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
            //this.CrearCajaDistribucion.Click += new System.EventHandler(this.CrearCajaDistribucion_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(353, 372);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 6;
            this.button3.Text = "Editar";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(485, 372);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(75, 23);
            this.button4.TabIndex = 7;
            this.button4.Text = "Eliminar";
            this.button4.UseVisualStyleBackColor = true;
            // 
            // dataGridView1
            // 
            this.dataGridView1.AutoGenerateColumns = false;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.cajaDistribucionIdDataGridViewTextBoxColumn,
            this.descipcionDataGridViewTextBoxColumn,
            this.longitudDataGridViewTextBoxColumn,
            this.latitudDataGridViewTextBoxColumn,
            this.fechaUltimaModificacionDataGridViewTextBoxColumn,
            this.usuarioUltimaModificacionDataGridViewTextBoxColumn});
            this.dataGridView1.DataSource = this.cajasDistribucionesBindingSource;
            this.dataGridView1.Location = new System.Drawing.Point(96, 112);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(666, 179);
            this.dataGridView1.TabIndex = 8;
            // 
            // cajaDistribucionIdDataGridViewTextBoxColumn
            // 
            this.cajaDistribucionIdDataGridViewTextBoxColumn.DataPropertyName = "CajaDistribucionId";
            this.cajaDistribucionIdDataGridViewTextBoxColumn.HeaderText = "CajaDistribucionId";
            this.cajaDistribucionIdDataGridViewTextBoxColumn.Name = "cajaDistribucionIdDataGridViewTextBoxColumn";
            this.cajaDistribucionIdDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // descipcionDataGridViewTextBoxColumn
            // 
            this.descipcionDataGridViewTextBoxColumn.DataPropertyName = "Descipcion";
            this.descipcionDataGridViewTextBoxColumn.HeaderText = "Descipcion";
            this.descipcionDataGridViewTextBoxColumn.Name = "descipcionDataGridViewTextBoxColumn";
            // 
            // longitudDataGridViewTextBoxColumn
            // 
            this.longitudDataGridViewTextBoxColumn.DataPropertyName = "Longitud";
            this.longitudDataGridViewTextBoxColumn.HeaderText = "Longitud";
            this.longitudDataGridViewTextBoxColumn.Name = "longitudDataGridViewTextBoxColumn";
            // 
            // latitudDataGridViewTextBoxColumn
            // 
            this.latitudDataGridViewTextBoxColumn.DataPropertyName = "Latitud";
            this.latitudDataGridViewTextBoxColumn.HeaderText = "Latitud";
            this.latitudDataGridViewTextBoxColumn.Name = "latitudDataGridViewTextBoxColumn";
            // 
            // fechaUltimaModificacionDataGridViewTextBoxColumn
            // 
            this.fechaUltimaModificacionDataGridViewTextBoxColumn.DataPropertyName = "FechaUltimaModificacion";
            this.fechaUltimaModificacionDataGridViewTextBoxColumn.HeaderText = "FechaUltimaModificacion";
            this.fechaUltimaModificacionDataGridViewTextBoxColumn.Name = "fechaUltimaModificacionDataGridViewTextBoxColumn";
            // 
            // usuarioUltimaModificacionDataGridViewTextBoxColumn
            // 
            this.usuarioUltimaModificacionDataGridViewTextBoxColumn.DataPropertyName = "UsuarioUltimaModificacion";
            this.usuarioUltimaModificacionDataGridViewTextBoxColumn.HeaderText = "UsuarioUltimaModificacion";
            this.usuarioUltimaModificacionDataGridViewTextBoxColumn.Name = "usuarioUltimaModificacionDataGridViewTextBoxColumn";
            // 
            // frmCajasDistribuciones
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.button4);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.CrearCajaDistribucion);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label1);
            this.Name = "frmCajasDistribuciones";
            this.Text = "frmCajasDistribuciones";
            //this.Load += new System.EventHandler(this.frmCajasDistribuciones_Load);
            ((System.ComponentModel.ISupportInitialize)(this.sgPymeBaseDataSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.cajasDistribucionesBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Button button1;
        private SgPymeBaseDataSet sgPymeBaseDataSet;
        private System.Windows.Forms.BindingSource cajasDistribucionesBindingSource;
        private SgPymeBaseDataSetTableAdapters.CajasDistribucionesTableAdapter cajasDistribucionesTableAdapter;
        private System.Windows.Forms.Button CrearCajaDistribucion;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.DataGridViewTextBoxColumn cajaDistribucionIdDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn descipcionDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn longitudDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn latitudDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn fechaUltimaModificacionDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn usuarioUltimaModificacionDataGridViewTextBoxColumn;
    }
}