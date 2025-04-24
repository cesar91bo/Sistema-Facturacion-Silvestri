using CapaEntidades;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.FormBase
{
    public partial class frmIndex : Form
    {
        public frmIndex()
        {
            InitializeComponent();
        }

        private void horaFecha_Tick(object sender, EventArgs e)
        {
            lblHora.Text = DateTime.Now.ToLongTimeString();
            lblFecha.Text = DateTime.Now.ToLongDateString();
        }

        private void frmIndex_Load(object sender, EventArgs e)
        {
            CajaNegocio cajaNegocio = new CajaNegocio();

            CajasDiarias cajaActual = cajaNegocio.ObtenerCajaActual();
            if (cajaActual == null || cajaActual.Estado == "Cerrado")
            {
                lblCaja.Text = "Caja No Abierta";
                lblCaja.ForeColor = Color.Red;
            }
            else
            {
                lblCaja.Text = "Caja Abierta"; ;
            }
        }
    }
}
