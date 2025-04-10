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

namespace VideoCableEsc.Forms.Cliente
{
    public partial class frmConsultaFacturasClientes : Form
    {

        public int clienteCajaDistribucionServicioId;
        public decimal totalFacturasImpagas;

        private readonly FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();

        public frmConsultaFacturasClientes()
        {
            InitializeComponent();
        }

        private void frmConsultaFacturasClientes_Load(object sender, EventArgs e)
        {
            try
            {

                CargarGrilla(true);

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void CargarGrilla(bool _siload)
        {
            try
            {
                listFacturasClientes.Items.Clear();

                var listado = facturasVentaNegocio.BuscarFacturasPorClienteCajaDistribucionServicioId(clienteCajaDistribucionServicioId);

                totalFacturasImpagas = listado
                    .Where(x => x.Pagado != null && x.Pagado.Value == false)
                    .Sum(x => x.Total);

                if (listado == null) { return; }

                foreach (var cli in listado)
                {
                    var item = new ListViewItem(cli.IdFacturaVenta.ToString());

                    item.SubItems.Add(cli.NCompFact);
                    item.SubItems.Add(cli.FechaAlta.ToShortDateString());
                    item.SubItems.Add(cli.Total.ToString("C2"));
                    item.SubItems.Add(cli.Pagado != null ? (cli.Pagado.Value ? "PAGADA" : "IMPAGA") :"IMPAGA");

                    listFacturasClientes.Items.Add(item);

                }

                txtTotalDeuda.Text = totalFacturasImpagas.ToString("C2");

                listFacturasClientes.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
