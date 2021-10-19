# frozen_string_literal: true

require 'test_helper'

class TargetsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @target = targets(:one)
  end

  sub_test_case 'not logged in' do
    setup do
      sign_out @target.user
    end

    test 'should get names of public targets' do
      get target_url(@target), params: { format: :json }
      assert_response :success
      assert_equal JSON.parse(response.body)["name"], 'one'
    end

    test 'should get index' do
      get targets_url, params: {}
      assert_response :success
      assert_not_nil assigns(:targets_grid)
    end

    test 'should be requested login when get new' do
      get new_target_url, params: {}
      assert_response :redirect
    end

    test 'should be requested login when get edit' do
      get edit_target_url(@target), params: {}
      assert_response :redirect
    end

    test 'should be requested login when get destroy' do
      delete target_url(@target), params: {}
      assert_response :redirect
    end
  end

  sub_test_case 'logged in' do
    setup do
      sign_in @target.user
    end

    test 'should get new' do
      get new_target_url, params: {}
      assert_response :success
    end

    test 'should create target' do
      assert_difference('Target.count') do
        post targets_url, params: { target: {
          name: 'tree',
          endpoint_url: 'http://example.com',
          dictionary_url: 'http://example.com',
          sample_queries: 'MyText',
          sortal_predicates: 'MyText',
          ignore_predicates: 'MyText'
        } }
      end

      assert_redirected_to target_path(Target.last)
    end

    test 'should show target' do
      get target_url(@target), params: { }
      assert_response :success
    end

    test 'should get edit' do
      get edit_target_url(@target), params: {}
      assert_response :success
    end

    test 'should update target' do
      put target_url(@target), params: {
        target: {
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
      }
      assert_redirected_to target_path(Target.last)
    end

    test 'should destroy target' do
      assert_difference('Target.count', -1) do
        delete target_url(@target), params: {}
      end

      assert_redirected_to targets_path
    end
  end
end
