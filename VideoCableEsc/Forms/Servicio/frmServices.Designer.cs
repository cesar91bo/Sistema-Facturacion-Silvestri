namespace VideoCableEsc.Forms.Servicio
{
    partial class frmServices
    {
        /// <summary>
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
            this.listServicios = new System.Windows.Forms.ListView();
            this.Id = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Descripcion = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Activo = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Costo = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.label1 = new System.Windows.Forms.Label();
            this.btnEditarServicio = new System.Windows.Forms.Button();
            this.btnNuevoServicio = new System.Windows.Forms.Button();
            this.checkMostrarTdo = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // listServicios
            // 
            this.listServicios.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.Id,
            this.Descripcion,
            this.Activo,
            this.Costo});
            this.listServicios.FullRowSelect = true;
            this.listServicios.GridLines = true;
            this.listServicios.HideSelection = false;
            this.listServicios.Location = new System.Drawing.Point(112, 159);
            this.listServicios.Name = "listServicios";
            this.listServicios.Size = new System.Drawing.Size(565, 269);
            this.listServicios.TabIndex = 0;
            this.listServicios.UseCompatibleStateImageBehavior = false;
            this.listServicios.View = System.Windows.Forms.View.Details;
            this.listServicios.SelectedIndexChanged += new System.EventHandler(this.listServicios_SelectedIndexChanged);
            // 
            // Id
            // 
            this.Id.Text = "Id";
            this.Id.Width = 83;
            // 
            // Descripcion
            // 
            this.Descripcion.Text = "Descripcion";
            this.Descripcion.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.Descripcion.Width = 300;
            // 
            // Activo
            // 
            this.Activo.Text = "Activo";
            this.Activo.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // Costo
            // 
            this.Costo.Text = "Costo";
            this.Costo.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.Costo.Width = 80;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(275, 117);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(170, 20);
            this.label1.TabIndex = 1;
            this.label1.Text = "Listado de Servicios";
            // 
            // btnEditarServicio
            // 
            this.btnEditarServicio.Enabled = false;
            this.btnEditarServicio.Location = new System.Drawing.Point(354, 452);
            this.btnEditarServicio.Name = "btnEditarServicio";
            this.btnEditarServicio.Size = new System.Drawing.Size(81, 37);
            this.btnEditarServicio.TabIndex = 8;
            this.btnEditarServicio.Text = "Editar";
            this.btnEditarServicio.UseVisualStyleBackColor = true;
            this.btnEditarServicio.Click += new System.EventHandler(this.btnEditarServicio_Click);
            // 
            // btnNuevoServicio
            // 
            this.btnNuevoServicio.Location = new System.Drawing.Point(248, 452);
            this.btnNuevoServicio.Name = "btnNuevoServicio";
            this.btnNuevoServicio.Size = new System.Drawing.Size(81, 37);
            this.btnNuevoServicio.TabIndex = 7;
            this.btnNuevoServicio.Text = "Nuevo";
            this.btnNuevoServicio.UseVisualStyleBackColor = true;
            this.btnNuevoServicio.Click += new System.EventHandler(this.btnNuevoServicio_Click);
            // 
            // checkMostrarTdo
            // 
            this.checkMostrarTdo.AutoSize = true;
            this.checkMostrarTdo.Location = new System.Drawing.Point(481, 463);
            this.checkMostrarTdo.Name = "checkMostrarTdo";
            this.checkMostrarTdo.Size = new System.Drawing.Size(89, 17);
            this.checkMostrarTdo.TabIndex = 47;
            this.checkMostrarTdo.Text = "Mostrar Todo";
            this.checkMostrarTdo.UseVisualStyleBackColor = true;
            this.checkMostrarTdo.Visible = false;
            // 
            // frmServices
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(784, 563);
            this.Controls.Add(this.checkMostrarTdo);
            this.Controls.Add(this.btnEditarServicio);
            this.Controls.Add(this.btnNuevoServicio);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.listServicios);
            this.Name = "frmServices";
            this.Text = "Servicios";
            this.Load += new System.EventHandler(this.frmServices_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListView listServicios;
        private System.Windows.Forms.ColumnHeader Id;
        private System.Windows.Forms.ColumnHeader Descripcion;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnEditarServicio;
        private System.Windows.Forms.Button btnNuevoServicio;
        private System.Windows.Forms.ColumnHeader Activo;
        private System.Windows.Forms.ColumnHeader Costo;
        private System.Windows.Forms.CheckBox checkMostrarTdo;
    }
}