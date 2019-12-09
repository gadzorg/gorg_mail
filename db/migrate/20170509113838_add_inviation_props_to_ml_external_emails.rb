class AddInviationPropsToMlExternalEmails < ActiveRecord::Migration[4.2]
  def change
    add_column :ml_external_emails, :enabled, :boolean
    add_column :ml_external_emails, :accepted_cgu_at, :datetime

    Ml::ExternalEmail.update_all(:enabled => true)
  end
end

