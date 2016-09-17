

# CUDA: Background Remover with WebCam using CUDA and OpenCV

## resumen

La susbtracción de fondo, tiene un significado muy importante en la detección y seguimiento de objetos en vídeo. Una gran parte de los esfuerzos de investigación de la detección de objetos y el seguimiento se centró en este problema en la última década \cite{Sonka2000}. En comparación con la detección de objetos sin movimiento , por un lado, la detección de movimiento complica el problema de detección de objetos mediante la adición del cambio temporal del objeto, pero por otra parte, también proporciona otra fuente de información para la detección y el seguimiento.


Se han propuesto una gran variedad de algoritmos de detección de movimiento que se pueden clasificar en los siguientes grupos:

* Background Substracción con Operador Diferencial,(q es el q usaremos ahora).
*Background Substracción con Desviacion Estandar: 
*Otros...

## Pruebas

* Procesador 3.4 Ghz. Intel i7
* 8Gb de RAM. 
* Windows 7 - 64 bits.
* opencv-2.4.13
* CUDA 7.5 
* Visual Studio 2013
* Webcam LogiTech HD 1080p 30 (frames por segundo)

Adicional a ello en GPU: 

* warp size: 32
* Threads por bloque: 1024
* Multiprocesadores: 5

## Mas Info
https://www.overleaf.com/1491429mkzkgf#/3850714/
filiberto.vilca.apaza@ucsp.edu.pe
sugerencia: probar primero con las 2 imagenes antes que con la
webcam

## Recomendaciones:

* Utilizar Zero-Copy con CUDA
* Realizar un profiling de los tiempos de calculo
* revisar cuantos frames calcula la webcam
* entonces cuantos frames se puede procesar con cuda?
