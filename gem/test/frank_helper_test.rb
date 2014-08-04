require_relative 'test_helper.rb'

class HelperForTesting
	include Frank::Cucumber::FrankHelper

	def mock_frank_server
		RR.mock(@mock_frank_server = Object.new)
	end

	private
	def frank_server
		@mock_frank_server
	end
end

describe "frank helper" do
	the_helper = nil

	before do
		the_helper = HelperForTesting.new
	end

	def successful_response_array(array)
		%Q{ { "outcome": "SUCCESS", "results": #{array} } }
	end

	describe "when determining visibility of selector" do

		def setup_the_helper_mock_result_array(helper, array)
			operation_map = Frank::Cucumber::Gateway.build_operation_map("FEX_isVisible", [])
			helper.mock_frank_server.send_post('map',
			:query => anything,
			:operation => operation_map,
			:selector_engine => anything) { successful_response_array(array) }
		end

		it "correctly processes no value case" do
			selector = "NoView"
			setup_the_helper_mock_result_array(the_helper, [])
			the_helper.element_is_not_hidden( selector ).must_equal(false)
		end

		it "filters out the only invisible element" do
			selector = "SingleView"
			setup_the_helper_mock_result_array(the_helper, [0])
			the_helper.element_is_not_hidden( selector ).must_equal(false)
		end

		it "keeps the only visible element" do
			selector = "SingleView"
			setup_the_helper_mock_result_array(the_helper, [1])
			the_helper.element_is_not_hidden( selector ).must_equal(true)
		end

		it "filters out invisible elements out of multiple candidates" do
			selector = "MultipleViews"
			setup_the_helper_mock_result_array(the_helper, [0, 0, 0, 0, 0])
			the_helper.element_is_not_hidden( selector ).must_equal(false)
		end

		it "keeps all the visible elements" do
			selector = "MultipleViews"
			setup_the_helper_mock_result_array(the_helper, [1, 1, 1])
			the_helper.element_is_not_hidden( selector ).must_equal(true)
		end

		it "only filters out invisible and keeps all the visible elements" do
			selector = "MultipleViews"
			setup_the_helper_mock_result_array(the_helper, [1, 0, 1, 0, 1])
			the_helper.element_is_not_hidden( selector ).must_equal(true)
		end

	end

end
