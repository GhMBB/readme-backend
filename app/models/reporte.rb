class Reporte < ApplicationRecord
  belongs_to :user
  #belongs_to :libro
  #belongs_to :comentario

  enum estado: {
    pendiente: 'pendiente',  #Cuando se crea el reporte
    en_revision: 'en_revision', # Cuando un usuario moderador está evaluando el reporte
    aceptado: 'aceptado', #Si el reporte fue aceptado
    rechazado: 'rechazado', #Si el moderador rechaza el reporte
    resuelto: 'resuelto' #Una vez que se ha tomado alguna acción sobre el reporte, como la eliminacion del contenido reportado.
  }
end
