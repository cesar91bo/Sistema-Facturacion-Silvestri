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
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace VideoCableEsc.Forms.Servicio
{
    public partial class frmCrearServicios : Form
    {
        public string Accion;
        public Int32 idServicio;
        public frmCrearServicios()
        {
            InitializeComponent();
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Validaciones()) return;

            var serviciosNegocio = new ServicioNegocio();

            var servicio = new Servicios
            {
                Descripcion = txtDescripcion.Text,
                Costo = Convert.ToDecimal(txtCosto.Text),
                FechaUltimaModificacion = DateTime.Now,
                Activo = checkHabilitar.Checked,
                TipoServicio = cmbTipoServicio.Text,
                UsuarioUltimaModificacion = 1
            };


            if (Accion == "ALTA")
            {
                servicio.Activo = true;
                Int32 NroServicio = serviciosNegocio.CreateService(servicio);
                if (NroServicio > 0) MessageBox.Show("El Servicio se creó correctamente." + Environment.NewLine + "Nro. Servicio: " + NroServicio, "ALTA CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                this.Close();
            }
            else
            {
                if (serviciosNegocio.EditarServicio(servicio, idServicio))
                    MessageBox.Show("El Servicio se editó correctamente.", "EDICIÓN CORRECTA",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);
                this.Close();
            }

        }

        private bool Validaciones()
        {
            bool Correcto = true;
            var serviciosNegocio = new ServicioNegocio();

            if (txtDescripcion.Text.All(char.IsWhiteSpace))
            {
                MessageBox.Show(txtDescripcion, "Ingrese la Descripción");
                return false;
            }
            else
            {
                var consultaDescripcion = serviciosNegocio.ConsultaDescripcion(txtDescripcion.Text);
                if (consultaDescripcion != string.Empty && Accion == "ALTA")
                {
                    MessageBox.Show(txtDescripcion, consultaDescripcion.ToString());
                    return  false;
                }
            }

            if (txtCosto.Text == "")
            {
                MessageBox.Show(txtDescripcion, "Ingrese el Costo");
                Correcto = false;
            }

            return Correcto;
        }

        private void frmCrearServicios_Load(object sender, EventArgs e)
        {
            cmbTipoServicio.SelectedIndex = 0;
            if (Accion == "MOD")
            {
                if (idServicio > 0)
                {
                    BuscarSer(idServicio);
                }
                else
                {
                    btnGuardar.Enabled = false;
                }
                btnGuardar.Text = "Editar";
            }
        }

        public void BuscarSer(int numServicio)
        {
            var servicioNegocio = new ServicioNegocio();
            Servicios ser = servicioNegocio.ObtenerServicioPorNroPro(numServicio);

            if (ser != null)
            {
                txtDescripcion.Text = ser.Descripcion;
                txtCosto.Text = Convert.ToString(ser.Costo);
                checkHabilitar.Checked = ser.Activo.Value;
                cmbTipoServicio.Text = ser.TipoServicio;
                btnGuardar.Enabled = true;
            }
            else
            {
                MessageBox.Show("No se encontró el Servicio", "Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
    }
}
