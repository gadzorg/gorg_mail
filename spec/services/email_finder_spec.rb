require 'rails_helper'

describe EmailFinder do

  it 'finds email source accounts' do
    user=FactoryGirl.create(:user_with_addresses)
    expect(EmailFinder.new(EmailSourceAccount.first.to_s).find_first).to eq(EmailSourceAccount.first)
  end

  it 'finds email redirect accounts' do
    user=FactoryGirl.create(:user_with_addresses)
    expect(EmailFinder.new(EmailRedirectAccount.first.redirect).find_first).to eq(EmailRedirectAccount.first)
  end

  it 'finds user accounts' do
    user=FactoryGirl.create(:user_with_addresses)
    expect(EmailFinder.new(user.email).find_first).to eq(user)
  end

  it 'finds external ml emails' do
    ml=FactoryGirl.create(:ml_list)
    ee=Ml::ExternalEmail.create(email: "toto@example.com", list_id: ml.id)
    expect(EmailFinder.new("toto@example.com").find_first).to eq(ee)
  end
end