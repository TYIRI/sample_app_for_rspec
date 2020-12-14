require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validation" do
    it "is valid with all attributes" do
      task = FactoryBot.create(:user).tasks.build(
        title: "Test Task",
        status: 0
      )
      expect(task).to be_valid
    end

    it "is invalid without title" do
      task = FactoryBot.create(:user).tasks.build(title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "is invalid without status" do
      task = FactoryBot.create(:user).tasks.build(status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it "is invalid with a duplicate title" do
      user = FactoryBot.create(:user)
      user.tasks.create(
        title: "Test Task",
        status: 0
      )
      task = user.tasks.build(
        title: "Test Task",
        status: 0
      )
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    it "is valid with another title" do
      user = FactoryBot.create(:user)
      user.tasks.create(
        title: "First Task",
        status: 0
      )
      task_with_another_title = user.tasks.build(
        title: "Second Task",
        status: 0
      )
      expect(task_with_another_title).to be_valid
    end
  end
end
