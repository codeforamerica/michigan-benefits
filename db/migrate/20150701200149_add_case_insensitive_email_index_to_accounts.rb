class AddCaseInsensitiveEmailIndexToAccounts < ActiveRecord::Migration
  # see http://stackoverflow.com/questions/3265190/rails-postgres-functional-indexes
  def up
    execute <<-SQL
      CREATE UNIQUE INDEX index_accounts_on_lowercase_email ON accounts (lower(email));
      UPDATE accounts SET email=lower(email);
    SQL
  end
  def down
    execute <<-SQL
      DROP INDEX index_accounts_on_lowercase_email;
    SQL
  end
end