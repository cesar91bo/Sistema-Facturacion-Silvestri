using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.Reportes
{
    public partial class FormImpresionPresup : Form
    {
        public FormImpresionPresup()
        {
            InitializeComponent();
        }

        private void FormImpresionPresup_Load(object sender, EventArgs e)
        {
            // TODO: esta línea de código carga datos en la tabla 'dS_Presupuesto.ReportePresupuesto' Puede moverla o quitarla según sea necesario.
            this.reportePresupuestoTableAdapter.Fill(this.dS_Presupuesto.ReportePresupuesto);

            this.reportViewer1.RefreshReport();
        }
    }
}
