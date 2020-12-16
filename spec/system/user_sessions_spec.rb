require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  fdescribe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        user = create(:user)

        visit root_path
        click_link 'Login'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Login'

        expect(page).to have_current_path root_path
        expect(page).to have_content 'Login successful'
      end
    end
    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
        visit login_path
        click_button 'Login'

        expect(page).to have_current_path login_path
        expect(page).to have_content 'Login failed'
      end
    end
  end

  fdescribe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        sign_in_as user

        visit root_path
        click_link 'Logout'
        expect(page).to have_current_path root_path
        expect(page).to have_content 'Logged out'
      end
    end
  end
end
