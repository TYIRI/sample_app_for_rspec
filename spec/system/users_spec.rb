require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  fdescribe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit root_path
          click_link 'SignUp'
          fill_in 'Email', with: 'tester@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          
          expect {
            click_button 'SignUp'
            expect(page).to have_current_path login_path
            expect(page).to have_content 'User was successfully created.'
          }.to change(User, :count).by(1)
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'

          expect {
            click_button 'SignUp'
            expect(page).to have_current_path users_path
            expect(page).to have_content "can't be blank"
          }.to_not change(User, :count)
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          user = create(:user)
          
          visit sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'

          expect {
            click_button 'SignUp'
            expect(page).to have_current_path users_path
            expect(page).to have_content 'has already been taken'
          }.to_not change(User, :count)
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_current_path login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  fdescribe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          sign_in_as user
          click_link 'Mypage'
          click_link 'Edit', href: edit_user_path(user)
          fill_in 'Email', with: 'new_email@example.com'
          click_button 'Update'
          expect(page).to have_current_path user_path(user)
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          sign_in_as user
          click_link 'Mypage'
          click_link 'Edit', href: edit_user_path(user)
          fill_in 'Email', with: ''
          click_button 'Update'
          expect(page).to have_current_path user_path(user)
          expect(page).to have_content "can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          other_user_with_duplicated_email = create(:user)

          sign_in_as user
          click_link 'Mypage'
          click_link 'Edit', href: edit_user_path(user)
          fill_in 'Email', with: other_user_with_duplicated_email.email
          click_button 'Update'
          expect(page).to have_current_path user_path(user)
          expect(page).to have_content 'has already been taken'
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          other_user = create(:user, :other_user)

          sign_in_as user
          visit edit_user_path(other_user)
          expect(page).to have_current_path user_path(user)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          new_task_title = 'new task!'

          sign_in_as user
          click_link 'New task', href: new_task_path
          fill_in 'Title', with: new_task_title
          select 'todo', from: 'Status'
          click_button 'Create Task'
          click_link 'Mypage'
          expect(page).to have_content new_task_title
        end
      end
    end
  end
end
