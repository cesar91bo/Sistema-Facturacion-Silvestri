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
    public partial class frmRegistroEgreso : Form
    {
        private CajaNegocio cajaNegocio = new CajaNegocio();
        private CajasDiarias CajaDiaria;
        public frmRegistroEgreso()
        {
            InitializeComponent();
        }

        private void btnEgreso_Click(object sender, EventArgs e)
        {
            if (Validaciones())
            {
                CajasEgresos cajasEgresos = new CajasEgresos();
                cajasEgresos.Monto = Convert.ToDecimal(txtMonto.Text);
                cajasEgresos.Motivo = txtMotivo.Text;
                cajasEgresos.IdCajaDiaria = cajaNegocio.ObtenerCajaActual().IdCajaDiaria;

                var resultado = cajaNegocio.GuardarEgreso(cajasEgresos);

                if (resultado.EsExitoso)
                {
                    MessageBox.Show(resultado.Mensaje, "Éxito", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    LimpiarFormulario();
                }
                else
                {
                    MessageBox.Show(resultado.Mensaje, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void LimpiarFormulario()
        {
            txtMotivo.Text = string.Empty;
            txtMonto.Text = string.Empty;
            CajaDiaria = null;
        }

        private bool Validaciones()
        {
            error.Clear();

            if (string.IsNullOrWhiteSpace(txtMotivo.Text))
            {
                error.SetError(txtMotivo, "Debe ingresar un motivo.");
                txtMotivo.Focus();
                return false;
            }
            else if (string.IsNullOrWhiteSpace(txtMonto.Text))
            {
                error.SetError(txtMonto, "Debe ingresar un monto.");
                txtMonto.Focus();
                return false;
            }
            CajaDiaria = cajaNegocio.ObtenerCajaActual();
            if (CajaDiaria == null)
            {

                DialogResult respuesta = MessageBox.Show("No se abrió ninguna caja para el día de hoy. ¿Desea hacerlo ahora?", "Caja no abierta",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                if (respuesta == DialogResult.Yes)
                {
                    frmAperturaCaja frm = new frmAperturaCaja();
                    frm.ShowDialog();

                    CajaDiaria = cajaNegocio.ObtenerCajaActual();
                    if (CajaDiaria == null || CajaDiaria.IdCajaDiaria == 0)
                    {
                        MessageBox.Show("No se pudo abrir la caja. Operación cancelada.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        return false;
                    }
                }
                else
                {
                    MessageBox.Show("Debe abrir una caja para continuar.", "Operación cancelada", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return false;
                }
            }

            if (CajaDiaria != null && CajaDiaria.MontoFinal < Convert.ToDecimal(txtMonto.Text))
            {
                MessageBox.Show("El monto de egreso supera el monto actual de la caja.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
            else 
            {
                var resultado = cajaNegocio.EditarMontoCajaDiaria(CajaDiaria);
                if (resultado.EsExitoso == false) 
                {
                    MessageBox.Show(resultado.Mensaje, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }

            return true;
        }

        private void txtMontoSistema_KeyPress(object sender, KeyPressEventArgs e)
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
