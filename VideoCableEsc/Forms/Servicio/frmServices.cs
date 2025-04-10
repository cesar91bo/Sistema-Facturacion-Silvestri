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

namespace VideoCableEsc.Forms.Servicio
{
    public partial class frmServices : Form
    {

        List<Servicios> servicios;

        public frmServices()
        {
            InitializeComponent();
        }

        private void frmServices_Load(object sender, EventArgs e)
        {
            try
            {
                var dt = new DataTable();
                dt.Columns.Add("IdBusqueda");
                dt.Columns.Add("Descripcion");
                dt.Rows.Add("ServicioId", "ServicioId");
                dt.Rows.Add("Descripcion", "Descripcion");
                dt.Rows.Add("Activo", "Activo");
                LLenarListaServicios(true);

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void LLenarListaServicios(bool _siload)
        {

            listServicios.Items.Clear();
            if (_siload)
            {
                var serviciosNegocio = new ServiciosNegocio();
                if (checkMostrarTdo.Checked) { servicios = serviciosNegocio.GetAll(); }
                else { servicios = serviciosNegocio.GetList(); }

            }

            if (servicios == null) { return; }


            foreach (var servicio in servicios)
            {
                //var item = new ListViewItem(servicio.ServicioId.ToString());

                var item = new ListViewItem
                {
                    Tag = servicio.ServicioId.ToString(),
                    Text = servicio.ServicioId.ToString()
                };
                item.SubItems.Add(servicio.Descripcion.ToString());
                item.SubItems.Add(servicio.Activo != null ? (servicio.Activo.Value == true ? "SI" : "NO") : "NO");
                item.SubItems.Add(servicio.Costo.ToString("C2"));

                if (servicio.Activo.Value == false) { item.ForeColor = Color.Red; }
                listServicios.Items.Add(item);
            }

            listServicios.Focus();
        }

        private void btnNuevoServicio_Click(object sender, EventArgs e)
        {
            try
            {
                var frm = new frmCrearServicios { Accion = "ALTA" };
                frm.ShowDialog();
                LLenarListaServicios(true);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message); ;
            }

        }

        private void btnEditarServicio_Click(object sender, EventArgs e)
        {

            try
            {
                if (listServicios.SelectedItems.Count > 0)
                {
                    if (Users.Rol != TiposUsers.Administrador) return;
                    var frmc = new frmCrearServicios { Accion = "MOD", idServicio = Convert.ToInt32(listServicios.SelectedItems[0].Tag) };
                    frmc.ShowDialog();
                    LLenarListaServicios(true);
                }
                else { MessageBox.Show("No se puede editar el Servicio", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation); }
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        private void listServicios_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listServicios.SelectedItems.Count > 0)
            {
                btnEditarServicio.Enabled = true;

            }
            else
            {
                btnEditarServicio.Enabled = false;

            }
        }

        private void checkMostrarTdo_CheckedChanged(object sender, EventArgs e)
        {
            LLenarListaServicios(true);
        }
    }
}
