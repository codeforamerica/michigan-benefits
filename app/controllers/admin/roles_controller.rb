class Admin::RolesController < Admin::AdminBaseController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  layout "admin/admin-wide"

  # GET /admin/roles
  def index
    @roles = Role.all
  end

  # GET /admin/roles/1
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
  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to admin_role_url(@role), notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/roles/1
  def update
    if @role.update(role_params)
      redirect_to admin_role_url(@role), notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/roles/1
  def destroy
    @role.destroy
    redirect_to admin_roles_url, notice: 'Role was successfully destroyed.'
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :key)
    end
end
