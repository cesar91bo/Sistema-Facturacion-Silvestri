using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.Cliente
{
    public partial class frmConsultaDeudaCliente : Form
    {
        public frmConsultaDeudaCliente()
        {
            InitializeComponent();
        }

        private void frmConsultaDeudaCliente_Load(object sender, EventArgs e)
        {
            this.sP_REPORTE_DEUDORTableAdapter.Fill(this.dS_ConsultaDeudaCliente.SP_REPORTE_DEUDOR, Convert.ToInt32(txt_IdCliente.Text));
            this.reportViewer1.RefreshReport();
        }
    }
}
