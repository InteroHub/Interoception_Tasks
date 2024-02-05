clear all

bloque.intero = {'intero' 'motor'};
bloque.contador = 0;
secuencias(1) = bloque;
bloque.intero = {'motor' 'intero'};
secuencias(2) = bloque;

save('secuencias.mat', 'secuencias');


