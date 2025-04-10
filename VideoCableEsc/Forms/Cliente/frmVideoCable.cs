using CapaEntidades;
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
using VideoCableEsc.Forms.ClienteCajaDistribucionServicioEstado;

namespace VideoCableEsc.Forms.Cliente
{
    public partial class frmVideoCable : Form
    {
        public bool Seleccion;
        List<VistaClientes> clis;
        public Int32 NroCliente;
        public frmVideoCable()
        {
            InitializeComponent();
        }

        private void frmVideoCable_Load(object sender, EventArgs e)
        {
            try
            {
                var dt = new DataTable();
                dt.Columns.Add("IdBusqueda");
                dt.Columns.Add("Descripcion");
                dt.Rows.Add("NroDoc", "N° Documento");
                dt.Rows.Add("Cliente", "Cliente");
                dt.Rows.Add("NroCliente", "N° Cliente");

                var estadoNegocio = new EstadoNegocio();
                cmbEstados.DataSource = estadoNegocio.GetAll();
                cmbEstados.DisplayMember = "Descripcion";
                cmbEstados.ValueMember = "EstadoId";


                CrearColListCliente();
                LLenarListaCliente(true);
                CalculaTotalCliente();

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void CalculaTotalCliente()
        {
            var cliNegocio = new ClienteNegocio();
            txtTotalActivo.Text = cliNegocio.CalculaTotalVideo().ToString();
        }

        private void CrearColListCliente()
        {
            try
            {
                listCliente.Columns.Add("Nro Cliente", 70, HorizontalAlignment.Left);
                listCliente.Columns.Add("Cliente", 200, HorizontalAlignment.Left);
                listCliente.Columns.Add("Tipo Doc.", 80, HorizontalAlignment.Left);
                listCliente.Columns.Add("DNI", 85, HorizontalAlignment.Left);
                listCliente.Columns.Add("Dirección", 200, HorizontalAlignment.Left);
                listCliente.Columns.Add("Teléfono", 90, HorizontalAlignment.Left);
                listCliente.Columns.Add("Ubicacion Caja").Width = 0;
                listCliente.Columns.Add("ClienteCajaDistribucionServicioId Caja").Width = 0;
                //listCliente.Columns.Add("Caja De Distribución", 200, HorizontalAlignment.Left);
                //listCliente.Columns.Add("ClienteCajaDistribucionServicioId", 90, HorizontalAlignment.Left);
                listCliente.Columns.Add("Estado", 90, HorizontalAlignment.Left);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void LLenarListaCliente(bool _siload)
        {
            try
            {
                listCliente.Items.Clear();

                if (_siload)
                {
                    var cliNegocio = new ClienteNegocio();
                    clis = cliNegocio.ObtenerClientesVideo();
                }
                else { clis = BuscarCli(); }

                if (clis == null) { return; }

                foreach (VistaClientes cli in clis)
                {
                    var item = new ListViewItem
                    {
                        Tag = cli.NroCliente.ToString(),
                        Text = cli.NroCliente.ToString()
                    };
                    item.SubItems.Add(cli.ApellidoyNombre.ToString());
                    item.SubItems.Add(cli.TipoDocumento);
                    item.SubItems.Add(cli.TipoDocumento == "CUIT" ? cli.Cuit.ToString() : cli.Nro_Doc.ToString());
                    item.SubItems.Add(cli.Direccion.ToString());
                    item.SubItems.Add(cli.Telefono.ToString());
                    item.SubItems.Add(cli.Descipcion.ToString());
                    item.SubItems.Add(cli.ClienteCajaDistribucionServicioId.ToString());
                    item.SubItems.Add(cli.Estado.ToString());
                    if (cli.Estado.ToString() == "Baja" || (cli.Estado.ToString() == "Suspendido")) { item.ForeColor = Color.Red; }
                    listCliente.Items.Add(item);
                }
                listCliente.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private List<VistaClientes> BuscarCli()
        {
            try
            {
                if (txtCliente.Text == "" && !checkHabilitar.Checked) { LLenarListaCliente(true); }
                else
                {
                    var cliNegocio = new ClienteNegocio();
                    if (txtCliente.Text != "")
                    {
                        return cliNegocio.ObtenerListClientesPorNomyApVideo(txtCliente.Text);
                    }

                    if (checkHabilitar.Checked)
                    {
                        return cliNegocio.ObtenerListClientesPorEstadoVideo(cmbEstados.Text);
                    }
                }
                return null;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void btnNuevoCliente_Click(object sender, EventArgs e)
        {
            var frm = new frmNuevoCliente { Accion = "ALTA" };
            frm.ShowDialog();
            LLenarListaCliente(true);
        }

        private void listCliente_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listCliente.SelectedItems.Count > 0)
            {
                btnEditar.Enabled = true;
                btnEstados.Enabled = true;
                btnFacturasClientes.Enabled = true;
            }
            else
            {
                btnEditar.Enabled = false;
                btnEstados.Enabled = false;
                btnFacturasClientes.Enabled = false;
            }
        }

        private void btnEstados_Click(object sender, EventArgs e)
        {
            if (listCliente.SelectedItems.Count > 0) //
            {
                var frmc = new frmConsultaClientesCajasDistribucionServiciosEstados() { clienteCajaDistribucionServicioId = Convert.ToInt32(listCliente.SelectedItems[0].SubItems[7].Text) };
                frmc.ShowDialog();
            }
            else
            {
                MessageBox.Show("No se seleccionó ningún cliente" + listCliente.SelectedItems[0].SubItems[1].Text, "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void btnFacturasClientes_Click(object sender, EventArgs e)
        {
            if (listCliente.SelectedItems.Count > 0) //
            {
                var frmc = new frmConsultaFacturasClientes() { clienteCajaDistribucionServicioId = Convert.ToInt32(listCliente.SelectedItems[0].SubItems[7].Text) };
                frmc.ShowDialog();
            }
            else
            {
                MessageBox.Show("No se puede dar de baja el Cliente " + listCliente.SelectedItems[0].SubItems[1].Text, "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            try
            {
                if (listCliente.SelectedItems.Count > 0)
                {
                    if (Users.Rol != TiposUsers.Administrador) return;
                    var frmc = new frmNuevoCliente { Accion = "MOD", NroCliente = Convert.ToInt32(listCliente.SelectedItems[0].Tag) };
                    frmc.ShowDialog();
                    LLenarListaCliente(true);
                }
                else { MessageBox.Show("No se puede editar el usuario genérico", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation); }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                LLenarListaCliente(false);

                if (string.IsNullOrWhiteSpace(txtCliente.Text) && !checkHabilitar.Checked)
                {
                    LLenarListaCliente(true);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void btnBuscar_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                if (e.KeyCode == Keys.Escape) Close();
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void listCliente_DoubleClick(object sender, EventArgs e)
        {
            try { SeleccionLv(); }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void SeleccionLv()
        {
            try
            {
                if (Seleccion)
                {
                    NroCliente = Convert.ToInt32(listCliente.SelectedItems[0].Tag);
                    DialogResult = DialogResult.OK;
                }
                else
                {
                    try
                    {
                        if (listCliente.SelectedItems.Count > 0)
                        {
                            if (Users.Rol != TiposUsers.Administrador) return;
                            var frmc = new frmNuevoCliente { Accion = "MOD", NroCliente = Convert.ToInt32(listCliente.SelectedItems[0].Tag) };
                            frmc.ShowDialog();
                            LLenarListaCliente(true);
                        }
                        else { MessageBox.Show("No se puede editar el usuario genérico", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation); }
                    }
                    catch (Exception ex)
                    {

                        throw ex;
                    }
                }
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void listCliente_ItemSelectionChanged(object sender, ListViewItemSelectionChangedEventArgs e)
        {
            if (listCliente.SelectedItems.Count > 0)
            {
                btnEditar.Enabled = true;
                btnEstados.Enabled = true;
                btnFacturasClientes.Enabled = true;
                btnConsultaDeuda.Enabled = true;
            }
            else
            {
                btnEditar.Enabled = false;
                btnEstados.Enabled = false;
                btnFacturasClientes.Enabled = false;
                btnConsultaDeuda.Enabled = false;
            }
        }

        private void frmVideoCable_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                if (e.KeyCode == Keys.Escape) Close();
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void checkHabilitar_CheckedChanged(object sender, EventArgs e)
        {
            if (checkHabilitar.Checked)
            {
                cmbEstados.Enabled = true;
            }
            else
            {
                cmbEstados.Enabled = false;
            }
        }

        private void btnConsultaDeuda_Click(object sender, EventArgs e)
        {
            NroCliente = Convert.ToInt32(listCliente.SelectedItems[0].Tag);

            FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();
            bool tieneDeuda = facturasVentaNegocio.ObtenerFacturaSinPagarPorCliente(NroCliente);

            if (tieneDeuda)
            {
                frmConsultaDeudaCliente frmConsultaDeudaCliente = new frmConsultaDeudaCliente();
                frmConsultaDeudaCliente.txt_IdCliente.Text = Convert.ToString(NroCliente);
                frmConsultaDeudaCliente.ShowDialog();
            }
            else
            {
                MessageBox.Show("El cliente no posee deuda");
            }
        }
    }
}
