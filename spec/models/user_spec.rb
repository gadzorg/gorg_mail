# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  hruid                  :string
#  firstname              :string
#  lastname               :string
#  role_id                :integer
#  last_gram_sync_at      :datetime
#

require 'rails_helper'


RSpec.describe User, type: :model do

  describe "lists_allowed" do
    it "list has a valid factory" do
      expect(FactoryGirl.build(:ml_list)).to be_valid
    end

    it "return allowed list" do
      group_uuid = SecureRandom.uuid

      user = FactoryGirl.create(:user)
      user_groups = [{"uuid"=> group_uuid}]

      # allow(user).to reveive(:grouos).and_return(:user_groups)

      an_open_inscription_list =FactoryGirl.build(:ml_list, inscription_policy: "open")
      a_closed_inscription_list =FactoryGirl.build(:ml_list, inscription_policy: "closed")
      a_list_in_the_same_group_as_user =FactoryGirl.build(:ml_list, group_uuid: group_uuid, inscription_policy: "in_group")
      a_closed_inscription_list_in_the_same_group_as_user =FactoryGirl.build(:ml_list, group_uuid: group_uuid, inscription_policy: "closed")

      # list_allowed = user.lists_allowed

      # expect(list_allowed).to include(an_list_in_the_same_group_as_user)
      # expect(list_allowed).to include(a_list_in_the_same_group_as_user)
      # expect(list_allowed).to include(a_closed_inscription_list_in_the_same_group_as_user)
      # expect(list_allowed).to_not include(a_closed_inscription_list)
    end
  end

  describe 'find by id or hruid' do
    let!(:user) {FactoryGirl.create(:user)}

    it "find by id" do
      expect(User.find_by_id_or_hruid_or_uuid(user.id)).to eq(user)
    end

    it "find by uuid" do
      expect(User.find_by_id_or_hruid_or_uuid(user.uuid)).to eq(user)
    end

    it "find by hruid" do
      expect(User.find_by_id_or_hruid_or_uuid(user.hruid)).to eq(user)
    end
  end


end
