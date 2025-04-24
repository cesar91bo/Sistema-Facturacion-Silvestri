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

namespace VideoCableEsc.Forms.Caja
{
    public partial class frmCierreCaja : Form
    {
        private CajaNegocio cajaNegocio = new CajaNegocio();
        private CajasDiarias cajaDiaria = null;
        private FacturasVentaNegocio facturasVentaN = new FacturasVentaNegocio();
        public frmCierreCaja()
        {
            InitializeComponent();
        }

        private void frmCierreCaja_Load(object sender, EventArgs e)
        {
            BuscarCaja();

            List<VistaCabFactVenta> facturasVentas = facturasVentaN.BuscarFacturasFechaDesdeFechaHasta(cajaDiaria.FechaApertura, cajaDiaria.FechaApertura);
            decimal montoTotalVentas = 0;
            if (facturasVentas != null && facturasVentas.Any())
            {
                montoTotalVentas = facturasVentas.Sum(f => f.Total);
                txtTotalVenta.Text = montoTotalVentas.ToString("N2");
            }

            List<CajasEgresos> cajasEgresos = cajaNegocio.ObtenerCajaEgresoPorFecha(cajaDiaria.FechaApertura);
            decimal montoEgresos = 0;
            if (cajasEgresos != null && cajasEgresos.Any())
            {
                montoEgresos = cajasEgresos.Sum(m => m.Monto);
                txtMontoEgresado.Text = montoEgresos.ToString("N2");
            }

            List<CajasIngresos> cajasIngresos = cajaNegocio.ObtenerCajaIngresoPorFecha(cajaDiaria.FechaApertura);
            decimal montoIngreso = 0;
            if (cajasIngresos != null && cajasIngresos.Any())
            {
                montoIngreso = cajasIngresos.Sum(m => m.Monto);
                txtMontoIngresos.Text = montoIngreso.ToString("N2");
            }

            txtMontoSistema.Text = cajaDiaria.MontoFinal.Value.ToString("N2");
        }

        private void BuscarCaja()
        {
            cajaDiaria = cajaNegocio.ObtenerCajaActual() ?? cajaNegocio.ObtenerUltimaCaja();

            if (cajaDiaria == null)
            {
                DialogResult respuesta = MessageBox.Show("No se abrió ninguna caja para el día de hoy. ¿Desea hacerlo ahora?", "Caja no abierta",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                if (respuesta == DialogResult.Yes)
                {
                    frmAperturaCaja frm = new frmAperturaCaja();
                    frm.ShowDialog();

                    cajaDiaria = cajaNegocio.ObtenerCajaActual();
                    if (cajaDiaria == null || cajaDiaria.IdCajaDiaria == 0)
                    {
                        MessageBox.Show("No se pudo abrir la caja. Operación cancelada.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        Close();
                    }
                }
                else
                {
                    MessageBox.Show("Debe abrir una caja para continuar.", "Operación cancelada", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    Close();
                }
            }

            if (cajaDiaria.Estado == "Cerrado")
            {
                if (cajaDiaria.FechaCierre.HasValue)
                {
                    MessageBox.Show($"La caja del día de hoy ya fue cerrada a las {cajaDiaria.FechaCierre.Value.ToLocalTime():HH:mm}");
                }
                else
                {
                    MessageBox.Show("La caja del día de hoy ya fue cerrada.");
                }
                Close();
            }
        }

        private void btnAbrirCaja_Click(object sender, EventArgs e)
        {
            if (Validaciones())
            {
                if (cajaDiaria != null)
                {
                    cajaDiaria.MontoFinal = Convert.ToDecimal(txtMontoFinal.Text);
                    cajaDiaria.FechaCierre = DateTime.Now;
                    cajaDiaria.Estado = "Cerrado";
                    cajaDiaria.Observaciones = txtObservaciones.Text;
                }
                ResultadoOperacion resultado = cajaNegocio.CerrarCajaDiaria(cajaDiaria);

                if (resultado.EsExitoso)
                {
                    MessageBox.Show("Se cerró la caja correctamente.", "Caja", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show(resultado.Mensaje, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                this.Close();
            }
        }

        private bool Validaciones()
        {
            if (string.IsNullOrWhiteSpace(txtMontoFinal.Text))
            {
                error.SetError(txtMontoFinal, "Debe ingresar un monto.");
                txtMontoFinal.Focus();
                return false;
            }

            if (cajaDiaria.MontoFinal == null)
            {
                cajaDiaria.MontoFinal = cajaDiaria.MontoInicial;
            }
            decimal montoFinalUsuario = Math.Round(Convert.ToDecimal(txtMontoFinal.Text), 2);
            if (cajaDiaria.MontoFinal != montoFinalUsuario && txtObservaciones.Text == "")
            {
                error.SetError(txtObservaciones, "Monto final distinto al sistema. Justifique en observaciones.");
                txtObservaciones.Focus();
                return false;
            }
            return true;
        }

        private void txtMontoFinal_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && e.KeyChar != '.')
            {
                e.Handled = true;
            }
            // Solo permitir un punto decimal
            TextBox textBox = sender as TextBox;
            if (e.KeyChar == '.' && textBox.Text.Contains("."))
            {
                e.Handled = true;
            }
        }
    }
}
