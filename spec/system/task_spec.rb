require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe 'タスクの新規作成、編集、削除' do
    context '正常系' do
      let(:user) { create(:user) }
      let(:task) { build(:task, title: 'task_new') }
      let!(:task_created){ create(:task, user_id: user.id) }
      # login
      before do
        login_as(user)
      end
      it 'ログインした状態でタスクの新規作成できる' do
        visit new_task_path
        fill_in 'task_title', with: task.title
        fill_in 'task_content', with: task.content
        select task.status, from: 'task_status'
        fill_in 'task_deadline', with: task.deadline
        click_button 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
        visit tasks_path
        expect(page).to have_content task.content
        expect(page).to have_content task.status
        expect(page).to have_content task.deadline.strftime('%Y/%-m/%-d %-H:%-M')
      end
      it 'ログインした状態でタスクの編集できる' do
        visit edit_task_path(task_created)
        fill_in 'task_title', with: 'title_updated'
        click_button 'Update Task'
        expect(page).to have_content 'Task was successfully updated.'
        expect(page).to have_content 'title_updated'
      end
      it 'ログインした状態でタスクの削除できる' do
        visit tasks_path
        click_on 'Destroy'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Task was successfully destroyed.'
        expect{Task.find(task_created.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
    context '異常系' do
      let(:user) { create(:user) }
      let(:task) { build(:task) }
      let!(:task_created){ create(:task, user_id: user.id) }
      it 'ログインしていない状態でタスクの新規作成に遷移できない' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(current_path).to eq '/login'
      end
      it 'ログインしていない状態でタスクの編集に遷移できない' do
        visit edit_task_path(task_created)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq '/login'
      end
      it 'ログインしていない状態でタスクのマイページに遷移できない' do
        visit user_path(user)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq '/login'
      end
    end
  end
  describe 'タスクの表示' do
    let(:user) { create(:user) }
    let(:user_another) { create(:user, email: 'another@gmail.com') }
    let!(:task){ create(:task, user_id: user.id) }
    # login
    context '正常系' do
      it 'マイページにユーザーが新規作成したタスクが表示されること' do
        login_as(user)
        visit user_path(user)
        expect(page).to have_content task.title
        expect(page).to have_content task.status
      end
    end
    context '異常系' do
      it '他のユーザーのタスク編集ページへの遷移ができないこと' do
        login_as(user_another)
        visit edit_task_path(task)
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end
end
