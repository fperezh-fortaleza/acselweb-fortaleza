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
    
DECLARE
  v_workspace_name VARCHAR2(100) := 'ws_francisco'; -- APEX Workspace Name
  v_app_id NUMBER := 107; -- APEX Application ID
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
  p_message_language => 'es-bo',
  p_message_text => 'Per�odo del Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_X_YEARS',
  p_message_language => 'es-bo',
  p_message_text => 'Siguientes %0 A�os');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.FILE_BROWSE.DOWNLOAD_LINK_TEXT',
  p_message_language => 'es-bo',
  p_message_text => 'Descargar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'INVALID_CREDENTIALS',
  p_message_language => 'es-bo',
  p_message_text => 'Credenciales de conexi�n no V�lidas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.NEXT_SET',
  p_message_language => 'es-bo',
  p_message_text => 'Juego Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.PREVIOUS',
  p_message_language => 'es-bo',
  p_message_text => 'Anterior');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MINUTES_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_SECONDS_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 segundos desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_3D',
  p_message_language => 'es-bo',
  p_message_text => '3D');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_SUBSCRIPTION',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar Suscripci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_AVG',
  p_message_language => 'es-bo',
  p_message_text => 'Media');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BGCOLOR',
  p_message_language => 'es-bo',
  p_message_text => 'Color de Fondo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CLEAR',
  p_message_language => 'es-bo',
  p_message_text => 'borrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IN',
  p_message_language => 'es-bo',
  p_message_text => 'en');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_IN_LAST',
  p_message_language => 'es-bo',
  p_message_text => 'en �ltimos(as)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_NOT_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'no es nulo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'es nulo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_REGEXP_LIKE',
  p_message_language => 'es-bo',
  p_message_text => 'coincide con expresi�n regular');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DEFAULT_REPORT_TYPE',
  p_message_language => 'es-bo',
  p_message_text => 'Tipo de Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DO_NOT_AGGREGATE',
  p_message_language => 'es-bo',
  p_message_text => '- No Agregar -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_CHART',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Valores de Gr�fico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_ADDRESS',
  p_message_language => 'es-bo',
  p_message_text => 'Direcci�n de Correo Electr�nico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_BCC',
  p_message_language => 'es-bo',
  p_message_text => 'Cco');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXPAND_COLLAPSE_ALT',
  p_message_language => 'es-bo',
  p_message_text => 'Ampliar/Reducir');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTER_EXPRESSION',
  p_message_language => 'es-bo',
  p_message_text => 'Expresi�n de Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTERS',
  p_message_language => 'es-bo',
  p_message_text => 'Filtros');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTIONS_OPERATORS',
  p_message_language => 'es-bo',
  p_message_text => 'Funciones/Operadores');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_01',
  p_message_language => 'es-bo',
  p_message_text => 'Las regiones de informes interactivos permiten que los usuarios finales personalicen los informes. Los usuarios pueden alterar el dise�o de los datos del informe seleccionando columnas, aplicando filtros, resaltando y ordenando. Tambi�n pueden definir saltos de l�nea, agregaciones, gr�ficos, organizaciones por grupos y sus propios c�lculos. Tambi�n se puede definir una suscripci�n para que envi� por correo electr�nico el informe en versi�n HTML con intervalos de tiempo designados. Los usuarios pueden crear m�ltiples variaciones del informe y guardarlas como informes con nombre, para visualizaci�n p�blica o privada. 
<p/> 
Las secciones siguientes ofrecen un resumen de los modos de personalizar un informe interactivo. Para obtener m�s informaci�n, consulte la secci�n sobre el uso de informes interactivos en <a href="http://www.oracle.com/pls/topic/lookup?ctx=E37097_01&id=AEEUG453" target="_blank"><i>Oracle Application Express End User''s Guide</i></a>.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHTS',
  p_message_language => 'es-bo',
  p_message_text => 'Resaltados');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT_WHEN',
  p_message_language => 'es-bo',
  p_message_text => 'Resaltar Cuando');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID',
  p_message_language => 'es-bo',
  p_message_text => 'No V�lido');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_IN_THE_NEXT',
  p_message_language => 'es-bo',
  p_message_text => '%0 est� en el siguiente %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_KEYPAD',
  p_message_language => 'es-bo',
  p_message_text => 'Teclado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MAX_ROW_CNT',
  p_message_language => 'es-bo',
  p_message_text => 'El recuento m�ximo de filas de este informe es %0 filas. Aplique un filtro para reducir el n�mero de registros de la consulta.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_AGGREGATION_DEFINED',
  p_message_language => 'es-bo',
  p_message_text => 'Ninguna agregaci�n definida.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NULLS_ALWAYS_LAST',
  p_message_language => 'es-bo',
  p_message_text => 'Valores Nulos Siempre al Final');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_OF_TOTAL_COUNT_X',
  p_message_language => 'es-bo',
  p_message_text => 'Porcentaje de Recuento Total %0 (%)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PRIMARY_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Informe Primario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_AS_DEFAULT',
  p_message_language => 'es-bo',
  p_message_text => 'Guardar como Valores por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH',
  p_message_language => 'es-bo',
  p_message_text => 'Buscar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Buscar Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_CATEGORY',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Categor�a -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_ASCENDING',
  p_message_language => 'es-bo',
  p_message_text => 'Orden Ascendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUBSCRIPTION_ENDING',
  p_message_language => 'es-bo',
  p_message_text => 'Terminando');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_DAYS',
  p_message_language => 'es-bo',
  p_message_text => 'd�as');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_HOURS',
  p_message_language => 'es-bo',
  p_message_text => 'horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_YEARS',
  p_message_language => 'es-bo',
  p_message_text => 'a�os');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALID_FORMAT_MASK',
  p_message_language => 'es-bo',
  p_message_text => 'Introduzca una mascara de formato v�lida.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_WEEK',
  p_message_language => 'es-bo',
  p_message_text => 'Semana');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_WEEKS',
  p_message_language => 'es-bo',
  p_message_text => '%0 semanas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'IR_STAR',
  p_message_language => 'es-bo',
  p_message_text => 'S�lo se muestra a los desarrolladores');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.SLIDER.VALUE_NOT_BETWEEN_MIN_MAX',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no est� en el rango v�lido de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.REGION.JQM_LIST_VIEW.LOAD_MORE',
  p_message_language => 'es-bo',
  p_message_text => 'Cargar M�s...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTION_N',
  p_message_language => 'es-bo',
  p_message_text => 'Funci�n %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INACTIVE_SETTINGS',
  p_message_language => 'es-bo',
  p_message_text => '%0 valores inactivos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_SETTING',
  p_message_language => 'es-bo',
  p_message_text => '1 valor no v�lido');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_SETTINGS',
  p_message_language => 'es-bo',
  p_message_text => '%0 valores no v�lidos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_AGG_NOT_ON_ROW_COL',
  p_message_language => 'es-bo',
  p_message_text => 'No puede agregar en una columna que se ha seleccionado como columna de fila.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_SORT',
  p_message_language => 'es-bo',
  p_message_text => 'Ordenaci�n Din�mica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_CHART',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Gr�fico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COLUMN_NOT_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar la columna de fila.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_REPORT_DEFAULT',
  p_message_language => 'es-bo',
  p_message_text => 'Guardar Informe *');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_MAX_ROW_CNT',
  p_message_language => 'es-bo',
  p_message_text => 'El recuento m�ximo de filas para una consulta de Gr�fico limita el n�mero de filas de la consulta base, no el numero de filas que se muestran. La consulta base supera el recuento m�ximo de filas de %0. Aplique un filtro para reducir el n�mero de registros en la consulta base.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT',
  p_message_language => 'es-bo',
  p_message_text => 'Editar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_PIVOT',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Din�mica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_SUBJECT_REQUIRED',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar el asunto del correo electr�nico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_ROW',
  p_message_language => 'es-bo',
  p_message_text => 'Seleccionar Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEND',
  p_message_language => 'es-bo',
  p_message_text => 'Enviar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MAX_QUERY_COST',
  p_message_language => 'es-bo',
  p_message_text => 'Se estima que la consulta supera el m�ximo de recursos permitidos. Modifique los valores del informe y vuelva a intentarlo.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NAME',
  p_message_language => 'es-bo',
  p_message_text => 'Nombre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NONE',
  p_message_language => 'es-bo',
  p_message_text => '- Ninguno -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_OF_TOTAL_SUM_X',
  p_message_language => 'es-bo',
  p_message_text => 'Porcentaje de Suma Total %0 (%)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PRIVATE',
  p_message_language => 'es-bo',
  p_message_text => 'Privado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_CONTROL_BREAK',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Divisi�n de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ACTIONS',
  p_message_language => 'es-bo',
  p_message_text => 'Acciones');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MODE',
  p_message_language => 'es-bo',
  p_message_text => 'Modo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALL',
  p_message_language => 'es-bo',
  p_message_text => 'Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_APPLY',
  p_message_language => 'es-bo',
  p_message_text => 'Aplicar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BOTTOM',
  p_message_language => 'es-bo',
  p_message_text => '�ltimo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART',
  p_message_language => 'es-bo',
  p_message_text => 'Gr�fico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_HEADING',
  p_message_language => 'es-bo',
  p_message_text => 'Cabecera de Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_INFO',
  p_message_language => 'es-bo',
  p_message_text => 'Informaci�n de la Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER_E1',
  p_message_language => 'es-bo',
  p_message_text => '(B+C)*100');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DAY',
  p_message_language => 'es-bo',
  p_message_text => 'D�a ');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE',
  p_message_language => 'es-bo',
  p_message_text => 'Suprimir');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAYED_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Columnas Mostradas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_CC',
  p_message_language => 'es-bo',
  p_message_text => 'Cc');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ENABLE',
  p_message_language => 'es-bo',
  p_message_text => 'Activar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXAMPLES_WITH_COLON',
  p_message_language => 'es-bo',
  p_message_text => 'Ejemplos:');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTER_TYPE',
  p_message_language => 'es-bo',
  p_message_text => 'Tipo de Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FINDER_ALT',
  p_message_language => 'es-bo',
  p_message_text => 'Seleccionar Columnas a Buscar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FORMAT',
  p_message_language => 'es-bo',
  p_message_text => 'Formato');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Agrupar por Columna %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_ACTIONS_MENU',
  p_message_language => 'es-bo',
  p_message_text => 'El men� Acciones aparece a la derecha del bot�n Ir en la barra de b�squeda. Utilice este men� para personalizar un informe interactivo.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_COLUMN_HEADING_MENU',
  p_message_language => 'es-bo',
  p_message_text => 'Al hacer clic en cualquier cabecera de columna, se muestra un men� de cabecera de columna con las siguientes opciones: 
<p></p> 
<ul> 
<li><b>El icono <b>Orden Ascendente</b> ordena el informe seg�n la columna en orden ascendente.</li> 
<li>El icono <b>Orden Descendente</b> ordena el informe seg�n la columna en orden descendente.</li> 
<li><b>Ocultar Columna</b> oculta la columna. No todas las columnas se pueden ocultar. Si una columna no se puede ocultar, no habr� ning�n icono Ocultar Columna.</li> 
<li><b>Columna Divisoria</b> crea un grupo de división en la columna. De esta forma se extrae la columna del informe como registro maestro.</li> 
<li><b>Informaci�n de la Columna</b> muestra texto de ayuda sobre la columna si est� disponible.</li> 
<li><b>Área de Texto</b> se utiliza para introducir criterios de b�squeda que no sean sensibles a may�sculas/min�sculas (no se necesitan comodines). Al introducir un valor, se reduce la lista de valores de la parte inferior del men�. A continuación, puede seleccionar un valor de la parte inferior para que se cree como filtro con ''='' (por ejemplo, <code>columna = ''ABC''</code>). Tambi�n puede hacer clic en el icono de linterna e introducir un valor para que se cree como filtro con el modificador ''LIKE'' (por ejemplo, <code>columna LIKE ''%ABC%''</code>). 
<li><b>Lista de Valores �nicos</b> contiene los 500 primeros valores �nicos que cumplen los filtros. Si la columna es una fecha, aparece una lista de rangos de fechas. Si selecciona un valor, se creará un filtro con ''='' (por ejemplo, <code>columna = ''ABC''</code>).</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT_CONDITION',
  p_message_language => 'es-bo',
  p_message_text => 'Condici�n para Resaltar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INTERACTIVE_REPORT_HELP',
  p_message_language => 'es-bo',
  p_message_text => 'Ayuda de Informe Interactivo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_TOTAL_SUM',
  p_message_language => 'es-bo',
  p_message_text => 'Porcentaje de Suma Total');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_AGGREGATE',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Agregado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_SETTINGS',
  p_message_language => 'es-bo',
  p_message_text => 'Valores de Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_VIEW',
  p_message_language => 'es-bo',
  p_message_text => 'Vista de Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEQUENCE',
  p_message_language => 'es-bo',
  p_message_text => 'Secuencia');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT',
  p_message_language => 'es-bo',
  p_message_text => 'Ordenar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUBSCRIPTION_STARTING_FROM',
  p_message_language => 'es-bo',
  p_message_text => 'Empezando por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_YEARS',
  p_message_language => 'es-bo',
  p_message_text => '%0 a�os');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.YES_NO.INVALID_VALUE',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# debe coincidir con los valores %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_GROUP_BY',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Grupo por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_PIVOT',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Dinámica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_ID_DOES_NOT_EXIST',
  p_message_language => 'es-bo',
  p_message_text => 'El informe interactivo guardado con el ID %0 no existe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Columnas de Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_DEFAULT_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Suprimir Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_ORDER',
  p_message_language => 'es-bo',
  p_message_text => 'Orden de Clasificaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TABLE_SUMMARY',
  p_message_language => 'es-bo',
  p_message_text => 'Regi�n = %0, Informe = %1, Vista = %2, Inicio de Filas Mostradas = %3, Fin de Filas Mostradas = %4, Total de Filas = %5');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_PIVOT',
  p_message_language => 'es-bo',
  p_message_text => 'Vista Din�mica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_ROWS',
  p_message_language => 'es-bo',
  p_message_text => '<li><b>Filas</b> define el n�mero de registros que se mostrar�n en cada p�gina.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MIN_X',
  p_message_language => 'es-bo',
  p_message_text => 'M�nimo %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_MONTH',
  p_message_language => 'es-bo',
  p_message_text => 'Mes Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_INVALID',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no coincide con el formato %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_LESS_MIN_VALUE',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# es inferior al m�nimo especificado %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_DAYS_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 d�as desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_FLOW_UTILITIES.CAL',
  p_message_language => 'es-bo',
  p_message_text => 'Calendario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_FLOW_UTILITIES.OK',
  p_message_language => 'es-bo',
  p_message_text => 'Aceptar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MAX',
  p_message_language => 'es-bo',
  p_message_text => 'M�ximo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MEDIAN',
  p_message_language => 'es-bo',
  p_message_text => 'Mediana');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALL_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Todas las Columnas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALTERNATIVE',
  p_message_language => 'es-bo',
  p_message_text => 'Alternativo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALTERNATIVE_DEFAULT_NAME',
  p_message_language => 'es-bo',
  p_message_text => 'Valor Por Defecto Alternativo:  %0 ');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AS_OF',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHOOSE_DOWNLOAD_FORMAT',
  p_message_language => 'es-bo',
  p_message_text => 'Seleccione el formato de descarga del informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_HEADING_MENU',
  p_message_language => 'es-bo',
  p_message_text => 'Men� de Cabecera de Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_ISNOT_IN_LAST',
  p_message_language => 'es-bo',
  p_message_text => 'no en �ltimos(as)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_NOT_LIKE',
  p_message_language => 'es-bo',
  p_message_text => 'no igual');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CONTROL_BREAK',
  p_message_language => 'es-bo',
  p_message_text => 'Divisi�n de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CONTROL_BREAKS',
  p_message_language => 'es-bo',
  p_message_text => 'Divisiones de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DEFAULT',
  p_message_language => 'es-bo',
  p_message_text => 'Valor por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_CONFIRM_JS_DIALOG',
  p_message_language => 'es-bo',
  p_message_text => '�Confirme que desea eliminar?');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DESCENDING',
  p_message_language => 'es-bo',
  p_message_text => 'Descendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DESCRIPTION',
  p_message_language => 'es-bo',
  p_message_text => 'Descripci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DETAIL_VIEW',
  p_message_language => 'es-bo',
  p_message_text => 'Vista de Una Sola Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DOWNLOAD',
  p_message_language => 'es-bo',
  p_message_text => 'Descargar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_BODY',
  p_message_language => 'es-bo',
  p_message_text => 'Cuerpo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_TO',
  p_message_language => 'es-bo',
  p_message_text => 'Para');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FLASHBACK_DESCRIPTION',
  p_message_language => 'es-bo',
  p_message_text => 'Las consultas de flashback permiten visualizar los datos tal como exist�an en un punto en el tiempo anterior.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FLASHBACK_ERROR_MSG',
  p_message_language => 'es-bo',
  p_message_text => 'No se ha podido realizar la solicitud de flashback');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY',
  p_message_language => 'es-bo',
  p_message_text => 'Agrupar por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_CHART',
  p_message_language => 'es-bo',
  p_message_text => 'Puede definir un gr�fico por informe guardado. Despu�s  
de definirlo, puede cambiar entre las vistas de gráfico e informe mediante los iconos de visualizaci�n de la barra de b�squeda. 
Las opciones incluyen:  
<p> 
</p><ul> 
<li><b>Tipo de Gr�fico</b> identifica el tipo de gr�fico que se debe incluir. 
Seleccione un gr�fico de barras horizontales, de barras verticales, de tarta o de l�neas.</li> 
<li><b>Etiqueta</b> permite seleccionar la columna que se debe utilizar como etiqueta.</li> 
<li><b>T�tulo del Eje para Etiqueta</b> es el t�tulo que se mostrar� en el eje asociado a la columna seleccionada como 
etiqueta. No est� disponible para gr�ficos de Pie.</li> 
<li><b>Valor</b> permite seleccionar la columna que se debe utilizar como valor. Si la funci�n 
es COUNT, no se tiene que seleccionar ning�n valor.</li> 
<li><b>T�tulo del Eje para Valor</b> es el t�tulo que se mostrar� en el eje asociado a la columna seleccionada 
como valor. No est� disponible para gr�ficos de tarta.</li> 
<li><b>Funci�n</b> es una funci�n opcional que se debe realizar en la columna seleccionada como valor.</li> 
<li><b>Ordenar</b> permite ordenar el juego de resultados.</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_COMPUTE',
  p_message_language => 'es-bo',
  p_message_text => 'Permite agregar columnas calculadas al informe. Pueden ser c�lculos matem�ticos (por ejemplo, <code>NBR_HOURS/24</code>) o funciones est�ndar de Oracle aplicadas a columnas existentes. Algunas se muestran como ejemplo pero tambi�n se pueden utilizar otras (como <code>TO_DATE)</code>). Las opciones incluyen: 
<p></p> 
<ul> 
<li><b>C�lculo</b> permite seleccionar un c�lculo definido previamente para editarlo.</li> 
<li><b>Cabecera de Columna</b> es la cabecera para la nueva columna.</li> 
<li><b>M�scara de Formato</b> es una m�scara de formato de Oracle que se debe aplicar a la columna (por ejemplo, S9999).</li> 
<li><b>C�lculo</b> es el c�lculo que se debe realizar. Dentro del c�lculo, se hace referencia a las columnas mediante los alias mostrados.</li> 
</ul> 
<p>Debajo del c�lculo, las columnas de la consulta se muestran con sus alias asociados. Al hacer clic en el nombre o el alias de una columna, estos se incluyen en el c�lculo. Junto a las columnas hay un teclado que funciona como m�todo abreviado para las teclas que m�s se utilizan. En el extremo de la derecha est�n las funciones.</p> 
<p>El siguiente es un ejemplo de c�lculo para mostrar la remuneraci�n total:</p> 
<pre>CASE WHEN A = ''VENTAS'' THEN B + C ELSE B END</pre> 
(donde A es ORGANIZACI�N, B es SALARIO y C es COMISI�N)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR',
  p_message_language => 'es-bo',
  p_message_text => 'En la parte superior de cada p�gina de informe se encuentra una regi�n de b�squeda. Esta regi�n (o barra de herramientas) proporciona las siguientes funciones:');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SORT',
  p_message_language => 'es-bo',
  p_message_text => '<p>Se utiliza para cambiar las columnas por las que se ordena y determina si ordenar en sentido ascendente o descendente. Tambi�n puede especificar c�mo se manejan los <code>valores nulos</code>: el valor por defecto, mostrarlos siempre al final o mostrarlos siempre al principio. La ordenaci�n resultante se muestra a la derecha de las cabeceras de columna del informe.</p>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_COMPUTATION',
  p_message_language => 'es-bo',
  p_message_text => 'Expresi�n de c�lculo no v�lida. %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MAX_X',
  p_message_language => 'es-bo',
  p_message_text => 'M�ximo %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_X_HOURS',
  p_message_language => 'es-bo',
  p_message_text => 'Siguientes %0 Horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_YEAR',
  p_message_language => 'es-bo',
  p_message_text => 'A�o Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_OPERATOR',
  p_message_language => 'es-bo',
  p_message_text => 'Operador');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PRIMARY',
  p_message_language => 'es-bo',
  p_message_text => 'Primario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_ALL',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_DEFAULT_CONFIRM',
  p_message_language => 'es-bo',
  p_message_text => 'Los valores de informe actuales se utilizar�n como valores por defecto para todos los usuarios.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_VALUE',
  p_message_language => 'es-bo',
  p_message_text => 'Seleccionar Valor');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SPACE_AS_IN_ONE_EMPTY_STRING',
  p_message_language => 'es-bo',
  p_message_text => 'espacio');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TOP',
  p_message_language => 'es-bo',
  p_message_text => 'Primero');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNIQUE_HIGHLIGHT_NAME',
  p_message_language => 'es-bo',
  p_message_text => 'El nombre del resaltado debe ser �nico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_WEEKLY',
  p_message_language => 'es-bo',
  p_message_text => 'Semanal');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_HOURS',
  p_message_language => 'es-bo',
  p_message_text => '%0 horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER.ICON_TEXT',
  p_message_language => 'es-bo',
  p_message_text => 'Calendario Emergente: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_ALIAS_DOES_NOT_EXIST',
  p_message_language => 'es-bo',
  p_message_text => 'El informe interactivo guardado con el alias %0 no existe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_DISPLAY_COLUMN_LIMIT_REACHED',
  p_message_language => 'es-bo',
  p_message_text => 'El n�mero de columnas de visualizaci�n del informe ha alcanzado el l�mite. Haga clic en Seleccionar Columnas en el men� Acciones para minimizar la lista de columnas de visualizaci�n del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_N',
  p_message_language => 'es-bo',
  p_message_text => 'Columna %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CONTROL_BREAK_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Columnas de Divisi�n de Control');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_MAX_ROW_CNT',
  p_message_language => 'es-bo',
  p_message_text => 'El recuento m�ximo de filas para una consulta de Agrupar por limita el n�mero de filas de la consulta base, no el n�mero de filas que se muestran. La consulta base supera el recuento m�ximo de filas de %0. Aplique un filtro para reducir el n�mero de registros en la consulta base.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SAVED_REPORTS.PRIMARY.DEFAULT',
  p_message_language => 'es-bo',
  p_message_text => 'Por Defecto Primario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT_TYPE',
  p_message_language => 'es-bo',
  p_message_text => 'Tipo de Resaltado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.GO_TO_ERROR',
  p_message_language => 'es-bo',
  p_message_text => 'Ir al error');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.PREVIOUS_SET',
  p_message_language => 'es-bo',
  p_message_text => 'Juego Anterior');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MINUTES_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 minutos desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_FLOW_UTILITIES.CLOSE',
  p_message_language => 'es-bo',
  p_message_text => 'Cerrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BETWEEN',
  p_message_language => 'es-bo',
  p_message_text => 'entre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Columnas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION',
  p_message_language => 'es-bo',
  p_message_text => 'C�lculo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COUNT_DISTINCT_X',
  p_message_language => 'es-bo',
  p_message_text => 'Recuento de los Valores Distintos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DAILY',
  p_message_language => 'es-bo',
  p_message_text => 'Diario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DATA_AS_OF',
  p_message_language => 'es-bo',
  p_message_text => 'Informar de datos de hace %0 minutos.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAY',
  p_message_language => 'es-bo',
  p_message_text => 'Mostrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAYED',
  p_message_language => 'es-bo',
  p_message_text => 'Mostrado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_ALTERNATIVE_DEFAULT',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Valor por Defecto Alternativo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_CHART2',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Gr�fico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_HIGHLIGHT',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Resaltado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_SUBJECT',
  p_message_language => 'es-bo',
  p_message_text => 'Asunto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ERROR',
  p_message_language => 'es-bo',
  p_message_text => 'Error');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXPRESSION',
  p_message_language => 'es-bo',
  p_message_text => 'Expresi�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GO',
  p_message_language => 'es-bo',
  p_message_text => 'Ir');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP',
  p_message_language => 'es-bo',
  p_message_text => 'Ayuda');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_AGGREGATE',
  p_message_language => 'es-bo',
  p_message_text => 'Las agregaciones son c�lculos matem�ticos que se realizan en una columna. Las agregaciones se muestran detr�s de cada divisi�n de control y, al final del informe, dentro de la columna en la que est�n definidos. Las opciones incluyen: 
<p> 
</p><ul> 
<li><b>Agregaci�n</b> permite seleccionar una agregaci�n definida previamente para editarla.</li> 
<li><b>Funci�n</b> es la funci�n que se debe ejecutar (por ejemplo, SUM, MIN).</li> 
<li><b>Columna</b> se utiliza para seleccionar la columna a la que se aplica la funci�n matem�tica. S�lo se muestran las columnas num�ricas.</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_CONTROL_BREAK',
  p_message_language => 'es-bo',
  p_message_text => 'Se utiliza para crear un grupo divisorio en una o varias columnas. Obtiene las columnas del informe interactivo y las muestra como un registro maestro.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_RESET',
  p_message_language => 'es-bo',
  p_message_text => 'Restablece los valores por defecto del informe eliminando todas las personalizaciones realizadas.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SAVE_REPORT',
  p_message_language => 'es-bo',
  p_message_text => '<p>Guarda el informe personalizado para su uso en el futuro. Se proporcionan un nombre y una descripci�n opcional y el p�blico (es decir, todos los usuarios con acceso al informe principal por defecto) podr� acceder al informe. Puede guardar cuatro tipos de informe interactivo:</p> 
<ul> 
<li><strong>Principal por Defecto</strong> (s�lo desarrolladores). El informe principal por defecto es el primero que se muestra. No se puede cambiar el nombre de estos informes ni se pueden suprimir.</li> 
<li><strong>Informe Alternativo</strong> (s�lo desarrolladores). Permite a los desarrolladores crear varios dise�os de informe. S�lo los desarrolladores pueden guardar, cambiar el nombre o suprimir un informe alternativo.</li> 
<li><strong>Informe P�blico</strong> (usuario final). El usuario final que lo cre� puede guardarlo, suprimirlo o cambiarle el nombre. Los dem�s usuarios pueden visualizarlo y guardar el dise�o como otro informe.</li> 
<li><strong>Informe Privado</strong> (usuario final). S�lo el usuario que cre� el informe puede visualizarlo, guardarlo, suprimirlo o cambiarle el nombre.</li> 
</ul> 
<p>Si guarda informes personalizados, se muestra un selector de informes en la barra de b�squeda a la izquierda del selector de filas (si est� activada esta funci�n).</p> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIDE_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Ocultar Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_WEEK',
  p_message_language => 'es-bo',
  p_message_text => 'Semana Pasada');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MOVE',
  p_message_language => 'es-bo',
  p_message_text => 'Mover');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MOVE_ALL',
  p_message_language => 'es-bo',
  p_message_text => 'Mover Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEW_AGGREGATION',
  p_message_language => 'es-bo',
  p_message_text => 'Nueva Agregaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_DAY',
  p_message_language => 'es-bo',
  p_message_text => 'D�a Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_END_DATE',
  p_message_language => 'es-bo',
  p_message_text => '- Sin Fecha de Finalizaci�n -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NULLS_ALWAYS_FIRST',
  p_message_language => 'es-bo',
  p_message_text => 'Valores Nulos Siempre al Principio');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PREVIOUS',
  p_message_language => 'es-bo',
  p_message_text => 'Anterior');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PUBLIC',
  p_message_language => 'es-bo',
  p_message_text => 'Público');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT_DOES_NOT_EXIST',
  p_message_language => 'es-bo',
  p_message_text => 'El informe no existe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RESET_CONFIRM',
  p_message_language => 'es-bo',
  p_message_text => 'Restaure los valores por defecto del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Columna -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALID_COLOR',
  p_message_language => 'es-bo',
  p_message_text => 'Introduzca un color v�lido.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALUE_REQUIRED',
  p_message_language => 'es-bo',
  p_message_text => 'Valor Necesario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_DETAIL',
  p_message_language => 'es-bo',
  p_message_text => 'Ver Detalle');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_GROUP_BY',
  p_message_language => 'es-bo',
  p_message_text => 'Ver Grupo por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.SLIDER.VALUE_NOT_MULTIPLE_OF_STEP',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no es un m�ltiplo de %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.YES_NO.NO_LABEL',
  p_message_language => 'es-bo',
  p_message_text => 'No');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_SORT',
  p_message_language => 'es-bo',
  p_message_text => 'Agrupar por Ordenaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_FORMAT',
  p_message_language => 'es-bo',
  p_message_text => '<p>El men� Formato permite personalizar la visualizaci�n del informe. 
Contiene los siguientes submen�s:</p> 
<ul><li>Ordenar</li> 
<li>Divisi�n de Control</li> 
<li>Resaltar</li> 
<li>Calcular</li> 
<li>Agregar</li> 
<li>Gr�fico</li> 
<li>Agrupar por</li> 
<li>Girar</li> 
</ul> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT',
  p_message_language => 'es-bo',
  p_message_text => 'Din�mica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_COLUMN_NOT_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar la columna din�mica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_MAX_ROW_CNT',
  p_message_language => 'es-bo',
  p_message_text => 'El recuento m�ximo de filas para una consulta din�mica limita el n�mero de filas de la consulta base, no el n�mero de filas que se muestran. La consulta base supera el recuento m�ximo de filas de %0. Aplique un filtro para reducir el n�mero de registros en la consulta base.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_DEFAULT_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Guardar Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DUPLICATE_PIVOT_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Columna din�mica duplicada. La lista de columna din�mica debe ser �nica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_PIVOT_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Columna Din�mica -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'RESTORE',
  p_message_language => 'es-bo',
  p_message_text => 'Restaurar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.SESSION_STATE.SSP_VIOLATION',
  p_message_language => 'es-bo',
  p_message_text => 'Violaci�n de la protecci�n del estado de la sesi�n: Puede ser debida a una modificaci�n manual de una direcci�n URL que contenga un total de control, que se haya utilizado un enlace con un total de control incorrecto o que no tenga ning�n total de control. En caso de duda sobre el motivo de este error, p�ngase en contacto con el administrador de la aplicaci�n para recibir ayuda.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.SESSION.EXPIRED',
  p_message_language => 'es-bo',
  p_message_text => 'La sesi�n ha vencido');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_IN_THE_LAST',
  p_message_language => 'es-bo',
  p_message_text => '%0 est� en el �ltimo %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEW_CATEGORY',
  p_message_language => 'es-bo',
  p_message_text => '- Nueva Categor�a -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_COMPUTATION_DEFINED',
  p_message_language => 'es-bo',
  p_message_text => 'Ning�n c�lculo definido.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORTS',
  p_message_language => 'es-bo',
  p_message_text => 'Informes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_NOT_BETWEEN_MIN_MAX',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no est� en el rango v�lido de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_NOT_BETWEEN_MIN_MAX',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no est� en el rango v�lido de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_DAYS_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 d�as');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MONTHS_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 meses');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_SECONDS_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 segundos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_YEARS_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 a�os');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.X_Y_OF_MORE_THAN_Z',
  p_message_language => 'es-bo',
  p_message_text => 'Fila(s) %0 - %1 de m�s de %2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.X_Y_OF_Z',
  p_message_language => 'es-bo',
  p_message_text => 'Fila(s) %0 - %1 de %2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => '4150_COLUMN_NUMBER',
  p_message_language => 'es-bo',
  p_message_text => 'Columna %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ACTIONS_MENU',
  p_message_language => 'es-bo',
  p_message_text => 'Men� de Acciones');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_COUNT',
  p_message_language => 'es-bo',
  p_message_text => 'Recuento');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ASCENDING',
  p_message_language => 'es-bo',
  p_message_text => 'Ascendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_TYPE',
  p_message_language => 'es-bo',
  p_message_text => 'Tipo de Gr�fico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_CONTAINS',
  p_message_language => 'es-bo',
  p_message_text => 'contiene');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_IS_IN_NEXT',
  p_message_language => 'es-bo',
  p_message_text => 'en siguientes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_NOT_IN',
  p_message_language => 'es-bo',
  p_message_text => 'no en');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER',
  p_message_language => 'es-bo',
  p_message_text => 'Cree un c�lculo utilizando los alias de columna.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COUNT_DISTINCT',
  p_message_language => 'es-bo',
  p_message_text => 'Recuento de los Valores Distintos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_CHECKED',
  p_message_language => 'es-bo',
  p_message_text => 'Suprimir Selecci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Suprimir Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DIRECTION',
  p_message_language => 'es-bo',
  p_message_text => 'Direcci�n %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DOWN',
  p_message_language => 'es-bo',
  p_message_text => 'Abajo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL',
  p_message_language => 'es-bo',
  p_message_text => 'Correo Electr�nico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ENABLED',
  p_message_language => 'es-bo',
  p_message_text => 'Activado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FORMAT_MASK',
  p_message_language => 'es-bo',
  p_message_text => 'M�scara de Formato %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTION',
  p_message_language => 'es-bo',
  p_message_text => 'Funci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HCOLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Columna Horizontal');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_X_HOURS',
  p_message_language => 'es-bo',
  p_message_text => '�ltimas %0 Horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_WEEK',
  p_message_language => 'es-bo',
  p_message_text => 'Semana Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO',
  p_message_language => 'es-bo',
  p_message_text => 'No');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NUMERIC_SEQUENCE',
  p_message_language => 'es-bo',
  p_message_text => 'La secuencia debe ser num�rica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PERCENT_TOTAL_COUNT',
  p_message_language => 'es-bo',
  p_message_text => 'Porcentaje de Recuento Total');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RENAME_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Cambiar Nombre del Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_ORDER',
  p_message_language => 'es-bo',
  p_message_text => 'Orden de Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVED_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Informe Guardado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Guardar Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Seleccionar Columnas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_STATUS',
  p_message_language => 'es-bo',
  p_message_text => 'Estado %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUM_X',
  p_message_language => 'es-bo',
  p_message_text => 'Suma de %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_WEEKS',
  p_message_language => 'es-bo',
  p_message_text => 'semanas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNIQUE_COLUMN_HEADING',
  p_message_language => 'es-bo',
  p_message_text => 'La cabecera de columna debe ser �nica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UP',
  p_message_language => 'es-bo',
  p_message_text => 'Arriba');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALUE_AXIS_TITLE',
  p_message_language => 'es-bo',
  p_message_text => 'T�tulo del Eje para Valor');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_CHART',
  p_message_language => 'es-bo',
  p_message_text => 'Ver Gr�fico');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.AUTHENTICATION.LOGIN_THROTTLE.ERROR',
  p_message_language => 'es-bo',
  p_message_text => 'El intento de conexi�n se ha bloqueado.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_FILTER_QUERY',
  p_message_language => 'es-bo',
  p_message_text => 'Consulta de filtro no v�lida');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LABEL_PREFIX',
  p_message_language => 'es-bo',
  p_message_text => 'Prefijo de Etiqueta');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_AGG_NOT_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar el agregado.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RENAME_DEFAULT_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Cambiar Nombre de Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Filtrar...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_MONTHS',
  p_message_language => 'es-bo',
  p_message_text => '%0 meses');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'OUT_OF_RANGE',
  p_message_language => 'es-bo',
  p_message_text => 'Se ha solicitado un juego de filas no v�lido, los datos de origen del informe se han modificado.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LABEL',
  p_message_language => 'es-bo',
  p_message_text => 'Etiqueta %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_HOUR',
  p_message_language => 'es-bo',
  p_message_text => '�ltima Hora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_X_DAYS',
  p_message_language => 'es-bo',
  p_message_text => '�ltimos %0 D�as');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_GREATER_MAX_DATE',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# es posterior a la fecha m�xima especificada %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_INVALID',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# debe ser num�rico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'FLOW.VALIDATION_ERROR',
  p_message_language => 'es-bo',
  p_message_text => 'Se han producido %0 errores');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'PAGINATION.NEXT',
  p_message_language => 'es-bo',
  p_message_text => 'Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_HOURS_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 horas desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_MONTHS_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 meses desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_NOW',
  p_message_language => 'es-bo',
  p_message_text => 'Ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_WEEKS_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 semanas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'TOTAL',
  p_message_language => 'es-bo',
  p_message_text => 'Total');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.FOUND_BUT_NOT_DISPLAYED',
  p_message_language => 'es-bo',
  p_message_text => 'M�nimo de filas solicitadas: %0, filas encontradas pero no mostradas: %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.SORT_BY_THIS_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Ordenar por esta columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.UNSAVED_DATA',
  p_message_language => 'es-bo',
  p_message_text => 'Esta pantalla contiene cambios no guardados. Pulse "Aceptar" para continuar sin guardar los cambios.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGGREGATION',
  p_message_language => 'es-bo',
  p_message_text => 'Agregaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_SUM',
  p_message_language => 'es-bo',
  p_message_text => 'Suma de %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AVERAGE_X',
  p_message_language => 'es-bo',
  p_message_text => 'Media de %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CANCEL',
  p_message_language => 'es-bo',
  p_message_text => 'Cancelar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CATEGORY',
  p_message_language => 'es-bo',
  p_message_text => 'Categor�a');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER_E2',
  p_message_language => 'es-bo',
  p_message_text => 'INITCAP(B)||'', ''||INITCAP(C)');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISABLED',
  p_message_language => 'es-bo',
  p_message_text => 'Desactivado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISPLAY_IN_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Mostrar en Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_NOT_CONFIGURED',
  p_message_language => 'es-bo',
  p_message_text => 'El correo electr�nico no se ha configurado para esta aplicaci�n. P�ngase en contacto con el administrador.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXAMPLES',
  p_message_language => 'es-bo',
  p_message_text => 'Ejemplos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GREEN',
  p_message_language => 'es-bo',
  p_message_text => 'verde');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_DOWNLOAD',
  p_message_language => 'es-bo',
  p_message_text => 'Permite descargar el juego de resultados actual. Los formatos de 
 descarga son diferentes seg�n la instalaci�n y la definici�n del 
 informe pero pueden ser CSV, HTML, Correo Electr�nico, XLS, PDF 
 o RTF.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_FLASHBACK',
  p_message_language => 'es-bo',
  p_message_text => 'Las consultas de flashback permiten visualizar los datos tal como exist�an en un punto en el tiempo anterior. El tiempo por defecto en el que se puede realizar la operaci�n de flashback es 3 horas (o 180 minutos) aunque el tiempo real es diferente seg�n la base de datos.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_REPORT_SETTINGS',
  p_message_language => 'es-bo',
  p_message_text => 'Si personaliza un informe interactivo, la configuraci�n del informe se mostrar� 
debajo de la barra de b�squeda y encima del informe. Esta �rea se puede reducir y ampliar mediante el icono de la izquierda. 
<p> 
En cada configuraci�n de informe, puede hacer lo siguiente: 
</p><ul> 
<li>Editar un valor haciendo clic en el nombre.</li> 
<li>Desactivar/activar un valor marcando o anulando la marca de la casilla de control Activar/Desactivar. Se utiliza para desactivar y activar temporalmente el valor.</li> 
<li>Eliminar un valor haciendo clic en el icono Eliminar.</li> 
</ul> 
<p>Si ha creado un gr�fico, una ordenaci�n por grupos o elemento din�mico, puede cambiar entre ellos 
y el informe base con los enlaces Vista de Informe, Vista de Gr�fico, Vista Agrupar por y Vista Din�mica por 
que se muestran a la derecha. Si est� visualizando el gr�fico, la ordenaci�n por grupos o elemento din�mico, tambi�n 
puede utilizar el enlace Editar para editar la configuraci�n.</p> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_NOT_IN_THE_NEXT',
  p_message_language => 'es-bo',
  p_message_text => '%0 no est� en el siguiente %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LABEL_AXIS_TITLE',
  p_message_language => 'es-bo',
  p_message_text => 'T�tulo del Eje para Etiqueta');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_DAY',
  p_message_language => 'es-bo',
  p_message_text => '�ltimo D�a');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MONTH',
  p_message_language => 'es-bo',
  p_message_text => 'Mes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MORE_DATA',
  p_message_language => 'es-bo',
  p_message_text => 'M�s Datos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT',
  p_message_language => 'es-bo',
  p_message_text => 'Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_X_DAYS',
  p_message_language => 'es-bo',
  p_message_text => 'Siguientes %0 D�as');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NULL_SORTING',
  p_message_language => 'es-bo',
  p_message_text => 'Ordenaci�n de Valores Nulos %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_OTHER',
  p_message_language => 'es-bo',
  p_message_text => 'Otro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_FLASHBACK',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Flashback');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_HIGHLIGHT',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Resaltado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROWS_PER_PAGE',
  p_message_language => 'es-bo',
  p_message_text => 'Filas por P�gina');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVE',
  p_message_language => 'es-bo',
  p_message_text => 'Guardar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SAVED_REPORT_MSG',
  p_message_language => 'es-bo',
  p_message_text => 'Informe Guardado = "%0"');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_COLUMNS_FOOTER',
  p_message_language => 'es-bo',
  p_message_text => 'Las columnas calculadas tienen el prefijo **.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_MONTHS',
  p_message_language => 'es-bo',
  p_message_text => 'meses');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VALUE',
  p_message_language => 'es-bo',
  p_message_text => 'Valor');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VCOLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Columna Vertical');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_ICONS',
  p_message_language => 'es-bo',
  p_message_text => 'Ver Iconos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_WORKING_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Informe de Trabajo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_YES',
  p_message_language => 'es-bo',
  p_message_text => 'S�');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'LAYOUT.T_CONDITION_EXPR2',
  p_message_language => 'es-bo',
  p_message_text => 'Expresi�n 2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.ITEM_TYPE.YES_NO.YES_LABEL',
  p_message_language => 'es-bo',
  p_message_text => 'S�');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_PIVOT',
  p_message_language => 'es-bo',
  p_message_text => 'Puede definir una vista din�mica por informe guardado. Una vez definidas, puede cambiar entre las vistas din�micas y de informe utilizando los iconos de vista que se encuentran en la barra de b�squeda. Para crear una vista din�mica, se seleccionan:  
<p></p> 
<ul> 
<li>las columnas sobre las que girar</li> 
<li>las columnas que mostrar como filas</li> 
<li>las columnas que agregar junto con la funci�n que se va a realizar (media, suma, recuento, etc.)</li> 
</ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_FINDER',
  p_message_language => 'es-bo',
  p_message_text => '<li>El icono <b>Seleccionar Columnas</b> permite identificar en qu� columnas buscar (o si desea hacerlo en todas).</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_REPORTS',
  p_message_language => 'es-bo',
  p_message_text => '<li><b>Informes</b> muestra informes privados o p�blicos por defecto o guardados de forma alterna.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_END_DATE',
  p_message_language => 'es-bo',
  p_message_text => 'La fecha de finalizaci�n debe ser posterior a la fecha de inicio.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COL_DIFF_FROM_PIVOT_COL',
  p_message_language => 'es-bo',
  p_message_text => 'La columna de fila debe ser diferente a la columna din�mica.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RPT_DISP_COL_EXCEED',
  p_message_language => 'es-bo',
  p_message_text => 'El número de columnas de visualizaci�n del informe ha alcanzado el l�mite. Haga clic en Seleccionar Columnas en el men� Acciones para minimizar la lista de columnas de visualizaci�n del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Buscar: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_FUNCTION',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar Funci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_GROUP_BY_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar Grupo por Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ALL_ROWS',
  p_message_language => 'es-bo',
  p_message_text => 'Todas las Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_REQUIRED',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar la direcci�n de correo electr�nico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_ROW_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Columna de Fila -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SUBSCRIPTION',
  p_message_language => 'es-bo',
  p_message_text => 'Suscripci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_YEAR',
  p_message_language => 'es-bo',
  p_message_text => 'A�o');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'IR_AS_DEFAULT_REPORT_SETTING',
  p_message_language => 'es-bo',
  p_message_text => 'Como Valores de Informe por Defecto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_GROUP_BY',
  p_message_language => 'es-bo',
  p_message_text => 'Puede definir una vista Agrupar por, por informe guardado. 
Una vez se ha definido, puede cambiar entre las vistas de agrupaci�n e informe 
mediante los iconos de vista que se encuentran en la barra de b�squeda. Para crear una vista Agrupar por, 
seleccione: 
<p></p><ul> 
<li>las columnas en las que realizar la agrupaci�n</li>, 
<li>las columnas para agregar, junto con la funci�n que se va a realizar (media, suma, recuento, etc.)</li> 
</ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_ROWS_PER_PAGE',
  p_message_language => 'es-bo',
  p_message_text => 'Define el n�mero de registros que se mostrar�n por p�gina.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WELCOME_USER',
  p_message_language => 'es-bo',
  p_message_text => 'Bienvenido: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'WWV_RENDER_REPORT3.X_Y_OF_Z_2',
  p_message_language => 'es-bo',
  p_message_text => '%0 - %1 de %2');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MONTHLY',
  p_message_language => 'es-bo',
  p_message_text => 'Mensual');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ORANGE',
  p_message_language => 'es-bo',
  p_message_text => 'naranja');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATA_HAS_CHANGED',
  p_message_language => 'es-bo',
  p_message_text => 'La versi�n actual de los datos de la base de datos ha cambiado desde que el usuario inici� el proceso de actualizaci�n. identificador de versi�n de fila actual = "%0" identificador de versi�n de fila de aplicaci�n = "%1"');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'FLOW.SINGLE_VALIDATION_ERROR',
  p_message_language => 'es-bo',
  p_message_text => 'Se ha producido 1 error');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_WEEKS_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 semanas desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGGREGATE',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CALENDAR',
  p_message_language => 'es-bo',
  p_message_text => 'Calendario');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CELL',
  p_message_language => 'es-bo',
  p_message_text => 'Celda');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_INITIALIZING',
  p_message_language => 'es-bo',
  p_message_text => 'Inicializando...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_ISNOT_IN_NEXT',
  p_message_language => 'es-bo',
  p_message_text => 'no en siguientes');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_FOOTER_E3',
  p_message_language => 'es-bo',
  p_message_text => 'CASE WHEN A = 10 THEN B + C ELSE B END');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DELETE_CONFIRM',
  p_message_language => 'es-bo',
  p_message_text => '�Desea suprimir estos valores del informe?');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DISABLE',
  p_message_language => 'es-bo',
  p_message_text => 'Desactivar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DO_NOT_DISPLAY',
  p_message_language => 'es-bo',
  p_message_text => 'No Mostrar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_SEE_ATTACHED',
  p_message_language => 'es-bo',
  p_message_text => 'Consulte adjuntos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ENABLE_DISABLE_ALT',
  p_message_language => 'es-bo',
  p_message_text => 'Activar/Desactivar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FLASHBACK',
  p_message_language => 'es-bo',
  p_message_text => 'Flashback');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_FUNCTIONS',
  p_message_language => 'es-bo',
  p_message_text => 'Funciones %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_DETAIL_VIEW',
  p_message_language => 'es-bo',
  p_message_text => 'Para visualizar los detalles de una sola fila cada vez, haga clic en el icono de vista de una sola fila correspondiente a la fila que desea visualizar. Si est� disponible, la vista de una sola fila siempre estar� en la primera columna. Seg�n la personalizaci�n del informe interactivo, la vista de una sola fila puede ser la vista est�ndar o una p�gina personalizada que se puede actualizar.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Delimita el informe mediante la adici�n o modificaci�n de la cl�usula WHERE de la consulta. Puede filtrar por columna o por fila. 
<p/> 
Si filtra por columna, seleccione primero una columna (no tiene que ser la mostrada), seleccione un operador est�ndar de Oracle (=, !=, no en, entre) y, a continuaci�n, introduzca una expresi�n con la que realizar la comparaci�n. Las expresiones son sensibles a may�sculas/min�sculas. Utilice % como comod�n (por ejemplo, <code>STATE_NAME 
like A%)</code>.</p> 
<p>Si filtra por fila, puede crear cl�usulas WHERE complejas con alias de columna y cualquier funci�n u operador de Oracle (por ejemplo, <code>G = ''VA'' o G = ''CT''</code>, donde <code>G</code> es el alias de CUSTOMER_STATE).</p> 
');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SELECT_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Se utiliza para modificar las columnas mostradas. Se muestran las columnas de la derecha. Las columnas de la izquierda permanecen ocultas. Puede volver a ordenar las columnas mostradas mediante las flechas que hay m�s a la derecha. Las columnas calculadas tienen el prefijo <b>**</b>.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_IS_NOT_IN_THE_LAST',
  p_message_language => 'es-bo',
  p_message_text => '%0 no est� en el �ltimo %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_X_YEARS',
  p_message_language => 'es-bo',
  p_message_text => '�ltimos %0 A�os');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LINE',
  p_message_language => 'es-bo',
  p_message_text => 'L�nea');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MEDIAN_X',
  p_message_language => 'es-bo',
  p_message_text => 'Mediana %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIE',
  p_message_language => 'es-bo',
  p_message_text => 'Pie');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_OF',
  p_message_language => 'es-bo',
  p_message_text => 'Fila %0 de %1');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_SORT_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Columna de Ordenaci�n -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNSUPPORTED_DATA_TYPE',
  p_message_language => 'es-bo',
  p_message_text => 'tipo de dato no soportado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_VIEW_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Ver Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_MINS',
  p_message_language => 'es-bo',
  p_message_text => '%0 minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_YELLOW',
  p_message_language => 'es-bo',
  p_message_text => 'amarillo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'IR_AS_NAMED_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Como Informe con Nombre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.AUTHENTICATION.LOGIN_THROTTLE.COUNTER',
  p_message_language => 'es-bo',
  p_message_text => 'Espere <span id="apex_login_throttle_sec">%0</span> segundos para volver a conectarse.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_TEXTBOX',
  p_message_language => 'es-bo',
  p_message_text => '<li>El <b>�rea de texto</b> permite utilizar criterios de b�squeda que no sean sensibles a may�sculas/min�sculas (se permite el uso de comodines).</li> 
<li>El <b>bot�n Ir</b> ejecuta la b�squeda. Al pulsar la tecla Intro, tambi�n se ejecutar� la b�squeda si el cursor est� en el �rea de texto de b�squeda.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_VIEW',
  p_message_language => 'es-bo',
  p_message_text => '<li><b>Iconos de Visualizaci�n</b> cambia entre la vista de icono, informe, detallada, gr�fico, agrupar por y din�mica del informe si se han definido.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NOT_VALID_EMAIL',
  p_message_language => 'es-bo',
  p_message_text => 'Direcci�n de correo electr�nico no v�lida.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Columnas Din�micas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_GROUP_BY_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Grupo por Columna -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_PIVOT_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar Columna Din�mica');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ADD_ROW_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Agregar Columna de Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHART_LABEL_NOT_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar la etiqueta de gr�fico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTATION_EXPRESSION',
  p_message_language => 'es-bo',
  p_message_text => 'Expresi�n de C�lculo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNGROUPED_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Columna sin Agrupaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_X_DAYS',
  p_message_language => 'es-bo',
  p_message_text => '%0 d�as');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'RESET',
  p_message_language => 'es-bo',
  p_message_text => 'Restablecer Paginaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RESET',
  p_message_language => 'es-bo',
  p_message_text => 'Restablecer');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_LESS_MIN_DATE',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# es anterior a la fecha m�nima especificada %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.DATEPICKER_VALUE_NOT_IN_YEAR_RANGE',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no est� en el rango v�lido de a�o de %0 y %1.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_GREATER_MAX_VALUE',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# es mayor que el m�ximo especificado de %0.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.NUMBER_FIELD.VALUE_INVALID2',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# no coincide con el formato num�rico %0 (Ejemplo: %1).');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.PAGE_ITEM_IS_REQUIRED',
  p_message_language => 'es-bo',
  p_message_text => '#LABEL# debe tener alg�n valor.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'REPORT_TOTAL',
  p_message_language => 'es-bo',
  p_message_text => 'Total de Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_HOURS_AGO',
  p_message_language => 'es-bo',
  p_message_text => 'Hace %0 horas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'SINCE_YEARS_FROM_NOW',
  p_message_language => 'es-bo',
  p_message_text => '%0 a�os desde ahora');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGGREGATE_DESCRIPTION',
  p_message_language => 'es-bo',
  p_message_text => 'Las agregaciones se muestran detr�s de cada divisi�n de control y al final del informe.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AGG_MIN',
  p_message_language => 'es-bo',
  p_message_text => 'M�nimo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_AND',
  p_message_language => 'es-bo',
  p_message_text => 'y');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_BLUE',
  p_message_language => 'es-bo',
  p_message_text => 'azul');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Columna');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_DOESNOT_CONTAIN',
  p_message_language => 'es-bo',
  p_message_text => 'no contiene');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPARISON_LIKE',
  p_message_language => 'es-bo',
  p_message_text => 'igual');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COMPUTE',
  p_message_language => 'es-bo',
  p_message_text => 'Calcular');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_COUNT_X',
  p_message_language => 'es-bo',
  p_message_text => 'Recuento %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_DATE',
  p_message_language => 'es-bo',
  p_message_text => 'Fecha');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EDIT_GROUP_BY',
  p_message_language => 'es-bo',
  p_message_text => 'Editar Grupo por');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EMAIL_FREQUENCY',
  p_message_language => 'es-bo',
  p_message_text => 'Frecuencia');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_EXCLUDE_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'Excluir Valores Nulos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_HIGHLIGHT',
  p_message_language => 'es-bo',
  p_message_text => '<p>Permite definir un filtro. Las filas que cumplen los criterios de filtro se resaltan seg�n las caracter�sticas asociadas al filtro. Las opciones incluyen:</p> 
<ul> 
<li><b>Nombre</b> s�lo se utiliza para la visualizaci�n.</li> 
<li><b>Secuencia</b> identifica la secuencia en la que se evaluar�n las reglas.</li> 
<li><b>Activado</b> identifica si la regla est� activada o desactivada.</li> 
<li><b>Tipo de Resaltado</b> identifica si la fila o la celda debe estar resaltada. Si se selecciona Celda, se resalta la columna a la que se hace referencia en Condici�n para Resaltar.</li> 
<li><b>Color de Fondo</b> es el nuevo color para el fondo del �rea resaltada.</li> 
<li><b>Color del Texto</b> es el nuevo color para el texto del �rea resaltada.</li> 
<li><b>Condici�n para Resaltar</b> define la condici�n del filtro.</li></ul>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HIGHLIGHT',
  p_message_language => 'es-bo',
  p_message_text => 'Resaltar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_MONTH',
  p_message_language => 'es-bo',
  p_message_text => 'Mes Pasado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_LAST_YEAR',
  p_message_language => 'es-bo',
  p_message_text => 'A�o Pasado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_MIN_AGO',
  p_message_language => 'es-bo',
  p_message_text => '%0 minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEW_COMPUTATION',
  p_message_language => 'es-bo',
  p_message_text => 'Nuevo C�lculo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NEXT_HOUR',
  p_message_language => 'es-bo',
  p_message_text => 'Hora Siguiente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NO_COLUMN_INFO',
  p_message_language => 'es-bo',
  p_message_text => 'No hay informaci�n de columna disponible.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_NUMERIC_FLASHBACK_TIME',
  p_message_language => 'es-bo',
  p_message_text => 'El tiempo de flashback debe ser un valor num�rico.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_RED',
  p_message_language => 'es-bo',
  p_message_text => 'rojo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REMOVE_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Eliminar Filtro');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_REPORT',
  p_message_language => 'es-bo',
  p_message_text => 'Informe');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW',
  p_message_language => 'es-bo',
  p_message_text => 'Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROWS',
  p_message_language => 'es-bo',
  p_message_text => 'Filas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_TEXT_CONTAINS',
  p_message_language => 'es-bo',
  p_message_text => 'El texto de la fila contiene');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SEARCH_BAR',
  p_message_language => 'es-bo',
  p_message_text => 'Barra de B�squeda');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECT_FUNCTION',
  p_message_language => 'es-bo',
  p_message_text => '- Seleccionar Funci�n -');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_COLUMN',
  p_message_language => 'es-bo',
  p_message_text => 'Columna de Ordenaci�n %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SORT_DESCENDING',
  p_message_language => 'es-bo',
  p_message_text => 'Orden Descendente');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TEXT_COLOR',
  p_message_language => 'es-bo',
  p_message_text => 'Color del Texto');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TIME_MINS',
  p_message_language => 'es-bo',
  p_message_text => 'minutos');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_UNAUTHORIZED',
  p_message_language => 'es-bo',
  p_message_text => 'No Autorizado');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.POPUP_LOV.ICON_TEXT',
  p_message_language => 'es-bo',
  p_message_text => 'Lista de Valores Emergente: %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.REGION.JQM_LIST_VIEW.SEARCH',
  p_message_language => 'es-bo',
  p_message_text => 'Buscar...');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_COL_NOT_NULL',
  p_message_language => 'es-bo',
  p_message_text => 'Se debe especificar la columna Agrupar por.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_GROUP_BY_SORT_ORDER',
  p_message_language => 'es-bo',
  p_message_text => 'Agrupar por Orden de Clasificaci�n');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SEARCH_BAR_ACTIONS_MENU',
  p_message_language => 'es-bo',
  p_message_text => '<li>El <b>men� Acciones</b> permite actualizar un informe. Consulte las siguientes secciones.</li>');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_HELP_SUBSCRIPTION',
  p_message_language => 'es-bo',
  p_message_text => 'Al agregar una suscripci�n, proporciona una direcci�n (o varias separadas por comas) y el asunto del correo electr�nico, la frecuencia y las fechas de inicio y fin. Los correos electr�nicos resultantes incluyen una versi�n HTML del informe interactivo que contiene los datos actuales utilizando la configuraci�n de informe que exist� al agregar la suscripci�n.');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INACTIVE_SETTING',
  p_message_language => 'es-bo',
  p_message_text => '1 valor inactivo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_PIVOT_COLUMN_N',
  p_message_language => 'es-bo',
  p_message_text => 'Columna Din�mica %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_COLUMN_N',
  p_message_language => 'es-bo',
  p_message_text => 'Columna de Fila %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_ROW_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Filtro de Fila');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_CHECK_ALL',
  p_message_language => 'es-bo',
  p_message_text => 'Activar Todo');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_SELECTED_COLUMNS',
  p_message_language => 'es-bo',
  p_message_text => 'Columnas Seleccionadas');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_TOGGLE',
  p_message_language => 'es-bo',
  p_message_text => 'Conmutar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEXIR_INVALID_FILTER',
  p_message_language => 'es-bo',
  p_message_text => 'Expresi�n de filtro no v�lida. %0');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.CLOSE_NOTIFICATION',
  p_message_language => 'es-bo',
  p_message_text => 'Notificaci�n de Cierre');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'MAXIMIZE',
  p_message_language => 'es-bo',
  p_message_text => 'Maximizar');

wwv_flow_api.create_message (
  p_id => null, -- to get unique ID from sequence
  p_flow_id => v_app_id,
  p_name => 'APEX.SESSION.EXPIRED.NEW_SESSION',
  p_message_language => 'es-bo',
  p_message_text => 'Haga clic <a href="%0">aqu�</a> para crear una nueva sesi�n.');



COMMIT; 
END;

