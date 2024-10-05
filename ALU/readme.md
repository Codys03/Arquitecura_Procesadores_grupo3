
# ¿Cómo Funciona el Código de la ALU?

Este código define un módulo llamado `alu`, que implementa una Unidad Aritmético-Lógica (ALU) capaz de realizar operaciones de suma, resta y multiplicación. Las operaciones se seleccionan a través de una señal de operación (`OP`), y los resultados de las operaciones se reflejan en varias salidas.

# Explicación Paso a Paso

## 1. Definición del Módulo:

El módulo en Verilog encapsula la lógica de la ALU y define sus entradas y salidas.

### Entradas:

+ **clk**: Señal de reloj que sincroniza las operaciones de la ALU.
+ **A**: Primer operando de 4 bits.
+ **B**: Segundo operando de 4 bits.
+ **OP**: Código de operación de 2 bits que determina qué operación realiza la ALU:
  - `00`: Suma.
  - `01`: Resta.
  - `10`: Multiplicación.
  - `11`: Operación vacía (no hace nada).
+ **sel**: Selección de operación para el módulo restador.
+ **init**: Señal de inicio que inicia el proceso de multiplicación.

### Salidas:

+ **Signo**: Señal que indica si el resultado de la resta es negativo.
+ **done**: Señal que indica cuando la multiplicación ha terminado.
+ **C_out**: Acarreo de salida de la operación de resta.
+ **C_out_s**: Acarreo de salida de la operación de suma.
+ **resul**: Resultado de la operación seleccionada, de hasta 6 bits.
+ **dis**: Señal que conecta el resultado a un decodificador para ser mostrado en un display de 7 segmentos.

## 2. Instanciación de Módulos:

Este código reutiliza varios módulos para realizar las operaciones individuales de suma, resta y multiplicación:

```verilog
sum4b s0(.A(A), .B(B), .Ci('b0), .Cout(C_out_s), .Sum(resul_sum));
Restador r0(.A(A), .B(B), .Resultado(resul_res), .Signo(Signo), .sel(sel), .C_out(C_out));
multiplicador m0(.clk(clk), .init(init), .MR(r_bitsA), .MD(r_bitsB), .done(done), .pp(resul_mult));
decoder deco(.num(resul), .Sseg(dis));

## 3. Descripción de los Módulos:

- **sum4b**: Realiza la operación de suma de 4 bits entre `A` y `B`. El resultado se almacena en `resul_sum` y el acarreo en `C_out_s`.
- **Restador**: Realiza la resta entre `A` y `B`. El resultado se almacena en `resul_res`, el signo del resultado en `Signo`, y el acarreo en `C_out`.
- **multiplicador**: Realiza la multiplicación secuencial de los 3 bits más bajos de `A` (`r_bitsA`) y `B` (`r_bitsB`). El resultado se almacena en `resul_mult` y la señal `done` indica cuando la operación ha finalizado.
- **decoder**: Decodifica el resultado (`resul`) para mostrarlo en un display de 7 segmentos mediante la señal `dis`.

## 4. Operación de la ALU:

El bloque `always` determina qué operación realiza la ALU según el valor de `OP`:

```verilog
always @(*) begin
	case (OP)
		2'b00: resul <= {2'b0, resul_sum};  // Suma
		2'b01: resul <= {2'b0, resul_res};  // Resta
		2'b10: resul <= resul_mult;         // Multiplicación
		2'b11: resul <= A & B;            // Operación AND entre A y B
		default: resul <= 'b00000;
	endcase
end

Suma (OP = 00): El resultado de la suma (resul_sum) se asigna a resul, extendiendo los 4 bits de resul_sum a 6 bits.
Resta (OP = 01): El resultado de la resta (resul_res) se asigna a resul, también extendido a 6 bits.
Multiplicación (OP = 10): El resultado de la multiplicación (resul_mult) se asigna directamente a resul.
Operación AND (OP = 11): Se asigna el resultado de la operación lógica AND entre A y B a resul.
Default: Si ninguna operación es seleccionada, se asigna 00000 a resul.

## 5. Multiplicación Secuencial:
La multiplicación se realiza en un módulo aparte y utiliza solo los 3 bits más bajos de A y B para calcular el producto. Esto se hace asignando las variables r_bitsA y r_bitsB:

assign r_bitsA = A[2:0];
assign r_bitsB = B[2:0];
## 6. Decodificación:
El módulo decoder convierte el resultado en un formato que puede ser mostrado en un display de 7 segmentos:

decoder deco(.num(resul), .Sseg(dis));










