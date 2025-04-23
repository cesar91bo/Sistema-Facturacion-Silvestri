using CapaEntidades;
using CapaNegocio;
using SistGestionEsc;
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
    public partial class frmCaja : Form
    {
        List<CajasDiarias> cajasDiarias = new List<CajasDiarias>();
        CajaNegocio cajaNegocio = new CajaNegocio();
        public bool load;
        private FacturasVentaNegocio facturasVentaN = new FacturasVentaNegocio();
        public frmCaja()
        {
            InitializeComponent();
        }

        private void frmCaja_Load(object sender, EventArgs e)
        {
            CrearColList();
            LLenarListaFecha(load);
        }

        private void CrearColList()
        {
            listCaja.Columns.Add("Id Caja", 70, HorizontalAlignment.Left);
            listCaja.Columns.Add("Fecha Apertura", 120, HorizontalAlignment.Left);
            listCaja.Columns.Add("Fecha Cierre", 120, HorizontalAlignment.Left);
            listCaja.Columns.Add("Monto Inicial", 120, HorizontalAlignment.Left);
            listCaja.Columns.Add("Monto Final", 120, HorizontalAlignment.Left);
            listCaja.Columns.Add("Total Ventas", 120, HorizontalAlignment.Left);
            listCaja.Columns.Add("Total Egresos", 120, HorizontalAlignment.Left);   
            listCaja.Columns.Add("Observaciones", 340, HorizontalAlignment.Left);
        }

        private void LLenarListaFecha(bool load)
        {
            listCaja.Items.Clear();
            DateTime desde = dtpDesde.Value.Date;
            DateTime hasta = dtpHasta.Value.Date;

            if (load)
            {
                cajasDiarias = cajaNegocio.ObtenerCajas();
            }
            else
            {
                cajasDiarias = cajaNegocio.ObtenerCajaPorFecha(desde, hasta);
            }

            if (cajasDiarias.Count > 0) 
            {
                
                foreach (var caja in cajasDiarias)
                {
                    List<CajasEgresos> cajasEgresos = cajaNegocio.ObtenerCajaEgresoPorIdCaja(caja.IdCajaDiaria);

                    List<VistaCabFactVenta> facturasVentas = facturasVentaN.BuscarFacturasFechaDesdeFechaHasta(caja.FechaApertura.Date, caja.FechaApertura.Date);

                    ListViewItem item = new ListViewItem(caja.IdCajaDiaria.ToString());
                    item.SubItems.Add(caja.FechaApertura.ToString("dd/MM/yyyy HH:mm") ?? "");
                    item.SubItems.Add(caja.FechaCierre?.ToString("dd/MM/yyyy HH:mm") ?? "");
                    item.SubItems.Add((caja.MontoInicial).ToString("N2"));
                    item.SubItems.Add((caja.MontoFinal ?? 0.00m).ToString("N2"));
                    item.SubItems.Add(facturasVentas.Sum(f => f.Total).ToString("N2"));
                    item.SubItems.Add(cajasEgresos.Sum(c => c.Monto).ToString("N2"));         
                    item.SubItems.Add(caja.Observaciones ?? "");

                    listCaja.Items.Add(item);
                }
            }

        }

        private void checkHabilitar_CheckedChanged(object sender, EventArgs e)
        {
            if (checkHabilitar.Checked)
            {
                dtpDesde.Enabled = true;
                dtpHasta.Enabled = true;
                btnBuscar.Enabled = true;
            }
            else { 
                dtpDesde.Enabled= false;
                dtpHasta.Enabled= false;
                btnBuscar.Enabled= false;
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            LLenarListaFecha(false);
        }

        private void btnAbrirCaja_Click(object sender, EventArgs e)
        {
            CajasDiarias caja = cajaNegocio.ObtenerCajaActual();
            if (caja != null && caja.FechaCierre == null)
            {
                MessageBox.Show("Ya existe una caja abierta para el día de hoy.");
                return;
            }
            var frmc = new frmAperturaCaja();

            frmc.ShowDialog();

            LLenarListaFecha(true);
        }

        private void btnEgreso_Click(object sender, EventArgs e)
        {
            CajasDiarias cajaDiaria = cajaNegocio.ObtenerCajaActual();
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

            var frmEgreso = new frmRegistroEgreso();
            frmEgreso.ShowDialog();

            LLenarListaFecha(true);
        }

        private void btnCerrarCaja_Click(object sender, EventArgs e)
        {
            CajasDiarias cajaDiaria = cajaNegocio.ObtenerUltimaCaja();

            if (cajaDiaria == null)
            {
                MessageBox.Show("No se puede cerrar la caja. No hay una caja abierta.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (cajaDiaria.FechaCierre != null)
            {
                MessageBox.Show("La caja ya fue cerrada.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            var frmCierra = new frmCierreCaja();
            frmCierra.ShowDialog();

            LLenarListaFecha(true);
        }
    }
}
