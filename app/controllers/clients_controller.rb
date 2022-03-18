class ClientsController < ApplicationController

    def show
        client = Client.find(params[:id])
        render json: client, include: :memberships, methods: :total_memberships_price, except: [:created_at, :updated_at]
    end

    def update
        # byebug
        client = Client.find(params[:id])
        client.update!(client_params)
        render json: client, status: :accepted
    end

    private 
    def client_params
        params.permit(:age, :name)
    end

end
