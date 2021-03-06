# frozen_string_literal: true

require 'test_helper'

class TargetsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @target = targets(:one)
  end

  sub_test_case 'not logged in' do
    test 'should get names of public targets' do
      get :names, format: :json
      assert_response :success
      assert_equal JSON.parse(response.body).first, 'one'
    end

    test 'should get index' do
      get :index
      assert_response :success
      assert_not_nil assigns(:targets_grid)
    end

    test 'should be requested login when get new' do
      get :new
      assert_response :redirect
    end

    test 'should be requested login when get edit' do
      get :edit, id: @target
      assert_response :redirect
    end

    test 'should be requested login when get destroy' do
      get :destroy, id: @target
      assert_response :redirect
    end
  end

  sub_test_case 'logged in' do
    setup do
      sign_in @target.user
    end

    test 'should get new' do
      get :new
      assert_response :success
    end

    test 'should create target' do
      assert_difference('Target.count') do
        post :create, target: {
          name: 'tree',
          endpoint_url: 'http://example.com',
          dictionary_url: 'http://example.com',
          sample_queries: 'MyText',
          sortal_predicates: 'MyText',
          ignore_predicates: 'MyText'
        }
      end

      assert_redirected_to target_path(assigns(:target))
    end

    test 'should show target' do
      get :show, id: @target
      assert_response :success
    end

    test 'should get edit' do
      get :edit, id: @target
      assert_response :success
    end

    test 'should update target' do
      put :update, id: @target, target: {
        description: @target.description,
        dictionary_url: @target.dictionary_url,
        endpoint_url: @target.endpoint_url,
        graph_uri: @target.graph_uri,
        ignore_predicates: @target.ignore_predicates.join('/t'),
        max_hop: @target.max_hop,
        name: @target.name,
        parser_url: @target.parser_url,
        sample_queries: @target.sample_queries.join('/t'),
        sortal_predicates: @target.sortal_predicates.join('/t')
      }
      assert_redirected_to target_path(assigns(:target))
    end

    test 'should destroy target' do
      assert_difference('Target.count', -1) do
        delete :destroy, id: @target
      end

      assert_redirected_to targets_path
    end
  end
end
