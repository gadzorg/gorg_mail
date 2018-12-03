require 'rails_helper'
require 'gram_v2_client/rspec/gram_account_mocker'

RSpec.describe GramAccountUpdatedMessageHandler, type: :message_handler do

  subject{GramAccountUpdatedMessageHandler}

  describe "on gram account creation" do
    let(:data){{
     key:"36a7e016-a300-4f52-85f4-6804dede6c6b",
     changes:{
        uuid:[nil,"36a7e016-a300-4f52-85f4-6804dede6c6b"],
        hruid:[nil,"paul.david-hewson.1986"],
        id_soce:[nil,1556001],
        enabled:[nil,true],
        lastname:[nil,"David Hewson"],
        firstname:[nil,"Paul"],
        birthname:[nil,""],
        birth_firstname:[ nil,""],
        email:[nil,"bono@gmail.com"],
        birthdate:[nil,"1960-05-10"],
        is_gadz:[nil,true],
        school_id:[nil,""],
        date_sortie_ecole:[nil,"1990-12-12"],
        buque_texte:[nil,"Bono"],
        buque_zaloeil:[nil,"Bono"],
        gadz_fams:[ nil,"59"],
        gadz_fams_zaloeil:[nil,""],
        gadz_proms_principale:[nil,"1986"],
        gadz_proms_secondaire:[nil,""],
        gadz_centre_principal:[nil,"bo"],
        gadz_centre_secondaire:[nil,""],
        avatar_url:[nil,"http://recette.soce.fr/images/"],
        url:[nil,"/api/v2/accounts/36a7e016-a300-4f52-85f4-6804dede6c6b"]
     }
  }}

    let(:message) {GorgService::Message.new(
        data: data,
        routing_key: "notify.account.created"
    )}

    let(:user){User.find_by(uuid: "36a7e016-a300-4f52-85f4-6804dede6c6b")}

    before(:each){
      subject.new(message)
    }

    it "create a GorgMail User" do
      expect(user).to be_a_kind_of(User)
    end

    it "set values" do
      expect(user.email).to eq("bono@gmail.com")
      expect(user.firstname).to eq("Paul")
      expect(user.lastname).to eq("David Hewson")
      expect(user.hruid).to eq("paul.david-hewson.1986")
      expect(user.is_gadz).to eq(true)
    end
  end

  describe "on gram account update" do
    let(:data){{
        key:"36a7e016-a300-4f52-85f4-6804dede6c6b",
        changes:{
            lastname:["David Hewson","David"],
            firstname:["Paul","Paulo"],
            is_gadz:[false,true],
        }
    }}

    let(:message) {GorgService::Message.new(
        data: data,
        routing_key: "notify.account.updated"
    )}

    context "existing gorgmail user" do
      let!(:user){User.create(uuid: "36a7e016-a300-4f52-85f4-6804dede6c6b",
                          password: Devise.friendly_token[0,20],
                          email: "bono@gmail.com",
                          hruid: "paul.david-hewson.1986",
                          firstname: "Paul",
                          lastname: "David Hewson",
                          is_gadz: false,
      )}

      before(:each){
        subject.new(message)
      }



      it "set values" do
        user.reload
        expect(user.email).to eq("bono@gmail.com")
        expect(user.firstname).to eq("Paulo")
        expect(user.lastname).to eq("David")
        expect(user.is_gadz).to eq(true)
        expect(user.hruid).to eq("paul.david-hewson.1986")
      end
    end

    context "not existing gorgmail user" do

      # https://github.com/gadzorg/gram2_api_client_ruby/blob/master/lib/gram_v2_client/rspec/gram_account_mocker.rb
      let(:gam) {GramAccountMocker.for(attr:{uuid: "36a7e016-a300-4f52-85f4-6804dede6c6b",
                                                        email: "bono@gmail.com",
                                                        hruid: "paul.david-hewson.1986",
                                                        firstname: "Paulo",
                                                        lastname: "David",
                                                        is_gadz: true,
                                                        gadz_proms_principale: "1986",
                                                        gadz_centre_principal: "bo"
                                                  },
                                                  auth: GramAccountMocker.http_basic_auth_header(Rails.application.secrets.gram_api_user,
                                                                                                 Rails.application.secrets.gram_api_password)
      )}

      let(:user){User.find_by(uuid: "36a7e016-a300-4f52-85f4-6804dede6c6b")}

      before(:each){
        gam.mock_get_request
        subject.new(message)
      }

      it "create a GorgMail User" do
        expect(user).to be_a_kind_of(User)
      end

      it "set values" do
        user.reload
        expect(user.email).to eq("bono@gmail.com")
        expect(user.firstname).to eq("Paulo")
        expect(user.lastname).to eq("David")
        expect(user.hruid).to eq("paul.david-hewson.1986")
        expect(user.is_gadz).to eq(true)
      end
    end



  end


end