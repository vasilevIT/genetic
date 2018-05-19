function x = chromosomeGetFloat(l, min, max, chromosome_size)
x = min + (l * (max - min)) / (2 ^ chromosome_size - 1);