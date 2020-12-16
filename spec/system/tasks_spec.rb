require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  fdescribe 'タスク新規作成' do
    context 'ログインしている状態' do
      it 'タスクの新規作成が成功する' do
        new_task_title = 'new task!'

        sign_in_as user
        click_link 'New task', href: new_task_path
        fill_in 'Title', with: new_task_title
        fill_in 'Content', with: 'aaa'
        select 'todo', from: 'Status'
        fill_in 'Deadline', with: '12162020\t0130p'

        expect {
          click_button 'Create Task'
          expect(page).to have_current_path task_path(Task.last)
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content new_task_title
        }.to change(Task, :count).by(1)
      end
    end
    context 'ログインしていない状態' do
      it 'タスクの新規作成ページへのアクセスが失敗する' do
        visit new_task_path
        expect(page).to have_current_path login_path
        expect(page).to have_content 'Login required'
      end
    end
  end

  fdescribe 'タスク編集' do
    context 'ログインしている状態' do
      it 'タスクの編集が成功する' do
        updated_task_title = 'updated task!'

        sign_in_as task.user
        click_link 'Edit', href: edit_task_path(task)
        fill_in 'Title', with: updated_task_title
        click_button 'Update Task'
        expect(page).to have_current_path task_path(task)
        expect(page).to have_content 'Task was successfully updated.'
        expect(page).to have_content updated_task_title
      end
    end
    context 'ログインしていない状態' do
      it 'タスク編集ページへのアクセスが失敗する' do
        visit edit_task_path(task)
        expect(page).to have_current_path login_path
        expect(page).to have_content 'Login required'        
      end
    end
    context '他ユーザーのタスク編集ページにアクセス' do
      it '編集ページへのアクセスが失敗する' do
        other_user = create(:user, :other_user)
        other_user_task = create(:task, user: other_user)
        
        sign_in_as user
        visit edit_task_path(other_user_task)
        expect(page).to have_current_path root_path
        expect(page).to have_content 'Forbidden access.'
      end
    end
  end

  fdescribe 'タスク削除' do
    context 'ログインしている状態' do
      it 'タスクの削除が成功する' do
        task = create(:task)

        sign_in_as task.user

        expect {
          page.accept_confirm do
            click_link 'Destroy', href: task_path(task)
          end
          expect(page).to have_current_path tasks_path
          expect(page).to have_content 'Task was successfully destroyed.'
          expect(page).to_not have_content task.title
        }.to change(Task, :count).by(-1)
      end
    end
  end
end
