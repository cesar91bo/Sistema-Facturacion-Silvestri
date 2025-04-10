using CapaEntidades;
using CapaNegocio;
using Spire.Pdf.HtmlConverter;
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
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace VideoCableEsc.Forms.Reportes
{
    public partial class FormPresupuesto : Form
    {
        ServiciosNegocio serviciosNegocio = new ServiciosNegocio();
        int cont = 0;
        decimal SumTotal = 0;
        public FormPresupuesto()
        {
            InitializeComponent();
        }

        private void FormPresupuesto_Load(object sender, EventArgs e)
        {
            cmbServicios.DataSource = serviciosNegocio.GetList();
            cmbServicios.DisplayMember = "Descripcion";
            cmbServicios.ValueMember = "ServicioId";
            cmbServicios.SelectedIndex = -1;

            cmbCondPago.SelectedIndex = 0;
            CrearColServicio();
        }

        private void CrearColServicio()
        {
            try
            {
                listServicio.Columns.Add("Servicio", 120, HorizontalAlignment.Left);
                listServicio.Columns.Add("Descripción", 380, HorizontalAlignment.Left);
                listServicio.Columns.Add("Condición de Pago.", 120, HorizontalAlignment.Left);
                listServicio.Columns.Add("Meses", 120, HorizontalAlignment.Left);
                listServicio.Columns.Add("Precio", 85, HorizontalAlignment.Left);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            if (ValidarCampos())
            {
                try
                {
                    cont++;
                    var item = new ListViewItem
                    {
                        Tag = cmbServicios.Text,
                        Text = cmbServicios.Text
                    };
                    item.SubItems.Add(txtDescripcion.Text);
                    item.SubItems.Add(cmbCondPago.Text);
                    item.SubItems.Add(txtMeses.Text);
                    item.SubItems.Add(txtPrecio.Text);
                    listServicio.Items.Add(item);
                    LimpiarCampos();
                    CalcularTotal();
                }
                catch (Exception ex)
                {

                    throw ex;
                }
            }
        }

        private void CalcularTotal()
        {
            decimal total = 0;
            // Recorrer los elementos de la ListView
            foreach (ListViewItem item in listServicio.Items)
            {
                // Obtener el valor de la columna de precios (txtPrecio)
                string precioString = item.SubItems[4].Text;

                // Convertir el valor a decimal y sumarlo al total
                decimal precio;
                if (decimal.TryParse(precioString, out precio))
                {
                    total += precio;
                }
            }
            SumTotal = total;
            lblTotal.Text = "Total: " + total.ToString();
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrEmpty(cmbServicios.Text) || string.IsNullOrEmpty(txtPrecio.Text) ||
                string.IsNullOrEmpty(txtMeses.Text) || string.IsNullOrEmpty(txtDescripcion.Text) || string.IsNullOrEmpty(cmbCondPago.Text))
            {
                MessageBox.Show("Por favor, complete todos los campos.", "Campos Vacíos", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false; // Al menos uno de los campos está vacío
            }
            return true;
        }

        private void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarCampos();          
        }

        private void LimpiarCampos()
        {
            cmbServicios.SelectedIndex = -1;
            txtPrecio.Text = "";
            txtMeses.Text = "";
            txtDescripcion.Text = "";
        }

        private void txtMeses_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Verifica si el caracter ingresado es un número o la tecla de retroceso
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
            {
                // Si no es un número, cancela la entrada de caracteres
                e.Handled = true;
            }
        }

        private void txtPrecio_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Obtiene el separador decimal del sistema
            char separator = Convert.ToChar(CultureInfo.CurrentCulture.NumberFormat.NumberDecimalSeparator);

            // Verifica si el caracter ingresado es un número, la tecla de retroceso o el separador decimal
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != separator || txtPrecio.Text.Contains(separator)))
            {
                // Si no es un número, la tecla de retroceso o el separador decimal, cancela la entrada de caracteres
                e.Handled = true;
            }
        }

        private void btnGenerar_Click(object sender, EventArgs e)
        {
            try
            {
                if (ValidarReporte())
                {
                    ReportePresupuestoNegocio reportePresupuestoN = new ReportePresupuestoNegocio();

                    reportePresupuestoN.EliminarRegistros();

                    int nroRep = 0;

                    foreach (ListViewItem item in listServicio.Items)
                    {
                        // Accede a los subelementos de cada ListViewItem para obtener los valores
                        string nombreServicio = item.SubItems[0].Text;
                        string descripcion = item.SubItems[1].Text;
                        string condPago = item.SubItems[2].Text;
                        int cantMeses = Convert.ToInt32(item.SubItems[3].Text);
                        decimal precio = Convert.ToDecimal(item.SubItems[4].Text);

                        string nombreSolicitante = txtNombre.Text;
                        string direccion = txtDireccion.Text;
                        string observacion = txtObservacion.Text;

                        // Crea una instancia de ReportePresupuesto con los valores obtenidos
                        var reporePres = new ReportePresupuesto
                        {
                            Servicio = nombreServicio,
                            Descripcion = descripcion,
                            Precio = precio,
                            CantMeses = cantMeses,
                            NombreSolicit = nombreSolicitante,
                            Direccion = direccion,
                            Observacion = observacion,
                            CondPago = condPago,
                            Total = SumTotal,
                            Fecha = DateTime.Today
                        };
                        // Agregar la instancia de ReportePresupuesto a la base de datos
                        nroRep = reportePresupuestoN.NuevoRepPres(reporePres);
                    }

                    if (nroRep > 0)
                    {
                        FormImpresionPresup formImpresionPresup = new FormImpresionPresup();
                        formImpresionPresup.ShowDialog();
                    }

                }
            } catch(Exception ex)
            {
                
            }
        }

        private bool ValidarReporte()
        {
            if(string.IsNullOrEmpty(txtNombre.Text))
            {
                MessageBox.Show("Por favor, ingrese los datos del solicitante.", "Campos Vacíos", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
            if (listServicio.Items.Count == 0)
            {
                MessageBox.Show("Por favor, ingrese al menos un servicio.", "Lista Vacía", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false; // ListView está vacío
            }
            return true;
        }
    }
}
