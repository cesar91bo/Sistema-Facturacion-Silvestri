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
using VideoCableEsc.Formularios;

namespace VideoCableEsc.Forms.Facturacion
{
    public partial class frmFactura : Form
    {
        private Int32 idcli, NroVendedor, NroVendedorExt;
        private decimal SaldoCtaCte;
        public string Accion;
        private string cuit;
        public Int32 IdFact;
        private List<long> lint;
        public Int16 IdTipoDoc;
        private bool siload;
        public List<Int32> lrem, ListPre;

        private readonly ClienteCajaDistribucionServicioNegocio clienteCajaDistribucionServicioNegocio = new ClienteCajaDistribucionServicioNegocio();

        public frmFactura()
        {
            InitializeComponent();
        }

        private void btnBuscarCli_Click(object sender, EventArgs e)
        {
            try
            {
                if (FuncionesForms.SiesInt32(txtNroCli.Text)) BuscarCli(Convert.ToInt32(txtNroCli.Text));
                else
                {
                    MessageBox.Show("Ingrese Nro. Cliente correcto para realizar la búsqueda", "Error de Ingreso", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    Activar(false);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void Activar(bool cond)
        {
            groupBox3.Enabled = cond;
            groupBox4.Enabled = cond;
            txtObservaciones.Enabled = cond;
            cmbConcepto.Enabled = cond;
            cmbFPago.Enabled = cond;
            cmbCondPago.Enabled = cond;
            dtpFecha.Enabled = cond;
        }

        private void BuscarCli(int IdCliente)
        {
            ClienteNegocio clienteNegocio = new ClienteNegocio();
            try
            {
                VistaClientes cli = clienteNegocio.ObtenerVCliporNroCli(IdCliente);
                if (cli != null)
                {
                    Activar(true);
                    if (cli.FechaBaja == "")
                    {
                        idcli = IdCliente;
                        btnGuardar.Enabled = true;
                        var ccNegocio = new CuentasCorrientesNegocio();
                        VistaCtaCteClientes vcc = ccNegocio.ObtenerVistaCtaCtexIdCliente(idcli, 1);
                        if (vcc != null) SaldoCtaCte = Convert.ToDecimal(vcc.Saldo);
                        ControlarObsCliente(true);
                        //List<VistaFacturasSinSaldar> Lista = repv.ObtenerListFacturasVencidas30DiasxNroCli(SeteosStatic.IdEmpresa, idcli);
                        if (cli.NroCliente == 1)
                        {
                            cmbFPago.SelectedValue = 1;
                            cmbCondPago.Enabled = false;
                        }
                        else
                        {
                            cmbFPago.SelectedValue = 2;
                            cmbCondPago.SelectedValue = 1;
                        }
                        var Lista = new List<Clientes>();
                        if (Lista.Count > 0 && Accion.ToUpper() == "ALTA" && idcli > 1)
                        {
                            if (MessageBox.Show("El Cliente posee facturas impagas de más de 30 días, ¿Desea facturar igual?", "AVISO IMPORTANTE", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                            {
                                dgrDetalle.Enabled = true;
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
                                bool tipoA = false;
                                if (cli.Descripcion.ToUpper() != "RESPONSABLE INSCRIPTO") { cmbTipoFact.SelectedValue = "2"; } //tipo B
                                else
                                {
                                    cmbTipoFact.SelectedValue = "1";
                                    tipoA = true;
                                }
                                CambiarTipoFact();
                                if (dgrDetalle.Rows.Count > 1)
                                {
                                    CambiarPrecios(true);
                                    CalcularTotales(tipoA);
                                }
                            }
                            else
                            {
                                idcli = 0;
                                txtNroCli.Text = "0";
                                lblCliente.Text = "";
                            }
                        }
                        else
                        {
                            dgrDetalle.Enabled = true;
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
                            bool tipoA = false;
                            if (cli.Descripcion.ToUpper() != "RESPONSABLE INSCRIPTO") { cmbTipoFact.SelectedValue = "2"; } //tipo B
                            else
                            {
                                cmbTipoFact.SelectedValue = "1";
                                tipoA = true;
                            }
                            CambiarTipoFact();
                            if (dgrDetalle.Rows.Count > 1)
                            {
                                CambiarPrecios(true);
                                CalcularTotales(tipoA);
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("El cliente fue dado de baja", "Error de Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        Activar(false);
                    }
                }
                else
                {
                    MessageBox.Show("No se encontró el Cliente", "Error de Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    Activar(false);
                }
            }
            catch (Exception ex) { throw ex; }
        }

        private void CalcularTotales(bool CalcSubT)
        {
            try
            {
                if (CalcSubT)
                {
                    lblSubTotal.Text = "0"; //en cero los subtotales
                    lblSubTotal105.Text = "0";
                    lblSubTotal21.Text = "0";
                    lblSubTotal0.Text = "0";
                    foreach (DataGridViewRow rw in dgrDetalle.Rows)
                    {
                        decimal subt = rw.Cells[10].Value == null ? 0 : Convert.ToDecimal(rw.Cells[10].Value);
                        if (cmbTipoFact.Text == "A") //Si es "A" se calculan los subtotales correspondientes al IVA del artículo y se suman
                        {
                            if (Convert.ToDecimal(rw.Cells[8].Value) == 21) //IVA 21%
                            {
                                lblSubTotal21.Text = Math.Round(Convert.ToDecimal(lblSubTotal21.Text) + subt, 2, MidpointRounding.AwayFromZero).ToString();
                            }
                            else if (Convert.ToDecimal(rw.Cells[8].Value) == 10.5M) //IVA 10,5%
                            {
                                lblSubTotal105.Text = Math.Round(Convert.ToDecimal(lblSubTotal105.Text) + subt, 2, MidpointRounding.AwayFromZero).ToString();
                            }
                            else //IVA 0%
                            {
                                lblSubTotal0.Text = Math.Round(Convert.ToDecimal(lblSubTotal0.Text) + subt, 2, MidpointRounding.AwayFromZero).ToString();
                            }
                            lblSubTotal.Text = Math.Round(Convert.ToDecimal(lblSubTotal0.Text) + Convert.ToDecimal(lblSubTotal21.Text) + Convert.ToDecimal(lblSubTotal105.Text), 2,
                                MidpointRounding.AwayFromZero).ToString();
                        }
                        else //Si es B solo subtotal sin IVA
                        {
                            if (Convert.ToDecimal(rw.Cells[8].Value) == 21) //IVA 21%
                            {
                                lblSubTotal21.Text = Math.Round((Convert.ToDecimal(lblSubTotal21.Text) + subt), 2, MidpointRounding.AwayFromZero).ToString();
                            }
                            else if (Convert.ToDecimal(rw.Cells[8].Value) == 10.5M) //IVA 10,5%
                            {
                                lblSubTotal105.Text = Math.Round((Convert.ToDecimal(lblSubTotal105.Text) + subt), 2, MidpointRounding.AwayFromZero).ToString();
                            }
                            else //IVA 0%
                            {
                                lblSubTotal0.Text = Math.Round(Convert.ToDecimal(lblSubTotal0.Text) + subt, 2, MidpointRounding.AwayFromZero).ToString();
                            }
                            lblSubTotal.Text = Math.Round(Convert.ToDecimal(lblSubTotal.Text) + subt, 2, MidpointRounding.AwayFromZero).ToString();
                        }
                    }
                }

                if (cmbTipoFact.Text == "A")
                {
                    lblTotalDto.Text = (Math.Round(Convert.ToDecimal(lblSubTotal0.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100), 2, MidpointRounding.AwayFromZero) +
                                        Math.Round(Convert.ToDecimal(lblSubTotal105.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100), 2, MidpointRounding.AwayFromZero) +
                                        Math.Round(Convert.ToDecimal(lblSubTotal21.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100), 2, MidpointRounding.AwayFromZero)).ToString();
                    //Esta porción de código es para que cuando el cálculo de abajo de -0.01 se sume 0.01 al campo de TotalDescuento.
                    //De esta forma se evita el error a la hora de actualizar algunas facturas que usan descuento.
                    if (Convert.ToDecimal(lblSubTotal.Text.Replace(".", ",")) -
                        Convert.ToDecimal(lblTotalDto.Text.Replace(".", ",")) -
                        Convert.ToDecimal(lblSubtDto21.Text.Replace(".", ",")) -
                        Convert.ToDecimal(lblSubtDto105.Text.Replace(".", ",")) == Convert.ToDecimal(-0.01))
                    {
                        lblTotalDto.Text = Convert.ToString(Convert.ToDecimal(lblTotalDto.Text.Replace(".", ",")) - Convert.ToDecimal(0.01), CultureInfo.InvariantCulture);
                    }
                    //Fin de la porción de código de validación del campo TotalDescuento.
                    lblSubtDto0.Text = Math.Round(Convert.ToDecimal(lblSubTotal0.Text) - (Convert.ToDecimal(lblSubTotal0.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblSubtDto105.Text = Math.Round(Convert.ToDecimal(lblSubTotal105.Text) - (Convert.ToDecimal(lblSubTotal105.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblSubtDto21.Text = Math.Round(Convert.ToDecimal(lblSubTotal21.Text) - (Convert.ToDecimal(lblSubTotal21.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblSubtDto.Text = Math.Round(Convert.ToDecimal(lblSubtDto0.Text) + Convert.ToDecimal(lblSubtDto105.Text) + Convert.ToDecimal(lblSubtDto21.Text), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblTotalIva105.Text = Math.Round(Convert.ToDecimal(lblSubtDto105.Text) * Convert.ToDecimal(0.105), 2, MidpointRounding.AwayFromZero).ToString();
                    lblTotalIva21.Text = Math.Round(Convert.ToDecimal(lblSubtDto21.Text) * Convert.ToDecimal(0.21), 2, MidpointRounding.AwayFromZero).ToString();
                    lblTotalIva0.Text = "0";
                    lblTotalIVA.Text = Math.Round(Convert.ToDecimal(lblTotalIva105.Text) + Convert.ToDecimal(lblTotalIva21.Text), 2, MidpointRounding.AwayFromZero).ToString();
                    lblTotal.Text = Math.Round(Convert.ToDecimal(lblSubtDto.Text) + Convert.ToDecimal(lblTotalIva105.Text) + Convert.ToDecimal(lblTotalIva21.Text), 2,
                        MidpointRounding.AwayFromZero).ToString();
                }
                else
                {
                    lblTotalDto.Text = Math.Round(Convert.ToDecimal(lblSubTotal.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100), 2, MidpointRounding.AwayFromZero).ToString();
                    //Esta porción de código es para que cuando el cálculo de abajo de -0.01 se sume 0.01 al campo de TotalDescuento.
                    //De esta forma se evita el error a la hora de actualizar algunas facturas que usan descuento.
                    if (Convert.ToDecimal(lblSubTotal.Text.Replace(".", ",")) -
                        Convert.ToDecimal(lblTotalDto.Text.Replace(".", ",")) -
                        Convert.ToDecimal(lblSubtDto21.Text.Replace(".", ",")) -
                        Convert.ToDecimal(lblSubtDto105.Text.Replace(".", ",")) == Convert.ToDecimal(-0.01))
                    {
                        lblTotalDto.Text = Convert.ToString(Convert.ToDecimal(lblTotalDto.Text.Replace(".", ",")) - Convert.ToDecimal(0.01), CultureInfo.InvariantCulture);
                    }
                    //Fin de la porción de código de validación del campo TotalDescuento.
                    lblSubtDto.Text = Math.Round(Convert.ToDecimal(lblSubTotal.Text) - Convert.ToDecimal(lblTotalDto.Text), 2, MidpointRounding.AwayFromZero).ToString();
                    lblTotal.Text = Convert.ToString(Math.Round(Decimal.Parse(lblSubTotal.Text) - (Decimal.Parse(lblSubTotal.Text) * (Decimal.Parse(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero));
                    lblSubtDto0.Text = Math.Round(Convert.ToDecimal(lblSubTotal0.Text) - (Convert.ToDecimal(lblSubTotal0.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblSubtDto105.Text = Math.Round(Convert.ToDecimal(lblSubTotal105.Text) - (Convert.ToDecimal(lblSubTotal105.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblSubtDto21.Text = Math.Round(Convert.ToDecimal(lblSubTotal21.Text) - (Convert.ToDecimal(lblSubTotal21.Text) * (Convert.ToDecimal(txtDto.Text.Replace(".", ",")) / 100)), 2,
                        MidpointRounding.AwayFromZero).ToString();
                    lblSubtDto.Text = Math.Round(Convert.ToDecimal(lblSubtDto0.Text) + Convert.ToDecimal(lblSubtDto105.Text) + Convert.ToDecimal(lblSubtDto21.Text), 2,
                        MidpointRounding.AwayFromZero).ToString();

                }

                ControlarObsCliente(false);
            }
            catch (Exception ex) { throw ex; }
        }

        private void CambiarPrecios(bool v)
        {
            //try
            //{
            //    foreach (DataGridViewRow rw in dgrDetalle.Rows)
            //    {
            //        if (!rw.IsNewRow && rw.Cells["NroArt"].Value != null)
            //        {
            //            var cmb = rw.Cells["Precio"] as DataGridViewComboBoxCell;
            //            var rep = new RepositorioArticulos();
            //            byte fPago = Convert.ToByte(cmbFPago.SelectedValue);
            //            if (CambioCli)
            //            {
            //                DataTable dt = SeteosStatic.Usar4DigitosPrecios ? rep.CargarComboPrecios4digitos(Convert.ToInt64(rw.Cells["NroArt"].Value), cmbTipoFact.Text)
            //                    : rep.CargarComboPrecios2digitos(Convert.ToInt64(rw.Cells["NroArt"].Value), cmbTipoFact.Text);
            //                cmb.DataSource = dt;
            //                cmb.Value = fPago == 1 | chkSelContado.Checked ? dt.Rows[0]["Precio"] : dt.Rows[1]["Precio"];
            //            }
            //            else
            //            {
            //                PreciosVenta pv = rep.ObtenerUltPrecioVenta(Convert.ToInt64(rw.Cells["NroArt"].Value));
            //                if (SeteosStatic.Usar4DigitosPrecios) { cmb.Value = cmbTipoFact.Text == "A" ? pv.PrecioContado : pv.PrecioContadoIva; }
            //                cmb.Value = cmbTipoFact.Text == "A" ? Math.Round(pv.PrecioContado, 2, MidpointRounding.AwayFromZero) : Math.Round(pv.PrecioContadoIva, 2, MidpointRounding.AwayFromZero);
            //            }
            //        }
            //    }
            //}
            //catch (Exception ex) { throw ex; }
        }

        private void btnListadoCli_Click(object sender, EventArgs e)
        {
            try
            {
                var frm = new frmConsultaClientes { Seleccion = true, Text = "Búsqueda Clientes" };
                frm.ShowDialog();
                if (frm.DialogResult != DialogResult.OK || frm.NroCliente <= 0) return;
                BuscarCli(frm.NroCliente);
            }
            catch (Exception ex) {MessageBox.Show(ex.Message); }
        }

        private void cmbCondPago_SelectedValueChanged(object sender, EventArgs e)
        {
            try
            {
                if (cmbCondPago.SelectedValue != null)
                {
                    if (FuncionesForms.SiesInt32(cmbCondPago.SelectedValue.ToString())) { dtpFechaVto.Value = dtpFecha.Value.AddDays(Convert.ToDouble(cmbCondPago.Text.Substring(0, 3).TrimEnd())); }
                }
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void frmFactura_Load(object sender, EventArgs e)
        {
            try
            {
                SaldoCtaCte = 0;
                LlenarCombos();

                if (Accion.ToUpper() == "MOD")
                {
                    if (IdFact > 0) ConsultarFact(IdFact);
                    if (Accion.ToUpper() == "MOD") lint = new List<Int64>();
                }

                
                if (IdTipoDoc == 8) //Remito X
                {
                    lblTipoDoc.Text = "Tipo/Nro. Remito X:";
                    txtBV.Text = "0001";
                    if (Accion.ToUpper() == "ALTA") cmbFPago.SelectedValue = 2;
                    cmbCondPago.SelectedValue = 1;
                    cmbCondPago.Enabled = true;
                    cmbFPago.Enabled = true;
                    //obtener último nro.remito X
                    if (Accion.ToUpper() == "ALTA")
                    {
                        var ventaNegocio = new VentaNegocio();
                        string UltimoComp = ventaNegocio.ObtenerUltimoNroCompRemitoX(1).PadLeft(8, '0');
                        txtBV.Text = UltimoComp.Substring(0, 4);
                        txtNroComp.Text = UltimoComp.Substring(5, 8);
                    }
                }
                if (IdTipoDoc == 3)
                {
                    lblTipoDoc.Text = "Tipo/Nro. N.Débito:";

                }
                siload = false;

            }
            catch (Exception ex) { throw ex; }
        }

        private void LlenarCombos()
        {
            var auxiliaresNegocio = new AuxiliaresNegocio();
            cmbConcepto.DataSource = auxiliaresNegocio.DtTiposConceptosFactura();
            cmbConcepto.DisplayMember = "Descripcion";
            cmbConcepto.ValueMember = "IdConceptoFactura";
            cmbConcepto.SelectedIndex = 1;
            cmbFPago.DataSource = auxiliaresNegocio.DtFormasPago();
            cmbFPago.DisplayMember = "Descripcion";
            cmbFPago.ValueMember = "IdFormaPago";
            cmbFPago.SelectedValue = 1;
            cmbFPago.Enabled = true;
            cmbCondPago.DisplayMember = "Descripcion";
            cmbCondPago.ValueMember = "IdCondicionPago";
            cmbCondPago.DataSource = auxiliaresNegocio.DtCondPago();
            cmbCondPago.SelectedValue = 1;
            cmbCondPago.Enabled = true;
            cmbTipoFact.DataSource = auxiliaresNegocio.DtTiposFact();
            cmbTipoFact.DisplayMember = "Descripcion";
            cmbTipoFact.ValueMember = "IdTipoFactura";
            cmbTipoFact.SelectedIndex = 1;
            //cmbCondPago.Enabled = false;
        }

        private void ConsultarFact(Int32 Id)
        {
            try
            {
                var ventaNegocio = new VentaNegocio();
                FacturasVenta fv = ventaNegocio.ObtenerFactura(Id);
                int f = 0;

                txtNroCli.Text = fv.ClienteCajaDistribucionServicioId.ToString();

                var cliente = clienteCajaDistribucionServicioNegocio.GetById(fv.ClienteCajaDistribucionServicioId);

                BuscarCli(cliente.ClienteId);

                cmbFPago.SelectedValue = fv.IdFormaPago;
                if (cmbFPago.SelectedValue.ToString() == "2")
                {
                    cmbCondPago.Visible = true;
                    LlenarComboCond();
                    cmbCondPago.SelectedValue = fv.IdCondicionPago;
                }
                if (!string.IsNullOrEmpty(fv.BVFact) && IdTipoDoc != 8) { txtBV.Text = fv.BVFact; }

                if (IdTipoDoc == 8)
                {
                    txtNroComp.Text = fv.NCompFact;
                }
                FacturasVenta fact = ventaNegocio.ObtenerFactura(lrem[0]);//agregado
                txtObservaciones.Text = fact.Observaciones;
                foreach (Int32 r in lrem)
                {
                    List<VistaDetalleFactVenta> detrem = ventaNegocio.ObtenerVistaDetalledeFacturaVta(r);
                    FacturasVenta rem = ventaNegocio.ObtenerFactura(r);
                    txtDto.Text = rem.Descuento.ToString();
                    dgrDetalle.Rows.Add(detrem.Count);
                    


                        if (fv.Impresa)
                        {
                            lblImpresa.Text = "La factura ya fue impresa";
                            txtNroComp.Text = fv.NCompFact;
                            txtBV.Text = fv.BVFact;
                            txtNroComp.Visible = true;
                            txtBV.Visible = true;
                        }
                        else if (IdTipoDoc != 8) lblImpresa.Text = "La factura está pendiente de impresión";

                    if (cmbTipoFact.Text == "B")
                    {
                        lbllblIVA21.Visible = false;
                        lbllblSubtDto.Visible = false;
                        lbllblSubTotaldto105.Visible = false;
                        lbllblSubTotaldto21.Visible = false;
                        lbllblSubTotal21.Visible = false;
                        lbllblSubTotal105.Visible = false;
                        lbllblIVA105.Visible = false;
                        lbllblIVA.Visible = false;
                        lblSubtDto105.Visible = false;
                        lblSubtDto21.Visible = false;
                        lblSubTotal105.Visible = false;
                        lblSubTotal21.Visible = false;
                        lblSubtDto.Visible = false;
                        lblTotalIva21.Visible = false;
                        lblTotalIVA.Visible = false;
                        lblTotalIva105.Visible = false;
                    }
                    else
                    {
                        lblSubtDto.Text = Math.Round(Convert.ToDecimal(lblSubtDto105.Text) + Convert.ToDecimal(lblSubtDto21.Text), 2, MidpointRounding.AwayFromZero).ToString();
                        lblTotalIVA.Text = Math.Round(Convert.ToDecimal(lblTotalIva21.Text) + Convert.ToDecimal(lblTotalIva105.Text), 2, MidpointRounding.AwayFromZero).ToString();
                    }
                    if (Accion.ToUpper() == "VER") btnGuardar.Visible = false;

                    List<FacturasVentaDetalle> det = ventaNegocio.ObtenerDetalledeFacturaVta(Id);
                    int i = 0;
                    foreach (FacturasVentaDetalle fvd in det)
                    {

                        var cmb = dgrDetalle["Precio", i] as DataGridViewComboBoxCell;
                        var dt = new DataTable();
                        if (fvd.IdServicio != null)
                        {
                    //        var repa = new RepositorioArticulos();
                    //        VistaArticulos art = repa.ObtenerVArtporId(Convert.ToInt64(fvd.IdArticulo));
                    //        dgrDetalle.Rows[i].Cells[3].Value = art.CodigoBarra;
                    //        dgrDetalle.Rows[i].Cells[4].Value = art.IdArticulo.ToString();
                    //        dgrDetalle.Rows[i].Cells[5].Value = art.DescCorta;
                    //        dgrDetalle.Rows[i].Cells[7].Value = art.UnidadMedida;

                    //        dt = SeteosStatic.Usar4DigitosPrecios ? repa.CargarComboPrecios4digitos(art.IdArticulo, cmbTipoFact.Text) : repa.CargarComboPrecios2digitos(art.IdArticulo, cmbTipoFact.Text);

                    //        cmb.DataSource = dt;
                    //        cmb.DisplayMember = "Desc";
                    //        cmb.ValueMember = "Precio";
                    //        dgrDetalle.Rows[i].Cells[12].Value = false;

                    //        if (Convert.ToBoolean(fvd.PrecioManual))
                    //        {
                    //            var rw = dt.NewRow();
                    //            rw[0] = "Manual: $" + fvd.PrecioUnitario.ToString(CultureInfo.InvariantCulture).Replace(".", ",");
                    //            rw[1] = fvd.PrecioUnitario.ToString(CultureInfo.InvariantCulture).Replace(".", ",");
                    //            dt.Rows.Add(rw);
                    //            cmb.DataSource = dt;
                    //            cmb.DisplayMember = "Desc";
                    //            cmb.ValueMember = "Precio";
                    //        }

                    //        cmb.Value = fvd.PrecioManual == false ? dt.Rows[0]["Precio"] : dt.Rows[2]["Precio"];
                       }
                    //    else
                    //    {
                    //        dgrDetalle.Rows[i].Cells[5].Value = fvd.Articulo;
                    //        dgrDetalle.Rows[i].Cells[7].Value = fvd.UMedida;
                    //        dt.Columns.Add("Desc");
                    //        dt.Columns.Add("Precio");
                    //        DataRow rw = dt.NewRow();
                    //        rw[0] = "$ " + fvd.PrecioUnitario;
                    //        rw[1] = fvd.PrecioUnitario;
                    //        dt.Rows.Add(rw);
                    //        cmb.DataSource = dt;
                    //        cmb.DisplayMember = "Desc";
                    //        cmb.ValueMember = "Precio";
                    //        cmb.Value = dt.Rows[0]["Precio"];
                    //        dgrDetalle.Rows[i].Cells[12].Value = true;
                    //        artdesc = true;
                    //    }

                    //    dgrDetalle.Rows[i].Cells[6].Value = fvd.Cantidad;
                    //    dgrDetalle["Total", i].Value = Math.Round(fvd.Cantidad * Convert.ToDecimal(cmb.Value), 2, MidpointRounding.AwayFromZero);
                    //    var repax = new RepositorioAuxiliares();
                    //    TiposIva ti = repax.ObtenerTipoIVAporId(fvd.IdTipoIva);
                    //    dgrDetalle.Rows[i].Cells[8].Value = ti.PorcentajeIVA;
                    //    dgrDetalle.Rows[i].Cells[11].Value = false;
                    //    dgrDetalle.Rows[i].Cells["IdFactVtaDetalle"].Value = fvd.IdFacturaVentaDetalle;
                    //    i += 1;
                    //    artdesc = false;
                    //}
                    //if (NroVendedor != 0)
                    //{
                    //    Vendedores vendedor = repve.ObtenerVenPorNroVen(NroVendedor);
                    //    decimal totalComision = Convert.ToDecimal(lblTotal.Text.Replace(".", ",")) * (vendedor.PorcComision / 100);
                    //    txtMontoComision.Text = Math.Round(totalComision, 2, MidpointRounding.AwayFromZero).ToString();
                    //}
                    //if (NroVendedorExt != 0)
                    //{
                    //    Vendedores vendedor = repve.ObtenerVenPorNroVen(NroVendedorExt);
                    //    decimal totalComision = Convert.ToDecimal(lblTotal.Text.Replace(".", ",")) * (vendedor.PorcComision / 100);
                    //    txtMontoComisionExt.Text = Math.Round(totalComision, 2, MidpointRounding.AwayFromZero).ToString();
                    }
                    //IdTipoDoc = fv.IdTipoDocumento;
                    //if (IdTipoDoc == 8) btnImprimir.Visible = true;
                    //CalcularTotales(true);
                }
            }
            catch (Exception ex) { throw ex; }
        }

        private void LlenarComboCond()
        {
            try
            {
                var auxiliares = new AuxiliaresNegocio();
                cmbCondPago.DisplayMember = "Descripcion";
                cmbCondPago.ValueMember = "IdCondicionPago";
                cmbCondPago.DataSource = auxiliares.DtCondPago();
                cmbCondPago.Enabled = true;
            }
            catch (Exception ex) { throw ex; }
        }

        private void CambiarTipoFact()
        {
            try
            {
                lbllblIVA21.Visible = cmbTipoFact.Text == "A";
                lbllblSubtDto.Visible = cmbTipoFact.Text == "A";
                lbllblSubTotaldto105.Visible = cmbTipoFact.Text == "A";
                lbllblSubTotaldto21.Visible = cmbTipoFact.Text == "A";
                lbllblSubTotal21.Visible = cmbTipoFact.Text == "A";
                lbllblSubTotal105.Visible = cmbTipoFact.Text == "A";
                lbllblIVA105.Visible = cmbTipoFact.Text == "A";
                lbllblIVA.Visible = cmbTipoFact.Text == "A";
                lblSubtDto105.Visible = cmbTipoFact.Text == "A";
                lblSubtDto21.Visible = cmbTipoFact.Text == "A";
                lblSubTotal105.Visible = cmbTipoFact.Text == "A";
                lblSubTotal21.Visible = cmbTipoFact.Text == "A";
                lblSubtDto.Visible = cmbTipoFact.Text == "A";
                lblTotalIva21.Visible = cmbTipoFact.Text == "A";
                lblTotalIVA.Visible = cmbTipoFact.Text == "A";
                lblTotalIva105.Visible = cmbTipoFact.Text == "A";
                lbllblIVA0.Visible = cmbTipoFact.Text == "A";
                lbllblSubTotal0.Visible = cmbTipoFact.Text == "A";
                lbllblSubTotaldto0.Visible = cmbTipoFact.Text == "A";
                lblSubtDto0.Visible = cmbTipoFact.Text == "A";
                lblSubTotal0.Visible = cmbTipoFact.Text == "A";
                lblTotalIva0.Visible = cmbTipoFact.Text == "A";
            }
            catch (Exception ex) { throw ex; }
        }

        private void ControlarObsCliente(bool siload)
        {
            try
            {
                if (idcli <= 1) return;
                ClienteNegocio clienteNegocio = new ClienteNegocio();
                Clientes cli = clienteNegocio.ObtenerCliporNroCli(idcli);

                if (cli.IdObservación == 2 && siload) MessageBox.Show(cli.MensajeCuenta, "MENSAJE CUENTA", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                else
                    switch (cli.IdObservación)
                    {
                        case 4:
                            MessageBox.Show(cli.CuentaCerrada, "CUENTA CERRADA", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            txtNroCli.Text = "";
                            idcli = 0;
                            lblCliente.Text = "";
                            Activar(false);
                            break;
                        case 3:
                            if ((Convert.ToDecimal(lblTotal.Text.Replace(".", ",")) + SaldoCtaCte) > cli.SaldoExcedido)
                            {
                                MessageBox.Show("Se excedió el Saldo establecido para éste Cliente", "SALDO EXCEDIDO", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                                btnGuardar.Enabled = false;
                            }
                            else btnGuardar.Enabled = true;
                            break;
                    }
            }

            catch (Exception ex) { throw ex; }
        }
    }
}
