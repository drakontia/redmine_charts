require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
  describe GroupingUtils do
    before(:all) do
      @utils = RedmineCharts::GroupingUtils
    end

    it 'should return_grouping_types' do
      expect(@utils.types).to eq([:user_id, :issue_id, :activity_id, :category_id, :tracker_id, :fixed_version_id, :priority_id, :author_id, :status_id, :project_id, :assigned_to_id])
    end

    it 'should return_all_for_nil_or_none_grouping' do
      expect(@utils.to_string(nil, nil)).to eq('all')
      expect(@utils.to_string(4, :none)).to eq('all')
      expect(@utils.to_string(nil, nil, 'default')).to eq('all')
      expect(@utils.to_string(4, :none, 'default')).to eq('all')
    end

    it 'should return_none_for_not_existed_grouping' do
      expect(@utils.to_string(3, :other)).to eq('none')
    end

    it 'should return_default_if_provided' do
      expect(@utils.to_string(3, :other, 'default')).to eq('default')
    end

    it 'should return_string_representation_of_users_grouping' do
      expect(@utils.to_string(2, :user_id)).to eq('John Smith')
      expect(@utils.to_string(0, :user_id)).to eq('none')
      expect(@utils.to_string(666, :user_id, 'Ozzy')).to eq('Ozzy')
    end

    it 'should return_string_representation_of_issues_grouping' do
      expect(@utils.to_string(15_042, :issue_id)).to eq('#15042 Issue2')
    end

    it 'should return_string_representation_of_activities_grouping' do
      expect(@utils.to_string(8, :activity_id)).to eq('Design')
    end

    it 'should return_string_representation_of_categories_grouping' do
      expect(@utils.to_string(15_042, :category_id)).to eq('Category2')
    end

    it 'should return_string_representation_of_trackers_grouping' do
      expect(@utils.to_string(1, :tracker_id)).to eq('Bug')
    end

    it 'should return_string_representation_of_versions_grouping' do
      expect(@utils.to_string(15_042, :fixed_version_id)).to eq('2.0')
    end

    it 'should return_string_representation_of_priorities_grouping' do
      expect(@utils.to_string(5, :priority_id)).to eq('High')
    end

    it 'should return_string_representation_of_authors_grouping' do
      expect(@utils.to_string(3, :author_id)).to eq('Dave Lopper')
    end

    it 'should return_string_representation_of_owners_grouping' do
      expect(@utils.to_string(3, :assigned_to_id)).to eq('Dave Lopper')
    end

    it 'should return_string_representation_of_statuses_grouping' do
      expect(@utils.to_string(2, :status_id)).to eq('Assigned')
    end

    it 'should return_string_representation_of_projects_grouping' do
      expect(@utils.to_string(15_042, :project_id)).to eq('#15042 Project2')
    end

    it 'should return_nil_when_param_does_not_include_grouping' do
      types = @utils.types
      grouping = @utils.from_params(types, {})
      expect(grouping).to eq(nil)
    end

    it 'should return_nil_when_param_include_wrong_grouping' do
      types = @utils.types
      grouping = @utils.from_params(types, grouping: :other)
      expect(grouping).to eq(nil)
    end

    it 'should return_proper_grouping_from_params' do
      types = @utils.types
      grouping = @utils.from_params(types, grouping: :user_id)
      expect(grouping).to eq(:user_id)
    end

    it 'should return_proper_grouping_from_string_params' do
      types = @utils.types
      grouping = @utils.from_params(types, grouping: 'tracker_id')
      expect(grouping).to eq(:tracker_id)
    end

  end
end
