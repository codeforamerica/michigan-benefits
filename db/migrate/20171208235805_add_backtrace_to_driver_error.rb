class AddBacktraceToDriverError < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_errors, :backtrace, :string
  end
end
