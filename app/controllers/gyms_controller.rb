class GymsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_gym_not_found
    # View one specific gym
    # if Gym exists, return JSON data for the gym
    # else return error with a status code
    
    def show
        gym = Gym.find(params[:id])
        render json: gym, except: [:created_at, :updated_at]
    end


        # Delete a gym
        # If the Gym exists, it should be removed from the database, along with any Memberships that 
        # are associated with it (a Membership belongs to a Gym, so you need to delete the 
        # Memberships before the Gym can be deleted).

        # After deleting the Gym, return an empty response body, along with the appropriate HTTP status code.

        # If the Gym does not exist, return the following JSON data, along with the appropriate HTTP status code: "error": "Gym not found"

    # def destroy
    #     gym = Gym.find(params[:id])
    #     gym.destroy
    #     head :no_content
    # rescue ActiveRecord::RecordNotFound => e
    #     render json: {error: "Gym not found - jp" }, status: :not_found
    # end
    

    # version above uses custom handling inside the method
    # version below uses the rescue_from
    
    def destroy
        gym = Gym.find(params[:id])
        gym.destroy
        head :no_content
    end

    private 

    def render_gym_not_found
        render json: { errors: record.message }, status: :not_found

    end
    
end
