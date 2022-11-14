class LibraryController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :authenticate_admin!, only:[:home, :create_library, :delete_library ]

  def home

    @libraries = Library.where('activated = true').order('branch_name') 

    if params[:branch_name].present?
        @libraries= @libraries.where("branch_name ILIKE ?", "%#{params[:branch_name]}%")
      end

  end

  def edit_library
    library_id = params[:id]
    @library = Library.find(library_id) if !library_id.blank?

  end

  def create_library

    library_id = params[:id]
    
    @library = Library.new if library_id.blank?
    @library = Library.find(library_id) if !library_id.blank?

    @library.branch_name = params[:branch_name]
    @library.address = params[:address]
    @library.phone_number = params[:phone_number]
    @library.save

    if library_id.blank?
        redirect_to '/library/home', notice: "Library created" 
    else
        redirect_to '/library/home', notice: "Library updated" 
    end

  end

  def delete_library

    library_id=params[:id]
    library_delete = Library.find(library_id)
    library_delete.activated = 0
    library_delete.save

    redirect_to '/library/home', notice: "library deleted"

  end

  def library_detail

    library_id = params[:id]
    @library_detail = Library.find(library_id)

  end
    
end
