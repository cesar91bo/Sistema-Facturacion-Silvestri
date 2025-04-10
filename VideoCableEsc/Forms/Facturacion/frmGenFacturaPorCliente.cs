using CapaEntidades;
using CapaEntidades.Enum;
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
using VideoCableEsc.Forms.ClienteCajaDistribucionServicioEstado;
using VideoCableEsc.Formularios;
using Spire.Doc.Fields;
using Spire.Doc;
using System.IO;
using CapaEntidades.Entidades;
using Newtonsoft.Json;
using ZXing.Common;
using ZXing.Rendering;
using ZXing;
using Xceed.Document.NET;
using Xceed.Words.NET;
using Image = Xceed.Document.NET.Image;

namespace VideoCableEsc.Forms.Facturacion
{
    public partial class frmGenFacturaPorCliente : Form
    {
        List<VistaCabFactVenta> listFacturas;
        public Int32 NroCliente;
        private string cuit;
        ServicioNegocio servicioNegocio = new ServicioNegocio();
        FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();
        ClienteNegocio clienteNegocio = new ClienteNegocio();
        AuxiliaresNegocio auxiliaresNegocio = new AuxiliaresNegocio();
        private readonly EmpresaNegocio empresaN = new EmpresaNegocio();
        private readonly FacturasElectronicasNegocio facturasElectronicasNegocio = new FacturasElectronicasNegocio();
        public frmGenFacturaPorCliente()
        {
            InitializeComponent();
        }

        private void frmGenFacturaPorCliente_Load(object sender, EventArgs e)
        {
            LlenarCombo();
            CrearColListFecha();
            LLenarLista(true);

            SuspenderClientesDeudores();
        }

        private void SuspenderClientesDeudores()
        {
            try
            {
                DateTime fecha_actual = DateTime.Now;
                Ultima_Revision_Deudores ultimaRevisionDeudores = auxiliaresNegocio.ObtenerFechaUltimaRevisionDeudores();

                if (ultimaRevisionDeudores == null ||
      ultimaRevisionDeudores.Fecha_Revision.Year < fecha_actual.Year ||
      (ultimaRevisionDeudores.Fecha_Revision.Year == fecha_actual.Year && ultimaRevisionDeudores.Fecha_Revision.Month < fecha_actual.Month))
                {
                    DialogResult resultado = MessageBox.Show("¿Desea generar el proceso para suspender deudores?",
                                                              "Confirmación", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                    if (resultado == DialogResult.Yes)
                    {
                        // Mostrar la barra de progreso
                        progressBar1.Visible = true;
                        this.Cursor = Cursors.WaitCursor;

                        // Ejecutar en otro hilo sin bloquear la interfaz
                        Task.Run(() =>
                        {
                            List<int> suspendidos = clienteNegocio.SuspenderDeudores();

                            // Usamos Invoke para actualizar la UI desde el hilo principal
                            this.Invoke((MethodInvoker)delegate
                            {
                                progressBar1.Visible = false;
                                this.Cursor = Cursors.Default;
                                MessageBox.Show("Se suspendieron a " + suspendidos.Count + " clientes.");
                            });

                            auxiliaresNegocio.GuardarRevisionDeudores(suspendidos);
                        });
                    }
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        private void LlenarCombo()
        {
            cbmServicio.DataSource = servicioNegocio.ObtenerServicios();
            cbmServicio.DisplayMember = "Descripcion";
            cbmServicio.ValueMember = "ServicioId";
        }

        private void CrearColListFecha()
        {
            try
            {
                lvFacturas.Columns.Add("Id Factura", 85, HorizontalAlignment.Left);
                lvFacturas.Columns.Add("Fecha de Emisión", 110, HorizontalAlignment.Center);
                lvFacturas.Columns.Add("Mes", 85, HorizontalAlignment.Right);
                lvFacturas.Columns.Add("Monto", 85, HorizontalAlignment.Right);
                lvFacturas.Columns.Add("Tipo Fact.", 85, HorizontalAlignment.Center);
                lvFacturas.Columns.Add("Pagado", 85, HorizontalAlignment.Center);
                lvFacturas.Columns.Add("Observaciones", 300, HorizontalAlignment.Center);

            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }
        private void LLenarLista(bool _siload)
        {
            try
            {
                lvFacturas.Items.Clear();

                var facturaNegocio = new FacturasVentaNegocio();
                if (!_siload)
                {
                    var nroCliente = txtNroCli.Text;

                    if (nroCliente != "")
                    {
                        listFacturas = facturaNegocio.BuscarFacturasPorClienteId(Convert.ToInt32(nroCliente));
                        if (listFacturas.Count == 0) { return; }
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
                    item.SubItems.Add(factura.FechaEmision.ToShortDateString());
                    item.SubItems.Add(factura.MesAbonado);
                    item.SubItems.Add(factura.Total.ToString("C2"));
                    item.SubItems.Add(factura.TipoFact);
                    item.SubItems.Add(factura.Pagado);
                    item.SubItems.Add(factura.Observaciones);


                    lvFacturas.Items.Add(item);
                }
                dtFecha.Value = listFacturas.Max(factura => factura.FechaEmision);
                lvFacturas.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void btnBuscarCli_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtNroCli.Text != "")
                {
                    NroCliente = Convert.ToInt32(txtNroCli.Text);

                    BuscarCliente(NroCliente);
                }
                else
                {
                    NroCliente = 0;
                    lblCliente.Visible = false;
                    MessageBox.Show("Ingrese Nro. de Cliente para realizar la búsqueda", "Error de Ingreso", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }
            }
            catch (Exception ex)
            {
                string mensajeError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(mensajeError);
            }
        }

        private void BuscarCliente(int nroCliente)
        {
            try
            {

                var clienteCajaDistribucionServicio = clienteNegocio.ObtieneClienteCajaDistribucionServicioIdPorCliente(nroCliente);

                if (clienteCajaDistribucionServicio != null)
                {
                    VistaClientes cli = clienteNegocio.ObtenerVCliporNroCli(clienteCajaDistribucionServicio.ClienteCajaDistribucionServicioId);
                    var aux = new AuxiliaresNegocio();

                    if (cli != null)
                    {
                        //if (cli.FechaBaja == "")
                        //{
                        NroCliente = cli.NroCliente;
                        lblCliente.Text = cli.ApellidoyNombre;
                        lblCliente.Visible = true;
                        txtNroCli.Text = NroCliente.ToString();

                        var servicio = servicioNegocio.ObtenerServicioPorNroPro(clienteCajaDistribucionServicio.ServicioId);

                        cbmServicio.SelectedValue = servicio.ServicioId;
                        cbmServicio.Text = servicio.Descripcion;

                        txtNroCli.Text = cli.NroCliente.ToString();
                        if (cli.Cuit != "")
                        {
                            lblCliente.Text = "CUIT - " + cli.Cuit + " - " + cli.ApellidoyNombre + " (" + cli.Descripcion + ")";
                            cuit = cli.Cuit;
                        }
                        else
                        {
                            lblCliente.Text = cli.TipoDocumento + " - " + cli.Nro_Doc + " - " + cli.ApellidoyNombre + " (" + cli.Descripcion + ")";
                            cuit = cli.Nro_Doc;
                        }

                        LLenarLista(false);

                        //}
                        //else { MessageBox.Show("El Cliente fue dado de baja", "Error de Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation); this.Close(); }
                    }
                }
                else
                {
                    MessageBox.Show("No se encontró el Cliente", "Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    NroCliente = 0;
                    lblCliente.Visible = false;
                }
            }
            catch (Exception ex)
            {
                string mensajeError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(mensajeError);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int idFacturaVenta = 0;

            if (lvFacturas.SelectedItems.Count == 0)
            {
                MessageBox.Show("Debe seleccionar una factura.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            idFacturaVenta = Convert.ToInt32(lvFacturas.SelectedItems[0].SubItems[0].Text);

            string pagado = lvFacturas.SelectedItems[0].SubItems[5].Text;

            if (idFacturaVenta != 0)
            {
                if (pagado == "NO")
                {
                    var frm = new frmFormaPago() { IdFactura = idFacturaVenta };
                    frm.ShowDialog();
                }
                else
                {
                    MessageBox.Show("La factura seleccionada ya se pagó.");
                }
            }
            LLenarLista(false);
        }

        private void btnListadoCli_Click(object sender, EventArgs e)
        {
            try
            {
                var frm = new frmConsultaClientes { Seleccion = true };
                frm.ShowDialog();
                lvFacturas.Items.Clear();
                if (frm.DialogResult != DialogResult.OK || frm.NroCliente <= 0) return;
                BuscarCliente(frm.NroCliente);

            }
            catch (Exception ex)
            {
                string mensajeError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                MessageBox.Show(mensajeError);
            }
        }

        private void btnLimpiar_Click(object sender, EventArgs e)
        {
            NroCliente = 0;
            txtNroCli.Text = "";
            lblCliente.Text = "Nombre del Cliente";
            cbmServicio.SelectedIndex = -1;
            cbmServicio.Text = "";
            dtFecha.Value = DateTime.Now;
            lvFacturas.Items.Clear();
        }

        private void btnConsultarFacturas_Click(object sender, EventArgs e)
        {
            if (NroCliente == 0)
            {
                MessageBox.Show("Debe seleccionar un Cliente.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (ValidaCliente())
            {
                facturasVentaNegocio.GenerarfacturasPorIdCliente(NroCliente);
                LLenarLista(false);
            }
        }

        private bool ValidaCliente()
        {
            var ClienteCajaDistribucionServicio = clienteNegocio.ObtieneClienteCajaDistribucionServicioIdPorCliente(NroCliente);
            var ultimoEstado = ClienteCajaDistribucionServicio.UltimoEstadoId;
            if (ultimoEstado != 1) // Si no está activo
            {
                var respuesta = MessageBox.Show("El cliente fue dado de baja o suspendido. ¿Desea activarlo?",
                                                "Activar Cliente",
                                                MessageBoxButtons.YesNo,
                                                MessageBoxIcon.Question);

                if (respuesta == DialogResult.Yes)
                {
                    var frmc = new frmConsultaClientesCajasDistribucionServiciosEstados() { clienteCajaDistribucionServicioId = ClienteCajaDistribucionServicio.ClienteCajaDistribucionServicioId };
                    frmc.ShowDialog();
                    MessageBox.Show("El cliente ha sido activado correctamente.", "Éxito", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            return true;
        }

        private void txtNroCli_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true; // Evita el sonido de "beep"

                if (!string.IsNullOrWhiteSpace(txtNroCli.Text))
                {
                    if (int.TryParse(txtNroCli.Text, out int nroCliente))
                    {
                        try
                        {
                            NroCliente = nroCliente;
                            BuscarCliente(NroCliente);
                        }
                        catch (Exception ex)
                        {
                            string mensajeError = ex.InnerException != null ? ex.InnerException.Message : ex.Message;
                            MessageBox.Show($"Error al buscar cliente: {mensajeError}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                    else
                    {
                        MessageBox.Show("Ingrese un número de cliente válido.", "Error de Ingreso", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    }
                }
                else
                {
                    NroCliente = 0;
                    lblCliente.Visible = false;
                    MessageBox.Show("Ingrese Nro. de Cliente para realizar la búsqueda", "Error de Ingreso", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }
            }
        }

        private void VerFacturaPdf_Click(object sender, EventArgs e)
        {
            var numeroComprobante = lvFacturas.SelectedItems[0].SubItems[0].Text;

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

        private void lvFacturas_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lvFacturas.SelectedItems.Count > 0)
            {
                VerFacturaPdf.Enabled = true;
                btnRegistrarPago.Enabled = true;
                btnEditarPrecio.Enabled = true;
                btnEditarPrecio.Visible = true;
            }
            else
            {
                VerFacturaPdf.Enabled = false;
                btnEditarPrecio.Enabled = false;
                btnEditarPrecio.Enabled = false;
                btnRegistrarPago.Enabled = false;   
            }
        }

        private void btnEditarPrecio_Click(object sender, EventArgs e)
        {
            if (lvFacturas.SelectedItems.Count > 0) //
            {
                var idFacturaVenta = Convert.ToInt32(lvFacturas.SelectedItems[0].SubItems[0].Text);

                var frmc = new frmEditarFactura() { idfactura = idFacturaVenta };

                frmc.ShowDialog();

                LLenarLista(false);
            }
        }
    }
}
