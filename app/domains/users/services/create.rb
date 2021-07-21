module Users
  module Services
    class Create
      def self.run(params)
        existing_user = User.find_by(email: params[:email])
        return :registered, existing_user if existing_user.present?

        params[:status] = User::ACTIVE
        user = User.new(params)

        if user.save
          return :ok, user
        else
          return :unprocessable_entity, user
        end
      end
    end
  end
end
