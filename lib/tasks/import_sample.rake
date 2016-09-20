namespace :import_sample do
  desc "TODO"
  task import_csv: :environment do
    require 'csv'
    require 'devise'
    Rails.logger.level = Logger::DEBUG

    CSV_ACCOUNTS_PATH=File.join(Rails.root,'lib/assets/accounts.csv')
    CSV_ERA_PATH=File.join(Rails.root,'lib/assets/era.csv')
    CSV_ESA_PATH=File.join(Rails.root,'lib/assets/esa.csv')
    CSV_ALIAS_PATH=File.join(Rails.root,'lib/assets/alias.csv')
    CSV_BLACKLIST_PATH=File.join(Rails.root,'lib/assets/blacklist.csv')
    CSV_UUID_PATH=File.join(Rails.root,'lib/assets/uuid.csv')

    accounts_csv=CSV.parse(File.read(CSV_ACCOUNTS_PATH),headers: true)
    era_csv=CSV.parse(File.read(CSV_ERA_PATH),headers: true)
    esa_csv=CSV.parse(File.read(CSV_ESA_PATH),headers: true)
    alias_csv=CSV.parse(File.read(CSV_ALIAS_PATH),headers: true)
    blacklist_csv=CSV.parse(File.read(CSV_BLACKLIST_PATH),headers: true)

    uuid_csv=CSV.parse(File.read(CSV_UUID_PATH),headers: true)

    puts "Load uuid file"
    uuids={}
    uuid_csv.each do |uuid_row|
      uuids[uuid_row['hruid']]=uuid_row['uuid']
    end


    puts "done"

    puts "Delete all ERA and ESA"
    EmailSourceAccount.delete_all
    EmailRedirectAccount.delete_all
    puts "done"

    accounts_count = accounts_csv.count.to_f
    accounts_imported = 0.to_f
    accounts_imported_error = 0
    start_date = DateTime.now

    CSV.foreach(CSV_ACCOUNTS_PATH,{:headers => :first_row}) do |ac_row|

        elapsed_time =(DateTime.now - start_date)*1.days
      remaining_time = elapsed_time/accounts_imported * (accounts_count-accounts_imported)
      percentage = (accounts_imported/(accounts_count+1)*100)

      puts accounts_imported.to_s + " / " + accounts_count.to_s + " | "+ percentage.round(2).to_s + "% | Temps écoulé : " +elapsed_time.round(2).to_s + "s | Temps restant : " + remaining_time.round(2).to_s + "s | erreurs" + accounts_imported_error.to_s


      puts ac_row['email'].to_s + " | "+ ac_row['firstname'].to_s + " | "+ ac_row['lastname'].to_s + " | "+ uuids[ac_row['hruid'].to_s]
      puts Benchmark.measure{
      if u=User.create_with(
        email: ac_row['email'],
        password: Devise.friendly_token[0,20],
        firstname: ac_row['firstname'],
        lastname: ac_row['lastname'],
        uuid: uuids[ac_row['hruid']]
        ).find_or_create_by(hruid: ac_row['hruid'])

        puts ac_row['hruid']+" : OK"
        #u.email_source_accounts.delete_all
        #u.email_redirect_accounts.delete_all

      else

        puts ac_row['hruid']+" : ERREUR !!!!!!"
        puts ac_row
        accounts_imported_error +=1


      end
      }
      accounts_imported +=1

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
      puts row['flags']
      u.email_source_accounts.create(
        email:row['email'],
        email_virtual_domain:EmailVirtualDomain.find_or_create_by(name: row['name']),
        type_source:row['type'],
        flag:row['flags'],
        primary: row['flags'].present? && row['flags'].include?("bestalias") ? true : false
      )
    end



#  email       :string
#  reject_text :string
    blacklist_csv.each do |row|
      if PostfixBlacklist.create(
        email: row['email'],
        reject_text: row['reject_text']
      )
        puts row['email']+" : OK"
      else
        puts row['email']+" : ERREUR !"

      end
    end

    # Alias Import
#  email      :string
#  redirect   :string
#  type       :string
    count = Hash.new
    alias_csv.each do |row|
      case row['type']
        when "alias", "list", "gapps", "group"
          #import as alias
          if Alias.create(
              email: row["email"],
              srs_rewrite: row["srs_rewrite"],
              email_virtual_domain_id: row["domain"],
              redirect: row["redirect"],
              alias_type: row["type"]
          )
            count[:alias_list_gapps_group_imported] = count[:alias_list_gapps_group_imported].to_i + 1
          else
            count[:alias_list_gapps_group_skipped] = count[:alias_list_gapps_group_skipped].to_i + 1

          end
        when "nick", "fam"
          count[:nick_and_fam] = count[:nick_and_fam].to_i + 1
          # convert to Email Source for the right user
          #find email
          redirect = row["redirect"]
          redirect_base, redirect_domain = redirect.split("@")

          email = row["email"]
          domain_id = row["domain"]

          user = nil
          evda=EmailVirtualDomain.where(name: "#{redirect_domain}")
          esa = EmailSourceAccount.where(email: redirect_base, email_virtual_domain_id: evda.first.id) if evda.present?
          era = EmailRedirectAccount.where(redirect: redirect) unless esa.present?
          #find user
          if esa.present?
            user = esa.first.user
          elsif era.present?
            user = era.first.user
          end

          if user
              new_esa = EmailSourceAccount.new(email: email, flag: "active", email_virtual_domain_id: domain_id)
            user.email_source_accounts << new_esa

            # convert alias to ESA
            count[:nick_and_fam_converted] = count[:nick_and_fam_converted].to_i + 1

          else
              # If no user or convertion fail, add standard alias
              if Alias.create(
                  email: row["email"],
                  redirect: row["redirect"],
                  srs_rewrite: row["srs_rewrite"],
                  email_virtual_domain_id: row["domain"],
                  alias_type: row["type"]
              )
                count[:nik_and_fam_pased_as_standard] = count[:nik_and_fam_pased_as_standard].to_i + 1
              end
          end

        else
          #import as alias
          if Alias.create(
              email: row["email"],
              redirect: row["redirect"],
              srs_rewrite: row["srs_rewrite"],
              email_virtual_domain_id: row["domain"],
              alias_type: row["type"]
          )
            count[:alias_unknown] = count[:alias_unknown].to_i + 1
            else
              count[:alias_unknown_skipped] = count[:alias_unknown_skipped].to_i + 1
          end
      end
      puts "#{row['email']} => #{row['redirect']} OK"
    end
    puts count

  end

end
