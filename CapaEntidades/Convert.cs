using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;

namespace CapaEntidades
{
    public static class Converter<T> where T : new()
    {
        public static DataTable Convert(List<T> items)
        {
            // Instancia del objeto a devolver
            var returnValue = new DataTable();
            // Información del tipo de datos de los elementos del List
            Type itemsType = typeof(T);
            // Recorremos las propiedades para crear las columnas del datatable
            foreach (PropertyInfo prop in itemsType.GetProperties())
            {
                // Crearmos y agregamos una columna por cada propiedad de la entidad
                if (prop.PropertyType.Name.StartsWith("Nullable"))
                {
                    var column = new DataColumn(prop.Name) { DataType = Type.GetType("System.Object") };
                    returnValue.Columns.Add(column);
                }
                else
                {
                    var column = new DataColumn(prop.Name) { DataType = prop.PropertyType };
                    returnValue.Columns.Add(column);
                }
            }
            Int32 j;
            // ahora recorremos la colección para guardar los datos
            // en el DataTable
            foreach (T item in items)
            {
                j = 0;
                object[] newRow = new object[returnValue.Columns.Count];
                // Volvemos a recorrer las propiedades de cada item para
                // obtener su valor guardarlo en la fila de la tabla
                foreach (PropertyInfo prop in itemsType.GetProperties())
                {
                    newRow[j] = prop.GetValue(item, null);
                    j++;
                }
                returnValue.Rows.Add(newRow);
            }
            // Devolver el objeto creado
            return returnValue;
        }
    }
}
