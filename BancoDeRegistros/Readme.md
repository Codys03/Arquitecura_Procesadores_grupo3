# Explicación del módulo `mips_suma`

Este es un módulo en Verilog llamado `mips_suma`, que simula una operación de suma usando un sistema basado en MIPS. A continuación, se explica cada sección y sus conexiones.

## 1. Entradas y salidas del módulo

- **Entradas**:
  - `clk`: Señal de reloj que sincroniza el sistema.
  - `operador`: Entrada de 4 bits que se utiliza como parte de la dirección de la instrucción en la memoria.
  - `rst`: Señal de reinicio.
  - `RegWrite`: Señal de control que indica si se permite escribir en el banco de registros.

- **Salida**:
  - `dis`: Salida de 14 bits para el display de 7 segmentos (probablemente para mostrar el resultado en una pantalla).

## 2. Wires y asignaciones

- **`salidamem`**: Es una señal de 32 bits que almacena el valor de la instrucción leída de la memoria de instrucciones.
- **`A` y `B`**: Son señales de 5 bits que representan las direcciones de los registros a leer en el banco de registros. Se asignan a partir de la instrucción (`salidamem`):
  - `A`: Se extrae de los bits 25 a 21 de `salidamem`.
  - `B`: Se extrae de los bits 20 a 16 de `salidamem`.
- **`addrW`**: Dirección del registro donde se escribirá el resultado de la ALU. Se asigna a partir de los bits 15 a 11 de `salidamem`.
- **`op`**: Código de operación (de 6 bits) que define la operación aritmética/lógica a realizar. Se extrae de los bits 5 a 0 de `salidamem`.
- **`datOutRa` y `datOutRb`**: Son las salidas del banco de registros correspondientes a las direcciones `A` y `B`.
- **`datw`**: Es el dato que se escribirá en el banco de registros, que corresponde al resultado de la operación en la ALU.

## 3. Instanciaciones de módulos

- **Memoria de instrucciones (`mem_ins`)**: Este módulo simula la memoria de instrucciones, que contiene las instrucciones a ejecutar. La dirección `addrRa` recibe la entrada `operador` extendida con 28 ceros a la izquierda. `datOutRa` es la salida que contiene la instrucción (`salidamem`) que se decodifica en los wires `A`, `B`, `addrW` y `op`.
  
- **Banco de registros (`BancoRegistro`)**: Este módulo simula el banco de registros de la arquitectura MIPS. Se leen los registros `A` y `B` para obtener `datOutRa` y `datOutRb`, y `datw` es el dato que se escribirá en el registro `addrW` si `RegWrite` está activo.
  
- **ALU**: Es la unidad aritmética/lógica que toma las entradas `datOutRa` y `datOutRb` y realiza la operación indicada por `op`. El resultado se almacena en `datw`.
  
- **Decodificador (`decoder`)**: Este módulo toma el valor de `datw[7:0]` y lo convierte en una señal para un display de 7 segmentos (`dis`). Esto podría ser para mostrar el resultado en un formato visual.

## Funcionamiento general del módulo

1. **Lectura de instrucción**: `mem_ins` toma `operador` como entrada de dirección y devuelve una instrucción completa en `salidamem`.
2. **Decodificación de la instrucción**: A partir de `salidamem`, se extraen `A`, `B`, `addrW` y `op`, que identifican los registros de entrada y la operación a realizar.
3. **Lectura de registros**: `BancoRegistro` toma `A` y `B` y lee los valores en `datOutRa` y `datOutRb`.
4. **Operación en la ALU**: La ALU recibe `datOutRa`, `datOutRb` y `op` para realizar la operación especificada (suma, en este caso). El resultado se almacena en `datw`.
5. **Mostrar resultado**: El decodificador convierte los 8 bits menos significativos de `datw` (`datw[7:0]`) a una señal `dis` para un display de 7 segmentos, mostrando el resultado en la salida `dis`.

Este código realiza una operación de suma entre dos registros, leyendo de una instrucción almacenada en `mem_ins`, ejecutándola a través del banco de registros y la ALU, y finalmente mostrando el resultado en un display.

