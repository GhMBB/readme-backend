class SolicitudRestauracionContenidosController < ApplicationController
  before_action :authenticate_request


  def index
    usuario = get_user
    if !(usuario.role=="moderador") && !(usuario.role=="administrador")
      render json: {error: "No tienes los permisos necesarios para realizar esta accion"}, status: 401
      return
    end

    if !params[:page].present?
      render json: {error: "Debe proporcionar el numero de la pagina"}, status: 400
      return
    end


    solicitudes = SolicitudRestauracionContenido.getPage(
                              params[:page],
                              params[:username],
                              params[:estado],
                              params[:fecha_desde],
                              params[:fecha_hasta],
                              params[:tipo]
                            )

    render json: solicitudes, status: :ok
  end


  def create_solicitud_libro

    usuario = get_user

    if params[:libro_id].nil?
      render json: {error: "Debe proporcionar el id del libro"}, status: 400
      return
    end

    message, status = SolicitudRestauracionContenido.create_solicitud_libro(usuario,params)
    render json: message.as_json, status: status, serializer: nil
  end

  def create_solicitud_comentario

    usuario = get_user

    if params[:comentario_id].nil?
      render json: {error: "Debe proporcionar el id del comentario"}, status: 400
      return
    end

    message, status = SolicitudRestauracionContenido.create_solicitud_comentario(usuario,params)
    render json: message.as_json, status: status, serializer: nil
  end

  def aceptar_restauracion
    usuario = get_user
    if !(usuario.role=="moderador") && !(usuario.role=="administrador")
      render json: {error: "No tienes los permisos necesarios para realizar esta accion"}, status: 401
      return
    end

    message, status = SolicitudRestauracionContenido.aceptar_restauracion(params[:solicitud_id],usuario)
    render json: message.as_json, status: status, serializer: nil
  end

  def rechazar_restauracion
    usuario = get_user
    if !(usuario.role=="moderador") && !(usuario.role=="administrador")
      render json: {error: "No tienes los permisos necesarios para realizar esta accion"}, status: 401
      return
    end

    message, status = SolicitudRestauracionContenido.rechazar_restauracion(params[:solicitud_id],usuario)
    render json: message.as_json, status: status, serializer: nil
  end

end
