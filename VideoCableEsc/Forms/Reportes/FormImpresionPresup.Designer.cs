namespace VideoCableEsc.Forms.Reportes
{
    partial class FormImpresionPresup
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
            this.reportViewer1 = new Microsoft.Reporting.WinForms.ReportViewer();
            this.reportePresupuestoBindingSource1 = new System.Windows.Forms.BindingSource(this.components);
            this.dS_Presupuesto = new VideoCableEsc.Forms.Reportes.DS_Presupuesto();
            this.reportePresupuestoBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.reportePresupuestoTableAdapter = new VideoCableEsc.Forms.Reportes.DS_PresupuestoTableAdapters.ReportePresupuestoTableAdapter();
            ((System.ComponentModel.ISupportInitialize)(this.reportePresupuestoBindingSource1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dS_Presupuesto)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.reportePresupuestoBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // reportViewer1
            // 
            this.reportViewer1.Dock = System.Windows.Forms.DockStyle.Fill;
            reportDataSource1.Name = "DataSet1";
            reportDataSource1.Value = this.reportePresupuestoBindingSource1;
            this.reportViewer1.LocalReport.DataSources.Add(reportDataSource1);
            this.reportViewer1.LocalReport.ReportEmbeddedResource = "VideoCableEsc.Forms.Reportes.ReportePresupuesto.rdlc";
            this.reportViewer1.Location = new System.Drawing.Point(0, 0);
            this.reportViewer1.Name = "reportViewer1";
            this.reportViewer1.ServerReport.BearerToken = null;
            this.reportViewer1.Size = new System.Drawing.Size(963, 721);
            this.reportViewer1.TabIndex = 0;
            // 
            // reportePresupuestoBindingSource1
            // 
            this.reportePresupuestoBindingSource1.DataMember = "ReportePresupuesto";
            this.reportePresupuestoBindingSource1.DataSource = this.dS_Presupuesto;
            // 
            // dS_Presupuesto
            // 
            this.dS_Presupuesto.DataSetName = "DS_Presupuesto";
            this.dS_Presupuesto.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // reportePresupuestoBindingSource
            // 
            this.reportePresupuestoBindingSource.DataMember = "ReportePresupuesto";
            this.reportePresupuestoBindingSource.DataSource = this.dS_Presupuesto;
            // 
            // reportePresupuestoTableAdapter
            // 
            this.reportePresupuestoTableAdapter.ClearBeforeFill = true;
            // 
            // FormImpresionPresup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(963, 721);
            this.Controls.Add(this.reportViewer1);
            this.Name = "FormImpresionPresup";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Impresión";
            this.Load += new System.EventHandler(this.FormImpresionPresup_Load);
            ((System.ComponentModel.ISupportInitialize)(this.reportePresupuestoBindingSource1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dS_Presupuesto)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.reportePresupuestoBindingSource)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Microsoft.Reporting.WinForms.ReportViewer reportViewer1;
        private DS_Presupuesto dS_Presupuesto;
        private System.Windows.Forms.BindingSource reportePresupuestoBindingSource;
        private DS_PresupuestoTableAdapters.ReportePresupuestoTableAdapter reportePresupuestoTableAdapter;
        private System.Windows.Forms.BindingSource reportePresupuestoBindingSource1;
    }
}