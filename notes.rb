# notes on how this needs to go down

# command line to get us started
rails g resource Gym name address --no-test-framework --api
# this creates the gym resources, without tests, and makes routes, models, controllers
rails g resource Client name age:integer --no-test-framework --api
rails g resource Membership charge:integer client:belongs_to gym:belongs_to

# after this be sure to go back and limit routes in the routes.rb
resources :gyms, only: [:index, :show] #or limit completely with only: []
# check routes - add those that are needed based on the methods

class Gym
    has_many :memberships, dependend: :destroy
    has_many :clients, through: :memberships
end 
# ^^ similar version to the client - membership is different

# set strong params on class controller
private
def membership_params
    params.permit(:gym_id, :client_id, :charge)
end
# this can be used in our create function
Membership.create!(membership_params)

# error handling with if/then
new_member = Membership.create(membership_params)
if new_member.valid?
    render json: new_member, status: :created
else
    render json: {errors: new_member.errors.full_messages}, status: :unprocessable_entity
end
# so if the new_member isn't valid, it gains the errors object
# and we can access the messages from the error object
# interestingly, even if it is problematic the status code will still
# still be 200 OK - so make sure to add status to any json sent back

# validates membership based on unique client per gym 
# (can't have more than one membership to a gym per client) - goes in the gym model
validates :gym_id, uniqueness: {scope: :client_id, message: "Client can only have one membership to a gym"}

# controller level rescue_from 
rescue_from ActiveRecord::RecordInvalid, with: :render_invalid
# using built in messages from the error record obj - place in private
def render_invalid(invalid)
    render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
end

# this one does the same for record not found
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
# built in messages accessible this way - place in private
def render_not_found_response(record)
    render json: { errors: record.message }, status: :not_found
end

# when destroying with linked data be sure the owner class has dependent: :destroy
has_many :memberships, dependent: :destroy

# notes about including/serializing nested/associated data
# the one below gives us the client, with all the membership info based
# on the ActiveRecord associations
render json: client, include: :memberships

# this one renders based on a custom method (better probs)
render json: client, methods: :total_memberships_price


