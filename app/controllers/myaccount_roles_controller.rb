require 'ostruct'

class MyaccountRolesController < ApplicationController
  include Pagy::Backend

  require_auth action: :index
  grant_access action: :index, roles: [ :superadmin ]
  # @route GET /myaccount/roles (myaccount_role)
  def index
    sort = {}
    if params[:sort] && params[:direction]
      sort[params[:sort]] = params[:direction]
    else
      sort[:name] = "asc"
    end
    
    # Get all role names and convert to objects for display
    role_names = Rabarber::Role.names
    @roles = role_names.map do |name|
      assignees_count = Rabarber::Role.assignees(name).count
      OpenStruct.new(
        name: name,
        assignees_count: assignees_count,
        created_at: Time.current, # Rabarber doesn't track creation time
        updated_at: Time.current  # Rabarber doesn't track update time
      )
    end
    
    # Apply search if query parameter exists
    if params[:q].present?
      query = params[:q].downcase
      @roles = @roles.select { |role| role.name.to_s.downcase.include?(query) }
    end
    
    # Apply sorting
    if sort[:name] == "desc"
      @roles = @roles.sort_by(&:name).reverse
    else
      @roles = @roles.sort_by(&:name)
    end
    
    # Simple pagination since we don't have pagy_array
    per_page = 10
    page = (params[:page] || 1).to_i
    total = @roles.length
    @roles = @roles.slice((page - 1) * per_page, per_page) || []
    @pagy = OpenStruct.new(page: page, limit: per_page, count: total, pages: (total.to_f / per_page).ceil)
  end

  require_auth action: :show
  grant_access action: :show, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:name
  def show
    @role = retrieve_role
    @assignees = Rabarber::Role.assignees(@role.name)
  end

  require_auth action: :new
  grant_access action: :new, roles: [ :superadmin ]
  # @route GET /myaccount/roles/new (myaccount_role_new)
  def new
    @role = OpenStruct.new(name: nil)
  end

  require_auth action: :edit
  grant_access action: :edit, roles: [ :superadmin ]
  # @route GET /myaccount/roles/:name/edit
  def edit
    @role = retrieve_role
  end

  require_auth action: :create
  grant_access action: :create, roles: [ :superadmin ]
  # @route POST /myaccount/roles (myaccount_role)
  def create
    role_name = role_params[:name]&.strip&.to_sym
    
    if role_name.blank?
      @role = OpenStruct.new(name: nil, errors: { name: ["can't be blank"] })
      render :new, status: :unprocessable_content
      return
    end
    
    if Rabarber::Role.names.include?(role_name)
      @role = OpenStruct.new(name: role_name, errors: { name: ["already exists"] })
      render :new, status: :unprocessable_content
      return
    end
    
    begin
      Rabarber::Role.add(role_name)
      redirect_to myaccount_role_list_path, notice: "Role was successfully created."
    rescue => e
      @role = OpenStruct.new(name: role_name, errors: { name: [e.message] })
      render :new, status: :unprocessable_content
    end
  end

  require_auth action: :update
  grant_access action: :update, roles: [ :superadmin ]
  # @route PUT /myaccount/roles/:name
  def update
    old_role = retrieve_role
    new_name = role_params[:name]&.strip&.to_sym
    
    if new_name.blank?
      @role = OpenStruct.new(name: old_role.name, errors: { name: ["can't be blank"] })
      render :edit, status: :unprocessable_content
      return
    end
    
    if new_name != old_role.name && Rabarber::Role.names.include?(new_name)
      @role = OpenStruct.new(name: old_role.name, errors: { name: ["already exists"] })
      render :edit, status: :unprocessable_content
      return
    end
    
    begin
      if new_name != old_role.name
        Rabarber::Role.rename(old_role.name, new_name, force: true)
      end
      redirect_to myaccount_role_list_path, notice: "Role was successfully updated."
    rescue => e
      @role = OpenStruct.new(name: old_role.name, errors: { name: [e.message] })
      render :edit, status: :unprocessable_content
    end
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :superadmin ]
  # @route DELETE /myaccount/roles/:name
  def destroy
    role = retrieve_role
    
    begin
      Rabarber::Role.remove(role.name, force: true)
      redirect_to myaccount_path, notice: "Role was successfully deleted."
    rescue => e
      redirect_to myaccount_role_list_path, alert: "Error deleting role: #{e.message}"
    end
  end

  private

  def retrieve_role
    role_name = params[:name]&.to_sym
    
    unless Rabarber::Role.names.include?(role_name)
      not_found
      return
    end
    
    assignees_count = Rabarber::Role.assignees(role_name).count
    OpenStruct.new(
      name: role_name,
      assignees_count: assignees_count,
      created_at: Time.current,
      updated_at: Time.current
    )
  end

  def role_params
    params.require(:role).permit(:name)
  end
end