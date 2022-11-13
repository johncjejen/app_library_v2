class ApplicationController < ActionController::Base

    def authenticate_admin!
        unless current_user.present? && current_user.admin?
          redirect_to root_path, notice: "Acces Denied"
        end
    end

end
