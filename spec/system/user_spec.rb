require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ログイン' do
    context '正常系' do
      let(:user) { create(:user) }
      it 'ログインが成功すること' do
        login_as(user)
        expect(page).to have_content 'Login successful'
      end
    end
    context '異常系' do
      it '未入力時にログインが失敗すること' do
        visit login_path
        click_button 'Login'
        expect(page).to have_content 'Login failed'
      end
    end
  end
  describe 'サインアップ' do
    context '正常系' do
      let(:user) { build(:user) }
      it 'ユーザーの新規作成、編集、削除ができること' do
        visit sign_up_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation
        click_button 'SignUp'
        expect(page).to have_content 'User was successfully created.'
      end
    end
    context '異常系' do
      it '未入力時にユーザーの新規作成が失敗すること' do
        visit sign_up_path
        click_button 'SignUp'
        expect(page).to have_content 'error'
      end
    end
  end
end
