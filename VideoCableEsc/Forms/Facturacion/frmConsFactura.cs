using CapaEntidades;
using CapaNegocio;
using SistGestionEsc;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using Xceed.Document.NET;
using Xceed.Words.NET;
using ZXing;
using ZXing.Common;
using ZXing.Rendering;
using Paragraph = Xceed.Document.NET.Paragraph;
using Image = Xceed.Document.NET.Image;
using Spire.Doc.Fields;
using Spire.Doc;
using System.Configuration;
using CapaEntidades.Enum;
using CapaEntidades.Entidades;
using Newtonsoft.Json;

namespace VideoCableEsc.Forms.Facturacion
{
    public partial class frmConsFactura : Form
    {
        List<VistaCabFactVenta> listFacturas;

        private readonly EmpresaNegocio empresaN = new EmpresaNegocio();

        private readonly FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();

        private readonly FacturasElectronicasNegocio facturasElectronicasNegocio = new FacturasElectronicasNegocio();

        private Form activeForm;

        private int nroCliente = 0; 

        public frmConsFactura(string cliente = "", int idCliente = 0)
        {
            InitializeComponent();
            txtClienteFactura.Text = cliente;
            nroCliente = idCliente;
        }

        #region Abrir Form hijo
        public void OpenChildForm(Form childForm, object btnSender)
        {
            frmPrincipal principal = Application.OpenForms["frmPrincipal"] as frmPrincipal;
            if (principal != null)
            {
                if (activeForm != null)
                {
                    activeForm.Close();
                }

                activeForm = childForm;
                childForm.TopLevel = false;
                childForm.FormBorderStyle = FormBorderStyle.None;
                childForm.Dock = DockStyle.Fill;
                principal.panelDesktop.Controls.Add(childForm);
                principal.panelDesktop.Tag = childForm;
                childForm.BringToFront();
                childForm.Show();
                principal.lblTittle.Text = childForm.Text;
            }


        }
        #endregion

        private void frmConsFactura_Load(object sender, EventArgs e)
        {
            try
            {
                var dt = new DataTable();
                dt.Columns.Add("IdBusqueda");
                dt.Columns.Add("Descripcion");
                dt.Rows.Add("IdFacuraVenta", "Id Factura de Venta");
                dt.Rows.Add("Cliente", "Cliente");
                dt.Rows.Add("FechaEmision", "Fecha de Emision");


                CrearColListFecha();
                LLenarListaFecha(false);

                btnComprobanteX.Enabled = false;
                btnFacturaElectronica.Enabled = false;
                VerFacturaPdf.Enabled = false;

            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void CrearColListFecha()
        {
            try
            {
                listFact.Columns.Add("Id Factura", 70, HorizontalAlignment.Left);
                listFact.Columns.Add("Id Cliente", 70, HorizontalAlignment.Left);
                listFact.Columns.Add("Cliente", 200, HorizontalAlignment.Left);
                listFact.Columns.Add("Fecha de Emisión", 100, HorizontalAlignment.Center);
                listFact.Columns.Add("Mes", 85, HorizontalAlignment.Right);
                listFact.Columns.Add("Monto", 85, HorizontalAlignment.Right);
                listFact.Columns.Add("Tipo Fact.", 65, HorizontalAlignment.Center);
                listFact.Columns.Add("Pagado", 65, HorizontalAlignment.Center);
                listFact.Columns.Add("Observaciones", 200, HorizontalAlignment.Center);

            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void LLenarListaFecha(bool _siload)
        {
            try
            {
                listFact.Items.Clear();
                DateTime fechaDesde;
                DateTime fechaHasta;
                var facturaNegocio = new FacturasVentaNegocio();
                if (_siload)
                {
                    fechaDesde = DateTime.Today.AddMonths(-6);
                    fechaHasta = DateTime.Today;

                    listFacturas = facturaNegocio.BuscarFacturasFechaDesdeFechaHasta(fechaDesde, fechaHasta);
                }
                else
                {
                   
                    var cliente = txtClienteFactura.Text;

                    if (checkHabilitar.Checked)
                    {
                        fechaDesde = Convert.ToDateTime(dtpFechaDesdeFact.Text + " 00:00:00");
                        fechaHasta = Convert.ToDateTime(dtpFechaHastaFact.Text + " 23:59:59");
                        listFacturas = facturaNegocio.BuscarFacturasPorClienteIdFechaDesdeFechaHasta(cliente, fechaDesde, fechaHasta);
                    }
                    else
                    {
                        listFacturas = facturaNegocio.BuscarFacturasPorClienteId(nroCliente);
                    }



                }

                if (listFacturas == null) { return; }

                foreach (VistaCabFactVenta factura in listFacturas)
                {
                    var item = new ListViewItem
                    {
                        Tag = factura.IdFacturaVenta.ToString(),
                        Text = factura.IdFacturaVenta.ToString()
                    };
                    item.SubItems.Add(factura.NroCliente.ToString());
                    item.SubItems.Add(factura.Cliente.ToString());
                    item.SubItems.Add(factura.FechaEmision.ToShortDateString());
                    item.SubItems.Add(factura.MesAbonado);
                    item.SubItems.Add(factura.Total.ToString("C2"));
                    item.SubItems.Add(factura.TipoFact);
                    item.SubItems.Add(factura.Pagado);
                    item.SubItems.Add(factura.Observaciones);


                    listFact.Items.Add(item);
                }
                listFact.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void listFact_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listFact.SelectedItems.Count > 0)
            {
                btnComprobanteX.Enabled = true;
                btnFacturaElectronica.Enabled = true;
                VerFacturaPdf.Enabled = true;
                btnEditarPrecio.Enabled = true;
                btnEditarPrecio.Visible = true;
            }
            else
            {
                btnComprobanteX.Enabled = false;
                btnFacturaElectronica.Enabled = false;
                VerFacturaPdf.Enabled = false;
                btnEditarPrecio.Enabled = false;
                btnEditarPrecio.Enabled = false;
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {


            LLenarListaFecha(false);
        }

        private void btnFacturaElectronica_Click(object sender, EventArgs e)
        {
            if (listFact.SelectedItems.Count > 0) //
            {
                var listado = new List<int>();
                var idFacturaVenta = listFact.SelectedItems[0].SubItems[0].Text;

                listado.Add(Convert.ToInt32(idFacturaVenta));

                var frmc = new frmFacturaElectronica() { ListFacturas = listado, bocaVenta = "003" };

                frmc.ShowDialog();

                LLenarListaFecha(true);

            }
            else
            {
                MessageBox.Show("No se puede cargar la ventana de Factura Electronica " + listFact.SelectedItems[0].SubItems[1].Text, "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void btnComprobanteX_Click(object sender, EventArgs e)
        {
            var numeroComprobante = listFact.SelectedItems[0].SubItems[0].Text;

            CargarPdf(numeroComprobante);

        }

        private void CargarPdf(string numeroComprobante)
        {

            var factura = facturasVentaNegocio.GetById(Convert.ToInt64(numeroComprobante));

            //if (factura.Pagado != null && factura.Pagado.Value == true)
            //{
            //    MessageBox.Show("La factura seleccionada ya fue marcada como pagada", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            //}

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
                        string iva21 = CalculaIVA(factura.Total);
                        field.Text = iva21;
                        break;

                    case "ImpTotal":
                        field.Text = factura.Total.ToString();
                        break;

                }
            }

            string mensaje;

            factura.Pagado = true;
            factura.IdTipoFactura = (int)TipoFactura.X;

            facturasVentaNegocio.Create(factura, out mensaje);

            document.SaveToFile(nombreDocumento, FileFormat.PDF);

            //Launch Document
            System.Diagnostics.Process.Start(nombreDocumento);

            LLenarListaFecha(true);

        }

        private void btnGenerarFacturas_Click(object sender, EventArgs e)
        {
            int cantidadFacturasGeneradas;

            facturasVentaNegocio.Generarfacturas(out cantidadFacturasGeneradas);

            MessageBox.Show("Cantidad de Facturas Generadas: " + cantidadFacturasGeneradas.ToString(), "FACTURAS GENERADAS", MessageBoxButtons.OK, MessageBoxIcon.Information);

            LLenarListaFecha(true);
        }

        private void VerFacturaPdf_Click(object sender, EventArgs e)
        {
            var numeroComprobante = listFact.SelectedItems[0].SubItems[0].Text;

            var factura = facturasVentaNegocio.GetById(Convert.ToInt64(numeroComprobante));

            if (factura.Pagado == null && factura.Pagado.Value == false)
            {
                MessageBox.Show("La factura seleccionada no fue marcada como pagada", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }

            var cliente = factura.ClientesCajasDistribucionesServicios.Clientes;

            var empresa = empresaN.GetEmpresa();

            var facturaElectronica = facturasElectronicasNegocio.GetFacturaElectronicaByFacturaVentaId(factura.IdFacturaVenta);

            string ruta = ConfigurationManager.AppSettings["pathFactura"];

            string original = string.Empty;
            string nuevoArchivo = string.Empty;
            string nombreDocumento = string.Empty;

            switch (factura.IdTipoFactura)
            {
                case (int)TipoFactura.A:
                    original = ruta + @"\FacturaVentaA.docx";
                    nombreDocumento = $"C:/Facturas/FacturaVentaA-{cliente.ApellidoyNombre}-{DateTime.Now.ToString("ddMMyyyyHHmmss")}.pdf";
                    nuevoArchivo = ruta + @"\FacturaVentaA Copia.docx";
                    break;
                case (int)TipoFactura.B:
                    original = ruta + @"\FacturaVentaB.docx";
                    nombreDocumento = $"C:/Facturas/FacturaVentaB-{cliente.ApellidoyNombre}-{DateTime.Now.ToString("ddMMyyyyHHmmss")}.pdf";
                    nuevoArchivo = ruta + @"\FacturaVentaB Copia.docx";
                    break;
                case (int)TipoFactura.X:
                    original = ruta + @"\FacturaVentaX.docx";
                    nombreDocumento = $"C:/Facturas/FacturaVentaX-{cliente.ApellidoyNombre}-{DateTime.Now.ToString("ddMMyyyyHHmmss")}.pdf";
                    nuevoArchivo = ruta + @"\FacturaVentaX Copia.docx";
                    break;

            }

            File.Copy(original, nuevoArchivo, true);

            if (factura.IdTipoFactura == (int)TipoFactura.A || factura.IdTipoFactura == (int)TipoFactura.B)
            {
                var rutaQr = QrGenerator(factura, cliente, empresa, facturaElectronica);

                AgregarQr(nuevoArchivo, rutaQr);
            }

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
                        field.Text = facturaElectronica != null ? facturaElectronica.NCompFact : "-";
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
                        if (cliente.TipoDocumento == "CUIT")
                        {
                            // Concatenar las partes del CUIT
                            field.Text = $"{cliente.Cuit0}-{cliente.Cuit1}-{cliente.Cuit2}";
                        }
                        else if (cliente.TipoDocumento == "DNI")
                        {
                            // Mantener el comportamiento original para DNI
                            field.Text = cliente.NroDocumento != null ? cliente.NroDocumento.Value.ToString() : "-";
                        }
                        else
                        {
                            // Si el tipo de documento no es CUIT ni DNI, mostrar "-"
                            field.Text = "-";
                        }
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

                    case "IVA21":
                        field.Text = factura.Subtotal21.ToString();
                        break;

                    case "UnitSIVA":
                        string precio = CalculaPrecioSIVA(factura.Total);
                        field.Text = precio;
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
                        string iva21 = CalculaIVA(factura.Total);
                        field.Text = iva21;
                        break;

                    case "ImpTotal":
                        field.Text = factura.Total.ToString();
                        break;

                    case "NumeroCae":
                        field.Text = facturaElectronica.CAE;
                        break;

                    case "FechaVtoCae":
                        field.Text = facturaElectronica.FechaVtoCAE.ToString("dd/MM/yyyy");
                        break;

                }
            }

            string mensaje;

            factura.Pagado = true;

            facturasVentaNegocio.Create(factura, out mensaje);

            document.SaveToFile(nombreDocumento, FileFormat.PDF);

            //Launch Document
            System.Diagnostics.Process.Start(nombreDocumento);

        }

        private string CalculaPrecioSIVA(decimal total)
        {
            var precioSIVA = total / 1.21m;
            return precioSIVA.ToString("F2");
        }

        private string CalculaIVA(decimal total)
        {
            var iva = total * 0.1736m;
            return iva.ToString("F2");
        }

        private void AgregarQr(string nuevoArchivo, string rutaQr)
        {


            using (DocX doc = DocX.Load(nuevoArchivo))
            {

                // Add an image into the document.    
                Image image = doc.AddImage(rutaQr);

                // Create a picture (A custom view of an Image).
                Picture picture = image.CreatePicture();

                picture.Height = 90;
                picture.Width = 120;


                foreach (var item in doc.GetBookmarks())
                {
                    if (item.Name == "Imagen")
                    {
                        item.Paragraph.AppendPicture(picture);
                    }
                }

                // Save this document.
                doc.Save();
            }

        }
        private string QrGenerator(FacturasVenta factura, Clientes cliente, Empresa empresa, FacturasElectronicas facturaElectronica)
        {
            //Color barcodeColor = newKnownColor.Black;

            BarcodeWriter barcodeWriter = new BarcodeWriter
            {
                Format = BarcodeFormat.QR_CODE,
                Options = new EncodingOptions
                {
                    Width = 50,
                    Height = 50,
                    PureBarcode = true
                },
                Renderer = new BitmapRenderer
                {
                    // Foreground = barcodeColor
                }
            };

            int tipoComprobante = 0;
            int tipoDocumentoReceptor = 0;

            switch (factura.IdTipoFactura)
            {
                case (int)TipoFactura.A:
                    tipoComprobante = 001;
                    break;
                case (int)TipoFactura.B:
                    tipoComprobante = 006;
                    break;

            }

            switch (cliente.TipoDocumento)
            {
                case "CUIL":
                    tipoDocumentoReceptor = 86;
                    break;
                case "CUIT":
                    tipoDocumentoReceptor = 80;
                    break;
                case "DNI":
                    tipoDocumentoReceptor = 96;
                    break;
                case "LC":
                    tipoDocumentoReceptor = 90;
                    break;
                case "LE":
                    tipoDocumentoReceptor = 89;
                    break;

            }

            var jsonParaQr = "";
            if (cliente.Cuit1 != null)
            {
                var afipQr = new AfipQr
                {
                    ver = 1,
                    fecha = facturaElectronica.Fecha.ToString("yyyy-MM-dd"),
                    cuit = Convert.ToInt64(empresa.CUIT),
                    ptoVta = Convert.ToInt32("003"),
                    tipoCmp = tipoComprobante,
                    nroCmp = Convert.ToInt64(facturaElectronica.NCompFact),
                    importe = factura.Total,
                    moneda = "PES", // PES es pesos
                    ctz = 1, // codigo de cotizacion de la moneda pesos
                    tipoDocRec = tipoDocumentoReceptor,
                    nroDocRec = Convert.ToInt64(cliente.Cuit0 + cliente.Cuit1 + cliente.Cuit2),
                    tipoCodAut = "E", //"E" para comprobante autorizado por CAE
                    codAut = Convert.ToInt64(facturaElectronica.CAE)
                };
                jsonParaQr = JsonConvert.SerializeObject(afipQr);
            }
            else
            {
                var afipQr = new AfipQr
                {
                    ver = 1,
                    fecha = facturaElectronica.Fecha.ToString("yyyy-MM-dd"),
                    cuit = Convert.ToInt64(empresa.CUIT),
                    ptoVta = Convert.ToInt32("003"),
                    tipoCmp = tipoComprobante,
                    nroCmp = Convert.ToInt64(facturaElectronica.NCompFact),
                    importe = factura.Total,
                    moneda = "PES", // PES es pesos
                    ctz = 1, // codigo de cotizacion de la moneda pesos
                    tipoDocRec = tipoDocumentoReceptor,
                    nroDocRec = cliente.NroDocumento.Value,
                    tipoCodAut = "E", //"E" para comprobante autorizado por CAE
                    codAut = Convert.ToInt64(facturaElectronica.CAE)
                };
                jsonParaQr = JsonConvert.SerializeObject(afipQr);
            }

            var jsonEnArray = Encoding.UTF8.GetBytes(jsonParaQr);

            var jsonBase64 = Convert.ToBase64String(jsonEnArray);


            Bitmap barCodeBitmap = barcodeWriter.Write($"https://www.afip.gob.ar/fe/qr/?p={jsonBase64}");
            var memoryStream = new MemoryStream();

            var rutaQr = $"C:/Facturas/Qr-{cliente.ApellidoyNombre}-{DateTime.Now.ToString("ddMMyyyyHHmmss")}.png";

            // save to stream as PNG
            barCodeBitmap.Save(rutaQr, System.Drawing.Imaging.ImageFormat.Png);

            return rutaQr;

        }

        private void checkHabilitar_CheckedChanged(object sender, EventArgs e)
        {
            if (checkHabilitar.Checked)
            {
                dtpFechaDesdeFact.Enabled = true;
                dtpFechaHastaFact.Enabled = true;
            }
            else
            {
                dtpFechaDesdeFact.Enabled = false;
                dtpFechaHastaFact.Enabled = false;
            }
        }

        private void btnEditarPrecio_Click(object sender, EventArgs e)
        {
            if (listFact.SelectedItems.Count > 0) //
            {
                var idFacturaVenta =  Convert.ToInt32(listFact.SelectedItems[0].SubItems[0].Text);

                var frmc = new frmEditarFactura() { idfactura = idFacturaVenta };

                frmc.ShowDialog();

                LLenarListaFecha(false);
            }
        }

        private void btnVolver_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmClienteFactura(), sender);
        }
    }
}
