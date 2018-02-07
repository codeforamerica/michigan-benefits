class BackfillAppliedBefore < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  class SnapApplication < ActiveRecord::Base; end
  class MedicaidApplication < ActiveRecord::Base; end

  def change
    SnapApplication.in_batches.update_all(applied_before: 0)
    MedicaidApplication.in_batches.update_all(applied_before: 0)
  end
end
