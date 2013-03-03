class CreateBalanceChangesSqlIndexes < ActiveRecord::Migration
  def up
    execute <<-q
      CREATE UNIQUE INDEX index_balance_changes_constrain_next_id_to_one_null
      ON balance_changes (user_id, COALESCE(next_id, 0));
    q

  end
  def down
    execute <<-q
      CREATE UNIQUE INDEX index_balance_changes_constrain_next_id_to_one_null;
    q
  end
end
