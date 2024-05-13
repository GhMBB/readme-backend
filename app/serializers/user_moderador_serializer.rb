# frozen_string_literal: true

class UserModeradorSerializer < ActiveModel::Serializer
    attributes :id, 
      :username, 
      :nombre, 
      :email, 
      :fecha_de_nacimiento, 
      :role_updated_at, 
      :registrado_por, 
      :reportes_resueltos_libros, 
      :reportes_rechazados_libros,
      :reportes_resueltos_comentarios,
      :reportes_rechazados_comentarios,
      :reportes_resueltos_usuarios,
      :reportes_rechazados_usuarios

    def username
        if object.deleted == true || object.persona.baneado == true
          'Usuario de Readme'
        else
          object.username
        end
    end

    def nombre
        object.persona&.nombre
    end

    def fecha_de_nacimiento
      object.persona&.fecha_de_nacimiento
    end

    def registrado_por
      object.role_updated_by&.username
    end

    def reportes_resueltos_libros
      object.reportes_manipulados.where(estado: 'resuelto').where.not(libro_id: nil).count
    end
  
    def reportes_rechazados_libros
      object.reportes_manipulados.where(estado: 'rechazado').where.not(libro_id: nil).count
    end
  
    def reportes_resueltos_comentarios
      object.reportes_manipulados.where(estado: 'resuelto').where.not(comentario_id: nil).count
    end
  
    def reportes_rechazados_comentarios
      object.reportes_manipulados.where(estado: 'rechazado').where.not(comentario_id: nil).count
    end
  
    def reportes_resueltos_usuarios
      object.reportes_manipulados.where(estado: 'resuelto').where.not(usuario_reportado_id: nil).count
    end
  
    def reportes_rechazados_usuarios
      object.reportes_manipulados.where(estado: 'rechazado').where.not(usuario_reportado_id: nil).count
    end
  
end
  