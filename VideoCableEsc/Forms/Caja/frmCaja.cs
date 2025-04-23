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
            DateTime desde = dtpDesde.Value;
            DateTime hasta = dtpHasta.Value;

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
                List<VistaCabFactVenta> facturasVentas = facturasVentaN.BuscarFacturasFechaDesdeFechaHasta(desde, hasta);
                foreach (var caja in cajasDiarias)
                {
                    List<CajasEgresos> cajasEgresos = cajaNegocio.ObtenerCajaEgresoPorIdCaja(caja.IdCajaDiaria);

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
            var frmc = new frmCierreCaja();

            frmc.ShowDialog();

            LLenarListaFecha(true);
        }
    }
}
