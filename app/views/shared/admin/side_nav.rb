class Views::Shared::Admin::SideNav < Views::Base
  def content
    ul(class: "side-nav") {
      li { link_to 'Accounts', admin_accounts_path }
      li { link_to 'Roles', admin_roles_path }
      li { link_to 'Metrics', admin_metrics_path }
    }
  end
end
