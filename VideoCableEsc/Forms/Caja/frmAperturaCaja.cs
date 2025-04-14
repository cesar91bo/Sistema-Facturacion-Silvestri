using CapaEntidades;
using CapaNegocio;
using Spire.Pdf.HtmlConverter;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.Caja
{
    public partial class frmAperturaCaja : Form
    {
        private CajaNegocio cajaNegocio = new CajaNegocio();
        public frmAperturaCaja()
        {
            InitializeComponent();
        }

        private void txtMontoInicial_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && e.KeyChar != ',')
            {
                e.Handled = true;
            }
        }

        private void btnAbrirCaja_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMontoInicial.Text))
            {
                MessageBox.Show("Debe ingresar un monto inicial para abrir la caja.", "Campo requerido", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtMontoInicial.Focus();
                return;
            }

            CajasDiarias caja = new CajasDiarias
            {
                FechaApertura = DateTime.Now,
                MontoInicial = Convert.ToDecimal(txtMontoInicial.Text),
                UsuarioApertura = 1,
                Estado = "Abierto"
            };

            bool apertura = cajaNegocio.NuevaCajaDiaria(caja);

            if (apertura)
            {
                MessageBox.Show("La caja fue abierta correctamente.");
            }
            else
            {
                MessageBox.Show("No se pudo abrir la caja. Intente nuevamente.", "ERROR CAJA", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            this.Close();
        }
    }
}
