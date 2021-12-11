/*
The MIT License (MIT)

Copyright (c) 2018 Pretius Sp. z o.o. sk.
Żwirki i Wigury 16a
02-092 Warsaw, Poland
www.pretius.com
www.translate-apex.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

SET DEFINE OFF
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;

    
DECLARE
  v_workspace_name VARCHAR2(100) := ''; -- APEX Workspace Name
  v_app_id NUMBER := 0; -- APEX Application ID
  v_session_id NUMBER := 1; -- APEX Session ID (doesn't matter)

  v_workspace_id apex_workspaces.workspace_id%type;

BEGIN
-- Get APEX workspace ID by name
  select 
    workspace_id
  into 
    v_workspace_id
  from 
    apex_workspaces
  where 
    upper(workspace) = upper(v_workspace_name);

-- Set APEX workspace ID
  apex_util.set_security_group_id(v_workspace_id);

-- Set APEX application ID
  apex_application.g_flow_id := v_app_id; 

-- Set APEX session ID
  apex_application.g_instance := v_session_id; 

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'REPORTING_PERIOD',
  p_message_language => 'es',
  p_message_text => 'Per�odo del Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_X_YEARS',
  p_message_language => 'es',
  p_message_text => 'Siguientes %0 A�os');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE',
  p_message_language => 'es',
  p_message_text => 'Eliminar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.FILE_BROWSE.DOWNLOAD_LINK_TEXT',
  p_message_language => 'es',
  p_message_text => 'Descargar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'INVALID_CREDENTIALS',
  p_message_language => 'es',
  p_message_text => 'Credenciales de conexión no válidas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.NEXT_SET',
  p_message_language => 'es',
  p_message_text => 'Juego Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.PREVIOUS',
  p_message_language => 'es',
  p_message_text => 'Anterior');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MINUTES_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_SECONDS_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 segundos desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_3D',
  p_message_language => 'es',
  p_message_text => '3D');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_SUBSCRIPTION',
  p_message_language => 'es',
  p_message_text => 'Agregar Suscripción');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_AVG',
  p_message_language => 'es',
  p_message_text => 'Media');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BGCOLOR',
  p_message_language => 'es',
  p_message_text => 'Color de Fondo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CLEAR',
  p_message_language => 'es',
  p_message_text => 'borrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IN',
  p_message_language => 'es',
  p_message_text => 'en');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_IN_LAST',
  p_message_language => 'es',
  p_message_text => 'en últimos(as)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_NOT_NULL',
  p_message_language => 'es',
  p_message_text => 'no es nulo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_NULL',
  p_message_language => 'es',
  p_message_text => 'es nulo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_REGEXP_LIKE',
  p_message_language => 'es',
  p_message_text => 'coincide con expresión regular');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DEFAULT_REPORT_TYPE',
  p_message_language => 'es',
  p_message_text => 'Tipo de Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DO_NOT_AGGREGATE',
  p_message_language => 'es',
  p_message_text => '- No Agregar -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_CHART',
  p_message_language => 'es',
  p_message_text => 'Editar Valores de Grafico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_ADDRESS',
  p_message_language => 'es',
  p_message_text => 'Direccion de Correo Electronico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_BCC',
  p_message_language => 'es',
  p_message_text => 'Cco');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXPAND_COLLAPSE_ALT',
  p_message_language => 'es',
  p_message_text => 'Ampliar/Reducir');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTER_EXPRESSION',
  p_message_language => 'es',
  p_message_text => 'Expresión de Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTERS',
  p_message_language => 'es',
  p_message_text => 'Filtros');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTIONS_OPERATORS',
  p_message_language => 'es',
  p_message_text => 'Funciones/Operadores');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_01',
  p_message_language => 'es',
  p_message_text => 'Las regiones de informes interactivos permiten que los usuarios finales personalicen los informes. Los usuarios pueden alterar el diseño de los datos del informe seleccionando columnas, aplicando filtros, resaltando y ordenando. También pueden definir saltos de línea, agregaciones, gráficos, organizaciones por grupos y sus propios cálculos. También se puede definir una suscripción para que envíe por correo electrónico el informe en versión HTML con intervalos de tiempo designados. Los usuarios pueden crear múltiples variaciones del informe y guardarlas como informes con nombre, para visualización pública o privada. 
<p/> 
Las secciones siguientes ofrecen un resumen de los modos de personalizar un informe interactivo. Para obtener más información, consulte la sección sobre el uso de informes interactivos en <a href="http://www.oracle.com/pls/topic/lookup?ctx=E37097_01&id=AEEUG453" target="_blank"><i>Oracle Application Express End User''s Guide</i></a>.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHTS',
  p_message_language => 'es',
  p_message_text => 'Resaltados');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT_WHEN',
  p_message_language => 'es',
  p_message_text => 'Resaltar Cuando');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID',
  p_message_language => 'es',
  p_message_text => 'No Válido');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_IN_THE_NEXT',
  p_message_language => 'es',
  p_message_text => '%0 está en el siguiente %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_KEYPAD',
  p_message_language => 'es',
  p_message_text => 'Teclado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MAX_ROW_CNT',
  p_message_language => 'es',
  p_message_text => 'El recuento máximo de filas de este informe es %0 filas. Aplique un filtro para reducir el número de registros de la consulta.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_AGGREGATION_DEFINED',
  p_message_language => 'es',
  p_message_text => 'Ninguna agregación definida.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NULLS_ALWAYS_LAST',
  p_message_language => 'es',
  p_message_text => 'Valores Nulos Siempre al Final');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_OF_TOTAL_COUNT_X',
  p_message_language => 'es',
  p_message_text => 'Porcentaje de Recuento Total %0 (%)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PRIMARY_REPORT',
  p_message_language => 'es',
  p_message_text => 'Informe Primario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_AS_DEFAULT',
  p_message_language => 'es',
  p_message_text => 'Guardar como Valores por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH',
  p_message_language => 'es',
  p_message_text => 'Buscar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH_REPORT',
  p_message_language => 'es',
  p_message_text => 'Buscar Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_CATEGORY',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Categoría -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_ASCENDING',
  p_message_language => 'es',
  p_message_text => 'Orden Ascendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUBSCRIPTION_ENDING',
  p_message_language => 'es',
  p_message_text => 'Terminando');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_DAYS',
  p_message_language => 'es',
  p_message_text => 'días');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_HOURS',
  p_message_language => 'es',
  p_message_text => 'horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_YEARS',
  p_message_language => 'es',
  p_message_text => 'años');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALID_FORMAT_MASK',
  p_message_language => 'es',
  p_message_text => 'Introduzca una máscara de formato válida.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_WEEK',
  p_message_language => 'es',
  p_message_text => 'Semana');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_WEEKS',
  p_message_language => 'es',
  p_message_text => '%0 semanas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'IR_STAR',
  p_message_language => 'es',
  p_message_text => 'Sólo se muestra a los desarrolladores');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.SLIDER.VALUE_NOT_BETWEEN_MIN_MAX',
  p_message_language => 'es',
  p_message_text => '#LABEL# no está en el rango válido de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.REGION.JQM_LIST_VIEW.LOAD_MORE',
  p_message_language => 'es',
  p_message_text => 'Cargar Más...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTION_N',
  p_message_language => 'es',
  p_message_text => 'Función %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INACTIVE_SETTINGS',
  p_message_language => 'es',
  p_message_text => '%0 valores inactivos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_SETTING',
  p_message_language => 'es',
  p_message_text => '1 valor no válido');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_SETTINGS',
  p_message_language => 'es',
  p_message_text => '%0 valores no válidos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_AGG_NOT_ON_ROW_COL',
  p_message_language => 'es',
  p_message_text => 'No puede agregar en una columna que se ha seleccionado como columna de fila.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_SORT',
  p_message_language => 'es',
  p_message_text => 'Ordenación Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_CHART',
  p_message_language => 'es',
  p_message_text => 'Eliminar Gráfico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COLUMN_NOT_NULL',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar la columna de fila.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_REPORT_DEFAULT',
  p_message_language => 'es',
  p_message_text => 'Guardar Informe *');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_MAX_ROW_CNT',
  p_message_language => 'es',
  p_message_text => 'El recuento máximo de filas para una consulta de Gráfico limita el número de filas de la consulta base, no el número de filas que se muestran. La consulta base supera el recuento máximo de filas de %0. Aplique un filtro para reducir el número de registros en la consulta base.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT',
  p_message_language => 'es',
  p_message_text => 'Editar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_PIVOT',
  p_message_language => 'es',
  p_message_text => 'Editar Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_SUBJECT_REQUIRED',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar el asunto del correo electrónico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_ROW',
  p_message_language => 'es',
  p_message_text => 'Seleccionar Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEND',
  p_message_language => 'es',
  p_message_text => 'Enviar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MAX_QUERY_COST',
  p_message_language => 'es',
  p_message_text => 'Se estima que la consulta supera el máximo de recursos permitidos. Modifique los valores del informe y vuelva a intentarlo.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NAME',
  p_message_language => 'es',
  p_message_text => 'Nombre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NONE',
  p_message_language => 'es',
  p_message_text => '- Ninguno -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_OF_TOTAL_SUM_X',
  p_message_language => 'es',
  p_message_text => 'Porcentaje de Suma Total %0 (%)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PRIVATE',
  p_message_language => 'es',
  p_message_text => 'Privado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_CONTROL_BREAK',
  p_message_language => 'es',
  p_message_text => 'Eliminar División de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ACTIONS',
  p_message_language => 'es',
  p_message_text => 'Acciones');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MODE',
  p_message_language => 'es',
  p_message_text => 'Modo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALL',
  p_message_language => 'es',
  p_message_text => 'Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_APPLY',
  p_message_language => 'es',
  p_message_text => 'Aplicar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BOTTOM',
  p_message_language => 'es',
  p_message_text => 'Último');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART',
  p_message_language => 'es',
  p_message_text => 'Gráfico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_HEADING',
  p_message_language => 'es',
  p_message_text => 'Cabecera de Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_INFO',
  p_message_language => 'es',
  p_message_text => 'Información de la Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER_E1',
  p_message_language => 'es',
  p_message_text => '(B+C)*100');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DAY',
  p_message_language => 'es',
  p_message_text => 'Día ');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE',
  p_message_language => 'es',
  p_message_text => 'Suprimir');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAYED_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Columnas Mostradas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_CC',
  p_message_language => 'es',
  p_message_text => 'Cc');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ENABLE',
  p_message_language => 'es',
  p_message_text => 'Activar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXAMPLES_WITH_COLON',
  p_message_language => 'es',
  p_message_text => 'Ejemplos:');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTER_TYPE',
  p_message_language => 'es',
  p_message_text => 'Tipo de Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FINDER_ALT',
  p_message_language => 'es',
  p_message_text => 'Seleccionar Columnas a Buscar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FORMAT',
  p_message_language => 'es',
  p_message_text => 'Formato');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Agrupar por Columna %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_ACTIONS_MENU',
  p_message_language => 'es',
  p_message_text => 'El menú Acciones aparece a la derecha del botón Ir en la barra de búsqueda. Utilice este menú para personalizar un informe interactivo.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_COLUMN_HEADING_MENU',
  p_message_language => 'es',
  p_message_text => 'Al hacer clic en cualquier cabecera de columna, se muestra un menú de cabecera de columna con las siguientes opciones: 
<p></p> 
<ul> 
<li><b>El icono <b>Orden Ascendente</b> ordena el informe según la columna en orden ascendente.</li> 
<li>El icono <b>Orden Descendente</b> ordena el informe según la columna en orden descendente.</li> 
<li><b>Ocultar Columna</b> oculta la columna. No todas las columnas se pueden ocultar. Si una columna no se puede ocultar, no habrá ningún icono Ocultar Columna.</li> 
<li><b>Columna Divisoria</b> crea un grupo de división en la columna. De esta forma se extrae la columna del informe como registro maestro.</li> 
<li><b>Información de la Columna</b> muestra texto de ayuda sobre la columna si está disponible.</li> 
<li><b>Área de Texto</b> se utiliza para introducir criterios de búsqueda que no sean sensibles a mayúsculas/minúsculas (no se necesitan comodines). Al introducir un valor, se reduce la lista de valores de la parte inferior del menú. A continuación, puede seleccionar un valor de la parte inferior para que se cree como filtro con ''='' (por ejemplo, <code>columna = ''ABC''</code>). También puede hacer clic en el icono de linterna e introducir un valor para que se cree como filtro con el modificador ''LIKE'' (por ejemplo, <code>columna LIKE ''%ABC%''</code>). 
<li><b>Lista de Valores Únicos</b> contiene los 500 primeros valores únicos que cumplen los filtros. Si la columna es una fecha, aparece una lista de rangos de fechas. Si selecciona un valor, se creará un filtro con ''='' (por ejemplo, <code>columna = ''ABC''</code>).</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT_CONDITION',
  p_message_language => 'es',
  p_message_text => 'Condición para Resaltar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INTERACTIVE_REPORT_HELP',
  p_message_language => 'es',
  p_message_text => 'Ayuda de Informe Interactivo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_TOTAL_SUM',
  p_message_language => 'es',
  p_message_text => 'Porcentaje de Suma Total');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_AGGREGATE',
  p_message_language => 'es',
  p_message_text => 'Eliminar Agregado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_SETTINGS',
  p_message_language => 'es',
  p_message_text => 'Valores de Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_VIEW',
  p_message_language => 'es',
  p_message_text => 'Vista de Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEQUENCE',
  p_message_language => 'es',
  p_message_text => 'Secuencia');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT',
  p_message_language => 'es',
  p_message_text => 'Ordenar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUBSCRIPTION_STARTING_FROM',
  p_message_language => 'es',
  p_message_text => 'Empezando por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_YEARS',
  p_message_language => 'es',
  p_message_text => '%0 años');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.YES_NO.INVALID_VALUE',
  p_message_language => 'es',
  p_message_text => '#LABEL# debe coincidir con los valores %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_GROUP_BY',
  p_message_language => 'es',
  p_message_text => 'Eliminar Grupo por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_PIVOT',
  p_message_language => 'es',
  p_message_text => 'Eliminar Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_ID_DOES_NOT_EXIST',
  p_message_language => 'es',
  p_message_text => 'El informe interactivo guardado con el ID %0 no existe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Columnas de Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_DEFAULT_REPORT',
  p_message_language => 'es',
  p_message_text => 'Suprimir Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_ORDER',
  p_message_language => 'es',
  p_message_text => 'Orden de Clasificación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TABLE_SUMMARY',
  p_message_language => 'es',
  p_message_text => 'Región = %0, Informe = %1, Vista = %2, Inicio de Filas Mostradas = %3, Fin de Filas Mostradas = %4, Total de Filas = %5');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_PIVOT',
  p_message_language => 'es',
  p_message_text => 'Ver Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_ROWS',
  p_message_language => 'es',
  p_message_text => '<li><b>Filas</b> define el número de registros que se mostrarán en cada página.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MIN_X',
  p_message_language => 'es',
  p_message_text => 'Mínimo %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_MONTH',
  p_message_language => 'es',
  p_message_text => 'Mes Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_INVALID',
  p_message_language => 'es',
  p_message_text => '#LABEL# no coincide con el formato %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_LESS_MIN_VALUE',
  p_message_language => 'es',
  p_message_text => '#LABEL# es inferior al mínimo especificado %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_DAYS_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 días desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_FLOW_UTILITIES.CAL',
  p_message_language => 'es',
  p_message_text => 'Calendario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_FLOW_UTILITIES.OK',
  p_message_language => 'es',
  p_message_text => 'Aceptar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MAX',
  p_message_language => 'es',
  p_message_text => 'Máximo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MEDIAN',
  p_message_language => 'es',
  p_message_text => 'Mediana');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALL_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Todas las Columnas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALTERNATIVE',
  p_message_language => 'es',
  p_message_text => 'Alternativo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALTERNATIVE_DEFAULT_NAME',
  p_message_language => 'es',
  p_message_text => 'Valor Por Defecto Alternativo:  %0 ');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AS_OF',
  p_message_language => 'es',
  p_message_text => 'Hace %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHOOSE_DOWNLOAD_FORMAT',
  p_message_language => 'es',
  p_message_text => 'Seleccione el formato de descarga del informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_HEADING_MENU',
  p_message_language => 'es',
  p_message_text => 'Menú de Cabecera de Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_ISNOT_IN_LAST',
  p_message_language => 'es',
  p_message_text => 'no en últimos(as)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_NOT_LIKE',
  p_message_language => 'es',
  p_message_text => 'no igual');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CONTROL_BREAK',
  p_message_language => 'es',
  p_message_text => 'División de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CONTROL_BREAKS',
  p_message_language => 'es',
  p_message_text => 'Divisiones de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DEFAULT',
  p_message_language => 'es',
  p_message_text => 'Valor por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_CONFIRM_JS_DIALOG',
  p_message_language => 'es',
  p_message_text => '¿Desea realizar esta acción de supresión?');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DESCENDING',
  p_message_language => 'es',
  p_message_text => 'Descendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DESCRIPTION',
  p_message_language => 'es',
  p_message_text => 'Descripción');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DETAIL_VIEW',
  p_message_language => 'es',
  p_message_text => 'Vista de Una Sola Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DOWNLOAD',
  p_message_language => 'es',
  p_message_text => 'Descargar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_BODY',
  p_message_language => 'es',
  p_message_text => 'Cuerpo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_TO',
  p_message_language => 'es',
  p_message_text => 'Para');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FLASHBACK_DESCRIPTION',
  p_message_language => 'es',
  p_message_text => 'Las consultas de flashback permiten visualizar los datos tal como existían en un punto en el tiempo anterior.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FLASHBACK_ERROR_MSG',
  p_message_language => 'es',
  p_message_text => 'No se ha podido realizar la solicitud de flashback');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY',
  p_message_language => 'es',
  p_message_text => 'Agrupar por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_CHART',
  p_message_language => 'es',
  p_message_text => 'Puede definir un gráfico por informe guardado. Después  
de definirlo, puede cambiar entre las vistas de gráfico e informe mediante los iconos de visualización de la barra de búsqueda. 
Las opciones incluyen:  
<p> 
</p><ul> 
<li><b>Tipo de Gráfico</b> identifica el tipo de gráfico que se debe incluir. 
Seleccione un gráfico de barras horizontales, de barras verticales, de tarta o de líneas.</li> 
<li><b>Etiqueta</b> permite seleccionar la columna que se debe utilizar como etiqueta.</li> 
<li><b>Título del Eje para Etiqueta</b> es el título que se mostrará en el eje asociado a la columna seleccionada como 
etiqueta. No está disponible para gráficos de tarta.</li> 
<li><b>Valor</b> permite seleccionar la columna que se debe utilizar como valor. Si la función 
es COUNT, no se tiene que seleccionar ningún valor.</li> 
<li><b>Título del Eje para Valor</b> es el título que se mostrará en el eje asociado a la columna seleccionada 
como valor. No está disponible para gráficos de tarta.</li> 
<li><b>Función</b> es una función opcional que se debe realizar en la columna seleccionada como valor.</li> 
<li><b>Ordenar</b> permite ordenar el juego de resultados.</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_COMPUTE',
  p_message_language => 'es',
  p_message_text => 'Permite agregar columnas calculadas al informe. Pueden ser cálculos matemáticos (por ejemplo, <code>NBR_HOURS/24</code>) o funciones estándar de Oracle aplicadas a columnas existentes. Algunas se muestran como ejemplo pero también se pueden utilizar otras (como <code>TO_DATE)</code>). Las opciones incluyen: 
<p></p> 
<ul> 
<li><b>Cálculo</b> permite seleccionar un cálculo definido previamente para editarlo.</li> 
<li><b>Cabecera de Columna</b> es la cabecera para la nueva columna.</li> 
<li><b>Máscara de Formato</b> es una máscara de formato de Oracle que se debe aplicar a la columna (por ejemplo, S9999).</li> 
<li><b>Cálculo</b> es el cálculo que se debe realizar. Dentro del cálculo, se hace referencia a las columnas mediante los alias mostrados.</li> 
</ul> 
<p>Debajo del cálculo, las columnas de la consulta se muestran con sus alias asociados. Al hacer clic en el nombre o el alias de una columna, estos se incluyen en el cálculo. Junto a las columnas hay un teclado que funciona como método abreviado para las teclas que más se utilizan. En el extremo de la derecha están las funciones.</p> 
<p>El siguiente es un ejemplo de cálculo para mostrar la remuneración total:</p> 
<pre>CASE WHEN A = ''VENTAS'' THEN B + C ELSE B END</pre> 
(donde A es ORGANIZACIÓN, B es SALARIO y C es COMISIÓN)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR',
  p_message_language => 'es',
  p_message_text => 'En la parte superior de cada página de informe se encuentra una región de búsqueda. Esta región (o barra de herramientas) proporciona las siguientes funciones:');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SORT',
  p_message_language => 'es',
  p_message_text => '<p>Se utiliza para cambiar las columnas por las que se ordena y determina si ordenar en sentido ascendente o descendente. También puede especificar cómo se manejan los <code>valores nulos</code>: el valor por defecto, mostrarlos siempre al final o mostrarlos siempre al principio. La ordenación resultante se muestra a la derecha de las cabeceras de columna del informe.</p>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_COMPUTATION',
  p_message_language => 'es',
  p_message_text => 'Expresión de cálculo no válida. %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MAX_X',
  p_message_language => 'es',
  p_message_text => 'Máximo %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_X_HOURS',
  p_message_language => 'es',
  p_message_text => 'Siguientes %0 Horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_YEAR',
  p_message_language => 'es',
  p_message_text => 'Año Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_OPERATOR',
  p_message_language => 'es',
  p_message_text => 'Operador');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PRIMARY',
  p_message_language => 'es',
  p_message_text => 'Primario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_ALL',
  p_message_language => 'es',
  p_message_text => 'Eliminar Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_DEFAULT_CONFIRM',
  p_message_language => 'es',
  p_message_text => 'Los valores de informe actuales se utilizarán como valores por defecto para todos los usuarios.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_VALUE',
  p_message_language => 'es',
  p_message_text => 'Seleccionar Valor');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SPACE_AS_IN_ONE_EMPTY_STRING',
  p_message_language => 'es',
  p_message_text => 'espacio');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TOP',
  p_message_language => 'es',
  p_message_text => 'Primero');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNIQUE_HIGHLIGHT_NAME',
  p_message_language => 'es',
  p_message_text => 'El nombre del resaltado debe ser único.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_WEEKLY',
  p_message_language => 'es',
  p_message_text => 'Semanal');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_HOURS',
  p_message_language => 'es',
  p_message_text => '%0 horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER.ICON_TEXT',
  p_message_language => 'es',
  p_message_text => 'Calendario Emergente: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_ALIAS_DOES_NOT_EXIST',
  p_message_language => 'es',
  p_message_text => 'El informe interactivo guardado con el alias %0 no existe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_DISPLAY_COLUMN_LIMIT_REACHED',
  p_message_language => 'es',
  p_message_text => 'El número de columnas de visualización del informe ha alcanzado el límite. Haga clic en Seleccionar Columnas en el menú Acciones para minimizar la lista de columnas de visualización del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_N',
  p_message_language => 'es',
  p_message_text => 'Columna %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CONTROL_BREAK_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Columnas de División de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_MAX_ROW_CNT',
  p_message_language => 'es',
  p_message_text => 'El recuento máximo de filas para una consulta de Agrupar por limita el número de filas de la consulta base, no el número de filas que se muestran. La consulta base supera el recuento máximo de filas de %0. Aplique un filtro para reducir el número de registros en la consulta base.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SAVED_REPORTS.PRIMARY.DEFAULT',
  p_message_language => 'es',
  p_message_text => 'Por Defecto Primario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT_TYPE',
  p_message_language => 'es',
  p_message_text => 'Tipo de Resaltado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.GO_TO_ERROR',
  p_message_language => 'es',
  p_message_text => 'Ir al error');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.PREVIOUS_SET',
  p_message_language => 'es',
  p_message_text => 'Juego Anterior');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MINUTES_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 minutos desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_FLOW_UTILITIES.CLOSE',
  p_message_language => 'es',
  p_message_text => 'Cerrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD',
  p_message_language => 'es',
  p_message_text => 'Agregar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BETWEEN',
  p_message_language => 'es',
  p_message_text => 'entre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Columnas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION',
  p_message_language => 'es',
  p_message_text => 'Cálculo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COUNT_DISTINCT_X',
  p_message_language => 'es',
  p_message_text => 'Recuento de los Valores Distintos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DAILY',
  p_message_language => 'es',
  p_message_text => 'Diario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DATA_AS_OF',
  p_message_language => 'es',
  p_message_text => 'Informar de datos de hace %0 minutos.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAY',
  p_message_language => 'es',
  p_message_text => 'Mostrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAYED',
  p_message_language => 'es',
  p_message_text => 'Mostrado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_ALTERNATIVE_DEFAULT',
  p_message_language => 'es',
  p_message_text => 'Editar Valor por Defecto Alternativo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_CHART2',
  p_message_language => 'es',
  p_message_text => 'Editar Gráfico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_HIGHLIGHT',
  p_message_language => 'es',
  p_message_text => 'Editar Resaltado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_SUBJECT',
  p_message_language => 'es',
  p_message_text => 'Asunto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ERROR',
  p_message_language => 'es',
  p_message_text => 'Error');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXPRESSION',
  p_message_language => 'es',
  p_message_text => 'Expresión');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GO',
  p_message_language => 'es',
  p_message_text => 'Ir');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP',
  p_message_language => 'es',
  p_message_text => 'Ayuda');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_AGGREGATE',
  p_message_language => 'es',
  p_message_text => 'Las agregaciones son cálculos matemáticos que se realizan en una columna. Las agregaciones se muestran detrás de cada división de control y, al final del informe, dentro de la columna en la que están definidos. Las opciones incluyen: 
<p> 
</p><ul> 
<li><b>Agregación</b> permite seleccionar una agregación definida previamente para editarla.</li> 
<li><b>Función</b> es la función que se debe ejecutar (por ejemplo, SUM, MIN).</li> 
<li><b>Columna</b> se utiliza para seleccionar la columna a la que se aplica la función matemática. Sólo se muestran las columnas numéricas.</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_CONTROL_BREAK',
  p_message_language => 'es',
  p_message_text => 'Se utiliza para crear un grupo divisorio en una o varias columnas. Obtiene las columnas del informe interactivo y las muestra como un registro maestro.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_RESET',
  p_message_language => 'es',
  p_message_text => 'Restablece los valores por defecto del informe eliminando todas las personalizaciones realizadas.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SAVE_REPORT',
  p_message_language => 'es',
  p_message_text => '<p>Guarda el informe personalizado para su uso en el futuro. Se proporcionan un nombre y una descripción opcional y el público (es decir, todos los usuarios con acceso al informe principal por defecto) podrá acceder al informe. Puede guardar cuatro tipos de informe interactivo:</p> 
<ul> 
<li><strong>Principal por Defecto</strong> (sólo desarrolladores). El informe principal por defecto es el primero que se muestra. No se puede cambiar el nombre de estos informes ni se pueden suprimir.</li> 
<li><strong>Informe Alternativo</strong> (sólo desarrolladores). Permite a los desarrolladores crear varios diseños de informe. Sólo los desarrolladores pueden guardar, cambiar el nombre o suprimir un informe alternativo.</li> 
<li><strong>Informe Público</strong> (usuario final). El usuario final que lo creó puede guardarlo, suprimirlo o cambiarle el nombre. Los demás usuarios pueden visualizarlo y guardar el diseño como otro informe.</li> 
<li><strong>Informe Privado</strong> (usuario final). Sólo el usuario que creó el informe puede visualizarlo, guardarlo, suprimirlo o cambiarle el nombre.</li> 
</ul> 
<p>Si guarda informes personalizados, se muestra un selector de informes en la barra de búsqueda a la izquierda del selector de filas (si está activada esta función).</p> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIDE_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Ocultar Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_WEEK',
  p_message_language => 'es',
  p_message_text => 'Semana Pasada');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MOVE',
  p_message_language => 'es',
  p_message_text => 'Mover');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MOVE_ALL',
  p_message_language => 'es',
  p_message_text => 'Mover Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEW_AGGREGATION',
  p_message_language => 'es',
  p_message_text => 'Nueva Agregación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_DAY',
  p_message_language => 'es',
  p_message_text => 'Día Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_END_DATE',
  p_message_language => 'es',
  p_message_text => '- Sin Fecha de Finalización -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NULLS_ALWAYS_FIRST',
  p_message_language => 'es',
  p_message_text => 'Valores Nulos Siempre al Principio');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PREVIOUS',
  p_message_language => 'es',
  p_message_text => 'Anterior');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PUBLIC',
  p_message_language => 'es',
  p_message_text => 'Público');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_DOES_NOT_EXIST',
  p_message_language => 'es',
  p_message_text => 'El informe no existe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RESET_CONFIRM',
  p_message_language => 'es',
  p_message_text => 'Restaure los valores por defecto del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_COLUMN',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Columna -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALID_COLOR',
  p_message_language => 'es',
  p_message_text => 'Introduzca un color válido.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALUE_REQUIRED',
  p_message_language => 'es',
  p_message_text => 'Valor Necesario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_DETAIL',
  p_message_language => 'es',
  p_message_text => 'Ver Detalle');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_GROUP_BY',
  p_message_language => 'es',
  p_message_text => 'Ver Grupo por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.SLIDER.VALUE_NOT_MULTIPLE_OF_STEP',
  p_message_language => 'es',
  p_message_text => '#LABEL# no es un múltiplo de %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.YES_NO.NO_LABEL',
  p_message_language => 'es',
  p_message_text => 'No');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_SORT',
  p_message_language => 'es',
  p_message_text => 'Agrupar por Ordenación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_FORMAT',
  p_message_language => 'es',
  p_message_text => '<p>El menú Formato permite personalizar la visualización del informe. 
Contiene los siguientes submenús:</p> 
<ul><li>Ordenar</li> 
<li>División de Control</li> 
<li>Resaltar</li> 
<li>Calcular</li> 
<li>Agregar</li> 
<li>Gráfico</li> 
<li>Agrupar por</li> 
<li>Girar</li> 
</ul> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT',
  p_message_language => 'es',
  p_message_text => 'Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_COLUMN_NOT_NULL',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar la columna dinámica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_MAX_ROW_CNT',
  p_message_language => 'es',
  p_message_text => 'El recuento máximo de filas para una consulta dinámica limita el número de filas de la consulta base, no el número de filas que se muestran. La consulta base supera el recuento máximo de filas de %0. Aplique un filtro para reducir el número de registros en la consulta base.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_DEFAULT_REPORT',
  p_message_language => 'es',
  p_message_text => 'Guardar Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DUPLICATE_PIVOT_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Columna dinámica duplicada. La lista de columna dinámica debe ser única.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_PIVOT_COLUMN',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Columna Dinámica -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'RESTORE',
  p_message_language => 'es',
  p_message_text => 'Restaurar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.SESSION_STATE.SSP_VIOLATION',
  p_message_language => 'es',
  p_message_text => 'Violación de la protección del estado de la sesión: Puede ser debida a una modificación manual de una dirección URL que contenga un total de control, que se haya utilizado un enlace con un total de control incorrecto o que no tenga ningún total de control. En caso de duda sobre el motivo de este error, póngase en contacto con el administrador de la aplicación para recibir ayuda.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.SESSION.EXPIRED',
  p_message_language => 'es',
  p_message_text => 'La sesión ha vencido');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_IN_THE_LAST',
  p_message_language => 'es',
  p_message_text => '%0 está en el último %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEW_CATEGORY',
  p_message_language => 'es',
  p_message_text => '- Nueva Categoría -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_COMPUTATION_DEFINED',
  p_message_language => 'es',
  p_message_text => 'Ningún cálculo definido.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORTS',
  p_message_language => 'es',
  p_message_text => 'Informes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_NOT_BETWEEN_MIN_MAX',
  p_message_language => 'es',
  p_message_text => '#LABEL# no está en el rango válido de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_NOT_BETWEEN_MIN_MAX',
  p_message_language => 'es',
  p_message_text => '#LABEL# no está en el rango válido de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_DAYS_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 días');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MONTHS_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 meses');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_SECONDS_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 segundos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_YEARS_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 años');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.X_Y_OF_MORE_THAN_Z',
  p_message_language => 'es',
  p_message_text => 'Fila(s) %0 - %1 de más de %2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.X_Y_OF_Z',
  p_message_language => 'es',
  p_message_text => 'Fila(s) %0 - %1 de %2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => '4150_COLUMN_NUMBER',
  p_message_language => 'es',
  p_message_text => 'Columna %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ACTIONS_MENU',
  p_message_language => 'es',
  p_message_text => 'Menú de Acciones');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_COUNT',
  p_message_language => 'es',
  p_message_text => 'Recuento');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ASCENDING',
  p_message_language => 'es',
  p_message_text => 'Ascendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_TYPE',
  p_message_language => 'es',
  p_message_text => 'Tipo de Gráfico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_CONTAINS',
  p_message_language => 'es',
  p_message_text => 'contiene');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_IN_NEXT',
  p_message_language => 'es',
  p_message_text => 'en siguientes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_NOT_IN',
  p_message_language => 'es',
  p_message_text => 'no en');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER',
  p_message_language => 'es',
  p_message_text => 'Cree un cálculo utilizando los alias de columna.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COUNT_DISTINCT',
  p_message_language => 'es',
  p_message_text => 'Recuento de los Valores Distintos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_CHECKED',
  p_message_language => 'es',
  p_message_text => 'Suprimir Selección');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_REPORT',
  p_message_language => 'es',
  p_message_text => 'Suprimir Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DIRECTION',
  p_message_language => 'es',
  p_message_text => 'Dirección %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DOWN',
  p_message_language => 'es',
  p_message_text => 'Abajo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_FILTER',
  p_message_language => 'es',
  p_message_text => 'Editar Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL',
  p_message_language => 'es',
  p_message_text => 'Correo Electrónico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ENABLED',
  p_message_language => 'es',
  p_message_text => 'Activado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FORMAT_MASK',
  p_message_language => 'es',
  p_message_text => 'Máscara de Formato %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTION',
  p_message_language => 'es',
  p_message_text => 'Función');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HCOLUMN',
  p_message_language => 'es',
  p_message_text => 'Columna Horizontal');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_X_HOURS',
  p_message_language => 'es',
  p_message_text => 'Últimas %0 Horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_WEEK',
  p_message_language => 'es',
  p_message_text => 'Semana Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO',
  p_message_language => 'es',
  p_message_text => 'No');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NUMERIC_SEQUENCE',
  p_message_language => 'es',
  p_message_text => 'La secuencia debe ser numérica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_TOTAL_COUNT',
  p_message_language => 'es',
  p_message_text => 'Porcentaje de Recuento Total');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RENAME_REPORT',
  p_message_language => 'es',
  p_message_text => 'Cambiar Nombre del Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_ORDER',
  p_message_language => 'es',
  p_message_text => 'Orden de Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVED_REPORT',
  p_message_language => 'es',
  p_message_text => 'Informe Guardado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_REPORT',
  p_message_language => 'es',
  p_message_text => 'Guardar Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Seleccionar Columnas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_STATUS',
  p_message_language => 'es',
  p_message_text => 'Estado %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUM_X',
  p_message_language => 'es',
  p_message_text => 'Suma de %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_WEEKS',
  p_message_language => 'es',
  p_message_text => 'semanas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNIQUE_COLUMN_HEADING',
  p_message_language => 'es',
  p_message_text => 'La cabecera de columna debe ser única.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UP',
  p_message_language => 'es',
  p_message_text => 'Arriba');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALUE_AXIS_TITLE',
  p_message_language => 'es',
  p_message_text => 'Título del Eje para Valor');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_CHART',
  p_message_language => 'es',
  p_message_text => 'Ver Gráfico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.AUTHENTICATION.LOGIN_THROTTLE.ERROR',
  p_message_language => 'es',
  p_message_text => 'El intento de conexión se ha bloqueado.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_FILTER_QUERY',
  p_message_language => 'es',
  p_message_text => 'Consulta de filtro no válida');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LABEL_PREFIX',
  p_message_language => 'es',
  p_message_text => 'Prefijo de Etiqueta');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_AGG_NOT_NULL',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar el agregado.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RENAME_DEFAULT_REPORT',
  p_message_language => 'es',
  p_message_text => 'Cambiar Nombre de Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_FILTER',
  p_message_language => 'es',
  p_message_text => 'Filtrar...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_MONTHS',
  p_message_language => 'es',
  p_message_text => '%0 meses');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'OUT_OF_RANGE',
  p_message_language => 'es',
  p_message_text => 'Se ha solicitado un juego de filas no válido, los datos de origen del informe se han modificado.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LABEL',
  p_message_language => 'es',
  p_message_text => 'Etiqueta %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_HOUR',
  p_message_language => 'es',
  p_message_text => 'Última Hora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_X_DAYS',
  p_message_language => 'es',
  p_message_text => 'Últimos %0 Días');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_GREATER_MAX_DATE',
  p_message_language => 'es',
  p_message_text => '#LABEL# es posterior a la fecha máxima especificada %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_INVALID',
  p_message_language => 'es',
  p_message_text => '#LABEL# debe ser numérico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'FLOW.VALIDATION_ERROR',
  p_message_language => 'es',
  p_message_text => 'Se han producido %0 errores');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.NEXT',
  p_message_language => 'es',
  p_message_text => 'Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_HOURS_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 horas desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MONTHS_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 meses desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_NOW',
  p_message_language => 'es',
  p_message_text => 'Ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_WEEKS_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 semanas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'TOTAL',
  p_message_language => 'es',
  p_message_text => 'Total');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.FOUND_BUT_NOT_DISPLAYED',
  p_message_language => 'es',
  p_message_text => 'Mínimo de filas solicitadas: %0, filas encontradas pero no mostradas: %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.SORT_BY_THIS_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Ordenar por esta columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.UNSAVED_DATA',
  p_message_language => 'es',
  p_message_text => 'Esta pantalla contiene cambios no guardados. Pulse "Aceptar" para continuar sin guardar los cambios.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGGREGATION',
  p_message_language => 'es',
  p_message_text => 'Agregación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_SUM',
  p_message_language => 'es',
  p_message_text => 'Suma de %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AVERAGE_X',
  p_message_language => 'es',
  p_message_text => 'Media de %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CANCEL',
  p_message_language => 'es',
  p_message_text => 'Cancelar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CATEGORY',
  p_message_language => 'es',
  p_message_text => 'Categoría');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER_E2',
  p_message_language => 'es',
  p_message_text => 'INITCAP(B)||'', ''||INITCAP(C)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISABLED',
  p_message_language => 'es',
  p_message_text => 'Desactivado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAY_IN_REPORT',
  p_message_language => 'es',
  p_message_text => 'Mostrar en Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_NOT_CONFIGURED',
  p_message_language => 'es',
  p_message_text => 'El correo electrónico no se ha configurado para esta aplicación. Póngase en contacto con el administrador.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXAMPLES',
  p_message_language => 'es',
  p_message_text => 'Ejemplos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GREEN',
  p_message_language => 'es',
  p_message_text => 'verde');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_DOWNLOAD',
  p_message_language => 'es',
  p_message_text => 'Permite descargar el juego de resultados actual. Los formatos de 
 descarga son diferentes según la instalación y la definición del 
 informe pero pueden ser CSV, HTML, Correo Electrónico, XLS, PDF 
 o RTF.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_FLASHBACK',
  p_message_language => 'es',
  p_message_text => 'Las consultas de flashback permiten visualizar los datos tal como existían en un punto en el tiempo anterior. El tiempo por defecto en el que se puede realizar la operación de flashback es 3 horas (o 180 minutos) aunque el tiempo real es diferente según la base de datos.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_REPORT_SETTINGS',
  p_message_language => 'es',
  p_message_text => 'Si personaliza un informe interactivo, la configuración del informe se mostrará 
debajo de la barra de búsqueda y encima del informe. Esta área se puede reducir y ampliar mediante el icono de la izquierda. 
<p> 
En cada configuración de informe, puede hacer lo siguiente: 
</p><ul> 
<li>Editar un valor haciendo clic en el nombre.</li> 
<li>Desactivar/activar un valor marcando o anulando la marca de la casilla de control Activar/Desactivar. Se utiliza para desactivar y activar temporalmente el valor.</li> 
<li>Eliminar un valor haciendo clic en el icono Eliminar.</li> 
</ul> 
<p>Si ha creado un gráfico, una ordenación por grupos o elemento dinámico, puede cambiar entre ellos 
y el informe base con los enlaces Vista de Informe, Vista de Gráfico, Vista Agrupar por y Vista Dinámica por 
que se muestran a la derecha. Si está visualizando el gráfico, la ordenación por grupos o elemento dinámico, también 
puede utilizar el enlace Editar para editar la configuración.</p> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_NOT_IN_THE_NEXT',
  p_message_language => 'es',
  p_message_text => '%0 no está en el siguiente %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LABEL_AXIS_TITLE',
  p_message_language => 'es',
  p_message_text => 'Título del Eje para Etiqueta');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_DAY',
  p_message_language => 'es',
  p_message_text => 'Último Día');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MONTH',
  p_message_language => 'es',
  p_message_text => 'Mes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MORE_DATA',
  p_message_language => 'es',
  p_message_text => 'Más Datos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT',
  p_message_language => 'es',
  p_message_text => 'Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_X_DAYS',
  p_message_language => 'es',
  p_message_text => 'Siguientes %0 Días');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NULL_SORTING',
  p_message_language => 'es',
  p_message_text => 'Ordenación de Valores Nulos %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_OTHER',
  p_message_language => 'es',
  p_message_text => 'Otro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_FLASHBACK',
  p_message_language => 'es',
  p_message_text => 'Eliminar Flashback');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_HIGHLIGHT',
  p_message_language => 'es',
  p_message_text => 'Eliminar Resaltado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROWS_PER_PAGE',
  p_message_language => 'es',
  p_message_text => 'Filas por Página');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE',
  p_message_language => 'es',
  p_message_text => 'Guardar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVED_REPORT_MSG',
  p_message_language => 'es',
  p_message_text => 'Informe Guardado = "%0"');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_COLUMNS_FOOTER',
  p_message_language => 'es',
  p_message_text => 'Las columnas calculadas tienen el prefijo **.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_MONTHS',
  p_message_language => 'es',
  p_message_text => 'meses');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALUE',
  p_message_language => 'es',
  p_message_text => 'Valor');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VCOLUMN',
  p_message_language => 'es',
  p_message_text => 'Columna Vertical');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_ICONS',
  p_message_language => 'es',
  p_message_text => 'Ver Iconos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_WORKING_REPORT',
  p_message_language => 'es',
  p_message_text => 'Informe de Trabajo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_YES',
  p_message_language => 'es',
  p_message_text => 'Sí');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'LAYOUT.T_CONDITION_EXPR2',
  p_message_language => 'es',
  p_message_text => 'Expresión 2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.YES_NO.YES_LABEL',
  p_message_language => 'es',
  p_message_text => 'Sí');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_PIVOT',
  p_message_language => 'es',
  p_message_text => 'Puede definir una vista dinámica por informe guardado. Una vez definidas, puede cambiar entre las vistas dinámicas y de informe utilizando los iconos de vista que se encuentran en la barra de búsqueda. Para crear una vista dinámica, se seleccionan:  
<p></p> 
<ul> 
<li>las columnas sobre las que girar</li> 
<li>las columnas que mostrar como filas</li> 
<li>las columnas que agregar junto con la función que se va a realizar (media, suma, recuento, etc.)</li> 
</ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_FINDER',
  p_message_language => 'es',
  p_message_text => '<li>El icono <b>Seleccionar Columnas</b> permite identificar en qué columnas buscar (o si desea hacerlo en todas).</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_REPORTS',
  p_message_language => 'es',
  p_message_text => '<li><b>Informes</b> muestra informes privados o públicos por defecto o guardados de forma alterna.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_END_DATE',
  p_message_language => 'es',
  p_message_text => 'La fecha de finalización debe ser posterior a la fecha de inicio.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COL_DIFF_FROM_PIVOT_COL',
  p_message_language => 'es',
  p_message_text => 'La columna de fila debe ser diferente a la columna dinámica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RPT_DISP_COL_EXCEED',
  p_message_language => 'es',
  p_message_text => 'El número de columnas de visualización del informe ha alcanzado el límite. Haga clic en Seleccionar Columnas en el menú Acciones para minimizar la lista de columnas de visualización del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Buscar: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_FUNCTION',
  p_message_language => 'es',
  p_message_text => 'Agregar Función');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_GROUP_BY_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Agregar Grupo por Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALL_ROWS',
  p_message_language => 'es',
  p_message_text => 'Todas las Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_REQUIRED',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar la dirección de correo electrónico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_ROW_COLUMN',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Columna de Fila -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUBSCRIPTION',
  p_message_language => 'es',
  p_message_text => 'Suscripción');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_YEAR',
  p_message_language => 'es',
  p_message_text => 'Año');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'IR_AS_DEFAULT_REPORT_SETTING',
  p_message_language => 'es',
  p_message_text => 'Como Valores de Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_GROUP_BY',
  p_message_language => 'es',
  p_message_text => 'Puede definir una vista Agrupar por, por informe guardado. 
Una vez se ha definido, puede cambiar entre las vistas de agrupación e informe 
mediante los iconos de vista que se encuentran en la barra de búsqueda. Para crear una vista Agrupar por, 
seleccione: 
<p></p><ul> 
<li>las columnas en las que realizar la agrupación</li>, 
<li>las columnas para agregar, junto con la función que se va a realizar (media, suma, recuento, etc.)</li> 
</ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_ROWS_PER_PAGE',
  p_message_language => 'es',
  p_message_text => 'Define el número de registros que se mostrarán por página.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WELCOME_USER',
  p_message_language => 'es',
  p_message_text => 'Bienvenido: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.X_Y_OF_Z_2',
  p_message_language => 'es',
  p_message_text => '%0 - %1 de %2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MONTHLY',
  p_message_language => 'es',
  p_message_text => 'Mensual');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ORANGE',
  p_message_language => 'es',
  p_message_text => 'naranja');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATA_HAS_CHANGED',
  p_message_language => 'es',
  p_message_text => 'La versión actual de los datos de la base de datos ha cambiado desde que el usuario inició el proceso de actualización. identificador de versión de fila actual = "%0" identificador de versión de fila de aplicación = "%1"');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'FLOW.SINGLE_VALIDATION_ERROR',
  p_message_language => 'es',
  p_message_text => 'Se ha producido 1 error');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_WEEKS_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 semanas desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGGREGATE',
  p_message_language => 'es',
  p_message_text => 'Agregar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CALENDAR',
  p_message_language => 'es',
  p_message_text => 'Calendario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CELL',
  p_message_language => 'es',
  p_message_text => 'Celda');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_INITIALIZING',
  p_message_language => 'es',
  p_message_text => 'Inicializando...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_ISNOT_IN_NEXT',
  p_message_language => 'es',
  p_message_text => 'no en siguientes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER_E3',
  p_message_language => 'es',
  p_message_text => 'CASE WHEN A = 10 THEN B + C ELSE B END');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_CONFIRM',
  p_message_language => 'es',
  p_message_text => '¿Desea suprimir estos valores del informe?');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISABLE',
  p_message_language => 'es',
  p_message_text => 'Desactivar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DO_NOT_DISPLAY',
  p_message_language => 'es',
  p_message_text => 'No Mostrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_SEE_ATTACHED',
  p_message_language => 'es',
  p_message_text => 'Consulte adjuntos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ENABLE_DISABLE_ALT',
  p_message_language => 'es',
  p_message_text => 'Activar/Desactivar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTER',
  p_message_language => 'es',
  p_message_text => 'Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FLASHBACK',
  p_message_language => 'es',
  p_message_text => 'Flashback');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTIONS',
  p_message_language => 'es',
  p_message_text => 'Funciones %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_DETAIL_VIEW',
  p_message_language => 'es',
  p_message_text => 'Para visualizar los detalles de una sola fila cada vez, haga clic en el icono de vista de una sola fila correspondiente a la fila que desea visualizar. Si está disponible, la vista de una sola fila siempre estará en la primera columna. Según la personalización del informe interactivo, la vista de una sola fila puede ser la vista estándar o una página personalizada que se puede actualizar.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_FILTER',
  p_message_language => 'es',
  p_message_text => 'Delimita el informe mediante la adición o modificación de la cláusula WHERE de la consulta. Puede filtrar por columna o por fila. 
<p/> 
Si filtra por columna, seleccione primero una columna (no tiene que ser la mostrada), seleccione un operador estándar de Oracle (=, !=, no en, entre) y, a continuación, introduzca una expresión con la que realizar la comparación. Las expresiones son sensibles a mayúsculas/minúsculas. Utilice % como comodín (por ejemplo, <code>STATE_NAME 
like A%)</code>.</p> 
<p>Si filtra por fila, puede crear cláusulas WHERE complejas con alias de columna y cualquier función u operador de Oracle (por ejemplo, <code>G = ''VA'' o G = ''CT''</code>, donde <code>G</code> es el alias de CUSTOMER_STATE).</p> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SELECT_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Se utiliza para modificar las columnas mostradas. Se muestran las columnas de la derecha. Las columnas de la izquierda permanecen ocultas. Puede volver a ordenar las columnas mostradas mediante las flechas que hay más a la derecha. Las columnas calculadas tienen el prefijo <b>**</b>.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_NOT_IN_THE_LAST',
  p_message_language => 'es',
  p_message_text => '%0 no está en el último %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_X_YEARS',
  p_message_language => 'es',
  p_message_text => 'Últimos %0 Años');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LINE',
  p_message_language => 'es',
  p_message_text => 'Línea');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MEDIAN_X',
  p_message_language => 'es',
  p_message_text => 'Mediana %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIE',
  p_message_language => 'es',
  p_message_text => 'Tarta');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_OF',
  p_message_language => 'es',
  p_message_text => 'Fila %0 de %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_SORT_COLUMN',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Columna de Ordenación -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNSUPPORTED_DATA_TYPE',
  p_message_language => 'es',
  p_message_text => 'tipo de dato no soportado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_REPORT',
  p_message_language => 'es',
  p_message_text => 'Ver Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_MINS',
  p_message_language => 'es',
  p_message_text => '%0 minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_YELLOW',
  p_message_language => 'es',
  p_message_text => 'amarillo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'IR_AS_NAMED_REPORT',
  p_message_language => 'es',
  p_message_text => 'Como Informe con Nombre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.AUTHENTICATION.LOGIN_THROTTLE.COUNTER',
  p_message_language => 'es',
  p_message_text => 'Espere <span id="apex_login_throttle_sec">%0</span> segundos para volver a conectarse.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_TEXTBOX',
  p_message_language => 'es',
  p_message_text => '<li>El <b>área de texto</b> permite utilizar criterios de búsqueda que no sean sensibles a mayúsculas/minúsculas (se permite el uso de comodines).</li> 
<li>El <b>botón Ir</b> ejecuta la búsqueda. Al pulsar la tecla Intro, también se ejecutará la búsqueda si el cursor está en el área de texto de búsqueda.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_VIEW',
  p_message_language => 'es',
  p_message_text => '<li><b>Iconos de Visualización</b> cambia entre la vista de icono, informe, detallada, gráfico, agrupar por y dinámica del informe si se han definido.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NOT_VALID_EMAIL',
  p_message_language => 'es',
  p_message_text => 'Dirección de correo electrónico no válida.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Columnas Dinámicas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_GROUP_BY_COLUMN',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Grupo por Columna -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_PIVOT_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Agregar Columna Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_ROW_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Agregar Columna de Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_LABEL_NOT_NULL',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar la etiqueta de gráfico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_EXPRESSION',
  p_message_language => 'es',
  p_message_text => 'Expresión de Cálculo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNGROUPED_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Columna sin Agrupación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_DAYS',
  p_message_language => 'es',
  p_message_text => '%0 días');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'REPORT',
  p_message_language => 'es',
  p_message_text => 'Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'RESET',
  p_message_language => 'es',
  p_message_text => 'Restablecer Paginación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RESET',
  p_message_language => 'es',
  p_message_text => 'Restablecer');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_LESS_MIN_DATE',
  p_message_language => 'es',
  p_message_text => '#LABEL# es anterior a la fecha mínima especificada %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_NOT_IN_YEAR_RANGE',
  p_message_language => 'es',
  p_message_text => '#LABEL# no está en el rango válido de año de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_GREATER_MAX_VALUE',
  p_message_language => 'es',
  p_message_text => '#LABEL# es mayor que el máximo especificado de %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_INVALID2',
  p_message_language => 'es',
  p_message_text => '#LABEL# no coincide con el formato numérico %0 (Ejemplo: %1).');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.PAGE_ITEM_IS_REQUIRED',
  p_message_language => 'es',
  p_message_text => '#LABEL# debe tener algún valor.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'REPORT_TOTAL',
  p_message_language => 'es',
  p_message_text => 'Total de Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_HOURS_AGO',
  p_message_language => 'es',
  p_message_text => 'Hace %0 horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_YEARS_FROM_NOW',
  p_message_language => 'es',
  p_message_text => '%0 años desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGGREGATE_DESCRIPTION',
  p_message_language => 'es',
  p_message_text => 'Las agregaciones se muestran detrás de cada división de control y al final del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MIN',
  p_message_language => 'es',
  p_message_text => 'Mínimo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AND',
  p_message_language => 'es',
  p_message_text => 'y');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BLUE',
  p_message_language => 'es',
  p_message_text => 'azul');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_DOESNOT_CONTAIN',
  p_message_language => 'es',
  p_message_text => 'no contiene');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_LIKE',
  p_message_language => 'es',
  p_message_text => 'igual');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTE',
  p_message_language => 'es',
  p_message_text => 'Calcular');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COUNT_X',
  p_message_language => 'es',
  p_message_text => 'Recuento %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DATE',
  p_message_language => 'es',
  p_message_text => 'Fecha');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_GROUP_BY',
  p_message_language => 'es',
  p_message_text => 'Editar Grupo por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_FREQUENCY',
  p_message_language => 'es',
  p_message_text => 'Frecuencia');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXCLUDE_NULL',
  p_message_language => 'es',
  p_message_text => 'Excluir Valores Nulos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_HIGHLIGHT',
  p_message_language => 'es',
  p_message_text => '<p>Permite definir un filtro. Las filas que cumplen los criterios de filtro se resaltan según las características asociadas al filtro. Las opciones incluyen:</p> 
<ul> 
<li><b>Nombre</b> sólo se utiliza para la visualización.</li> 
<li><b>Secuencia</b> identifica la secuencia en la que se evaluarán las reglas.</li> 
<li><b>Activado</b> identifica si la regla está activada o desactivada.</li> 
<li><b>Tipo de Resaltado</b> identifica si la fila o la celda debe estar resaltada. Si se selecciona Celda, se resalta la columna a la que se hace referencia en Condición para Resaltar.</li> 
<li><b>Color de Fondo</b> es el nuevo color para el fondo del área resaltada.</li> 
<li><b>Color del Texto</b> es el nuevo color para el texto del área resaltada.</li> 
<li><b>Condición para Resaltar</b> define la condición del filtro.</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT',
  p_message_language => 'es',
  p_message_text => 'Resaltar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_MONTH',
  p_message_language => 'es',
  p_message_text => 'Mes Pasado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_YEAR',
  p_message_language => 'es',
  p_message_text => 'Año Pasado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MIN_AGO',
  p_message_language => 'es',
  p_message_text => '%0 minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEW_COMPUTATION',
  p_message_language => 'es',
  p_message_text => 'Nuevo Cálculo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_HOUR',
  p_message_language => 'es',
  p_message_text => 'Hora Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_COLUMN_INFO',
  p_message_language => 'es',
  p_message_text => 'No hay información de columna disponible.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NUMERIC_FLASHBACK_TIME',
  p_message_language => 'es',
  p_message_text => 'El tiempo de flashback debe ser un valor numérico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RED',
  p_message_language => 'es',
  p_message_text => 'rojo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_FILTER',
  p_message_language => 'es',
  p_message_text => 'Eliminar Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT',
  p_message_language => 'es',
  p_message_text => 'Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW',
  p_message_language => 'es',
  p_message_text => 'Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROWS',
  p_message_language => 'es',
  p_message_text => 'Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_TEXT_CONTAINS',
  p_message_language => 'es',
  p_message_text => 'El texto de la fila contiene');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH_BAR',
  p_message_language => 'es',
  p_message_text => 'Barra de Búsqueda');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_FUNCTION',
  p_message_language => 'es',
  p_message_text => '- Seleccionar Función -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_COLUMN',
  p_message_language => 'es',
  p_message_text => 'Columna de Ordenación %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_DESCENDING',
  p_message_language => 'es',
  p_message_text => 'Orden Descendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TEXT_COLOR',
  p_message_language => 'es',
  p_message_text => 'Color del Texto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_MINS',
  p_message_language => 'es',
  p_message_text => 'minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNAUTHORIZED',
  p_message_language => 'es',
  p_message_text => 'No Autorizado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.POPUP_LOV.ICON_TEXT',
  p_message_language => 'es',
  p_message_text => 'Lista de Valores Emergente: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.REGION.JQM_LIST_VIEW.SEARCH',
  p_message_language => 'es',
  p_message_text => 'Buscar...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_COL_NOT_NULL',
  p_message_language => 'es',
  p_message_text => 'Se debe especificar la columna Agrupar por.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_SORT_ORDER',
  p_message_language => 'es',
  p_message_text => 'Agrupar por Orden de Clasificación');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_ACTIONS_MENU',
  p_message_language => 'es',
  p_message_text => '<li>El <b>menú Acciones</b> permite actualizar un informe. Consulte las siguientes secciones.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SUBSCRIPTION',
  p_message_language => 'es',
  p_message_text => 'Al agregar una suscripción, proporciona una dirección (o varias separadas por comas) y el asunto del correo electrónico, la frecuencia y las fechas de inicio y fin. Los correos electrónicos resultantes incluyen una versión HTML del informe interactivo que contiene los datos actuales utilizando la configuración de informe que existía al agregar la suscripción.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INACTIVE_SETTING',
  p_message_language => 'es',
  p_message_text => '1 valor inactivo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_COLUMN_N',
  p_message_language => 'es',
  p_message_text => 'Columna Dinámica %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COLUMN_N',
  p_message_language => 'es',
  p_message_text => 'Columna de Fila %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_FILTER',
  p_message_language => 'es',
  p_message_text => 'Filtro de Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHECK_ALL',
  p_message_language => 'es',
  p_message_text => 'Activar Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECTED_COLUMNS',
  p_message_language => 'es',
  p_message_text => 'Columnas Seleccionadas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TOGGLE',
  p_message_language => 'es',
  p_message_text => 'Conmutar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_FILTER',
  p_message_language => 'es',
  p_message_text => 'Expresión de filtro no válida. %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.CLOSE_NOTIFICATION',
  p_message_language => 'es',
  p_message_text => 'Notificación de Cierre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'MAXIMIZE',
  p_message_language => 'es',
  p_message_text => 'Maximizar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.SESSION.EXPIRED.NEW_SESSION',
  p_message_language => 'es',
  p_message_text => 'Haga clic <a href="%0">aquí</a> para crear una nueva sesión.');



COMMIT; END;
/
