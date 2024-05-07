# frozen_string_literal: true

class User < ApplicationRecord
  #before_create :generate_confirmation_token
  has_secure_password
  has_secure_token :reset_password_token

  validates :email, presence: { message: 'El email de usuario no puede estar en blanco' },
            uniqueness: { message: 'El email de usuario ya está en uso' },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'El formato del email es inválido' }

  validates :username, presence: { message: 'El nombre de usuario no puede estar en blanco' },
            uniqueness: { message: 'El nombre de usuario ya está en uso' },
            format: { with: /\A[a-z0-9]+\z/, message: 'El nombre de usuario solo puede contener letras minúsculas y números' }
  validates :password, length: { minimum: 8, message: 'La contraseña debe tener al menos 8 caracteres' },
                       format: { with: /\A.*(?=.*\d).*\z/, message: 'La contraseña debe contener al menos un dígito' }
  validates :role, inclusion: { in: %w[usuario moderador administrador], message: 'El rol no es válido' }

  attribute :deleted, :boolean, default: false
  #attribute :email_confirmed, :boolean, default: false

  has_many :favoritos
  has_many :libros
  has_many :reportes, -> { where(deleted: false) }, foreign_key: :usuario_reportado_id
  has_many :resenhas
  has_many :comentarios
  has_many :lecturas
  has_one :persona

  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Seguidor'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followed_relationships, foreign_key: :follower_id, class_name: 'Seguidor'
  has_many :followeds, through: :followed_relationships, source: :followed

  def regenerate_reset_password_token!
    self.regenerate_reset_password_token # Genera un nuevo token de restablecimiento de contraseña
    self.save! # Guarda el registro actualizado en la base de datos
  end

  def show(params, user)
    finded_user = User.find_by(id: params[:id])
    return [{ message: 'No se encontró el usuario' }, 404] if finded_user.nil?
  
    seguidor = Seguidor.exists?(follower_id: user.id, followed_id: finded_user.id,deleted:false)
    seguido = Seguidor.exists?(follower_id: finded_user.id, followed_id: user.id,deleted:false)
  
    user_data = UserSerializer.new(finded_user).as_json
    user_data[:seguidor] = seguidor
    user_data[:seguido] = seguido
  
    user_data
  end
  def libros_en_progreso(params)
    libros_en_progreso = Libro.joins(:lecturas)
                              .where(lecturas: { user_id: id, terminado: false, deleted: false })
                              .order(updated_at: :desc)
                              .distinct
                              .paginate(page: params[:page])
    total_items = libros_en_progreso.count
    libros_serializados = libros_en_progreso.map { |libro| LibroSerializer.new(libro) }
    params[:page]
    libros_en_progreso.total_pages
    { total_pages: libros_en_progreso.total_pages,
      total_items:,
      last_page: params[:page] == libros_en_progreso.total_pages,
      libros: libros_serializados }
  end

  def lista_lectura(params)
    libros_en_progreso = Libro.joins(:lecturas)
                              .where(lecturas: { user_id: params[:user_id], deleted: false })
                              .order(updated_at: :desc)
                              .distinct
                              .paginate(page: params[:page])
    total_items = libros_en_progreso.count
    libros_serializados = libros_en_progreso.map { |libro| LibroSerializer.new(libro) }

    { total_pages: libros_en_progreso.total_pages,
      total_items:,
      libros: libros_serializados }
  end

  def cambiar_rol(id,role)
    usuario = User.find_by(id: id)
    if usuario.nil?
      return [{ error: 'Usuario no encontrado' }, :unprocessable_entity]
    end

    if !(role=='moderador') && !(role=='usuario') && !(role=='administrador')
      return [{ error: 'Rol invalido' }, :unprocessable_entity]
    end

    usuario.role = role
    usuario.update_columns(role:role)
    return [usuario, :ok]

  end

  def borradores(params, user)
    libros = user.libros.includes(:capitulos).where(capitulos: { publicado: false }).distinct.paginate(page: params[:page])

    libros_con_ultimo_capitulo_no_publicado = libros.map do |libro|
      ultimo_capitulo_no_publicado = libro.capitulos.where(publicado: false).order(updated_at: :desc).first
      capitulo = CapituloForOwnerSerializer.new(ultimo_capitulo_no_publicado)
      libro = LibroSerializer.new(libro)
      { libro:, ultimo_capitulo_no_publicado: capitulo }
    end
    total_pages = libros.total_pages
    {
      total_pages:,
      last_page: params[:page].to_i == total_pages, # Asegúrate de convertir params[:page] a entero
      libros: libros_con_ultimo_capitulo_no_publicado
    }
  end

  def update_password(params, user)
    if user.authenticate(params[:current_password])
      if params[:new_password] == params[:confirm_password]
        if user.update(password: params[:new_password], email: user.email)
          [{ message: 'Contraseña actualizada exitosamente' }, :ok]
        else
          [user.errors, :unprocessable_entity]
        end
      else
        [{ error: 'Las contraseñas no coinciden' }, :unprocessable_entity]
      end
    else
      [{ error: 'Contraseña actual incorrecta' }, :unprocessable_entity]
    end
  end

  # @return [[Hash{Symbol->String (frozen) | UserSerializer}, Symbol]]
  def update_username(params, user)
    if user.authenticate(params[:password])
      if user.update(username: params[:username], password: params[:password], email: user.email)
        [{ message: 'Username actualizado con exito', user: UserSerializer.new(user) }, :ok]
      else
        [{ error: 'Nombre de usuario en uso.' }, :unprocessable_entity]
      end
    else
      [{ error: 'Contraseña incorrecta' }, :unprocessable_entity]
    end
  end

  def update_profile(params, user)
    @persona = user.persona
    @persona = Persona.new(user_id: user.id) if @persona.nil?
    return { error: 'Se debe pasar el perfil' }, 400 unless params[:profile].present?
    @persona.profile = guardar_perfil(params)
    if @persona.save
      [user, :ok]
    else
      [@persona.errors, :unprocessable_entity]
    end
  end

  def delete_profile(user)
      @persona = user.persona
      @persona.profile = eliminar_perfil(@persona.profile)
      if @persona.save
        [user, :ok]
      else
        [@persona.errors, :unprocessable_entity]
      end
  end

  def update_portada(params, user)
    @persona = user.persona
    return { error: 'Se debe pasar el perfil' }, 400 unless params[:portada].present?

    @persona.portada = guardar_portada(params)

    if @persona.save
      [user, :ok]
    else
      [@persona.errors, :unprocessable_entity]
    end
  end

  def delete_portada(user)
    @persona = user.persona
    @persona.portada = eliminar_perfil(@persona.portada)
    if @persona.save
      [user, :ok]
    else
      [@persona.errors, :unprocessable_entity]
    end
  end

  def eliminar_cuenta(user, params)
    if user.authenticate(params[:password])
      eliminar_recuperar_datos(user.id, true)
      user.persona.update(fecha_eliminacion: Time.now)
      if user.update(deleted: true, password: params[:password])
        [{ message: 'Eliminado con exito' }, :ok]
      else
        [{ error: 'Error al eliminar el usuario' }, :unprocessable_entity]
      end
    else
      [{ error: 'Contraseña incorrecta' }, :unprocessable_entity]
    end
  end

  def delete_user(user, usuario_a_eliminar, params)
    return { error: 'El usuario no se encontró' }, :bad_request if usuario_a_eliminar.blank?
    if usuario_a_eliminar.id != user.id && user.role != 'moderador' && user.role != 'administrador'
      return { error: 'El usuario no puede eliminar a otro usuario' }, :forbidden
    end
    if usuario_a_eliminar.id != user.id && usuario_a_eliminar.role == 'moderador' && user.role == 'moderador'
      return { error: 'El moderador no puede eliminar a otro moderador, solo un administrador' }, :forbidden
    end
    eliminar_recuperar_datos(usuario_a_eliminar.id, true)
    if usuario_a_eliminar.persona.update(baneado: true)
      solicitud = SolicitudDesbaneo.new(estado:"pendiente")
      solicitud.baneado = usuario_a_eliminar
      solicitud.moderador_id = user.id
      solicitud.save!
      NotificationMailer.with(user: usuario_a_eliminar).ban_notification.deliver_later
      [{ message: 'Eliminado con exito' }, :ok]
    else
      [{ error: 'Error al eliminar el usuario' }, :unprocessable_entity]
    end
  end

  def restablecer_cuenta(user, params)
    eliminar_recuperar_datos(user.id, false)
    user.persona.update(fecha_eliminacion: nil)
    user.update(deleted: false, password: params[:password])
  end

  def desbanear(id)
    user = User.find_by(id: id)
    return {message: "Usuario no encontrado"}, 400 if user.blank?
    eliminar_recuperar_datos(user.id, false)
    if user.persona.update(baneado: false, fecha_eliminacion: nil)
      return {message: "Usuario desbaneado"}, 200
    else
      return {error: "Ha ocurrido un error al desbanear al usuario"}, 400
    end
  end

  def eliminar_email_usuarios_no_baneados

  end
  private
  def guardar_perfil(params)
    if params[:profile].present?
      cloudinary_response = Cloudinary::Uploader.upload(params[:profile], folder: 'fotosPerfil')

      return cloudinary_response['public_id'] if cloudinary_response['public_id'].present?

      render json: { error: 'No se pudo guardar la imagen.' }, status: :unprocessable_entity
      return

    end
    ''
  end

  def guardar_portada(params)
    if params[:portada].present?
      cloudinary_response = Cloudinary::Uploader.upload(params[:portada], folder: 'fotosPerfil')
      return cloudinary_response['public_id'] if cloudinary_response['public_id'].present?
      render json: { error: 'No se pudo guardar la imagen.' }, status: :unprocessable_entity
      return
    end
    ''
  end

  def eliminar_perfil(public_id)
    return if public_id.blank?
    cloudinary_response = Cloudinary::Uploader.destroy(public_id)
    unless cloudinary_response['result'] == 'ok'
      # render json: { error: 'No se pudo eliminar la foto de perfil.' }, status: :unprocessable_entity
    end
    ''
  end
  def eliminar_recuperar_datos(user_id, deleted)
    tables_to_update = ActiveRecord::Base.connection.tables.select do |table_name|
      ActiveRecord::Base.connection.column_exists?(table_name, :user_id) &&
        ActiveRecord::Base.connection.column_exists?(table_name, :deleted) &&
          ActiveRecord::Base.connection.column_exists?(table_name, :deleted_by_user)
    end
    tables_to_update.each do |table_name|
      model_class = table_name.singularize.classify.constantize
      model_class.where(user_id: user_id, deleted_by_user: false).update_all(deleted: deleted)
    end
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end
end
