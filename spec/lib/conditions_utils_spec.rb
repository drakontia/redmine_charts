require File.dirname(__FILE__) + '/../rails_helper'

module RedmineCharts
  describe ConditionsUtils do
    before(:all) do
      @utils = RedmineCharts::ConditionsUtils
      @types = @utils.types
    end

    it 'should return project_its_subprojects_ids' do
      expect(@utils.project_and_its_children_ids(15_041)).to eq([15_041, 15_042])
    end

    it 'should return conditions_types' do
      expect(@utils.types).to eq([:issue_ids, :project_ids, :user_ids, :category_ids, :status_ids, :activity_ids, :fixed_version_ids, :tracker_ids, :priority_ids, :author_ids, :assigned_to_ids])
    end

    it 'should return_proper_conditions' do
      project = Project.find(15_041)
      options = @utils.to_options(project, @types)

      options[:user_ids] = options[:user_ids].select { |u| u[1] != 9 }
      options[:assigned_to_ids] = options[:assigned_to_ids].select { |u| u[1] != 9 }
      options[:author_ids] = options[:author_ids].select { |u| u[1] != 9 }

      expect(options[:issue_ids]).to be_nil
      expect(options[:project_ids]).to eq([['Project1', 15_041], ['Project2', 15_042]])
      expect(options[:user_ids]).to eq([['Dave Lopper', 15_043], ['John Smith', 15_042], ['Redmine Admin', 15_041]])
      expect(options[:assigned_to_ids]).to eq([['Dave Lopper', 15_043], ['John Smith', 15_042], ['Redmine Admin', 15_041]])
      expect(options[:author_ids]).to eq([['Dave Lopper', 15_043], ['John Smith', 15_042], ['Redmine Admin', 15_041]])
      expect(options[:activity_ids]).to eq([['Design', 8], ['Development', 9]])
      expect(options[:category_ids]).to eq([['Project1 - Category1', 15_041], ['Project1 - Category2', 15_042], ['Project2 - Category3', 15_043]])
      expect(options[:fixed_version_ids]).to eq([['Project1 - 1.0', 15_041], ['Project1 - 2.0', 15_042]])
      expect(options[:tracker_ids]).to eq([['Bug', 1], ['Feature', 2], ['Support', 3]])
      expect(options[:priority_ids]).to eq([['High', 3], ['Immediate', 5], ['Low', 1], ['Normal', 2], ['Urgent', 4]])
      expect(options[:status_ids]).to eq([['Assigned', 2], ['Closed', 5], ['Feedback', 4], ['New', 1], ['Rejected', 6], ['Resolved', 3]])
    end

    it 'should set project_ids if not provided in params' do
      conditions = @utils.from_params(@types, 15_041, {})
      expect(conditions[:project_ids]).to eq([15_041, 15_042])
    end

    it 'should set project_ids if provided empty project in params' do
      conditions = @utils.from_params(@types, 15_041, project_ids: [])
      expect(conditions[:project_ids]).to eq([15_041, 15_042])
    end

    it 'should set project_ids if provided wronghin params' do
      conditions = @utils.from_params(@types, 15_041, project_ids: [0, nil, 15_041, 15_043, 15_099])
      expect(conditions[:project_ids]).to eq([15_041, 15_043])
    end

    it 'should read project_ids from params' do
      conditions = @utils.from_params(@types, 15_041, project_ids: [15_041, 15_042, 15_043])
      expect(conditions[:project_ids]).to eq([15_041, 15_042, 15_043])
    end

    it 'should read conditions from params' do
      conditions = @utils.from_params(@types, 15_041, issue_ids: 66, activity_ids: 12)
      expect(conditions[:issue_ids]).to eq([66])
      expect(conditions[:activity_ids]).to eq([12])

    end

    it 'should read multiple conditions from params' do
      conditions = @utils.from_params(@types, 15_041, category_ids: [3, 5, 7])
      expect(conditions[:category_ids]).to eq([3, 5, 7])
    end

    it 'should remove wrong conditions from params' do
      conditions = @utils.from_params(@types, 15_041, tracker_ids: [3, 0, nil, 7])
      expect(conditions[:tracker_ids]).to eq([3, 7])
    end

    it 'should set nil instead of empty array for conditions from params' do
      conditions = @utils.from_params(@types, 15_041, user_ids: 0, issue_ids: nil, author_ids: [0], priority_ids: [nil], status_ids: [])
      expect(conditions[:user_ids]).to be_nil
      expect(conditions[:issue_ids]).to be_nil
      expect(conditions[:author_ids]).to be_nil
      expect(conditions[:status_ids]).to be_nil
      expect(conditions[:priority_ids]).to be_nil
      expect(conditions[:fixed_version_ids]).to be_nil
    end

  end
end
