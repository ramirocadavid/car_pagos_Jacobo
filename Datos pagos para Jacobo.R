# Lista de archivos a utilizar
archivos.dbf <- c("car_pagos.DBF", "car_vigente.DBF", "car_mcre.DBF" )

# Librería para leer archivos .dbf (foreign) y manipular objetos (dplyr)
library(foreign)
library(dplyr)

# Importar datos
for(i in seq_along(archivos.dbf)) {
     assign(archivos.dbf[i], read.dbf(archivos.dbf[i]))
     assign(archivos.dbf[i], select(get(archivos.dbf[i]),
                                    -starts_with("X")))
}

# Seleccionar variables
car_pagos <- select(car_pagos.DBF, CEDULA:INTPENDI, -FECHA)
# Crear variable de año
car_pagos <- data.frame(car_pagos, 
                        periodo = as.numeric(substr(car_pagos$FECHACRE, 
                                                    1, 4)))

# Filtrar datos 2014-2017 reestructurados
car_pagos <- car_pagos[car_pagos$periodo >= 2014 &
                         car_pagos$CODCREDITO == 5, ]
# Nombres variables
names(car_pagos) <- c("cedula", "codigo_credito", "municipio",
                      "numero_credito", "fecha", "fecha_vencimiento",
                      "dias_credito", "dias_plazo", "dias_mora", "credito",
                      "seguro", "interes", "provision", "capital",
                      "valor_total", "numero_pago", "interes_mora",
                      "interes_causado", "interes_pendiente", "periodo")
# Exportar datos
write.csv(car_pagos, "pagos_cartera_reest_14_17.csv")
