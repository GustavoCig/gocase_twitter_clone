class UserController < ApplicationController
   
    def index
    end

    def teste
        redirect_to "/users/sign_in"
    end
end
