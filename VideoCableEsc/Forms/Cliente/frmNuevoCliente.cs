using CapaEntidades;
using CapaEntidades.Enum;
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

namespace VideoCableEsc.Forms
{
    public partial class frmNuevoCliente : Form
    {
        public string Accion;
        public Int32 NroCliente, clienteCajaDistribucionServicioId;
        public bool VienedeFact;
        Servicios servicios;

        ClienteNegocio clienteNegocio = new ClienteNegocio();
        EstadoNegocio estadoNegocio = new EstadoNegocio();
        ClienteCajaDistribucionServicioNegocio clienteCajaDistribucionServicioNegocio = new ClienteCajaDistribucionServicioNegocio();
        ClienteCajaDistribucionServicioEstadoNegocio clienteCajaDistribucionServicioEstadoNegocio = new ClienteCajaDistribucionServicioEstadoNegocio();
        CajasDistribucionesNegocio cajasDistribucionesNegocios = new CajasDistribucionesNegocio();
        ServiciosNegocio serviciosNegocio = new ServiciosNegocio();
        ClientesCajasDistribucionesServicios clientesCajasDistribucionesServicios;
        ClientesCajasDistribucionesServiciosNegocio clientesCajasDistribucionesServiciosNegocio = new ClientesCajasDistribucionesServiciosNegocio();

        public frmNuevoCliente()
        {
            InitializeComponent();
        }

        private void frmNuevoCliente_Load(object sender, EventArgs e)
        {
            try
            {
                var neg = new AuxiliaresNegocio();
                var estadoN = new EstadoNegocio();

                cmbRegimenImp.DataSource = neg.ObtenerRegimenes();
                cmbRegimenImp.DisplayMember = "Descripcion";
                cmbRegimenImp.ValueMember = "IdRegimenImpositivo";
                cmbRegimenImp.SelectedIndex = 3;

                cmbTipoDoc.DataSource = neg.ObtenerTipoDoc();
                cmbTipoDoc.DisplayMember = "TipoDocumento";
                cmbTipoDoc.ValueMember = "TipoDocumento";
                cmbTipoDoc.SelectedIndex = 3;

                //cmbCajaD.DataSource = cajasDistribucionesNegocios.GetList();
                //cmbCajaD.DisplayMember = "Descipcion";
                //cmbCajaD.ValueMember = "CajaDistribucionId";


                cmbServicios.DataSource = serviciosNegocio.GetAllActive();
                cmbServicios.DisplayMember = "Descripcion";
                cmbServicios.ValueMember = "ServicioId";


                if (Accion == "MOD")
                {
                    if (NroCliente > 0) BuscarCli(NroCliente);
                    else
                    {
                        DeshabControls();

                        lblCli.Visible = true;
                        txtNroCli.Visible = true;
                    }
                }
            }

            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void BuscarCli(int _nroCli)
        {
            try
            {
                clientesCajasDistribucionesServicios = clienteCajaDistribucionServicioNegocio.GetByIdCliente(_nroCli);

                Clientes cli = clienteNegocio.ObtenerCliporNroCli(clientesCajasDistribucionesServicios.ClienteId);

                var cajasDistribuciones = cajasDistribucionesNegocios.GetById(clientesCajasDistribucionesServicios.CajaDistribucionId);

                servicios = serviciosNegocio.GetById(clientesCajasDistribucionesServicios.ServicioId);

                var estados = estadoNegocio.GetAll();
                if (cli != null)
                {
                    if (cli.FechaBaja != null)
                    {
                        MessageBox.Show("El Cliente fue dado de baja", "Error de Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        checkHabilitar.Checked = true;
                        checkHabilitar.Visible = true;
                    }

                    NroCliente = cli.NroCliente;
                    txtNroCli.Text = cli.NroCliente.ToString();
                    txtNombreApellido.Text = cli.ApellidoyNombre;
                    txtDireccion.Text = cli.Direccion;
                    txtCuit0.Text = cli.Cuit0;
                    txtCuit1.Text = cli.Cuit1;
                    txtCuit2.Text = cli.Cuit2;
                    cmbRegimenImp.SelectedValue = cli.IdRegimenImpositivo;
                    cmbTipoDoc.SelectedValue = cli.TipoDocumento ?? "-";
                    txtNroDoc.Text = cli.NroDocumento.ToString();
                    txtTelefono.Text = cli.Telefono;
                    txtCaja.Text = cli.Caja;
                    cmbServicios.SelectedValue = servicios.ServicioId;
                    cmbServicios.Text = servicios.Descripcion;
                    txtPrecinto.Text = cli.Precinto;

                    btnGuardar.Enabled = true;
                    lblCli.Visible = true;
                    txtNroCli.Visible = true;

                    Validaciones();
                }
                else MessageBox.Show("No se encontró el Cliente", "Búsqueda", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
            catch (Exception ex) { throw ex; }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Validaciones())
                {

                    if (cmbTipoDoc.SelectedValue.ToString() == "CUIT")
                    {
                        List<Clientes> cuit = clienteNegocio.ObtenerClientesCargadosCUIT(Convert.ToInt64(txtCuit1.Text), cmbTipoDoc.SelectedValue.ToString());
                        if (cuit.Count > 1)
                        {
                            if (Accion.ToUpper() == "ALTA")
                                if (MessageBox.Show("Se ha encontroado un cliente con el mismo número de CUIT, ¿Desea cargarlo de todas formas?",
                                    "CUIT ENCONTRADO", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                                {
                                    MessageBox.Show("Esta registando un Cliente con un mismo CUIT");
                                    return;
                                }
                        }
                        
                    }
                    var cli = new Clientes
                    {
                        ApellidoyNombre = txtNombreApellido.Text,
                        Direccion = txtDireccion.Text,
                        Precinto = txtPrecinto.Text,
                        Telefono = txtTelefono.Text,
                        CodigoPostal = 3531,
                        SubCodigoPostal = 1,
                        Caja = txtCaja.Text
                    };
                    cli.IdRegimenImpositivo = Convert.ToInt16(cmbRegimenImp.SelectedValue);
                    switch (cmbTipoDoc.SelectedValue.ToString())
                    {
                        case "CUIT":
                            cli.Cuit0 = txtCuit0.Text;
                            cli.Cuit1 = txtCuit1.Text;
                            cli.Cuit2 = txtCuit2.Text;
                            cli.TipoDocumento = "CUIT";
                            cli.NroDocumento = null;
                            break;
                        case "-":
                            cli.Cuit0 = null;
                            cli.Cuit1 = null;
                            cli.Cuit2 = null;
                            cli.TipoDocumento = null;
                            cli.NroDocumento = null;
                            break;
                        case "DNI":
                            cli.Cuit0 = null;
                            cli.Cuit1 = null;
                            cli.Cuit2 = null;
                            cli.TipoDocumento = cmbTipoDoc.SelectedValue.ToString();
                            cli.NroDocumento = Convert.ToInt32(txtNroDoc.Text);
                            break;
                        default:
                            cli.Cuit0 = null;
                            cli.Cuit1 = null;
                            cli.Cuit2 = null;
                            cli.TipoDocumento = cmbTipoDoc.SelectedValue.ToString();
                            cli.NroDocumento = Convert.ToInt32(txtNroDoc.Text);
                            break;
                    }

                    string mensaje = string.Empty;

                    if (Accion == "ALTA")
                    {
                        cli.UsrAcceso = Users.Usr;
                        Int32 NroCli = clienteNegocio.NuevoCli(cli);
                        if (NroCli > 0)
                        {
                            var clienteCajaDistribucionServicio = new ClientesCajasDistribucionesServicios
                            {
                                ClienteId = NroCli,
                                CajaDistribucionId = 4,
                                ServicioId = Convert.ToInt32(cmbServicios.SelectedValue),
                                FechaUltimaModificacion = DateTime.Now,
                                UltimoEstadoId = 1,
                                UsuarioUltimaModificacion = 1,
                            };
                            int NroClienteCaja = clientesCajasDistribucionesServiciosNegocio.NuevoCliCaja(clienteCajaDistribucionServicio);

                            //@cesar, por favor analiza este bloque de codigo
                            //la idea es que si el mensaje vuelve del servicio con valor, es porque ocurrio un error entonces se debe cancelar todo el proces de creacion.
                            if (NroClienteCaja <= 0)
                            {
                                MessageBox.Show(mensaje + Environment.NewLine +
                                   "Nro.Cliente: " + NroCli, "ALTA INCORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                                this.Close();
                            }

                            if (VienedeFact)
                            {
                                NroCliente = NroCli;
                                DialogResult = DialogResult.OK;
                            }

                            MessageBox.Show("El cliente se ingresó correctamente." + Environment.NewLine +
                           "Nro.Cliente: " + NroCli, "ALTA CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                            this.Close();
                        }
                    }
                    else if (Accion == "MOD")
                    {
                        if (checkHabilitar.Visible)
                        {
                            if (checkHabilitar.Checked == true) { cli.FechaBaja = null; } else { cli.FechaBaja = DateTime.Now; }
                            clienteNegocio.EditarCli(cli, NroCliente, true);
                        }
                        clienteNegocio.EditarCli(cli, NroCliente);
                        clientesCajasDistribucionesServiciosNegocio.EditarClientesCajasDistribucionesServiciosPorClienteid(NroCliente, Convert.ToInt32(cmbServicios.SelectedValue));

                        //var ultimoEstado = clienteCajaDistribucionServicioEstadoNegocio.GetUltimoEstado(1);

                        //if (ultimoEstado.EstadoId != estadoSeleccionado)
                        //{
                        //    var nuevoEstado = clienteCajaDistribucionServicioEstadoNegocio.Create(
                        //        new ClientesCajasDistribucionesServiciosEstados
                        //        {
                        //            ClienteCajaDistribucionServicioId = 1,
                        //            EstadoId = estadoSeleccionado,
                        //            FechaUltimaModificacion = DateTime.Now,
                        //            UsuarioUltimaModificacion = 1
                        //        },
                        //        out mensaje
                        //        );

                        //    if (!string.IsNullOrEmpty(mensaje))
                        //    {
                        //        //mostrar error
                        //    }
                        //}
                        MessageBox.Show("El cliente se editó correctamente.", "EDICIÓN CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        DeshabControls();
                        NroCliente = 0;
                        this.Close();
                    }
                    FuncionesForms.BlanquearGroupBox(groupBox1);
                }

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private bool Validaciones()
        {
            try
            {
                bool Correcto = true;

                if (txtNombreApellido.Text.All(char.IsWhiteSpace))
                {
                    Error.SetError(txtNombreApellido, "Ingrese Nombre y Apellido");
                    Correcto = false;
                }
                else Error.SetError(txtNombreApellido, "");

                if (txtNombreApellido.Text.All(char.IsNumber))
                {
                    Error.SetError(txtNombreApellido, "Nombre y Apellido invalido");
                    Correcto = false;
                }
                else Error.SetError(txtNombreApellido, "");

                if (txtDireccion.Text == "")
                {
                    Error.SetError(txtDireccion, "Ingrese Direccion");
                    Correcto = false;
                }
                else Error.SetError(txtDireccion, "");
                if (cmbRegimenImp.SelectedValue.ToString() == "1" || cmbTipoDoc.SelectedValue.ToString() == "CUIT") //Resp Inscripto
                {
                    if (!FuncionesForms.SiesInt32(txtCuit0.Text) || !FuncionesForms.SiesInt32(txtCuit1.Text) || !FuncionesForms.SiesInt32(txtCuit2.Text))
                    {
                        Error.SetError(txtCuit2, "Ingrese Nro.Cuit correcto");
                        Correcto = false;
                    }
                    else
                    {
                        if (txtCuit0.Text.Length != 2)
                        {
                            Error.SetError(txtCuit2, "Ingrese Nro.Cuit correcto");
                            Correcto = false;
                        }
                        else
                        {
                            Int32 verif = 0;
                            if (!FuncionesForms.VerificarCuit(txtCuit0.Text, txtCuit1.Text, txtCuit2.Text, ref verif))
                            {
                                Error.SetError(txtCuit2, "CUIT incorrecto. El dígito verificador correcto para el CUIT ingresado es: " + verif.ToString());
                                Correcto = false;
                            }
                            else Error.SetError(txtCuit2, "");
                        }
                    }
                }
                else
                {
                    if (cmbTipoDoc.SelectedValue.ToString() != "-")
                    {
                        if (!FuncionesForms.SiesInt64(txtNroDoc.Text))
                        {
                            Error.SetError(txtNroDoc, "Si selecciona un Tipo Doc. deberá ingresar un nro. de documento" + Environment.NewLine +
                                "Sino quiere ingresar Nro.Documento seleccione el Tipo de Documento: '-'");
                            Correcto = false;
                        }
                        else
                        {
                            if (cmbTipoDoc.SelectedValue.ToString() == "DNI")
                            {
                                if (txtNroDoc.Text.Length < 8)
                                {
                                    Error.SetError(txtNroDoc, "Faltan números por ingresar");
                                    Correcto = false;
                                }
                                else Error.SetError(txtNroDoc, "");
                            }
                        }
                    }
                    else
                    {
                        if (txtNroDoc.Text == "0" || txtNroDoc.Text == "")
                            Error.SetError(txtNroDoc, "");
                        else
                        {
                            Error.SetError(txtNroDoc, "No se puede ingresar Numero de Documento para el Tipo de Documento '-'" + Environment.NewLine +
                                                      "Si quiere ingresar un valor para este campo seleccione un Tipo de Documento diferente");
                            Correcto = false;
                        }
                        
                    }
                }
                if (!Correcto) return false;

                if (cmbTipoDoc.SelectedValue.ToString() == "DNI" || cmbTipoDoc.SelectedValue.ToString() == "LC" || cmbTipoDoc.SelectedValue.ToString() == "LE" || cmbTipoDoc.SelectedValue.ToString() == "CUIL")
                {
                    if (txtNroDoc.Text == "0") return Correcto;
                }
                return Correcto;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        private void DeshabControls()
        {
            foreach (Control x in groupBox1.Controls)
            {
                if (x is TextBox || x is ComboBox || x is CheckBox || x is DateTimePicker)
                {
                    x.Enabled = false;
                }
            }

            txtNroCli.Enabled = true;
        }

        private void cmbTipoDoc_SelectedValueChanged(object sender, EventArgs e)
        {
            try
            {
                if (cmbTipoDoc.SelectedValue != null)
                {
                    if (cmbTipoDoc.SelectedValue.ToString() == "CUIT")
                    {
                        txtCuit0.Visible = true;
                        txtCuit1.Visible = true;
                        txtCuit2.Visible = true;
                        txtNroDoc.Visible = false;
                    }
                    else
                    {
                        txtCuit0.Visible = false;
                        txtCuit1.Visible = false;
                        txtCuit2.Visible = false;
                        txtNroDoc.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void txtCaja_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
            {
                // Si no es un número, la tecla de retroceso o el separador decimal, cancela la entrada de caracteres
                e.Handled = true;
            }
        }

        private void txtPrecinto_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
            {
                // Si no es un número, la tecla de retroceso o el separador decimal, cancela la entrada de caracteres
                e.Handled = true;
            }
        }

        private void checkHabilitar_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}
