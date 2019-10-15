require 'rails_helper'

RSpec.describe 'Tasks', type: :system do

  let(:user) { create(:user) }
  let(:user_another) { create(:user, email: 'another@gmail.com') }
  let(:task){ create(:task, user_id: user.id) }
  describe 'タスクの新規作成画面' do
    context 'ログインした状態' do
      it 'タスクが新規作成できる' do
        login_as(user)
        visit new_task_path
        fill_in 'task_title', with: 'title'
        fill_in 'task_content', with: 'content'
        select 'todo', from: 'task_status'
        fill_in 'task_deadline', with: '002019/10/9 11:11'
        click_button 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
        visit tasks_path
        expect(page).to have_content 'content'
        expect(page).to have_content 'todo'
        expect(page).to have_content '2019/10/9 11:11'
      end
    end
    context 'ログインしていない状態' do
      it 'タスクの新規作成に遷移できない' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
  end
  describe 'タスクの編集画面' do
    context 'ログインした状態' do
      it 'タスクが編集できる' do
        login_as(user)
        visit edit_task_path(task)
        fill_in 'task_title', with: 'title_updated'
        click_button 'Update Task'
        expect(page).to have_content 'Task was successfully updated.'
        expect(page).to have_content 'title_updated'
      end
    end
    context 'ログインしていない状態' do
      it 'タスクの編集に遷移できない' do
        visit edit_task_path(task)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
  end
  describe 'タスクの削除画面' do
    context 'ログインした状態' do
      it 'タスクが削除できる' do
        login_as(user)
        task
        visit tasks_path
        click_on 'Destroy'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Task was successfully destroyed.'
        expect{Task.find(task.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
    context 'ログインしていない状態' do
      it 'タスクの削除に遷移できない' do
        visit tasks_path
        expect(page).not_to have_content 'Destroy'
      end
    end
  end
  describe 'タスクの詳細画面' do
    context 'ログインした状態' do
      it 'タスクの詳細に遷移できる' do
        login_as(user)
        visit task_path(task)
        expect(page).to have_content task.title
      end
    end
    context 'ログインしていない状態' do
      it 'タスクの詳細に遷移できる' do
        visit task_path(task)
        expect(page).to have_content task.title
      end
    end
  end
  describe 'タスクの詳細画面' do
    context 'ログインした状態' do
      it 'マイページにユーザーが新規作成したタスクが表示される' do
        login_as(user)
        task
        visit user_path(user)
        expect(page).to have_content task.title
        expect(page).to have_content task.status
      end
    end
    context 'ログインしていない状態' do
      it '他のユーザーのタスク編集ページへの遷移ができない' do
        login_as(user_another)
        visit edit_task_path(task)
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end
end
