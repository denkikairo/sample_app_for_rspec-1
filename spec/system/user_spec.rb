require 'rails_helper'

RSpec.describe 'Users', type: :system do

  let(:user) { create(:user) }
  let(:user_another) { create(:user, email: 'another@gmail.com') }
  describe 'ログイン画面' do
    context '入力値が正常な状態' do
      it 'ログインが成功すること' do
        login_as(user)
        expect(page).to have_content 'Login successful'
      end
    end
    context '入力値が異常な状態' do
      it 'ログインが失敗すること' do
        visit login_path
        click_button 'Login'
        expect(page).to have_content 'Login failed'
      end
    end
  end
  describe 'サインアップ画面' do
    context '入力値が正常な状態' do
      it 'ユーザーの新規作成が成功すること' do
        visit sign_up_path
        fill_in 'user_email', with: 'example@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'SignUp'
        expect(page).to have_content 'User was successfully created.'
      end
    end
    context '入力値が異常な状態(未入力)' do
      it 'ユーザーの新規作成が失敗すること' do
        visit sign_up_path
        click_button 'SignUp'
        expect(page).to have_content 'error'
      end
    end
    context '入力値が異常な状態(登録済みアドレス使用)' do
      it 'ユーザーの新規作成が失敗すること' do
        visit sign_up_path
        user
        fill_in 'user_email', with: 'example@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'SignUp'
        expect(page).to have_content 'Email has already been taken'
      end
    end
  end
  describe 'ユーザー編集画面' do
    context '入力値が正常な状態' do
      it 'ユーザーの編集ができること' do
        login_as(user)
        visit edit_user_path(user)
        fill_in 'user_email', with: 'updated@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Update'
        expect(page).to have_content 'User was successfully updated.'
        expect(page).to have_content 'updated@gmail.com'
      end
    end
    context '入力値が異常な状態(未入力)' do
      it 'ユーザーの編集ができないこと' do
        login_as(user)
        visit edit_user_path(user)
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Update'
        expect(page).to have_content 'error'
      end
    end
    context '入力値が異常な状態(登録済みアドレス使用)' do
      it 'ユーザーの編集ができないこと' do
        login_as(user)
        visit edit_user_path(user)
        user_another
        fill_in 'user_email', with: 'another@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Update'
        expect(page).to have_content 'Email has already been taken'
      end
    end
    context '異常系：他のユーザーのページにアクセス' do
      it '編集画面に遷移できない' do
        login_as(user)
        visit edit_user_path(user_another)
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end
end
