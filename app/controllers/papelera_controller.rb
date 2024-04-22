class PapeleraController < ApplicationController
    before_action :authenticate_request
    def index
        user = get_user
        papelera_data = Libro.get_papelera(user, params[:page])
        render json: papelera_data, status: :ok, serializer: nil
      end
end
