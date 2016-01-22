namespace :import_sample do
  desc "TODO"
  task import_csv: :environment do
    require 'csv'
    require 'devise'

    CSV_ACCOUNTS_PATH=File.join(Rails.root,'lib/assets/accounts.csv')
    CSV_ERA_PATH=File.join(Rails.root,'lib/assets/era.csv')
    CSV_ESA_PATH=File.join(Rails.root,'lib/assets/esa.csv')

    accounts_csv=CSV.parse(File.read(CSV_ACCOUNTS_PATH),headers: true)
    era_csv=CSV.parse(File.read(CSV_ERA_PATH),headers: true)
    esa_csv=CSV.parse(File.read(CSV_ESA_PATH),headers: true)


    accounts_csv.each do |ac_row|
      if u=User.create_with(
        email: ac_row['email'],
        password: Devise.friendly_token[0,20],
        firstname: ac_row['firstname'],
        lastname: ac_row['lastname'],
        ).find_or_create_by(hruid: ac_row['hruid'])

      puts ac_row['hruid']+" : OK"
      u.email_source_accounts.delete_all
      u.email_redirect_accounts.delete_all

      else

        puts ac_row['hruid']+" : ERREUR !!!!!!"
        puts ac_row

      end
    end

#  id            :integer          not null, primary key
#  uid           :integer
#  redirect      :string
#  rewrite       :string
#  type          :integer
#  action        :integer
#  broken_date   :date
#  broken_level  :integer
#  last          :date
#  flag          :integer
#  hash          :string
#  allow_rewrite :integer
#  srs_rewrite   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer

    era_csv.each do |row|
      u=User.find_by_hruid(row['hruid'])
      u.email_redirect_accounts.create(
        redirect:row['redirect'],
        rewrite:row['rewrite'],
        type_redir:row['type'],
        action:row['action'],
        broken_date:row['broken_date'],
        broken_level:row['broken_level'],
        last:row['last'],
        flag:row['flags'],
        # hash:row['hash'],
        allow_rewrite:row['allow_rewrite'],
        srs_rewrite:row['srs_rewrite'],
      )
    end

#  email      :string
#  uid        :integer
#  type       :integer
#  flag       :string
#  expire     :date

    esa_csv.each do |row|
      u=User.find_by_hruid(row['hruid'])
      u.email_source_accounts.create(
        email:row['email'],
        email_virtual_domain:EmailVirtualDomain.find_or_create_by(name: row['name']),
        type_source:row['type'],
        flag:row['flags'],
      )
    end

  end

end
