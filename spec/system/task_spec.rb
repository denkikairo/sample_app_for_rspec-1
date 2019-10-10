require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe 'タスクの新規作成画面' do
    context 'ログインした状態' do
      let(:user) { create(:user) }
      let(:task) { build(:task, title: 'task_new') }
      let(:task_created){ create(:task, user_id: user.id) }
      it 'タスクが新規作成できる' do
        login_as(user)
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
      let(:user) { create(:user) }
      let(:task_created){ create(:task, user_id: user.id) }
      it 'タスクが編集できる' do
        login_as(user)
        visit edit_task_path(task_created)
        fill_in 'task_title', with: 'title_updated'
        click_button 'Update Task'
        expect(page).to have_content 'Task was successfully updated.'
        expect(page).to have_content 'title_updated'
      end
    end
    context 'ログインしていない状態' do
      let(:task_created){ create(:task) }
      it 'タスクの編集に遷移できない' do
        visit edit_task_path(task_created)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
  end
  describe 'タスクの削除画面' do
    context 'ログインした状態' do
      let(:user) { create(:user) }
      let(:task_created){ create(:task, user_id: user.id) }
      it 'タスクが削除できる' do
        login_as(user)
        task_created
        visit tasks_path
        click_on 'Destroy'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Task was successfully destroyed.'
        expect{Task.find(task_created.id)}.to raise_exception(ActiveRecord::RecordNotFound)
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
      let(:user) { create(:user) }
      let(:task){ create(:task) }
      it 'タスクの詳細に遷移できる' do
        login_as(user)
        visit task_path(task)
        expect(page).to have_content task.title
      end
    end
    context 'ログインしていない状態' do
      let(:task){ create(:task) }
      it 'タスクの詳細に遷移できる' do
        visit task_path(task)
        expect(page).to have_content task.title
      end
    end
  end
  describe 'タスクの詳細画面' do
    let(:user) { create(:user) }
    let(:task){ create(:task, user_id: user.id) }
    context 'ログインした状態' do
      it 'マイページにユーザーが新規作成したタスクが表示される' do
        login_as(user)
        task
        visit user_path(user)
        expect(page).to have_content task.title
        expect(page).to have_content task.status
      end
    end
    let(:user) { create(:user) }
    let(:user_another) { create(:user, email: 'another@gmail.com') }
    let(:task){ create(:task, user_id: user.id) }
    context 'ログインしていない状態' do
      it '他のユーザーのタスク編集ページへの遷移ができない' do
        login_as(user_another)
        visit edit_task_path(task)
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end
end
