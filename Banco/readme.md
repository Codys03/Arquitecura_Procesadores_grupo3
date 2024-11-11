# Explicación del Banco de Registros

Este código define un módulo de Banco de Registro en Verilog, que es una estructura fundamental para almacenar y acceder a múltiples registros en sistemas digitales. Un banco de registros es útil en arquitecturas de procesamiento como CPUs, donde se necesita almacenar temporalmente datos para operaciones rápidas y su acceso directo a través de direcciones.

## Resumen del Código
El código define un módulo de banco de registros parametrizable que permite realizar operaciones de lectura y escritura en un conjunto de registros. Estos registros se inicializan con datos provenientes de un archivo de memoria ``(Reg16.mem)`` que contiene los valores iniciales de cada registro.

### Parámetros Definidos:

* ``BIT_ADDR``: Define el número de bits de la dirección. Aquí es ``8``, lo que permite un máximo de 2^8 = 256 direcciones de registro.
* ``BIT_DATO``: Especifica el tamaño de cada dato en bits. Aquí es 4, de modo que cada registro almacena 4 bits.
* ``RegFILE``: Es el archivo de memoria inicial, aquí "Reg16.mem", que contiene los valores de los registros iniciales.

### Entradas y Salidas:

* ``addrRa`` y ``addrRb``: Son las direcciones de lectura para los registros Ra y Rb, respectivamente.
* ``datOutRa`` y ``datOutRb``: Son las salidas de datos correspondientes a Ra y Rb.
* ``addrW`` y ``datW``: Dirección de escritura y dato a escribir.
* ``RegWrite``: Señal de habilitación de escritura (si está activa, permite la escritura en el registro especificado por addrW).
* ``clk`` y ``rst``: Señales de reloj y reinicio para controlar el tiempo y estado del banco de registros.

## Desglose del Funcionamiento Interno

### Declaración del Banco de Registros:
```
reg [BIT_DATO-1: 0] breg [NREG-1:0];
```
Esta línea define ``breg`` como una matriz de registros de ``NREG`` entradas, cada una de ``BIT_DATO`` bits. Aquí, ``NREG`` se calcula como 
2 ^BIT_ADDR, lo cual indica el número de registros disponibles en el banco.

### Asignación de Salidas:
```
assign datOutRa = breg[addrRa];
assign datOutRb = breg[addrRb];
```
Estas asignaciones hacen que ``datOutRa`` y ``datOutRb`` sean siempre iguales al contenido de los registros en las direcciones ``addrRa`` y ``addrRb``. Es decir, permiten leer los datos de los registros de manera continua y sin necesitar señal de habilitación.

### Escritura en el Banco de Registros:

```
always @(posedge clk) begin
   if (RegWrite == 1)
      breg[addrW] <= datW;
end
```
Este bloque ``always`` se ejecuta en cada flanco positivo de ``clk``. Si la señal ``RegWrite`` está en 1, el valor de ``datW`` se escribe en el registro cuya dirección es ``addrW``.

### Inicialización del Banco de Registros:
```
initial begin
   $readmemh(RegFILE, breg);
end
```
En esta sección inicial, se usa ``$readmemh`` para cargar los valores iniciales de los registros desde un archivo hexadecimal (``Reg16.mem``). Aquí, el archivo ``Reg16.mem`` contendrá los valores ``1, 2, 3, 4`` y se colocarán en las primeras posiciones de ``breg``.

### Análisis Funcional de ``Reg16.mem``

Este archivo ``Reg16.mem`` almacena los valores iniciales de cada registro. En este caso, el archivo contiene cuatro valores (``1, 2, 3, 4``), que serán cargados en los primeros cuatro registros de ``breg``. Esto es útil para inicializar el banco de registros con datos específicos antes de que el circuito comience a operar.

### Flujo de Operación
1. Inicialización: Al iniciar la simulación o el hardware, el archivo ``Reg16.mem`` carga los valores iniciales en el banco de registros.
2. Lectura: En cada ciclo, los registros `Ra` y ``Rb`` se leen en las direcciones ``addrRa`` y ``addrRb``.
3. Escritura: Cuando ``RegWrite`` está en ``1``, el valor ``datW`` se escribe en el registro en la dirección ``addrW`` en el flanco positivo de ``clk``.

Este código representa un banco de registros simple que permite lectura dual (en dos registros al mismo tiempo) y escritura controlada por una señal de habilitación (``RegWrite``), útil en el diseño de procesadores y otros sistemas digitales que requieren múltiples registros.

Este banco de registros es útil para simular sistemas de almacenamiento en arquitecturas digitales. Las capacidades de lectura y escritura controladas permiten manejar datos de manera eficiente en sistemas embebidos y procesadores.

