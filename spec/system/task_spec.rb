require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'タスクの新規作成、編集、削除' do
    context '正常系' do
      let!(:user) { create(:user) }
      let!(:task) { build(:task) }
      let(:task_created) { create(:task) }
      # login
      before do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'password'
        click_button 'Login'
      end
      it 'ログインした状態でタスクの新規作成' do
        visit new_task_path
        fill_in 'task_title', with: task.title
        fill_in 'task_content', with: task.content
        select task.status, from: 'task_status'
        fill_in 'task_deadline', with: task.deadline
        click_button 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
      end
      it 'ログインした状態でタスクの編集' do
        visit edit_task_path(task_created)
        fill_in 'task_title', with: 'title updated'
        click_button 'Update Task'
        expect(page).to have_content 'Task was successfully updated.'
      end
      it 'ログインした状態でタスクの削除' do
        expect {
          delete task_path(task_created), params: { id: task_created.id }
        }.to change(Task, :count).by(-1)
      end
    end
  end
  describe 'タスクの表示' do
  end
end
