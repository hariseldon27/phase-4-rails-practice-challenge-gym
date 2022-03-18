class MembershipsController < ApplicationController
# validates uniqueness of name on uniqueness of gym? or error
    def index
        memberships = Membership.all
        render json: memberships, except: [:created_at, :updated_at]
        
    end
    def create
        new_member = Membership.create!(membership_params)
        render json: new_member, status: :created
    end

    private 
    def membership_params
        params.permit(:gym_id, :client_id, :charge)
    end
end
