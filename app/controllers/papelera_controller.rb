class PapeleraController < ApplicationController
    before_action :authenticate_request
    def index
        user = get_user
        papelera_data = Libro.get_papelera(user, params[:page])
        render json: papelera_data, status: :ok, serializer: nil
    end

    def restore_libro
        user = get_user
        response, status = Libro.restore_libro(user, params[:id])
        render json: response, status: status, serializer: LibroSerializer
    end

    def restore_capitulo
        user = get_user
        response, status = Capitulo.restore_capitulo(user, params[:id])
        render json: response, status: status, serializer: CapituloForOwnerSerializer
    end
end
