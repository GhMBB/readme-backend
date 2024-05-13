class SolicitudDesbaneosController < ApplicationController
  before_action :authenticate_request, except: %i[create] 


  # GET /solicitud_desbaneos
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


    solicitudes = SolicitudDesbaneo.getPage(
                              params[:page],
                              params[:username],
                              params[:estado],
                              params[:fecha_desde],
                              params[:fecha_hasta]
                            )

    render json: solicitudes, status: :ok
  end

  # POST /solicitud_desbaneos
  def create

    if params[:email].nil?
      render json: {error: "Debe proporcionar un email"}, status: 400
      return
    end

    message, status = SolicitudDesbaneo.create_solicitud(params[:email],params[:justificacion])
    render json: message, status: status
  end

  def aceptar_desbaneo
    usuario = get_user
    if !(usuario.role=="moderador") && !(usuario.role=="administrador")
      render json: {error: "No tienes los permisos necesarios para realizar esta accion"}, status: 401
      return
    end

    message, status = SolicitudDesbaneo.aceptar_desbaneo(params[:solicitud_id],usuario)
    render json: message, status: status
  end

  def rechazar_desbaneo
    usuario = get_user
    if !(usuario.role=="moderador") && !(usuario.role=="administrador")
      render json: {error: "No tienes los permisos necesarios para realizar esta accion"}, status: 401
      return
    end

    message, status = SolicitudDesbaneo.rechazar_desbaneo(params[:solicitud_id],usuario)
    render json: message, status: status
  end


end
