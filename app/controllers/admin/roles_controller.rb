class Admin::RolesController < Admin::AdminBaseController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    @roles = Role.all
    respond_with @roles
  end

  def show
    respond_with @role
  end

  def new
    @role = Role.new
    respond_with @role
  end

  def create
    @role = Role.create(role_params)
    respond_with @role, location: [:admin, @role]
  end

  def edit
    respond_with @role
  end

  def update
    @role.update(role_params)
    respond_with @role, location: [:admin, @role]
  end

  def destroy
    @role.destroy
    respond_with @role, location: admin_roles_url
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name, :key)
    end
end
