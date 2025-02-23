class UsersController < ApplicationController
    def create
      result = Users::Create.run(params)
      if result.is_a?(User)
        render json: result, status: :created
      else
        render json: result.errors, status: :unprocessable_entity
      end
    end
  end