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
    public partial class frmEditarPrecio : Form
    {
        public int idfactura;
        FacturasVenta Factura;
        List<FacturasVentaDetalle> facturasVentaDetalle;
        VentaNegocio ventaN = new VentaNegocio();
        public frmEditarPrecio()
        {
            InitializeComponent();
        }

        private void frmEditarPrecio_Load(object sender, EventArgs e)
        {         
            Factura = ventaN.ObtenerFactura(idfactura);
            facturasVentaDetalle = ventaN.ObtenerDetalledeFacturaVta(idfactura);

            if (Factura != null)
            { 
                lblPrecioActual.Text = Factura.Total.ToString();
            }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (txtPrecioNuevo.Text != "")
            {               
                Factura.Total = Math.Round(Convert.ToDecimal(txtPrecioNuevo.Text), 2);
                Factura.Subtotal21 = Math.Round(Factura.Total / Convert.ToDecimal(1.21), 2);               
                Factura.SubTotal = Factura.Subtotal21;
                Factura.TotalIva21 = Math.Round(Factura.Total - Factura.Subtotal21, 2);
                Factura.Observaciones = txtDescription.Text;

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
    }
}
