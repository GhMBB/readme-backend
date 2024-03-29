class User < ApplicationRecord
    has_secure_password
    validates :username, presence: { message: "El nombre de usuario no puede estar en blanco" }, uniqueness: { message: "El nombre de usuario ya está en uso" }
    validates :password, length: { minimum: 8, message: "La contraseña debe tener al menos 8 caracteres" }, format: { with: /\A.*(?=.*\d).*\z/, message: "La contraseña debe contener al menos un dígito" }
    validates :role, inclusion: { in: %w(usuario moderador), message: "El rol no es válido" }

    attribute :deleted, :boolean, default: false

    has_many :favoritos
    has_many :libros
    has_many :reportes, -> { where(deleted: false) }, foreign_key: :usuario_reportado_id
    has_many :resenhas
    has_many :comentarios
    has_many :lecturas
    has_one :persona

    def libros_en_progreso(params)
        libros_en_progreso = Libro.joins(:lecturas)
                                  .where(lecturas: { user_id: id, terminado: false, deleted: false })
                                  .order(updated_at: :desc)
                                  .distinct
                                  .paginate(page: params[:page])

        libros_serializados = libros_en_progreso.map { |libro| LibroSerializer.new(libro) }

        return {total_pages: libros_en_progreso.total_pages,
                last_page:  params[:page] == libros_en_progreso.total_pages,
                libros: libros_serializados}
    end

    def libros_con_capitulos_no_publicados(params, user)

        libros = user.libros.includes(:capitulos).where(capitulos: { publicado: false }).distinct.paginate(page: params[:page])

        libros_con_ultimo_capitulo_no_publicado = libros.map do |libro|
            ultimo_capitulo_no_publicado = libro.capitulos.where(publicado: false).order(updated_at: :desc).first
            capitulo = CapituloForOwnerSerializer.new(ultimo_capitulo_no_publicado)
            libro = LibroSerializer.new(libro)
            { libro: libro, ultimo_capitulo_no_publicado: capitulo }
        end
        total_pages = libros.total_pages
        return {
          total_pages: total_pages,
          last_page: params[:page].to_i == total_pages, # Asegúrate de convertir params[:page] a entero
          libros: libros_con_ultimo_capitulo_no_publicado
        }
    end

    def update_password(params, user)
        if user.authenticate(params[:current_password])
            if params[:new_password] == params[:confirm_password]
                if user.update(password: params[:new_password])
                    return  {message: 'Contraseña actualizada exitosamente'}, :ok
                else
                    return  user.errors, :unprocessable_entity
                end
            else
                return  { error: 'Las contraseñas no coinciden' },:unprocessable_entity
            end
        else
            return  { error: 'Contraseña actual incorrecta' }, :unprocessable_entity
        end
    end

    def update_username(params, user)
        if user.authenticate(params[:password])
            if user.update(username: params[:username], password: params[:password])
                return {message: "Username actualizado con exito", user: UserSerializer.new(user)},  :ok
            else
                return { error: 'Nombre de usuario en uso.' },  :unprocessable_entity
            end
        else
            return { error: 'Contraseña incorrecta' }, :unprocessable_entity
        end
    end

    def update_profile(params, user)
        if user.authenticate(params[:password])
            @persona = user.persona
            if @persona.nil?
                @persona = Persona.new(user_id: user.id)
            end

            if params[:profile].present?
                @persona.profile = guardar_perfil(params)
            else
                return { error: 'Se debe pasar el perfil' }, 400
            end

            if @persona.save
                return  user, :ok
            else
                return  @persona.errors, :unprocessable_entity
            end
        else
            return { error: 'Contraseña incorrecta' }, :unprocessable_entity
        end

    end

    def update_birthday(params, user)
        if user.authenticate(params[:password])
            @persona = user.persona
            if @persona.nil?
                @persona = Persona.new(user_id: user.id)
            end

            @persona.fecha_de_nacimiento = params[:fecha_de_nacimiento]
            if @persona.save
                return  user, :ok
            else
                return  @persona.errors, :unprocessable_entity
            end
        else
            return { error: 'Contraseña incorrecta' }, :unprocessable_entity
        end
    end

    def delete_profile(params, user)
        if user.authenticate(params[:password])
            @persona = user.persona
            @persona.profile = eliminar_perfil(@persona.profile)
            if @persona.save
                return  user, :ok
            else
                return  @persona.errors, :unprocessable_entity
            end
        else
            return { error: 'Contraseña incorrecta' }, :unprocessable_entity
        end

    end

    private
    def guardar_perfil(params)
        if params[:profile].present?
            cloudinary_response = Cloudinary::Uploader.upload(params[:profile], :folder => "fotosPerfil")

            if cloudinary_response['public_id'].present?
                return cloudinary_response['public_id']
            else
                render json: { error: 'No se pudo guardar la imagen.' }, status: :unprocessable_entity
                return
            end
        end
        return ""
    end

    def eliminar_perfil(public_id)
        return if public_id.blank?

        cloudinary_response = Cloudinary::Uploader.destroy(public_id)

        if cloudinary_response['result'] == 'ok'
            return ""
        else
            #render json: { error: 'No se pudo eliminar la foto de perfil.' }, status: :unprocessable_entity
            return ""
        end
    end

end

  