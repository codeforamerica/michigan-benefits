class Admin::RolesController < ApplicationController
  before_filter :require_admin
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /admin/roles
  # GET /admin/roles.json
  def index
    @roles = Role.all
  end

  # GET /admin/roles/1
  # GET /admin/roles/1.json
  def show
  end

  # GET /admin/roles/new
  def new
    @role = Role.new
  end

  # GET /admin/roles/1/edit
  def edit
  end

  # POST /admin/roles
  # POST /admin/roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to admin_role_url(@role), notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/roles/1
  # PATCH/PUT /admin/roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to admin_role_url(@role), notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/roles/1
  # DELETE /admin/roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to admin_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :key)
    end
end
