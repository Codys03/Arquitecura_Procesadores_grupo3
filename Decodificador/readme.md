# Decodificación BCD a 7 Segmentos
Los displays de 7 segmentos son ampliamente utilizados en dispositivos electrónicos para mostrar números y caracteres alfanuméricos. Utilizando una configuración de polarización de ánodo común, cada segmento del display se enciende al aplicar un voltaje bajo a sus terminales de cátodo, mientras que la conexión común de ánodo se mantiene en alto. En este contexto, la conversión de un número en formato BCD (Decimal Codificado en Binario) a señales que controlen los segmentos del display es fundamental.

Para convertir un número decimal a su representación en un display de 7 segmentos, se utiliza el concepto de BCD (Decimal Codificado en Binario). En este sistema, cada dígito decimal se representa con un grupo de 4 bits. Por ejemplo, el número decimal 2 se codifica como ``0010`` en BCD. La decodificación de estos códigos BCD en señales adecuadas para encender los segmentos del display es esencial para mostrar correctamente los números.

Los módulos en Verilog que se explican a continuación se encargan de esta conversión, transformando un número en BCD a la correspondiente representación de segmentos para ser visualizada en un display de 7 segmentos.

# 1. Módulo BCD2Sseg

Este módulo se encarga de convertir un valor BCD de 4 bits en la correspondiente representación de 7 segmentos
[Codigo BCD](/Decodificador/bcd1.v).

###  Funcionamiento del Módulo BCD2Sseg

* Entradas y Salidas:
```
    input      [3:0] BCD, 
    output reg [6:0] Sseg
```

1. Entrada: Un número BCD de 4 bits (``BCD``).
2. Salida: Un valor de 7 bits (``Sseg``) que representa qué segmentos deben encenderse en un display de 7 segmentos.

* Decodificación:
```
 case (BCD)
            4'b0000: Sseg = 7'b0000001; // "0"  
            4'b0001: Sseg = 7'b1001111; // "1" 
            4'b0010: Sseg = 7'b0010010; // "2" 
            4'b0011: Sseg = 7'b0000110; // "3" 
            4'b0100: Sseg = 7'b1001100; // "4" 
            4'b0101: Sseg = 7'b0100100; // "5" 
            4'b0110: Sseg = 7'b0100000; // "6" 
            4'b0111: Sseg = 7'b0001111; // "7" 
            4'b1000: Sseg = 7'b0000000; // "8"  
            4'b1001: Sseg = 7'b0000100; // "9" 
            4'ha: Sseg = 7'b0001000;    // "A" 
            4'hb: Sseg = 7'b1100000;    // "B" 
            4'hc: Sseg = 7'b0110001;    // "C" 
            4'hd: Sseg = 7'b1000010;    // "D" 
            4'he: Sseg = 7'b0110000;    // "E" 
            4'hf: Sseg = 7'b0111000;    // "F" 
            default:
                Sseg = 7'b0;
        endcase
```
Utiliza una estructura case para determinar qué bits encender en el display según el valor de BCD.

Cada combinación de 4 bits se traduce en un patrón de 7 segmentos. Por ejemplo:

* 4'b0000 (0 en decimal) enciende todos los segmentos excepto el segmento G.
* 4'b0001 (1 en decimal) enciende los segmentos B y C.

#### Ejemplo:
Si la entrada ``BCD`` es ``4'b0010`` (que representa el número 2), el resultado ``Sseg`` será ``7'b0010010``, indicando que los segmentos que representan el número 2 deben estar encendidos.

# 2. Módulo decoder
Este módulo es un decodificador que convierte un número de 16 bits en sus representaciones BCD para unidades, decenas y centenas [Codigo](/Decodificador/decoder.v).

### Funcionamiento del Módulo decoder
#### Entradas y Salidas:
````
module decoder#(parameter displays=3, segments = 7)(
    input  [15:0] num,
    output [segments*displays-1:0] Sseg
);
````
* Entrada: Un número de 16 bits (num).
* Salida: Un vector que representa los segmentos a encender para múltiples displays, en este caso 3 displays de 7 segmentos.

#### Decodificación BCD:
Se separa el número en sus dígitos BCD de unidades, decenas y centenas:

* `` bcd_units``: Obtiene las unidades de num usando ``num % 10``.

* ``bcd_tens``: Obtiene las decenas usando la fórmula ``(num % 100 - num % 10) / 10.``

* ``bcd_hundreds``: Obtiene las centenas usando ``(num % 1000 - num % 100) / 100.``

#### Instanciación de Módulos:

Se instancian tres veces el módulo ``BCD2Sseg``, una para cada uno de los dígitos BCD (unidades, decenas, centenas). Cada instancia convierte el BCD correspondiente en el patrón de segmentos.

#### Ejemplo:
* Si num es 345 (en decimal):

1. bcd_units será 5 (0101 en BCD).
2. bcd_tens será 4 (0100 en BCD).
3. bcd_hundreds será 3 (0011 en BCD).

Los resultados de las instancias de BCD2Sseg serán:

* sseg_units para 5 → 7'b0100100
* sseg_tens para 4 → 7'b1001100
* sseg_hundreds para 3 → 7'b0000110

Finalmente, la salida Sseg concatenará estos valores para controlar un display de 3 dígitos de 7 segmentos.


Los módulos [BCD2Sseg ](/Decodificador/bcd1.v) y [decoder](/Decodificador/decoder.v) trabajan conjuntamente para convertir un número decimal en su representación visual utilizando displays de 7 segmentos con polarización de ánodo común. Al aplicar un voltaje bajo a los segmentos adecuados, se pueden mostrar números y caracteres, facilitando la visualización en diversas aplicaciones electrónicas.
