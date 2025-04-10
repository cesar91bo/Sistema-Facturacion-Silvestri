using CapaEntidades;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.Facturacion
{
    public partial class frmEditarFactura : Form
    {
        public int idfactura;
        FacturasVenta Factura;
        List<FacturasVentaDetalle> facturasVentaDetalle;
        VentaNegocio ventaN = new VentaNegocio();
        AuxiliaresNegocio auxiliaresNegocio = new AuxiliaresNegocio();
        public frmEditarFactura()
        {
            InitializeComponent();
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            Factura.Total = !string.IsNullOrWhiteSpace(txtPrecioNuevo.Text) ? Math.Round(Convert.ToDecimal(txtPrecioNuevo.Text), 2) : Convert.ToDecimal(lblPrecioActual.Text);
            Factura.Subtotal21 = Math.Round(Factura.Total / Convert.ToDecimal(1.21), 2);
            Factura.SubTotal = Factura.Subtotal21;
            Factura.TotalIva21 = Math.Round(Factura.Total - Factura.Subtotal21, 2);
            Factura.Observaciones = txtDescription.Text;
            if (txtTipoFac.Text.ToUpper() == "B") Factura.IdTipoFactura = 2;
            else if(txtTipoFac.Text.ToUpper() == "A") Factura.IdTipoFactura = 1;
            else Factura.IdTipoFactura = 4;
            if (Factura.Pagado == true)
            {
                Factura.Pagado = !string.IsNullOrWhiteSpace(txtPrecioNuevo.Text) ? false : true;
                Factura.Impresa = !string.IsNullOrWhiteSpace(txtPrecioNuevo.Text) ? false : true;
            }
            Factura.FechaEmision = Convert.ToDateTime(fechaEmision.Text);
            Factura.IdFormaPago = (short)cmbFPago.SelectedValue;
            foreach (var item in facturasVentaDetalle)
            {
                item.PrecioUnitario = Factura.Total;
                item.TotalArt = Factura.Total;

                ventaN.EditarFacturaVentaDetalle(item);
            }

            if (ventaN.EditarFactura(Factura))
            {
                MessageBox.Show("La Factura se ha editado correctamente.");
                this.Close();
            };
        }

        private void txtPrecioNuevo_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && e.KeyChar != '.')
            {
                e.Handled = true;
            }

            if (e.KeyChar == '.' && (sender as TextBox).Text.IndexOf('.') > -1)
            {
                e.Handled = true;
            }
        }

        private void frmEditarFactura_Load(object sender, EventArgs e)
        {
            Factura = ventaN.ObtenerFactura(idfactura);
            facturasVentaDetalle = ventaN.ObtenerDetalledeFacturaVta(idfactura);

            cmbFPago.DataSource = auxiliaresNegocio.ObtenerFormasPago().ToList();
            cmbFPago.ValueMember = "IdFormaPago";
            cmbFPago.DisplayMember = "Descripcion";

            if (Factura != null)
            {
                lblNroFactura.Text = lblNroFactura.Text + ": " + Factura.IdFacturaVenta.ToString();

                lblPrecioActual.Text = Factura.Total.ToString();

                cmbFPago.SelectedValue = Factura.IdFormaPago;

                if (Factura.IdTipoFactura == 2) txtTipoFac.Text = "B"; else if (Factura.IdTipoFactura == 1) txtTipoFac.Text = "A"; else txtTipoFac.Text = "X";

                fechaEmision.Text = Factura.FechaEmision.ToString();

                //lblFormaPago.Text = Factura.IdFacturaVenta.ToString();
            }
        }

        private void txtTipoFac_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!"ABab".Contains(e.KeyChar) && e.KeyChar != (char)Keys.Back)
            {
                e.Handled = true;
            }

            if (txtTipoFac.Text.Length >= 1 && e.KeyChar != (char)Keys.Back)
            {
                e.Handled = true;
            }
        }
    }
}
