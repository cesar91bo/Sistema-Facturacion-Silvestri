namespace VideoCableEsc.Forms.ClienteCajaDistribucionServicioEstado
{
    partial class frmConsultaClientesCajasDistribucionServiciosEstados
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
            this.listClientesEstados = new System.Windows.Forms.ListView();
            this.ClienteCajaDistribucionServicioEstadoId = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Estado = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Fecha = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Observaciones = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.btnNuevoClienteEstado = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // listClientesEstados
            // 
            this.listClientesEstados.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.ClienteCajaDistribucionServicioEstadoId,
            this.Estado,
            this.Fecha,
            this.Observaciones});
            this.listClientesEstados.FullRowSelect = true;
            this.listClientesEstados.GridLines = true;
            this.listClientesEstados.HideSelection = false;
            this.listClientesEstados.Location = new System.Drawing.Point(43, 32);
            this.listClientesEstados.Name = "listClientesEstados";
            this.listClientesEstados.Size = new System.Drawing.Size(707, 329);
            this.listClientesEstados.TabIndex = 0;
            this.listClientesEstados.UseCompatibleStateImageBehavior = false;
            this.listClientesEstados.View = System.Windows.Forms.View.Details;
            // 
            // ClienteCajaDistribucionServicioEstadoId
            // 
            this.ClienteCajaDistribucionServicioEstadoId.Text = "Id";
            // 
            // Estado
            // 
            this.Estado.Text = "Estado";
            this.Estado.Width = 84;
            // 
            // Fecha
            // 
            this.Fecha.Text = "Fecha";
            this.Fecha.Width = 132;
            // 
            // Observaciones
            // 
            this.Observaciones.Text = "Observaciones";
            this.Observaciones.Width = 385;
            // 
            // btnNuevoClienteEstado
            // 
            this.btnNuevoClienteEstado.Location = new System.Drawing.Point(334, 378);
            this.btnNuevoClienteEstado.Name = "btnNuevoClienteEstado";
            this.btnNuevoClienteEstado.Size = new System.Drawing.Size(81, 37);
            this.btnNuevoClienteEstado.TabIndex = 5;
            this.btnNuevoClienteEstado.Text = "Nuevo";
            this.btnNuevoClienteEstado.UseVisualStyleBackColor = true;
            this.btnNuevoClienteEstado.Click += new System.EventHandler(this.btnNuevoClienteEstado_Click);
            // 
            // frmConsultaClientesCajasDistribucionServiciosEstados
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnNuevoClienteEstado);
            this.Controls.Add(this.listClientesEstados);
            this.Name = "frmConsultaClientesCajasDistribucionServiciosEstados";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Estados del Cliente";
            this.Load += new System.EventHandler(this.frmConsultaClientesCajasDistribucionServiciosEstados_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListView listClientesEstados;
        private System.Windows.Forms.ColumnHeader ClienteCajaDistribucionServicioEstadoId;
        private System.Windows.Forms.ColumnHeader Estado;
        private System.Windows.Forms.ColumnHeader Fecha;
        private System.Windows.Forms.ColumnHeader Observaciones;
        private System.Windows.Forms.Button btnNuevoClienteEstado;
    }
}