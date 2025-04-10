namespace VideoCableEsc.Forms.Cliente
{
    partial class frmConsultaDeudaCliente
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
            Microsoft.Reporting.WinForms.ReportDataSource reportDataSource1 = new Microsoft.Reporting.WinForms.ReportDataSource();
            this.sPREPORTEDEUDORBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.dS_ConsultaDeudaCliente = new VideoCableEsc.Forms.Cliente.DS_ConsultaDeudaCliente();
            this.reportViewer1 = new Microsoft.Reporting.WinForms.ReportViewer();
            this.sP_REPORTE_DEUDORTableAdapter = new VideoCableEsc.Forms.Cliente.DS_ConsultaDeudaClienteTableAdapters.SP_REPORTE_DEUDORTableAdapter();
            this.txt_IdCliente = new System.Windows.Forms.TextBox();
            this.sPREPORTEDEUDORBindingSource1 = new System.Windows.Forms.BindingSource(this.components);
            this.sPREPORTEDEUDORBindingSource2 = new System.Windows.Forms.BindingSource(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.sPREPORTEDEUDORBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dS_ConsultaDeudaCliente)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.sPREPORTEDEUDORBindingSource1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.sPREPORTEDEUDORBindingSource2)).BeginInit();
            this.SuspendLayout();
            // 
            // sPREPORTEDEUDORBindingSource
            // 
            this.sPREPORTEDEUDORBindingSource.DataMember = "SP_REPORTE_DEUDOR";
            this.sPREPORTEDEUDORBindingSource.DataSource = this.dS_ConsultaDeudaCliente;
            // 
            // dS_ConsultaDeudaCliente
            // 
            this.dS_ConsultaDeudaCliente.DataSetName = "DS_ConsultaDeudaCliente";
            this.dS_ConsultaDeudaCliente.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // reportViewer1
            // 
            this.reportViewer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.reportViewer1.DocumentMapWidth = 66;
            reportDataSource1.Name = "DataSet1";
            reportDataSource1.Value = this.sPREPORTEDEUDORBindingSource2;
            this.reportViewer1.LocalReport.DataSources.Add(reportDataSource1);
            this.reportViewer1.LocalReport.ReportEmbeddedResource = "VideoCableEsc.Forms.Cliente.ReporteDeudaCliente.rdlc";
            this.reportViewer1.Location = new System.Drawing.Point(0, 0);
            this.reportViewer1.Name = "reportViewer1";
            this.reportViewer1.ServerReport.BearerToken = null;
            this.reportViewer1.Size = new System.Drawing.Size(1317, 808);
            this.reportViewer1.TabIndex = 1;
            // 
            // sP_REPORTE_DEUDORTableAdapter
            // 
            this.sP_REPORTE_DEUDORTableAdapter.ClearBeforeFill = true;
            // 
            // txt_IdCliente
            // 
            this.txt_IdCliente.Location = new System.Drawing.Point(21, 75);
            this.txt_IdCliente.Name = "txt_IdCliente";
            this.txt_IdCliente.Size = new System.Drawing.Size(133, 22);
            this.txt_IdCliente.TabIndex = 2;
            this.txt_IdCliente.Visible = false;
            // 
            // sPREPORTEDEUDORBindingSource1
            // 
            this.sPREPORTEDEUDORBindingSource1.DataMember = "SP_REPORTE_DEUDOR";
            this.sPREPORTEDEUDORBindingSource1.DataSource = this.dS_ConsultaDeudaCliente;
            // 
            // sPREPORTEDEUDORBindingSource2
            // 
            this.sPREPORTEDEUDORBindingSource2.DataMember = "SP_REPORTE_DEUDOR";
            this.sPREPORTEDEUDORBindingSource2.DataSource = this.dS_ConsultaDeudaCliente;
            // 
            // frmConsultaDeudaCliente
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1317, 808);
            this.Controls.Add(this.txt_IdCliente);
            this.Controls.Add(this.reportViewer1);
            this.Name = "frmConsultaDeudaCliente";
            this.Text = "frmConsultaDeudaCliente";
            this.Load += new System.EventHandler(this.frmConsultaDeudaCliente_Load);
            ((System.ComponentModel.ISupportInitialize)(this.sPREPORTEDEUDORBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dS_ConsultaDeudaCliente)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.sPREPORTEDEUDORBindingSource1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.sPREPORTEDEUDORBindingSource2)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Microsoft.Reporting.WinForms.ReportViewer reportViewer1;
        private System.Windows.Forms.BindingSource sPREPORTEDEUDORBindingSource;
        private DS_ConsultaDeudaCliente dS_ConsultaDeudaCliente;
        private DS_ConsultaDeudaClienteTableAdapters.SP_REPORTE_DEUDORTableAdapter sP_REPORTE_DEUDORTableAdapter;
        public System.Windows.Forms.TextBox txt_IdCliente;
        private System.Windows.Forms.BindingSource sPREPORTEDEUDORBindingSource1;
        private System.Windows.Forms.BindingSource sPREPORTEDEUDORBindingSource2;
    }
}