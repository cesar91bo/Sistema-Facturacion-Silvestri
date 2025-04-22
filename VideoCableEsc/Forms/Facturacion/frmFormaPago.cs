using CapaEntidades.Enum;
using CapaEntidades;
using CapaNegocio;
using SistGestionEsc;
using Spire.Doc.Fields;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using Spire.Doc;
using VideoCableEsc.Forms.Caja;

namespace VideoCableEsc.Forms.Facturacion
{
    public partial class frmFormaPago : Form
    {
        AuxiliaresNegocio auxiliaresNegocio = new AuxiliaresNegocio();
        FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();
        EmpresaNegocio empresaN = new EmpresaNegocio();
        public int IdFactura;
        VistaCabFactVenta factura = new VistaCabFactVenta();
        CajaNegocio cajaNegocio = new CajaNegocio();
        CajasDiarias cajaDiaria = new CajasDiarias();
        public frmFormaPago()
        {
            InitializeComponent();
        }

        private void frmFormaPago_Load(object sender, EventArgs e)
        {
            txtNroFact.Text = IdFactura.ToString();

            cmbFPago.DataSource = auxiliaresNegocio.ObtenerFormasPago().ToList();
            cmbFPago.ValueMember = "IdFormaPago";
            cmbFPago.DisplayMember = "Descripcion";

            BuscarFactura();
        }

        private void BuscarFactura()
        {
            FacturasVentaNegocio facturasVentaN = new FacturasVentaNegocio();

            factura = facturasVentaN.BuscarVistaCabFacturaVentaPorId(IdFactura);

            txtMonto.Text = factura.Total.ToString();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (Validaciones())
            {
                if (factura != null)
                {
                    FacturasVenta facturaVenta = facturasVentaNegocio.BuscarFacturaVentaPorId(factura.IdFacturaVenta);

                    facturaVenta.IdFormaPago = (short)cmbFPago.SelectedValue;

                    facturasVentaNegocio.EditarFacturaVenta(facturaVenta);

                    if(cajaDiaria != null && facturaVenta.IdFormaPago == 1)
                    {
                        decimal montoFactura = facturaVenta.Total;
                        cajaNegocio.EditarMontoCajaDiaria(montoFactura, cajaDiaria.IdCajaDiaria);
                    }
                }


                string tipoFactura = rbFacturaX.Checked ? "Factura X" : "Factura Electrónica";

                if (tipoFactura == "Factura Electrónica")
                {
                    var listado = new List<int>();

                    listado.Add(IdFactura);

                    var frmc = new frmFacturaElectronica() { ListFacturas = listado, bocaVenta = "003" };

                    frmc.ShowDialog();
                }
                else
                {
                    var numeroComprobante = IdFactura.ToString();

                    CargarPdf(numeroComprobante);
                }
            }
            Close();
        }

        private bool Validaciones()
        {

            if (!rbFacturaX.Checked && !rbFacturaElectronica.Checked)
            {
                MessageBox.Show("Debe seleccionar un tipo de factura.");
                return false;
            }

            cajaDiaria = cajaNegocio.ObtenerCajaActual();

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
                        return false;
                    }
                }
            }

            return true;
        }

        private void CargarPdf(string numeroComprobante)
        {

            var factura = facturasVentaNegocio.GetById(Convert.ToInt64(numeroComprobante));

            var cliente = factura.ClientesCajasDistribucionesServicios.Clientes;

            var empresa = empresaN.GetEmpresa();

            string ruta = ConfigurationManager.AppSettings["pathFactura"];

            string original = string.Empty;
            string nuevoArchivo = string.Empty;
            string nombreDocumento = string.Empty;


            original = ruta + @"\FacturaVentaX.docx";

            nuevoArchivo = ruta + @"\FacturaVentaX Copia.docx";

            nombreDocumento = $"C:/Facturas/FacturaVentaX-{cliente.ApellidoyNombre}-{DateTime.Now.ToString("ddMMyyyyHHmmss")}.pdf";

            File.Copy(original, nuevoArchivo, true);

            Spire.License.LicenseProvider.SetLicenseKey("PUILu36Ih+JDtwEAr15df+E9OHwWC9pL54zFDJvFvQaW0gyLhw7Ynog/D53EWfx4AqgfkWxQxO8XR6vHzNtTnzemNPKTf4OMd/FVxzKPnIvOjuG0c1G5v1ZtlAZb5Uv1bwM9Ar+RjvXfQnylsQJwub+b9BZwnvNzOdWqDf8lqs6YcLDC5i3ObVJ24LVWpJI+Pxl0Mrg3ccRsSH7JraWEbvCfReHJyi5JJDG2KFxLH0cyx2TiRf4Sduan6+F3ZrjgPM5A2oCYfnDbHBLFv0oX9/oRKepuLb/PuASMMySZrjxoLMdCEEqc/mFB+BW0FzLKfgNIael5geTryiN5AGWEnB5K03Dsgo+o1k++02w1WQi4qD9n28rBQMvLrCyqreqacsRlUR2CjDgR1+Wor+ZG5GNVCoXYlY3MOY1oKbuAHy3VqgAeAwAdaHmHYrwXI/x4l+tIfnJWjiePqRa41je6KE2fDC4gboDMJlq1dk5Bdyzpe1HHe2IsZffg4eUvEfIPQTIIRtQdS4ynsUAirIBSGZGOD18vW/v1HJAUCkt/Dddxp+csS14i/OmUG4JddryhLRufFVkFk9wpQfiPjNXm/CI9eq22igO5I2Z3MNvAFV5EKvtJ9xy3eV4+w/1iZRtOU9OQYv7dSKXsfFflAVxjgDM0JjVQphsqHbarbs88LAO02P4G1wB36evbA8n/HAQTJvFtb6XpiI1mA9/XNnWS72rzVD69MBSZWelJWXvb6dnHI0CTdPVGpKDyZnI9fmpmvq+Yc7fjtC+P1rGtpLls3FiHR16s0fidh9uFJquJe0DXlFVR5Nk9oh5fMOpov9Bsy3G9UM3VpMS//UNx1LENKqz9lx7niE26gIM907h0ihSFiMgq8uU9s1+y44mNE2lNMD9ykQG5mK0WP8BzU2aoX9/T45ERldOSXm+dn6dTtHngaNfN7LgdXtcQYW0/2hLz3xJli9x7PL5R/iFTUufW0KgGMQOu4OBi/j8lTFROcR/lGI3rjhg5IWWy6cO+mGAXiJKdmtXWeWTdCfpu//RyBZtiGqFu1Z0m7bQzrFVGTB9MLuWJqVXM5UekXbEGK7ksxadKjx9cSwZapRHAh2gJp7eMvk160AAl3AleXyLC0f8fBSyzQFnvioAxwsATdbjxThZk/Pt1Zu/uOG1Dnul8wm90I9DYpcOaWW6okYEHQf37GmnkOYW2VVDOw/7YXw2nxTri1JrNlqw8E+9XXx779IzZcsX0XU71E7qqHWxP5JfRlSm4f2d+oS3alGhvduH7Y/PF08a8hhBSnznDziJeoYVjd+ZwT2uZ46ZGqcri2e10/x9OfjSoYDQn2JFG72dJLwmh/so0jkcjroDdWTLWqKZp5uTU3Xd0IoRCWyw7/k5cIBrV5qMaiNwtQWptH8KaeBbdqoxZqHWJdIjO+JMAIKTTAA8ZOHA1lEOkxjMYZnJtSVqxCGC+2fagkaANoZAv");

            //Load Document
            Spire.Doc.Document document = new Spire.Doc.Document();

            document.LoadFromFile(nuevoArchivo);

            foreach (FormField field in document.Sections[0].Body.FormFields)
            {
                switch (field.Name)
                {
                    //CAMPOS EMPRESA

                    case "RazonSocialEmpresa":
                        field.Text = empresa.RazonSocial;
                        break;

                    case "DomicilioComercialEm":
                        field.Text = empresa.Direccion;
                        break;

                    case "CondicionIvaEmp":
                        field.Text = empresa.CondicionIva;
                        break;

                    case "PuntoVenta":
                        field.Text = "003";
                        break;

                    case "ComprobanteNro":
                        field.Text = "-";
                        break;

                    case "FechaEmision":
                        field.Text = DateTime.Now.ToShortDateString();
                        break;

                    case "CuitEmpresa":
                        field.Text = empresa.CuitParaImpresion;
                        break;

                    case "IngresosBrutosEmp":
                        field.Text = empresa.IIBBParaImpresion;
                        break;

                    case "FechaInicioActividad":
                        field.Text = empresa.InicioActividades != null ? empresa.InicioActividades.Value.ToString("dd/MM/yyyy") : "-";
                        break;

                    //CAMPOS CLIENTE
                    case "CuitCliente":
                        field.Text = cliente.NroDocumento != null ? cliente.NroDocumento.Value.ToString() : "-";
                        break;

                    case "RazonSocialCliente":
                        field.Text = cliente.ApellidoyNombre;
                        break;

                    case "CondicionIvaCliente":
                        field.Text = cliente.RegimenesImpositivos != null ? cliente.RegimenesImpositivos.Descripcion : "-";
                        break;

                    case "DomicilioCliente":
                        field.Text = string.IsNullOrEmpty(cliente.Direccion) ? "-" : cliente.Direccion;
                        break;

                    case "CondicionVenta":
                        field.Text = factura.FormasPago.Descripcion;
                        break;

                    case "MesAbonado":
                        field.Text = factura.MesAbonado;
                        break;

                    //CAMPOS SERVICIOS

                    case "ServicioCodigoAfip":
                        field.Text = "1";
                        break;

                    case "ServicioDescripcion":
                        field.Text = factura.ClientesCajasDistribucionesServicios.Servicios.Descripcion;
                        break;

                    case "ServicioCantidad":
                        field.Text = "1";
                        break;

                    case "ServicioPrecio":
                        switch (factura.IdTipoFactura)
                        {
                            case (int)TipoFactura.A:
                                field.Text = (factura.Total - factura.TotalIva21).ToString();
                                break;

                            case (int)TipoFactura.B:
                                field.Text = (factura.Total).ToString();
                                break;

                            case (int)TipoFactura.C:
                                break;

                            case (int)TipoFactura.X:
                                field.Text = (factura.Total).ToString();
                                break;

                            default:
                                field.Text = (factura.Total).ToString();
                                break;

                        }
                        field.Text = factura.ClientesCajasDistribucionesServicios.Servicios.Costo.ToString();
                        break;

                    case "ServicioSubtotal":
                        field.Text = factura.SubTotal.ToString();
                        break;

                    case "PorcentajeIva":
                        field.Text = "21";
                        break;

                    case "SubtotalCIva":
                        field.Text = factura.Total.ToString();
                        break;

                    //CAMPOS OTROS TRIBUTOS

                    case "ImpNetGra":
                        switch (factura.IdTipoFactura)
                        {
                            case (int)TipoFactura.A:
                                field.Text = (factura.Total - factura.TotalIva21).ToString();
                                break;

                            case (int)TipoFactura.B:
                                field.Text = (factura.Total).ToString();
                                break;

                            case (int)TipoFactura.C:
                                break;

                            case (int)TipoFactura.X:
                                field.Text = (factura.Total).ToString();
                                break;

                            default:
                                field.Text = (factura.Total).ToString();
                                break;

                        }
                        break;

                    case "ImpIva21":
                        field.Text = factura.Subtotal21.ToString();
                        break;

                    case "ImpTotal":
                        field.Text = factura.Total.ToString();
                        break;

                }
            }

            string mensaje;

            factura.Pagado = true;
            factura.IdTipoFactura = (int)(int)TipoFactura.X;

            facturasVentaNegocio.Create(factura, out mensaje);

            document.SaveToFile(nombreDocumento, FileFormat.PDF);

            //Launch Document
            System.Diagnostics.Process.Start(nombreDocumento);

        }
    }
}
