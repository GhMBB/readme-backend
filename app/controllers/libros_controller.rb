require 'cloudinary'

class LibrosController < ApplicationController
  before_action :set_libro, only: %i[ show update destroy]
  before_action :authenticate_request
  rescue_from StandardError, with: :internal_server_error

  # GET /libros
  def index
    libros = Libro.where(deleted: false).order(created_at: :desc)
    libros = filter_libros(libros)

    libros.each do |libro|
      libro.portada = obtener_portada(libro.portada)
    end if !params[:page]

    libros = paginate_libros(libros) if params[:page]

    render json: libros
  end


  # GET /libros/1
  def show
    edad_usuario = calcular_edad(get_user.persona.fecha_de_nacimiento)

    if edad_usuario < 18 && @libro.adulto
      render json: {error: "Debes ser mayor de edad para leer este libros"}, status: 403
      return
    end

    @libro.cantidad_lecturas = @libro.cantidad_lecturas+1
    @libro.save
    formated_libro = @libro
    formated_libro.portada = obtener_portada(@libro.portada)
    render json: formated_libro, usuario_id: get_user.id
  end

  # POST /libros
  def create
    usuario = get_user
    @libro = Libro.new(libro_params)
    @libro.user = usuario
    @libro.portada = guardar_portada

    if @libro.save
      @libro.portada = obtener_portada(@libro.portada)
      render json: @libro, status: :created
    else
      render json: @libro.errors, status: :unprocessable_entity
    end
  end

  def update
    if @libro.user != get_user
      render json: {error: "Debes ser el propietario del libro para editarlo."}, status: 401
      return
    end
    if @libro.update(libro_params)
      @libro.portada = guardar_portada if params[:portada].present?

      if @libro.save
        @libro.portada = obtener_portada(@libro.portada)
        render json: @libro, status: :ok
      else
        render json: @libro.errors, status: :unprocessable_entity
      end
    else
      render json: @libro.errors, status: :unprocessable_entity
    end
  end


  # DELETE /libros/1
  def destroy
    usuario = get_user
    if @libro.user != usuario && usuario.role != "moderador" && usuario.role != "administrador"
      render json: {error: "Debes ser el propietario del libro para editarlo o tener el rol de moderador."}, status: 401
      return
    end

    @libro.deleted = true
    @libro.deleted_by_user = @libro.user == usuario
    if @libro.save
      if @libro.user != usuario && usuario.role == "moderador" && usuario.role != "administrador"
        NotificationMailer.with(user: @libro.user, book:@libro).delete_book_notification.deliver_later
      end
      render status: :ok
    else
      render json: {error: "No se pudo eliminar el libro"}, status: 400
    end
  end
  def categorias
    categorias_enum = Libro.categoria
    @categorias = categorias_enum.keys.map { |key| [key.to_s, categorias_enum[key]] }
    render json: @categorias
  end

  def destroy_portada
    usuario = get_user
    @libro = Libro.find_by(id: params[:id], deleted: false)
    if @libro.user != usuario && usuario.role != "moderador" && usuario.role != "administrador"
      render json: {error: "Debes ser el propietario del libro para editarlo o tener el rol de moderador."}, status: 401
      return
    end
    @libro.portada = Libro.delete_portada(@libro.portada)
    if @libro.save
      return render json: @libro, status: :ok
    else
      return render json: {error: 'No se pudo eliminar la portada'}, status: :unprocessable_entity
    end
  end

  def handle_notification
    usuario = get_user
    if !params[:libro_id].present?
      return render json: { error: 'Debe proporcionar el id del libro' }, status: 400
    end
  
    notificacion = NotificacionDeCapitulo.find_by(user_id: usuario.id, libro_id: params[:libro_id])
  
    if notificacion.nil?
      NotificacionDeCapitulo.create(user_id: usuario.id, libro_id: params[:libro_id], deleted: false)
      return render json: { message: 'Notificación Activada correctamente' }, status: :ok
    elsif notificacion.deleted
      notificacion.update(deleted: false)
      return render json: { message: 'Notificación Activada correctamente' }, status: :ok
    else
      notificacion.update(deleted: true)
      return render json: { message: 'Notificación Desactivada correctamente' }, status: :ok
    end
  end

  def getIntereses
    message, status = Libro.getIntereses()
    render json: message.to_json, status: status
  end

  

  private
  def guardar_portada
    if params[:portada].present?
      cloudinary_response = Cloudinary::Uploader.upload(params[:portada], :folder => "libros")

      if cloudinary_response['public_id'].present?
        return cloudinary_response['public_id']
      else
        render json: { error: 'No se pudo guardar la imagen.' }, status: :unprocessable_entity
        return
      end
    end
    return ""
  end



  def obtener_portada(portada_public_id)
    if !portada_public_id
      return ""
    end

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{portada_public_id}", :resource_type => :image, :expires_at => (Time.now + 3600).to_i)
      return enlace_temporal
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      return ""
    end
  end

  def calcular_edad(fecha_nacimiento)
    begin
      now = Time.now.utc.to_date
      now.year - fecha_nacimiento.year - ((now.month > fecha_nacimiento.month || (now.month == fecha_nacimiento.month && now.day >= fecha_nacimiento.day)) ? 0 : 1)
    rescue => e
      puts "Error al calcular la edad: #{e.message}"
      # Aquí puedes manejar el error de la manera que desees, como devolver un valor predeterminado o lanzar una excepción diferente.
    end
  end
  

  def filter_libros(libros)
    libros = libros.where("titulo ILIKE ?", "%#{params[:titulo]}%") if params[:titulo]
    libros = libros.where(adulto: params[:adulto]) if params[:adulto]
    libros = libros.where(user_id: params[:user_id]) if params[:user_id]
    libros = libros.where(categoria: params[:categorias]) if params[:categorias].present?
    libros = libros.where("puntuacion_media >= ?", params[:puntuacion_media]) if params[:puntuacion_media].present?
    libros = libros.joins(:capitulos).where("capitulos.publicado = ?", true)
                   .group("libros.id")
                   .having("COUNT(capitulos.id) >= ?", params[:cantidad_minima_capitulos].to_i) if params[:cantidad_minima_capitulos]
   edad_usuario = calcular_edad(get_user.persona.fecha_de_nacimiento)
   puts edad_usuario
   libros = libros.where(adulto: false) if edad_usuario < 18

    libros
  end



  def paginate_libros(libros)
    page_number = params[:page].to_i


    paginated_libros = libros.paginate(page: page_number, per_page: WillPaginate.per_page)
    total_pages = paginated_libros.total_pages

    data = paginated_libros.map do |libro|
      serialized_libro = LibroSerializer.new(libro).as_json
      serialized_libro.merge(portada: obtener_portada(libro.portada))
    end


    {
      total_pages: total_pages,
      last_page: page_number == total_pages,
      total_items: paginated_libros.total_entries,
      data: data
    }
  end


  def set_libro
    @libro = Libro.find_by(id: params[:id], deleted: false)
    if @libro.nil?
      render json: { error: 'Libro no encontrado' }, status: :not_found
    end
  end


    def libro_params
      params.permit(:titulo, :sinopsis, :adulto, :categoria)
    end
end
